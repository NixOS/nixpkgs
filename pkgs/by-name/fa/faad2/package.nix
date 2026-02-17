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
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = finalAttrs.version;
    hash = "sha256-JvmblrmE3doUMUwObBN2b+Ej+CDBWNemBsyYSCXGwo8=";
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
    maintainers = with lib.maintainers; [ codyopel ];
    mainProgram = "faad";
    platforms = lib.platforms.all;
  };
})
