{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule (finalAttrs: {
  pname = "itd";
  version = "1.1.1";

  # https://gitea.elara.ws/Elara6331/itd/tags
  src = fetchFromGitea {
    domain = "gitea.elara.ws";
    owner = "Elara6331";
    repo = "itd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q7UyuokwRZJU84IdsPcSFigiMr6OWye1OnwtclNCs7k=";
  };

  vendorHash = "sha256-EfsvgjSX3FLJe0b97DSwTkQKJ67MF8ak7DaPRrQrhcs=";

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
