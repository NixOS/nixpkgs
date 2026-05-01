{
  pkgs,
  ...
}:

let
  fakeBazelisk = pkgs.writeShellScriptBin "bazelisk" ''
    echo "fake bazelisk $*"
  '';

  fakeCc = pkgs.writeShellScriptBin "bazelisk-test-cc" ''
    exit 0
  '';

  fakeCxx = pkgs.writeShellScriptBin "bazelisk-test-cxx" ''
    exit 0
  '';

  extraTool = pkgs.writeShellScriptBin "bazelisk-extra-tool" ''
    echo "extra tool"
  '';
in
{
  name = "bazelisk";

  nodes.machine = {
    programs.bazelisk = {
      enable = true;
      package = fakeBazelisk;
      cc = "${fakeCc}/bin/bazelisk-test-cc";
      cxx = "${fakeCxx}/bin/bazelisk-test-cxx";
      extraPackages = [ extraTool ];
      extraBazelrc = ''
        build --action_env=BAZELISK_TEST=1
      '';
    };
  };

  testScript = ''
    start_all()

    machine.wait_until_succeeds("mountpoint -q /usr/bin")
    machine.wait_until_succeeds("test -e /bin/bash")

    machine.succeed("test -x /run/current-system/sw/bin/bazelisk")
    machine.succeed("test -x /run/current-system/sw/bin/bazel")
    machine.succeed("bazel --version | grep 'fake bazelisk --version'")
    machine.succeed("PATH= /bin/bash --version")

    bazelrc = machine.succeed("cat /etc/bazel.bazelrc")
    for expected in [
        "build --action_env=PATH=",
        "build --host_action_env=PATH=",
        "${pkgs.bash}/bin",
        "${pkgs.binutils}/bin",
        "${pkgs.coreutils}/bin",
        "${extraTool}/bin",
        "build --repo_env=CC=${fakeCc}/bin/bazelisk-test-cc",
        "build --action_env=CC=${fakeCc}/bin/bazelisk-test-cc",
        "build --repo_env=CXX=${fakeCxx}/bin/bazelisk-test-cxx",
        "build --action_env=CXX=${fakeCxx}/bin/bazelisk-test-cxx",
        "build --action_env=BAZELISK_TEST=1",
    ]:
        assert expected in bazelrc, f"{expected!r} missing from bazelrc"
  '';
}
