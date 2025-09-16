{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fsatrace";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "jacereda";
    repo = "fsatrace";
    rev = "5af79511828ca6cea4e5dd9f28e1676fb0b705e9";
    "hash" = "sha256-pn07qlrRaM153znEviziuKWrkX9cLsNFCujovmE4UUA=";
  };

  installDir = "libexec/${pname}-${version}";

  makeFlags = [ "INSTALLDIR=$(out)/$(installDir)" ];

  preInstall = ''
    mkdir -p $out/$installDir
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/$installDir/fsatrace $out/bin/fsatrace
  '';

  meta = with lib; {
    homepage = "https://github.com/jacereda/fsatrace";
    description = "Filesystem access tracer";
    mainProgram = "fsatrace";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
