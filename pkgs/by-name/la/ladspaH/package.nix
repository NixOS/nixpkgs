{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ladspa.h";
  version = "1.17";
  src = fetchurl {
    url = "https://www.ladspa.org/download/ladspa_sdk_${finalAttrs.version}.tgz";
    hash = "sha256-J9JPJ55Lgb0X7L3MOOTEKZG7OIgmwLIABnzg61nT2ls=";
  };

  installPhase = ''
    mkdir -p $out/include
    cp src/ladspa.h $out/include/ladspa.h
  '';

  meta = {
    description = "LADSPA format audio plugins header file";
    longDescription = ''
      The ladspa.h API header file from the LADSPA SDK.
      For the full SDK, use the ladspa-sdk package.
    '';
    homepage = "http://www.ladspa.org/ladspa_sdk/overview.html";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
  };
})
