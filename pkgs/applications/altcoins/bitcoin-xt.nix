{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, curl
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-xt-" + version;
  version = "0.11D";

  src = fetchurl {
    url = "https://github.com/bitcoinxt/bitcoinxt/archive/v${version}.tar.gz";
    sha256 = "09r2i88wzqaj6mh66l3ngyfkm1a0dhwm5ibalj6y55wbxm9bvd36";
  };

  buildInputs = [ pkgconfig autoreconfHook openssl db48 boost zlib
                  miniupnpc utillinux protobuf curl ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [
    "--with-boost-libdir=${boost.lib}/lib"
    "--with-libcurl-headers=${curl}/include"
  ] ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
       Bitcoin XT is an implementation of a Bitcoin full node, based upon the
       source code of Bitcoin Core. It is built by taking the latest stable
       Core release, applying a series of patches, and then doing deterministic
       builds so anyone can check the downloads correspond to the source code. 

      Maintainer's note: Nix doesn't use the official deterministic builds.
    '';
    homepage = "https://bitcoinxt.software/";
    maintainers = with maintainers; [ jefdaj ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
