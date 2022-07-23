{ lib
, mkDerivation
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, which
, python3
, rsync
, qtbase
, qtsvg
, libGLU
, libGL
, zlib
, icu
, freetype
}:

mkDerivation rec {
  pname = "organicmaps";
  version = "2022.06.29-3";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    rev = "${version}-android";
    sha256 = "sha256-/K3bxnb6y+9nEuGvoIpPl218xmNqjOWgpV8hQ/W12ZA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Disable certificate check. It's dependent on time
    echo "exit 0" > tools/unix/check_cert.sh

    # crude fix for https://github.com/organicmaps/organicmaps/issues/1862
    echo "echo ${lib.replaceStrings ["." "-"] ["" ""] version}" > tools/unix/version.sh
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    which
    python3
    rsync
  ];

  # Most dependencies are vendored
  buildInputs = [
    qtbase
    qtsvg
    libGLU
    libGL
    zlib
    icu
    freetype
  ];

  # Yes, this is PRE configure. The configure phase uses cmake
  preConfigure = ''
    bash ./configure.sh
  '';

  meta = with lib; {
    # darwin: "invalid application of 'sizeof' to a function type"
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    homepage = "https://organicmaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "OMaps";
  };
}
