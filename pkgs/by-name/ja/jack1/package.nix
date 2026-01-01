{
  lib,
  stdenv,
  fetchurl,
  pkg-config,

  # Optional Dependencies
  alsa-lib ? null,
  db ? null,
  libuuid ? null,
  libffado ? null,
  celt_0_7 ? null,

  testers,
}:

let
  shouldUsePkg =
    pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  optAlsaLib = shouldUsePkg alsa-lib;
  optDb = shouldUsePkg db;
  optLibuuid = shouldUsePkg libuuid;
  optLibffado = shouldUsePkg libffado;
  optCelt = shouldUsePkg celt_0_7;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jack1";
  version = "0.126.0";

  src = fetchurl {
    url = "https://github.com/jackaudio/jack1/releases/download/${finalAttrs.version}/jack1-${finalAttrs.version}.tar.gz";
    hash = "sha256-eykOnce5JirDKNQe74DBBTyXAT76y++jBHfLmypUReo=";
  };

  configureFlags = [
    (lib.enableFeature (optLibffado != null) "firewire")
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    optAlsaLib
    optDb
    optLibffado
    optCelt
  ];
  propagatedBuildInputs = [ optLibuuid ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

<<<<<<< HEAD
  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "JACK audio connection kit";
    homepage = "https://jackaudio.org";
    license = with lib.licenses; [
=======
  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "JACK audio connection kit";
    homepage = "https://jackaudio.org";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2Plus
      lgpl21
    ];
    pkgConfigModules = [ "jack" ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
