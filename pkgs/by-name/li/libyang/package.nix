{
  stdenv,
  lib,
  fetchFromGitHub,

  # build time
  cmake,
  pkg-config,

  # dependencies
  pcre2,
  xxHash,

  # update script
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libyang";
  version = "3.13.6";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v${version}";
    hash = "sha256-rc/WdBCVZDwensqnVMrQXCPevLg0INidzN9Qwhqw2Mk=";
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
    xxHash
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "YANG data modelling language parser and toolkit";
    longDescription = ''
      libyang is a YANG data modelling language parser and toolkit written (and
      providing API) in C. The library is used e.g. in libnetconf2, Netopeer2,
      sysrepo or FRRouting projects.
    '';
    homepage = "https://github.com/CESNET/libyang";
<<<<<<< HEAD
    license = with lib.licenses; [ bsd3 ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ woffs ];
=======
    license = with licenses; [ bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ woffs ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
