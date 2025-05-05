{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "trimal";
  version = "1.5.0";

  src = fetchFromGitHub {
    repo = "trimal";
    owner = "scapella";
    rev = "v${version}";
    sha256 = "sha256-6GXirih7nY0eD2XS8aplLcYf53EeLuae+ewdUgBiKQQ=";
  };

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a trimal readal statal $out/bin
  '';

  meta = with lib; {
    description = "Tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "http://trimal.cgenomics.org";
    maintainers = [ maintainers.bzizou ];
  };
}
