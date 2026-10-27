{ pkgs, ... }:
let
  bst = pkgs.buildstream;

  # `bst` is a buildPythonApplication; its own site-packages only contains
  # buildstream's own files, not the propagated runtime deps (protobuf,
  # grpcio, click, ...) that only reach the wrapped `bst` script's PYTHONPATH.
  # `toPythonModule` reinterprets it as a regular library so its full
  # dependency closure gets merged in by `withPackages` below.
  bstModule = pkgs.python3.pkgs.toPythonModule bst;

  # Test fixture plugin package used by test_source_mirror_plugin[pip]; upstream
  # normally installs this via tox before running the pip-origin plugin loading test.
  samplePlugins = pkgs.python3Packages.buildPythonPackage {
    pname = "sample-plugins";
    version = "1.2.3";
    pyproject = true;
    build-system = [ pkgs.python3Packages.setuptools ];
    src = "${bst.src}/tests/plugins/sample-plugins";
    dontCheck = true;
  };
in
{
  name = "buildstream";

  meta.maintainers = with pkgs.lib.maintainers; [ shymega ];

  nodes.machine =
    { pkgs, ... }:
    {
      # The default "auto" diskSize only sizes the root filesystem to fit
      # the system closure, with no scratch space; the suite builds real
      # CAS/cache artifacts under pytest's basetemp (`./tmp`, per
      # setup.cfg) for hundreds of parametrized cases, which exhausts that
      # in a few minutes (`OSError: could not create numbered dir`).
      virtualisation.diskSize = 16 * 1024;
      virtualisation.memorySize = 2048;

      environment.systemPackages = [
        (pkgs.python3.withPackages (
          ps: with ps; [
            bstModule
            pexpect
            pyftpdlib
            pytest
            pytest-datafiles
            pytest-env
            pytest-timeout
            pytest-xdist
            samplePlugins
          ]
        ))
        bst
        pkgs.buildbox
        pkgs.gitMinimal
      ];
    };

  testScript = ''
    machine.succeed("cp -r ${bst.src} /tmp/src && chmod -R u+w /tmp/src")

    # The dummy buildbox-casd scripts spawned by tests/internals/cascache.py use
    # an `/usr/bin/env sh` shebang, which doesn't exist here either.
    machine.succeed(
        "sed -i 's|#!/usr/bin/env sh|#!${pkgs.runtimeShell}|'"
        + " /tmp/src/tests/internals/cascache.py"
    )

    machine.succeed("cd /tmp/src && HOME=/root pytest")
  '';
}
