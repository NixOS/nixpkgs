{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-scale-to-sound";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "obs-scale-to-sound";
    tag = version;
    hash = "sha256-N6OMufx4+WyLGnIZQNxwlPdlmsa+GoZhuDMS9NIbIGE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ obs-studio ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  meta = {
    description = "OBS filter plugin that scales a source reactively to sound levels";
    homepage = "https://github.com/dimtpap/obs-scale-to-sound";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
