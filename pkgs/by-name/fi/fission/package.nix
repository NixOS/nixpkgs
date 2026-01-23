{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "fission";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${version}";
    hash = "sha256-Tl7aKibVbNAKOa1tycKtEzdJ8rJHBMa8PTUm0i7DKA4=";
  };

  vendorHash = "sha256-PhB6zR/dXnOCHJiJ/EjVOD26SubaAITRm61XOvULerU=";

  ldflags = [
    "-s"
    "-w"
    "-X info.Version=${version}"
  ];

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = {
    description = "Cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ neverbehave ];
  };
}
