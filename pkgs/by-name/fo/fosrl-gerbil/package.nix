{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gerbil";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = version;
    hash = "sha256-Pnti0agkohRBWQ42cqNOA5TnnSLP9JbOK1eyGf88cao=";
  };

  vendorHash = "sha256-Sz+49ViQUwJCy7wXDrQf7c76rOZbSGBCgB+Du8T6ug0=";

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
