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
, makeWrapper
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
  version = "2022.03.23-4-android";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    rev = version;
    sha256 = "sha256-4VBsHq8z/odD7Nrk9e0sYMEBBLeTAHsWsdgPIN1KVZo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Disable certificate check. It's dependent on time
    echo "exit 0" > tools/unix/check_cert.sh

    # crude fix for https://github.com/organicmaps/organicmaps/issues/1862
    echo "echo ${lib.replaceStrings ["." "-" "android"] ["" "" ""] version}" > tools/unix/version.sh
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    which
    python3
    rsync
    makeWrapper
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

  postInstall = ''
    install -Dm755 OMaps $out/bin/OMaps
    # Tell the program that the read-only and the read-write data locations
    # are different, and create the read-write one.
    wrapProgram $out/bin/OMaps \
      --add-flags "-resources_path $out/share/organicmaps/data" \
      --add-flags '-data_path "''${XDG_DATA_HOME:-''${HOME}/.local/share}/OMaps"' \
      --run 'mkdir -p "''${XDG_DATA_HOME:-''${HOME}/.local/share}/OMaps"'

    mkdir -p $out/share/organicmaps
    cp -r ../data $out/share/organicmaps/data
    install -Dm644 ../qt/res/logo.png $out/share/icons/hicolor/96x96/apps/organicmaps.png
    install -Dm644 ../qt/res/OrganicMaps.desktop $out/share/applications/OrganicMaps.desktop
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
