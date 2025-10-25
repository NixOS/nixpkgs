{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gerbil";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = version;
    hash = "sha256-fJ10bWEVhb1sfBTz4aOgpMoMQkpQr2Ses/vQwtR9iE0=";
  };

  vendorHash = "sha256-/ywbLXprTChZ0XOIfgNieoV+PsW4KQY25ifdyrZrVBc=";

  # patch out the /usr/sbin/iptables
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail '/usr/sbin/iptables' '${lib.getExe iptables}'
  '';

  meta = {
    description = "Simple WireGuard interface management server";
    mainProgram = "gerbil";
    homepage = "https://github.com/fosrl/gerbil";
    changelog = "https://github.com/fosrl/gerbil/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
}
