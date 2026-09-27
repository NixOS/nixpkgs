{ pkgs, lib, ... }:
let
  bstPlugins = pkgs.python3Packages.buildstream-plugins;
  buildstream = pkgs.buildstream.override { enableBuildstreamPlugins = false; };

  # These pull in buildstream's shared bzr/git "repo kind" tests, which write
  # into the (permission-preserving, since pytest-datafiles 3.0) copy of
  # buildstream's own installed test fixtures. That copy is read-only here
  # too, since /nix/store is always read-only, so these still fail the same
  # way they do in the plain derivation check; tracked upstream at
  # https://github.com/apache/buildstream/issues/2196. Unrelated to FUSE.
  disabledTestPaths = [
    "tests/sources/cargo.py"
    "tests/sources/docker.py"
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

    # Genuinely needs network access (fetches a base container image from
    # bst-integration-test-images.ams3.cdn.digitaloceanspaces.com), which
    # isn't available in the Nix build sandbox; only reachable at all now
    # because real FUSE support lets `HAVE_SANDBOX` come out true.
    "source_determinism.py::test_deterministic_source_umask"
  ];

  pytestFlags = map (
    path: if lib.hasInfix "::" path then "--deselect=${path}" else "--ignore-glob=${path}"
  ) disabledTestPaths;

  # `buildstream`'s own `bst` entry point bakes its dependencies' site-packages
  # directories directly into that script (via `site.addsitedir`), rather than
  # exposing them under `${buildstream}/${python3.sitePackages}`; `toPythonModule`
  # is needed to pull `buildstream` and its dependencies into a shared
  # environment that `pytest` can import from.
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      (ps.toPythonModule buildstream)
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
    machine.succeed("cp -r ${bstPlugins.src} /tmp/src && chmod -R u+w /tmp/src")
    machine.succeed(
        "cd /tmp/src && HOME=/root PYTHONPATH=${pythonEnv}/${pkgs.python3.sitePackages}"
        # The `pip` source plugin looks for a `pip`-capable Python by name
        # (`python3`, `python3.12`, ...) on PATH, and picks up the test
        # driver's own unrelated Python before `pythonEnv`'s; PYTHONPATH is
        # honoured regardless of which interpreter it finds, unlike the
        # `site.addsitedir` calls baked into `pythonEnv`'s own wrapper scripts.
        + " ${pythonEnv}/bin/pytest ${lib.concatStringsSep " " pytestFlags}"
    )
  '';
}
