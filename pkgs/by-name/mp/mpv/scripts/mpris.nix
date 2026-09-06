{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  pkg-config,
  glib,
  mpv-unwrapped,
  ffmpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpv-mpris";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = finalAttrs.version;
    hash = "sha256-Q2kNaXZtI6U+x2f00x5CiHZq4o64xFTNC/3W4IiP0+4=";
  };
  passthru.updateScript = gitUpdater { };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glib
    mpv-unwrapped
    ffmpeg
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'PKG_CONFIG =' 'PKG_CONFIG ?='
  '';

  installFlags = [ "SCRIPTS_DIR=${placeholder "out"}/share/mpv/scripts" ];

  # Otherwise, the shared object isn't `strip`ped. See:
  # https://discourse.nixos.org/t/debug-why-a-derivation-has-a-reference-to-gcc/7009
  stripDebugList = [ "share/mpv/scripts" ];
  passthru.scriptName = "mpris.so";

  meta = {
    description = "MPRIS plugin for mpv";
    homepage = "https://github.com/hoyon/mpv-mpris";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ajs124 ];
    changelog = "https://github.com/hoyon/mpv-mpris/releases/tag/${finalAttrs.version}";
  };
})
