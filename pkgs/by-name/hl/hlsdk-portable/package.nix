{
  lib,
  fetchFromGitHub,
  stdenv,
  wafHook,
  python3,
}:

stdenv.mkDerivation {
  pname = "hlsdk-portable";

  # Taken from build script: https://github.com/FWGS/hlsdk-portable/blob/afe7d33e15c75fa61fc5a8e287bc484146e7c377/wscript#L10
  version = "2.4";

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "hlsdk-portable";
    fetchSubmodules = true;
    rev = "afe7d33e15c75fa61fc5a8e287bc484146e7c377";
    hash = "sha256-lR5otfTur9yRcyAt/NkcCIYcqsMg2QQ+EdkA8o18vA0=";
  };

  nativeBuildInputs = [
    python3
    wafHook
  ];

  dontAddPrefix = true;

  wafConfigureFlags = [ "-T release" ] ++ lib.optionals stdenv.buildPlatform.is64bit [ "-8" ];

  wafInstallFlags = [ "--destdir=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/FWGS/hlsdk-portable";
    description = "Portable crossplatform Half-Life SDK for GoldSource and Xash3D engines";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
