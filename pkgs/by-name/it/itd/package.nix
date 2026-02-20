{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule (finalAttrs: {
  pname = "itd";
  version = "1.1.0";

  # https://gitea.elara.ws/Elara6331/itd/tags
  src = fetchFromGitea {
    domain = "gitea.elara.ws";
    owner = "Elara6331";
    repo = "itd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-95/9Qy0HhrX+ORuv6g1T4/Eq1hf539lYG5fTkLeY6B0=";
  };

  vendorHash = "sha256-ZkAxNs4yDUFBhhmIRtzxQlEQtsa/BTuHy0g3taFcrMM=";

  preBuild = ''
    echo r${finalAttrs.version} > version.txt
  '';

  subPackages = [
    "."
    "cmd/itctl"
  ];

  postInstall = ''
    install -Dm644 itd.toml $out/etc/itd.toml
  '';

  meta = {
    description = "Daemon to interact with the PineTime running InfiniTime";
    homepage = "https://gitea.elara.ws/Elara6331/itd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mindavi
      raphaelr
    ];
  };
})
