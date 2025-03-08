{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.44.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-u5NklyTtrTfqC+p3UnUv7LJ2Dm7GuQnuAAyplm1M7rE=";
  };

  vendorHash = "sha256-GPIJ3IvTM2da962M1FLHKn8OitHDPZ9zp8nSLaeRq10=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

  meta = with lib; {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = licenses.asl20;
    maintainers = with maintainers; [ cbrewster ];
    platforms = platforms.unix;
    mainProgram = "hermit";
  };
}
