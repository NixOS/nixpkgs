{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "lprobe";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "fivexl";
    repo = "lprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Opa2AkUA5/iogg4bJy7o3ZCOZmAqKgW6KqG/Kn4eS9o=";
  };

  vendorHash = "sha256-H/el8zj3uUIkSXKHPD0RqAaaGPTH++NXd5dKpzUSHFQ=";

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
