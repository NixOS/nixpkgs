{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gerbil";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = finalAttrs.version;
    hash = "sha256-SKpXWlpMkmo5Qwdi/MylqNIBvP4jEHSZfP5BjQD1nVs=";
  };

  vendorHash = "sha256-k5G8mkqrezRYY2lH1kbMMcW8GsUkyDaPglLEAzJIxYo=";

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
