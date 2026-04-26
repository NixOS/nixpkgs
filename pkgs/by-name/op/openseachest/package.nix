{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openseachest";
  version = "26.03.1";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G7dLa8WtBuzotDQFjFsoKT7+b3u45eEfuSpbYCmo4Fo=";
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
