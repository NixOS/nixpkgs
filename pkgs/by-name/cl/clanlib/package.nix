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
  libXinerama,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clanlib";
  version = "4.2.0";

  src = fetchFromGitHub {
    repo = "ClanLib";
    owner = "sphair";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sRHRkT8NiKVfa9YgP6DYV9WzCZoH7f0phHpoYMnCk98=";
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
    libXinerama
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/sphair/ClanLib";
    description = "Cross platform toolkit library with a primary focus on game creation";
    license = licenses.mit;
    maintainers = with maintainers; [ nixinator ];
    platforms = with platforms; intersectLists linux (x86 ++ arm ++ aarch64 ++ riscv);
  };
})
