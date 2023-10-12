{ lib, buildGoModule, fetchFromGitHub, installShellFiles, callPackage }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-L8yJE3rjNcx+1gawQ8urZcFfoQdO20E67mJQjWaVwVo=";
  };

  vendorHash = "sha256-h00s+xqepj+odKAgf54s35xMnnj3gtx5LWDOYFx5GY0=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

  ldflags = let t = "github.com/zyedidia/micro/v2/internal"; in [
    "-s"
    "-w"
    "-X ${t}/util.Version=${version}"
    "-X ${t}/util.CommitHash=${src.rev}"
  ];

  preBuild = ''
    go generate ./runtime
  '';

  postInstall = ''
    installManPage assets/packaging/micro.1
    install -Dt $out/share/applications assets/packaging/micro.desktop
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
