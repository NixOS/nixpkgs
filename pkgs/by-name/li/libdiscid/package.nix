{ lib, stdenv, fetchurl, cmake, pkg-config, darwin }:

stdenv.mkDerivation rec {
  pname = "libdiscid";
  version = "0.6.4";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-3V6PHJrq1ELiO3SanMkzY3LmLoitcHmitiiVsDkMsoI=";
  };

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework CoreFoundation -framework IOKit";

  meta = with lib; {
    description = "C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = "http://musicbrainz.org/doc/libdiscid";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
