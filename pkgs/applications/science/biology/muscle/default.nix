{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  _name   = "muscle";
  name    = "${_name}-${version}";
  version = "3.8.31";

  src = fetchurl {
    url = "https://www.drive5.com/muscle/downloads${version}/${_name}${version}_src.tar.gz";
    sha256 = "1b89z0x7h098g99g00nqadgjnb2r5wpi9s11b7ddffqkh9m9dia3";
  };

  patches = [
    ./muscle-3.8.31-no-static.patch
  ];

  preBuild = ''
    cd ./src/
    patchShebangs mk
  '';

  installPhase = ''
    install -vD muscle $out/bin/muscle
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A multiple sequence alignment method with reduced time and space complexity";
    license     = licenses.publicDomain;
    homepage    = "https://www.drive5.com/muscle/";
    maintainers = [ maintainers.unode ];
    # NOTE: Supposed to be compatible with darwin/intel & PPC but currently fails.
    # Anyone with access to these platforms is welcome to give it a try
    platforms   = lib.platforms.linux;
  };
}
