{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hVFmViwGXuYVAKaCkzK/LHjCi8AtLu0tsPpT61glxys=";
  };

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

  vendorSha256 = "sha256-YcAKl4keizkbgQLAZGiCG3CGpNTNad8EvOJEXLX2s0s=";

  ldflags = [ "-s" "-w" "-X github.com/zyedidia/micro/v2/internal/util.Version=${version}" "-X github.com/zyedidia/micro/v2/internal/util.CommitHash=${src.rev}" ];

  postInstall = ''
    installManPage assets/packaging/micro.1
    install -Dt $out/share/applications assets/packaging/micro.desktop
  '';

  meta = with lib; {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
