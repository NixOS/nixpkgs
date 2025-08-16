{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "joomla";
  version = "5.2.3";

  src = fetchurl {
    url = "https://downloads.joomla.org/cms/joomla${lib.versions.major finalAttrs.version}/${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }/Joomla_${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }-Stable-Full_Package.tar.gz?format=gz";
    sha256 = "sha256-j8qToPPxqLuxRkvCdqrVJNDO341PVDex/Vh9+ZV5HAA=";
  };

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r * $out/
    runHook postInstall
  '';

  meta = {
    description = "Open Source CMS Software";
    homepage = "https://www.joomla.org";
    maintainers = with lib.maintainers; [
      kiike
    ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
})
