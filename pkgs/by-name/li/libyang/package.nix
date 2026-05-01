{
  stdenv,
  lib,
  fetchFromGitHub,

  # build time
  cmake,
  pkg-config,

  # dependencies
  pcre2,
  xxhash,

  # update script
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libyang";
  version = "5.4.9";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YXQyfZjxWt5cdutad6qThjdyVgibRdLEafxDQFisMEA=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    xxhash
  ];

  propagatedBuildInputs = [
    pcre2
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "YANG data modelling language parser and toolkit";
    longDescription = ''
      libyang is a YANG data modelling language parser and toolkit written (and
      providing API) in C. The library is used e.g. in libnetconf2, Netopeer2,
      sysrepo or FRRouting projects.
    '';
    homepage = "https://github.com/CESNET/libyang";
    license = with lib.licenses; [ bsd3 ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ woffs ];
  };
})
