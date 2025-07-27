{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ncurses,
  libpulseaudio,
  pandoc,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ncpamixer";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "fulhax";
    repo = "ncpamixer";
    tag = version;
    hash = "sha256-uafjAaXtn97NNmRPxeHmbAaMeHIR/nrQKsTqDX5NRGU=";
  };

  patches = [
    ./remove_dynamic_download.patch
  ];

  postPatch =
    let
      PandocMan = fetchurl {
        url = "https://github.com/rnpgp/cmake-modules/raw/387084811ee01a69911fe86bcc644b7ed8ad6304/PandocMan.cmake";
        hash = "sha256-KI55Yc2IuQtmbptqkk6Hzr75gIE/uQdUbQsm/fDpaWg=";
      };
    in
    ''
      substituteInPlace src/CMakeLists.txt \
        --replace "include(PandocMan)" "include(${PandocMan})"
    '';

  nativeBuildInputs = [
    cmake
    pandoc
    pkg-config
  ];

  buildInputs = [
    ncurses
    libpulseaudio
  ];

  configurePhase = ''
    runHook preConfigure

    make PREFIX=$out USE_WIDE=1 RELEASE=1 build/Makefile

    runHook postConfigure
  '';

  meta = with lib; {
    description = "Terminal mixer for PulseAudio inspired by pavucontrol";
    homepage = "https://github.com/fulhax/ncpamixer";
    license = licenses.mit;
    platforms = platforms.linux;
    teams = [ teams.c3d2 ];
    mainProgram = "ncpamixer";
  };
}
