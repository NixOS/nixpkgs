{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-nssf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "nssf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ggX4SwQFEYJj8NrlEaQ4I5o+xzJdUQDWAfAMHnNunRU=";
  };

  vendorHash = "sha256-HqLxGpW15vHRNLyc6lwaFD5J9TVoqFqH+hFFiivgITQ=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
