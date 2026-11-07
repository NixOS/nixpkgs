{ pkgs, lib, ... }:
let
  bstPlugins = pkgs.python3Packages.buildstream-plugins;
  buildstream = pkgs.python3Packages.toPythonModule (
    pkgs.buildstream.override { enableBuildstreamPlugins = false; }
  );

  # These write into buildstream's installed test fixtures, which are
  # read-only under /nix/store; tracked upstream at
  # https://github.com/apache/buildstream/issues/2196.
  disabledTestFiles = [
    "tests/sources/cargo.py"
    "tests/sources/docker.py"
  ];

  # Needs network access unavailable in the Nix build sandbox; only reachable
  # here since FUSE support makes `HAVE_SANDBOX` true.
  disabledTests = [
    "build_checkout.py::test_fetch_build_checkout"
    "fetch.py::test_fetch"
    "fetch.py::test_fetch_cross_junction"
    "mirror.py::test_mirror_fetch"
    "mirror.py::test_mirror_fetch_upstream_absent"
    "mirror.py::test_mirror_from_includes"
    "mirror.py::test_mirror_track_upstream_present"
    "mirror.py::test_mirror_track_upstream_absent"
    "track.py::test_track"
    "track.py::test_track_recurse"
    "track.py::test_track_recurse_except"
    "track.py::test_cross_junction"
    "track.py::test_track_include"
    "track.py::test_track_include_junction"
    "track.py::test_track_junction_included"
    "workspace.py::test_open"
    "source_determinism.py::test_deterministic_source_umask"
  ];

  pytestFlags =
    (map (path: "--ignore-glob=${path}") disabledTestFiles)
    ++ (map (path: "--deselect=${path}") disabledTests);

  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      buildstream
      bstPlugins
      pip
      pytest
      pytest-datafiles
      pytest-env
    ]
  );
in
{
  name = "buildstream-plugins";

  meta.maintainers = with pkgs.lib.maintainers; [ shymega ];

  nodes.machine =
    { pkgs, ... }:
    {
      # buildbox-casd finds `buildbox-fuse` on PATH and defaults to real
      # FUSE-based staging, which needs `/dev/fuse` and a working mount
      # path that the Nix build sandbox can't provide; that's why the
      # plain derivation check has to force the hardlink/copy stager
      # instead. Running here as a VM test instead exercises the real
      # FUSE-backed path.
      programs.fuse.enable = true;

      environment.systemPackages = [
        pythonEnv
        pkgs.buildbox
        pkgs.gitMinimal
      ];
    };

  testScript = ''
    machine.succeed("cp -r ${bstPlugins.src} /var/tmp/src && chmod -R u+w /var/tmp/src")
    machine.succeed(
        "cd /var/tmp/src && HOME=/root PATH=${pythonEnv}/bin:$PATH"
        # The `pip` source plugin looks for a `pip`-capable Python by name
        # (`python3`, `python3.12`, ...) on PATH; put `pythonEnv` first so it
        # finds that instead of whatever unrelated Python is already there.
        + " ${pythonEnv}/bin/pytest ${lib.concatStringsSep " " pytestFlags}"
    )
  '';
}
