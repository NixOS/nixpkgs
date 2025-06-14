{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
  replaceVars,
}:

buildGoModule rec {
  pname = "fosrl-gerbil";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = version;
    hash = "sha256-6ZmnokXmn4KIfNZT9HrraYP4fjfY2C0sK+xAJyq/pkU=";
  };
  # patch out the /usr/sbin/iptables
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail '/usr/sbin/iptables' '${lib.getExe iptables}'
  '';

  vendorHash = "sha256-lYJjw+V94oxILu+akUnzGACtsU7CLGwljysRvyUk+yA=";

  meta = {
    description = "Simple WireGuard interface management server";
    mainProgram = "gerbil";
    homepage = "https://github.com/fosrl/gerbil";
    changelog = "https://github.com/fosrl/gerbil/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jackr ];
    platforms = lib.platforms.linux;
  };
}
