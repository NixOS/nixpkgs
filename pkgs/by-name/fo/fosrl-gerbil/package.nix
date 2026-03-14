{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gerbil";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = finalAttrs.version;
    hash = "sha256-A3ehUYR5dM2No0AXxOCXZi83Lh/NXo6vMSFtYpvSAJo=";
  };

  vendorHash = "sha256-FZuIDHAQtqEuxE1W4yYRnr4Kj8YedNi0Z1NeuWrgnRc=";

  # patch out the /usr/sbin/iptables
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail '/usr/sbin/iptables' '${lib.getExe iptables}'
  '';

  meta = {
    description = "Simple WireGuard interface management server";
    mainProgram = "gerbil";
    homepage = "https://github.com/fosrl/gerbil";
    changelog = "https://github.com/fosrl/gerbil/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    platforms = lib.platforms.linux;
  };
})
