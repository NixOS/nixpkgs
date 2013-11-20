{ stdenv, fetchurl, libX11, libXtst, libXext, libXdamage, libXfixes, wineUnstable, makeWrapper, libXau
, bash, patchelf }:

let
  topath = "${wineUnstable}/bin";

  toldpath = stdenv.lib.concatStringsSep ":" (map (x: "${x}/lib") 
    [ stdenv.gcc.gcc libX11 libXtst libXext libXdamage libXfixes wineUnstable ]);
in
stdenv.mkDerivation {
  name = "teamviewer-8.0.17147";
  src = fetchurl {
    url = "http://download.teamviewer.com/download/teamviewer_linux_x64.deb";
    sha256 = "0s5m15f99rdmspzwx3gb9mqd6jx1bgfm0d6rfd01k9rf7gi7qk0k";
  };

  buildInputs = [ makeWrapper patchelf ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/share/teamviewer8 $out/bin
    cp -a opt/teamviewer8/* $out/share/teamviewer8
    rm -R $out/share/teamviewer8/tv_bin/wine/{bin,lib,share}

    cat > $out/bin/teamviewer << EOF
    #!${bash}/bin/sh
    export LD_LIBRARY_PATH=${toldpath}\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
    export PATH=${topath}\''${PATH:+:\$PATH}
    $out/share/teamviewer8/tv_bin/script/teamviewer "\$@"
    EOF
    chmod +x $out/bin/teamviewer

    patchelf --set-rpath "${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXext}/lib:${libXau}/lib:${libXdamage}/lib:${libXfixes}/lib" $out/share/teamviewer8/tv_bin/teamviewerd
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/share/teamviewer8/tv_bin/teamviewerd
    ln -s $out/share/teamviewer8/tv_bin/teamviewerd $out/bin/
  '';

  meta = {
    homepage = "http://www.teamviewer.com";
    license = "unfree";
    description = "Desktop sharing application, providing remote support and online meetings";
  };
}
