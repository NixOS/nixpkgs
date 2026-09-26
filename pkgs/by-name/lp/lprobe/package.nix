{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "lprobe";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "fivexl";
    repo = "lprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-325Y9PSvnzFUpSOeZTp7DiltLLaGNmUuB//sHR7Gdf4=";
  };

  vendorHash = "sha256-6Ip9d9laS6wr/Qu3wWTlW5vI7QzmRX0Y6xhtIQ4J3ps=";

  buildInputs = [
    libpcap
  ];

  meta = {
    description = "Command-line tool to perform Local Health Check Probes inside Container Images (ECS, Docker)";
    homepage = "https://github.com/fivexl/lprobe";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cageyv ];
    mainProgram = "lprobe";
  };
})
