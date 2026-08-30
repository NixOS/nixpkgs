{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "npapi-sdk";

  version = "0.27.2";

  src = fetchurl {
    url = "https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-${finalAttrs.version}.tar.bz2";

    sha256 = "0xxfcsjmmgbbyl9zwpzdshbx27grj5fnzjfmldmm9apws2yk9gq1";
  };

  meta = {
    description = "Bundle of NPAPI headers by Mozilla";

    homepage = "https://bitbucket.org/mgorny/npapi-sdk"; # see also https://github.com/mozilla/npapi-sdk
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
