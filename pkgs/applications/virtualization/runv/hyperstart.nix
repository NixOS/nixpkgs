{ stdenv, lib, fetchFromGitHub, autoconf, automake, cpio }:

with lib;

stdenv.mkDerivation rec {
  name = "hyperstart-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hyperhq";
    repo = "hyperstart";
    rev = "v${version}";
    sha256 = "0caznq9c785zwqj4zj48ls60sy01imlc9mchdr9103jix5kc3hp5";
  };


  buildInputs = [ autoconf automake cpio ];

  preConfigure = ''
    ./autogen.sh
  '';

  installPhase = ''
    mkdir -p $out
    cp -a build/kernel $out/
    cp -a build/hyper-initrd.img $out/
  '';

  meta = {
    homepage = https://github.com/hyperhq/hyperstart;
    description = "The tiny Init service for HyperContainer";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.linux;
  };
}
