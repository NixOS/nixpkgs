{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "openseachest";
  version = "25.05";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    rev = "v${version}";
    hash = "sha256-rxy+A2HV20RbCF6rnl04RwAP7LHm1jM9Y78N08pBr6E=";
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
