{ lib
, mkDerivation
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, pkg-config
, which
, python3
, makeWrapper
, qtbase
, qtsvg
, libGLU
, libGL
, zlib
}:

mkDerivation rec {
  pname = "organicmaps";
  version = "2021.12.01-4-android";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    rev = version;
    sha256 = "sha256-1PS9vQ8KPi68MYv3TyeKE430KZb+sxuffeeltKePTQg=";
    fetchSubmodules = true;
  };

  # Disable certificate check. It's dependent on time
  postPatch = ''
    echo "exit 0" > tools/unix/check_cert.sh
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    which
    python3
    makeWrapper
  ];

  # Most dependencies are vendored
  buildInputs = [
    qtbase
    qtsvg
    libGLU
    libGL
    zlib
  ];

  # Yes, this is PRE configure. The configure phase uses cmake
  preConfigure = ''
    bash ./configure.sh
  '';

  NIX_LDFLAGS = "-lGL";

  postInstall = ''
    install -Dm755 OMaps $out/bin/OMaps
    # Tell the program that the read-only and the read-write data locations
    # are different, and create the read-write one.
    wrapProgram $out/bin/OMaps \
      --add-flags "-resources_path $out/share/organicmaps/data" \
      --add-flags '-data_path "''${XDG_DATA_HOME:-''${HOME}/.local/share}/OMaps"' \
      --run 'mkdir -p "''${XDG_DATA_HOME:-''${HOME}/.local/share}/OMaps"'

    mkdir $out/share/organicmaps
    cp -r ../data $out/share/organicmaps/data
    install -Dm644 ../qt/res/logo.png $out/share/icons/hicolor/96x96/apps/organicmaps.png
    install -Dm644 ../qt/res/OrganicMaps.desktop $out/share/applications/OrganicMaps.desktop

    # Part of the vendored expat package. OMaps only needs the library, so we
    # delete this to avoid conflicts with the system's expat.
    rm $out/bin/xmlwf
  '';

  meta = with lib; {
    homepage = "https://organicmaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "OMaps";
    broken = stdenv.isDarwin; # "invalid application of 'sizeof' to a function type"
  };
}
