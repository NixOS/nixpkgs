{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  libmpdclient,
  openssl,
  lua5_5,
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
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "jcorporation";
    repo = "myMPD";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OwTYcyiRT/2K09UirhcNobXo1g9aDpz7eh5OYtA0eIo=";
  };

  # Backport the Lua 5.5 dump fix until it is included in a release.
  patches = [
    (fetchpatch2 {
      name = "mympd-lua55-dump-end.patch";
      url = "https://github.com/jcorporation/myMPD/commit/47e49136e413000035ab53b4201a287ba2e5f39b.patch?full_index=1";
      hash = "sha256-PLFvrGle7aa15FVju+Keo3sAeL5GAJ3SWqc4RKCwg6s=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    gzip
    perl
    jq
    lua5_5 # luac is needed for cross builds
  ];
  preConfigure = ''
    env MYMPD_BUILDDIR=$PWD/build ./build.sh createassets
  '';
  buildInputs = [
    libmpdclient
    openssl
    lua5_5
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
