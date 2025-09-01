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

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework CoreFoundation -framework IOKit";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = "https://musicbrainz.org/doc/libdiscid";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
})
