{ stdenv
, lib
, nix-update-script
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, makeWrapper
, fmt_8
, libsndfile
, SDL2
, zlib
, withJACK ? stdenv.hostPlatform.isUnix
, libjack2
, withGUI ? true
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "furnace";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "tildearrow";
    repo = "furnace";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-BcaPQuDFkAaxFQKwoI6xdSWcyHo5VsqZcwf++JISqRs=";
  };

  patches = [
    (fetchpatch {
      name = "0001-furnace-fix-wrong-include-path.patch";
      url = "https://github.com/tildearrow/furnace/commit/456db22f9d9f0ed40d74fe50dde492e69e901fcc.patch";
      sha256 = "17ikb1z9ldm7kdj00m4swsrq1qx94vlzhc6h020x3ryzwnglc8d3";
    })
  ];

  postPatch = ''
    # rtmidi is not used yet
    sed -i -e '/add_subdirectory(extern\/rtmidi/d' -e '/DEPENDENCIES_LIBRARIES rtmidi/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
  ];

  buildInputs = [
    fmt_8
    libsndfile
    SDL2
    zlib
  ] ++ lib.optionals withJACK [
    libjack2
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
  ];

  cmakeFlags = [
    "-DBUILD_GUI=${if withGUI then "ON" else "OFF"}"
    "-DSYSTEM_FMT=ON"
    "-DSYSTEM_LIBSNDFILE=ON"
    "-DSYSTEM_ZLIB=ON"
    "-DSYSTEM_SDL2=ON"
    "-DWITH_JACK=${if withJACK then "ON" else "OFF"}"
    "-DWARNINGS_ARE_ERRORS=ON"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Normal CMake install phase on Darwin only installs the binary, the user is expected to use CPack to build a
    # bundle. That adds alot of overhead for not much benefit (CPack is currently abit broken, and needs impure access
    # to /usr/bin/hdiutil). So we'll manually assemble & install everything instead.

    mkdir -p $out/{Applications/Furnace.app/Contents/{MacOS,Resources},share/{,doc,licenses}/furnace}
    mv $out/{bin,Applications/Furnace.app/Contents/MacOS}/furnace
    makeWrapper $out/{Applications/Furnace.app/Contents/MacOS,bin}/furnace

    install -m644 {../res,$out/Applications/Furnace.app/Contents}/Info.plist
    install -m644 ../res/icon.icns $out/Applications/Furnace.app/Contents/Resources/Furnace.icns
    install -m644 {..,$out/share/licenses/furnace}/LICENSE
    cp -r ../papers $out/share/doc/furnace/
    cp -r ../demos $out/share/furnace/
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Multi-system chiptune tracker compatible with DefleMask modules";
    homepage = "https://github.com/tildearrow/furnace";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
