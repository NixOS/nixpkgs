{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gocovsh";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "orlangure";
    repo = "gocovsh";
    tag = "v${version}";
    hash = "sha256-VZNu1uecFVVDgF4xDLTgkCahUWbM+1XASV02PEUfmr0=";
  };

  vendorHash = "sha256-Fb7BIWojOSUIlBdjIt57CSvF1a+x33sB45Z0a86JMUg=";

  ldflags = [
    "-s"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
    "-X main.date=19700101T000000Z"
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    description = "Go Coverage in your terminal: a tool for exploring Go Coverage reports from the command line";
    homepage = "https://github.com/orlangure/gocovsh";
    changelog = "https://github.com/orlangure/gocovsh/releases";
    # https://github.com/orlangure/gocovsh/blob/8880bc63283c13a1d630ce3817c7165a6c210d46/.goreleaser.yaml#L33
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gocovsh";
  };
}
