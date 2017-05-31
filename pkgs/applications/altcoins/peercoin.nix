{ stdenv, fetchFromGitHub
, pkgconfig, autoreconfHook
, openssl, db48, boost, zlib, miniupnpc
, protobuf, utillinux, qt4, qrencode
, withGui, libevent }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "peercoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.6.2ppc";

  src = fetchFromGitHub {
    owner = "peercoin";
    repo = "peercoin";
    rev = "v${version}";
    sha256 = "16wxwwrv83x0qjj4dndlkrpw9ril9j0rh6skp1q1xm5zyc0fx0xl";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc utillinux protobuf libevent qt4 ]
                  ++ optionals withGui [ qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  buildPhase = ''
    qmake
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp peercoin-qt $out/bin/
  '';

  meta = {
    description = "A lite version of Bitcoin using scrypt as a proof-of-work algorithm";
    longDescription= ''
      Peercoin is a peer-to-peer Internet currency that enables instant payments
      to anyone in the world. It is based on the Bitcoin protocol but differs
      from Bitcoin in that it can be efficiently mined with consumer-grade hardware.
      Litecoin provides faster transaction confirmations (2.5 minutes on average)
      and uses a memory-hard, scrypt-based mining proof-of-work algorithm to target
      the regular computers and GPUs most people already have.
      The Litecoin network is scheduled to produce 84 million currency units.
    '';
    homepage = https://peercoin.org/;
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ offline AndersonTorres ];  
  };
}
