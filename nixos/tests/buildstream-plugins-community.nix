{
  pkgs,
  lib,
  ...
}:
let
  bstPluginsCommunity = pkgs.python3Packages.buildstream-plugins-community;

  deselectedTests = [
    # These reach out to gitlab.com to download real files (bazel manifest
    # fetches, git-lfs test repo), which isn't possible in this VM either.
    "tests/sources/bazel.py::test_basic"
    "tests/sources/bazel.py::test_multi_url"
    "tests/sources/bazel_file.py::test_basic"
    "tests/sources/bazel_file.py::test_multi_url"
    "tests/sources/git_tag.py::test_gitlfs"
    "tests/sources/git_tag.py::test_gitlfs_off"
    "tests/sources/git_tag.py::test_gitlfs_notset"
  ];

  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      (ps.toPythonModule pkgs.buildstream)
      bstPluginsCommunity
      pytest
      pytest-datafiles
      pytest-env
      pytest-xdist
      pyftpdlib
    ]
  );
in
{
  name = "buildstream-plugins-community";

  meta.maintainers = with pkgs.lib.maintainers; [ shymega ];

  nodes.machine = { pkgs, ... }: {
    programs.fuse.enable = true;

    environment.systemPackages = [
      pythonEnv
      pkgs.buildbox
      pkgs.gitMinimal
      pkgs.ostree
    ];
  };

  testScript = ''
    machine.succeed("cp -r ${bstPluginsCommunity.src} /tmp/src && chmod -R u+w /tmp/src")
    machine.succeed(
        "cd /tmp/src && HOME=/root ${pythonEnv}/bin/pytest tests"
        + " ${lib.concatStringsSep " " (map (t: "--deselect=${t}") deselectedTests)}"
    )
  '';
}
