{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "hts-engine";
  version = "1.10";

  src = fetchurl {
    url = "mirror://sourceforge/hts-engine/hts_engine%20API/hts_engine_API-${version}/hts_engine_API-${version}.tar.gz";
    sha256 = "sha256-4hMr5YYNj7SkYL52ZFTP18PiHPZ7UJxI4YBP6rFJaPc=";
  };

  meta = with lib; {
    description = "HMM-based speech synthesis engine";
    homepage = "https://hts-engine.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yorwba ];
  };
}
