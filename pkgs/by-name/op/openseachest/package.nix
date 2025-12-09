{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "openseachest";
  version = "25.05.3";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    tag = "v${version}";
    hash = "sha256-huhdRF2K1AEDRX6Jyz8a/OpUEKFmH+FLNr5KHM/4Sk4=";
    fetchSubmodules = true;
  };

  makeFlags = [ "-C Make/gcc" ];
  buildFlags = [ "release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r Make/gcc/openseachest_exes/. $out/bin
    cp -r docs/man $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Collection of command line diagnostic tools for storage devices";
    homepage = "https://github.com/Seagate/openSeaChest";
    license = licenses.mpl20;
    maintainers = with maintainers; [ justinas ];
    platforms = with platforms; freebsd ++ linux;
  };
}
