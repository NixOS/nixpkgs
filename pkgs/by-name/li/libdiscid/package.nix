{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdiscid";
  version = "0.6.5";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "libdiscid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lGq2iGt7c4h8HntEPeQcd7X+IykRLm0kvjrLswRWSSs=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "CoreFoundation"
      "-framework"
      "IOKit"
    ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = "https://musicbrainz.org/doc/libdiscid";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
})
