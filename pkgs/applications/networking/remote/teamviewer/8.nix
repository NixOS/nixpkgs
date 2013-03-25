{ stdenv, fetchurl, libX11, libXtst, libXext, libXdamage, libXfixes, wine, makeWrapper
, bash }:

# Work in progress.

# It doesn't want to start unless teamviewerd is running as root.
# I haven't tried to make the daemon run.

assert stdenv.system == "i686-linux";
let
  topath = "${wine}/bin";

  toldpath = stdenv.lib.concatStringsSep ":" (map (x: "${x}/lib") 
    [ stdenv.gcc.gcc libX11 libXtst libXext libXdamage libXfixes wine ]);
in
stdenv.mkDerivation {
  name = "teamviewer-8.0.17147";
  src = fetchurl {
    url = "http://download.teamviewer.com/download/teamviewer_linux_x64.deb";
    sha256 = "01iynk954pphl5mq4avs843xyzvdfzng1lpsy7skgwvw0k9cx5ab";
  };

  buildInputs = [ makeWrapper ];

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
    $out/share/teamviewer8/tv_bin/script/teamviewer
    EOF
    chmod +x $out/bin/teamviewer
  '';

  meta = {
    homepage = "http://www.teamviewer.com";
    license = "unfree";
    description = "Desktop sharing application, providing remote support and online meetings";
  };
}
