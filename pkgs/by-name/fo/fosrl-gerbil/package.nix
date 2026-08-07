{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gerbil";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = finalAttrs.version;
    hash = "sha256-9bKpuMAhQlhK8+IB6L3pEw4WU/1I3YXa0HDBhWPNOAo=";
  };

  vendorHash = "sha256-bTUUGVn4vKEoxd95iCGw9AFrRZmYSs5eQc8Lan+wSDw=";

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
