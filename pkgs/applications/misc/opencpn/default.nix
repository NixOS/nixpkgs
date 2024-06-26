{ stdenv
, lib
, AppKit
, DarwinTools
, alsa-utils
, at-spi2-core
, cmake
, curl
, dbus
, elfutils
, fetchFromGitHub
, flac
, gtk3
, glew
, gtest
, jasper
, lame
, libGLU
, libarchive
, libdatrie
, libepoxy
, libexif
, libogg
, libopus
, libselinux
, libsepol
, libsndfile
, libthai
, libunarr
, libusb1
, libvorbis
, libxkbcommon
, lsb-release
, lz4
, libmpg123
, makeWrapper
, pcre
, pcre2
, pkg-config
, portaudio
, rapidjson
, sqlite
, tinyxml
, udev
, util-linux
, wxGTK32
, xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencpn";
  version = "5.8.4";

  src = fetchFromGitHub {
    owner = "OpenCPN";
    repo = "OpenCPN";
    rev = "Release_${finalAttrs.version}";
    hash = "sha256-axRI3sssj2Q6IBfIeyvOa494b0EgKFP+lFL/QrGIybQ=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i '/fixup_bundle/d; /NO_DEFAULT_PATH/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gtest
  ] ++ lib.optionals stdenv.isLinux [
    lsb-release
  ] ++ lib.optionals stdenv.isDarwin [
    DarwinTools
    makeWrapper
  ];

  buildInputs = [
    at-spi2-core
    curl
    dbus
    flac
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    AppKit
  ] ++ [
    gtk3
    glew
    jasper
    libGLU
    libarchive
    libdatrie
    libepoxy
    libexif
    libogg
    libopus
    libsndfile
    libthai
    libunarr
    libusb1
    libvorbis
    libxkbcommon
    lz4
    libmpg123
    pcre
    pcre2
    portaudio
    rapidjson
    sqlite
    tinyxml
    wxGTK32
  ] ++ lib.optionals stdenv.isLinux [
    alsa-utils
    libselinux
    libsepol
    util-linux
    xorg.libXdmcp
    xorg.libXtst
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [
    elfutils
  ] ++ lib.optionals stdenv.isDarwin [
    lame
  ];

  cmakeFlags = [ "-DOCPN_BUNDLE_DOCS=true" ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (!stdenv.hostPlatform.isx86) [
    "-DSQUISH_USE_SSE=0"
  ]);

  postInstall = lib.optionals stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/OpenCPN.app $out/Applications
    makeWrapper $out/Applications/OpenCPN.app/Contents/MacOS/OpenCPN $out/bin/opencpn
  '';

  doCheck = true;

  meta = with lib; {
    description = "Concise ChartPlotter/Navigator";
    maintainers = with maintainers; [ kragniz lovesegfault ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    homepage = "https://opencpn.org/";
  };
})
