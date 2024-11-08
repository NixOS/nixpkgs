{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  libGL,
  libpng,
  pkg-config,
  xorg,
  freetype,
  fontconfig,
  alsa-lib,
  libXrender,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clanlib";
  version = "4.1.0";

  src = fetchFromGitHub {
    repo = "ClanLib";
    owner = "sphair";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-SVsLWcTP+PCIGDWLkadMpJPj4coLK9dJrW4sc2+HotE=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libGL
    libpng
    xorg.xorgproto
    freetype
    fontconfig
    alsa-lib
    libXrender
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/sphair/ClanLib";
    description = "Cross platform toolkit library with a primary focus on game creation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nixinator ];
    platforms = with lib.platforms; lib.intersectLists linux (x86 ++ arm ++ aarch64 ++ riscv);
  };
})
