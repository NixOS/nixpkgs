{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openseachest";
  version = "26.03.0";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L/YoJEUr5e/XtmejbeZ5cP17ym8v3IonWvZ/T772c5E=";
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
