{ stdenv
, lib
, alsa-utils
, at-spi2-core
, cmake
, curl
, dbus
, fetchFromGitHub
, fetchpatch
, flac
, gtk3
, jasper
, libGLU
, libarchive
, libdatrie
, libelf
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
, makeWrapper
, pcre
, pkg-config
, portaudio
, sqlite
, tinyxml
, udev
, util-linux
, wxGTK32
, xorg
}:

stdenv.mkDerivation rec {
  pname = "opencpn";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "OpenCPN";
    repo = "OpenCPN";
    rev = "Release_${version}";
    hash = "sha256-sNZYf/2gtjRrrGPuazVnKTgcuIQpKPazhexqlK21T4g=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/OpenCPN/OpenCPN/commit/30fa16850ba97d3df0622273947e3e3975b8e6c0.patch";
      sha256 = "sha256-Sb4FE9QJA5kMJi52/x1Az6rMTS3WSURPx4QAhcv2j9E=";
    })
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/TargetSetup.cmake \
      --replace '"sw_vers" "-productVersion"' '"echo" "1"'
    sed -i '/fixup_bundle/d' CMakeLists.txt
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    substituteInPlace CMakeLists.txt \
      --replace 'DARWIN_VERSION LESS 16' 'TRUE'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    lsb-release
  ] ++ lib.optionals stdenv.isDarwin [
    makeWrapper
  ];

  buildInputs = [
    at-spi2-core
    curl
    dbus
    flac
    gtk3
    jasper
    libGLU
    libarchive
    libdatrie
    libelf
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
    pcre
    portaudio
    sqlite
    tinyxml
    wxGTK32
  ] ++ lib.optionals stdenv.isLinux [
    alsa-utils
    libselinux
    libsepol
    udev
    util-linux
    xorg.libXdmcp
    xorg.libXtst
  ];

  cmakeFlags = [ "-DOCPN_BUNDLE_DOCS=true" ];

  NIX_CFLAGS_COMPILE = lib.optionals (!stdenv.hostPlatform.isx86) [
    "-DSQUISH_USE_SSE=0"
  ];

  postInstall = lib.optionals stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/OpenCPN.app $out/Applications
    makeWrapper $out/Applications/OpenCPN.app/Contents/MacOS/OpenCPN $out/bin/opencpn
  '';

  doCheck = true;

  meta = with lib; {
    description = "A concise ChartPlotter/Navigator";
    maintainers = with maintainers; [ kragniz lovesegfault ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    homepage = "https://opencpn.org/";
  };
}
