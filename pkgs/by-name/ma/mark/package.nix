{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

# Tests with go 1.24 do not work. For now
# https://github.com/kovetskiy/mark/pull/581#issuecomment-2797872996
buildGoModule rec {
  pname = "mark";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "mark";
    rev = "v${version}";
    sha256 = "sha256-OYLL96xvyrsnfIc0h+kQhZeW1ImyO7IG2ybD2SMBn/U=";
  };

  vendorHash = "sha256-y7MDgCYOvrFF4IMy8zpWXqyaOel1Xjei7h2OkiE6r+g=";

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

  meta = with lib; {
    description = "Tool for syncing your markdown documentation with Atlassian Confluence pages";
    mainProgram = "mark";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rguevara84
      wrbbz
    ];
  };
}
