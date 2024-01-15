{ lib, buildGoModule, fetchFromGitHub, installShellFiles, callPackage }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fe+7RkUwCveBk14bYzg5uLGOqTVVJsrqixBQhCS79hY=";
  };

  vendorHash = "sha256-ePhObvm3m/nT+7IyT0W6K+y+9UNkfd2kYjle2ffAd9Y=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

  ldflags = let t = "github.com/zyedidia/micro/v2/internal"; in [
    "-s"
    "-w"
    "-X ${t}/util.Version=${version}"
    "-X ${t}/util.CommitHash=${src.rev}"
  ];

  preBuild = ''
    GOOS= GOARCH= go generate ./runtime
  '';

  postInstall = ''
    installManPage assets/packaging/micro.1
    install -Dm444 -t $out/share/applications assets/packaging/micro.desktop
    install -Dm644 assets/micro-logo-mark.svg $out/share/icons/hicolor/scalable/apps/micro.svg
  '';

  passthru.tests.expect = callPackage ./test-with-expect.nix { };

  meta = with lib; {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "micro";
  };
}
