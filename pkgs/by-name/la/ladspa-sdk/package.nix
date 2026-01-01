{
  lib,
  stdenv,
  fetchurl,
<<<<<<< HEAD
  libsndfile,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ladspa-sdk";
<<<<<<< HEAD
  version = "1.17";
  src = fetchurl {
    url = "https://www.ladspa.org/download/ladspa_sdk_${finalAttrs.version}.tgz";
    hash = "sha256-J9JPJ55Lgb0X7L3MOOTEKZG7OIgmwLIABnzg61nT2ls=";
  };

  buildInputs = [ libsndfile ];

=======
  version = "1.15";
  src = fetchurl {
    url = "https://www.ladspa.org/download/ladspa_sdk_${finalAttrs.version}.tgz";
    sha256 = "1vgx54cgsnc3ncl9qbgjbmq12c444xjafjkgr348h36j16draaa2";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      For just ladspa.h, use the ladspaH package.
    '';
    homepage = "http://www.ladspa.org/ladspa_sdk/overview.html";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ magnetophon ];
=======
    '';
    homepage = "http://www.ladspa.org/ladspa_sdk/overview.html";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.magnetophon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
  };
})
