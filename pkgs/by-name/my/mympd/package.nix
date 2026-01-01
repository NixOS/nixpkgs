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
<<<<<<< HEAD
  version = "23.0.1";
=======
  version = "23.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jcorporation";
    repo = "myMPD";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-X5Pyh5QqVbH+4z1hf+u/JmN4lVKcW1RYu+rtDd5ec3w=";
=======
    sha256 = "sha256-tD7ywqZJEix+ET26z3yJmgHXBACBOrSAlR9U1Uff/v8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
