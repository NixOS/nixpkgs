{ stdenv, lib, autoconf, automake, go, file, git, wget, gnupg1, squashfsTools, cpio
, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.8.0";
  name = "rkt-${version}";

  src = fetchFromGitHub {
      rev = "v${version}";
      owner = "coreos";
      repo = "rkt";
      sha256 = "1abv9psd5w0m8p2kvrwyjnrclzajmrpbwfwmkgpnkydhmsimhnn0";
  };

  buildInputs = [ autoconf automake go file git wget gnupg1 squashfsTools cpio ];
  
  preConfigure = ''
    ./autogen.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv build-rkt-${version}/bin/* $out/bin
  '';
    
  meta = with lib; {
    description = "A fast, composable, and secure App Container runtime for Linux";
    homepage = http://rkt.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge ];
    platforms = platforms.linux;
  };
}
