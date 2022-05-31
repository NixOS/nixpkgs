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
  version = "2022.04.27-2";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    rev = "${version}-android";
    sha256 = "sha256-HsskddXne5xClBZoT3aXP+51VRQQJhlUPda/M20SrH0=";
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

  # Tell the program that the read-only and the read-write data locations
  # are different, and create the read-write one.
  # https://github.com/organicmaps/organicmaps/issues/2387
  postInstall = ''
    wrapProgram $out/bin/OMaps \
      --add-flags "-resources_path $out/share/organicmaps/data" \
      --add-flags '-data_path "''${XDG_DATA_HOME:-''${HOME}/.local/share}/OMaps"' \
      --run 'mkdir -p "''${XDG_DATA_HOME:-''${HOME}/.local/share}/OMaps"'
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
