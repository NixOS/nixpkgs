{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b51fvc9hrjfl8acr3yybp66xfll7d43412qwi76wxwarn06gkci";
  };

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

  vendorSha256 = "19iqvl63g9y6gkzfmv87rrgj4c4y6ngh467ss94rzrhaybj2b2d8";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/zyedidia/micro/v2/internal/util.Version=${version} -X github.com/zyedidia/micro/v2/internal/util.CommitHash=${src.rev}" ];

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
