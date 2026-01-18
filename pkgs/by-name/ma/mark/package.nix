{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

# Tests with go 1.24 do not work. For now
# https://github.com/kovetskiy/mark/pull/581#issuecomment-2797872996
buildGoModule rec {
  pname = "mark";
  version = "15.2.0";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = "v${version}";
    sha256 = "sha256-ZvFaSoD9nQtxc5ONWneVgpAfX3f7sS0lBSMXqhABn8o=";
  };

  vendorHash = "sha256-3hfeh7PRzsPfQ+aLPV44ExXum6lG6Huvc7itRIn8mNo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  checkFlags =
    let
      skippedTests = [
        # Expects to be able to launch google-chrome
        "TestExtractMermaidImage"
        "TestExtractD2Image/example"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  meta = {
    description = "Tool for syncing your markdown documentation with Atlassian Confluence pages";
    mainProgram = "mark";
    homepage = "https://github.com/kovetskiy/mark";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rguevara84
      wrbbz
    ];
  };
}
