{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  allegro5,
  alsa-lib,
  jack2,
  zlib,
}:

stdenv.mkDerivation {
  pname = "b-em";
  version = "unstable-2026-06-30";

  src = fetchFromGitHub {
    owner = "stardot";
    repo = "b-em";
    rev = "6018d5e91a097d0a6dc0aee95e0477845e12660c";
    hash = "sha256-9X5zQZaGPiEEiGvjrk57264jBZNTgWT03amqpHIuVl8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    allegro5
    alsa-lib
    jack2
    zlib
  ];

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  postInstall = ''
    # The upstream install target copies optional ROM, disc, and tape images.
    # Keep Nixpkgs output to the emulator and support files only.
    rm -rf "$out/share/b-em/roms" "$out/share/b-em/discs" "$out/share/b-em/tapes"
    install -Dm644 icon/b-em.svg "$out/share/icons/hicolor/scalable/apps/b-em.svg"
  '';

  meta = {
    description = "BBC Micro emulator";
    homepage = "https://github.com/stardot/b-em";
    license = lib.licenses.gpl2Plus;
    mainProgram = "b-em";
    maintainers = with lib.maintainers; [ kaistarkk ];
    platforms = lib.platforms.linux;
  };
}
