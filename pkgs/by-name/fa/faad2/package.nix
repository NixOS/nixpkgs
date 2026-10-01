{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  # for passthru.tests
  gst_all_1,
  mpd,
  ocamlPackages,
  vlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faad2";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = finalAttrs.version;
    hash = "sha256-39CMBSnGkOS6E5sSi2t70nWJHTFsaNx02gu8zQNVgiA=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit mpd vlc;
    inherit (gst_all_1) gst-plugins-bad;
    ocaml-faad = ocamlPackages.faad;
  };

  meta = {
    description = "Open source MPEG-4 and MPEG-2 AAC decoder";
    homepage = "https://sourceforge.net/projects/faac/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "faad";
    platforms = lib.platforms.all;
  };
})
