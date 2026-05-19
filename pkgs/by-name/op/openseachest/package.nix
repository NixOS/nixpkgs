{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openseachest";
  version = "25.05.3";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-huhdRF2K1AEDRX6Jyz8a/OpUEKFmH+FLNr5KHM/4Sk4=";
    fetchSubmodules = true;
  };

  makeFlags = [ "--directory=Make/gcc" ];
  buildFlags = [ "release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r Make/gcc/openseachest_exes/. $out/bin
    cp -r docs/man $out/share

    runHook postInstall
  '';

  meta = {
    description = "Collection of command line diagnostic tools for storage devices";
    homepage = "https://github.com/Seagate/openSeaChest";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ justinas ];
    platforms = with lib.platforms; freebsd ++ linux;
  };
})
