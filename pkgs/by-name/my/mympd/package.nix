{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libmpdclient,
  openssl,
  lua5_3,
  libid3tag,
  flac,
  pcre2,
  gzip,
  perl,
  jq,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mympd";
  version = "20.0.0";

  src = fetchFromGitHub {
    owner = "jcorporation";
    repo = "myMPD";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+j6Y1Z17fJkH4KQyC1gjZeWhFRwHpCGcLQC2hOmIZ2A=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    gzip
    perl
    jq
    lua5_3 # luac is needed for cross builds
  ];
  preConfigure = ''
    env MYMPD_BUILDDIR=$PWD/build ./build.sh createassets
  '';
  buildInputs = [
    libmpdclient
    openssl
    lua5_3
    libid3tag
    flac
    pcre2
  ];

  cmakeFlags = [
    # Otherwise, it tries to parse $out/etc/mympd.conf on startup.
    "-DCMAKE_INSTALL_SYSCONFDIR=/etc"
    # similarly here
    "-DCMAKE_INSTALL_LOCALSTATEDIR=/var/lib/mympd"
  ];
  hardeningDisable = [
    # causes redefinition of _FORTIFY_SOURCE
    "fortify3"
  ];
  # 5 tests out of 23 fail, probably due to the sandbox...
  doCheck = false;

  strictDeps = true;

  passthru.tests = { inherit (nixosTests) mympd; };

  meta = {
    homepage = "https://jcorporation.github.io/myMPD";
    description = "Standalone and mobile friendly web mpd client with a tiny footprint and advanced features";
    maintainers = [ lib.maintainers.doronbehar ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    mainProgram = "mympd";
  };
})
