{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdiscid";
  version = "0.7.0";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "libdiscid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ynQuEzHblXnqvV6bKtjJNFuwUkd/ACVCy+jFfUAD+jo=";
  };

  postPatch = ''
    substituteInPlace libdiscid.pc.in \
      --replace-fail 'libdir=@libdir@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=@includedir@' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "CoreFoundation"
      "-framework"
      "IOKit"
    ];
  };

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = "https://musicbrainz.org/doc/libdiscid";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
    pkgConfigModules = [ "libdiscid" ];
  };
})
