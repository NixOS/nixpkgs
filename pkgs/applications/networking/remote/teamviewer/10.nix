{ stdenv, fetchurl, libX11, libXtst, libXext, libXdamage, libXfixes, wineUnstable, makeWrapper, libXau
, bash, patchelf, config }:

let
  topath = "${wineUnstable}/bin";

  toldpath = stdenv.lib.concatStringsSep ":" (map (x: "${x}/lib") 
    [ stdenv.cc.cc libX11 libXtst libXext libXdamage libXfixes wineUnstable ]);
in
stdenv.mkDerivation {
  name = "teamviewer-10.0.37742";
  src = fetchurl {
    url = config.teamviewer10.url or "http://download.teamviewer.com/download/teamviewer_amd64.deb";
    sha256 = config.teamviewer10.sha256 or "1j3zbvyj003gk8mm9sv1dld9x30l6fswwlhdyk46mixsqq5ayp6c";
  };

  buildInputs = [ makeWrapper patchelf ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/share/teamviewer $out/bin
    cp -a opt/teamviewer/* $out/share/teamviewer
    rm -R $out/share/teamviewer/tv_bin/wine/{bin,lib,share}

    cat > $out/bin/teamviewer << EOF
    #!${bash}/bin/sh
    export LD_LIBRARY_PATH=${toldpath}\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
    export PATH=${topath}\''${PATH:+:\$PATH}
    $out/share/teamviewer/tv_bin/script/teamviewer "\$@"
    EOF
    chmod +x $out/bin/teamviewer

    patchelf --set-rpath "${stdenv.cc.cc}/lib64:${stdenv.cc.cc}/lib:${libX11}/lib:${libXext}/lib:${libXau}/lib:${libXdamage}/lib:${libXfixes}/lib" $out/share/teamviewer/tv_bin/teamviewerd
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/teamviewer/tv_bin/teamviewerd
    ln -s $out/share/teamviewer/tv_bin/teamviewerd $out/bin/
  '';

  meta = {
    homepage = "http://www.teamviewer.com";
    license = stdenv.lib.licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
  };
}
