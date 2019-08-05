{ stdenv, fetchurl, jre, makeWrapper }:

let
  rpath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc ];
in
  stdenv.mkDerivation rec {
    pname = "coinomi";
    version = "1.0.11";

    src = fetchurl {
      url = "https://binaries.coinomi.com/desktop/coinomi-wallet-${version}-linux64.tar.gz";
      sha256 = "2547c71103c20699f4325098fbe5e6be4bbf1949a3ad71a3c7c66e0f09fa1819";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cd Coinomi
      cp -r . $out
      ln -s $out/Coinomi $out/bin/Coinomi
      ln -s $out/coinomi-wallet.desktop $out/share/applications
    '';

    postFixup = ''
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/Coinomi
      patchelf --set-rpath "${rpath}" $out/Coinomi
    '';

    meta = with stdenv.lib; {
      homepage = "https://www.coinomi.com/";
      description = "Securely store, manage and exchange Bitcoin, Ethereum, and more than 1,500 other blockchain assets.";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = [ maintainers.angristan ];
    };
  }
