{
  lib,
  stdenv,
  fetchurl,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ladspa-sdk";
  version = "1.17";
  src = fetchurl {
    url = "https://www.ladspa.org/download/ladspa_sdk_${finalAttrs.version}.tgz";
    hash = "sha256-J9JPJ55Lgb0X7L3MOOTEKZG7OIgmwLIABnzg61nT2ls=";
  };

  buildInputs = [ libsndfile ];

  sourceRoot = "ladspa_sdk_${finalAttrs.version}/src";

  strictDeps = true;

  patchPhase = ''
    sed -i 's@/usr/@$(out)/@g'  Makefile
    substituteInPlace Makefile \
      --replace /tmp/test.wav $NIX_BUILD_TOP/${finalAttrs.sourceRoot}/test.wav
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CPP=${stdenv.cc.targetPrefix}c++"
  ];

  # The default target also runs tests, which we don't want to do in
  # the build phase as it would break cross.
  buildFlags = [ "targets" ];

  # Tests try to create and play a sound file.  Playing will fail, but
  # it's probably still useful to run the part that creates the file.
  doCheck = true;

  meta = {
    description = "SDK for the LADSPA audio plugin standard";
    longDescription = ''
      The LADSPA SDK, including the ladspa.h API header file,
      ten example LADSPA plugins and
      three example programs (applyplugin, analyseplugin and listplugins).
      For just ladspa.h, use the ladspaH package.
    '';
    homepage = "http://www.ladspa.org/ladspa_sdk/overview.html";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
