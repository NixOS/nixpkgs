{
  lib,
  stdenv,
  ladspa-sdk,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ladspa-header";

  inherit (ladspa-sdk) version src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    cp src/ladspa.h $out/include/ladspa.h
  '';

  meta = {
    inherit (ladspa-sdk.meta) homepage license maintainers;
    description = "LADSPA format audio plugins header file";
    longDescription = ''
      The ladspa.h API header file from the LADSPA SDK.
      For the full SDK, use the ladspa-sdk package.
    '';
    platforms = lib.platforms.all;
  };
})
