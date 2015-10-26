{ stdenv, fetchurl, libX11, libXtst, libXext, libXdamage, libXfixes,
wineUnstable, makeWrapper, libXau , patchelf, config }:

with stdenv.lib;

let
  topath = "${wineUnstable}/bin";

  toldpath = stdenv.lib.concatStringsSep ":" (map (x: "${x}/lib") 
    [ stdenv.cc.cc libX11 libXtst libXext libXdamage libXfixes wineUnstable ]);
in
stdenv.mkDerivation {
  name = "teamviewer-10.0.37742";
  src = fetchurl {
    url = config.teamviewer10.url or "http://download.teamviewer.com/download/teamviewer_amd64.deb";
    sha256 = config.teamviewer10.sha256 or "10risay1a5a85ijbjaz2vxqbfxygpxslvh0dvzz32k988hr9p1gk";
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
    #!${stdenv.shell}
    export LD_LIBRARY_PATH=${toldpath}\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
    export PATH=${topath}\''${PATH:+:\$PATH}
    $out/share/teamviewer/tv_bin/script/teamviewer "\$@"
    EOF
    chmod +x $out/bin/teamviewer

    ln -s $out/share/teamviewer/tv_bin/teamviewerd $out/bin/
    rm -rf  $out/share/teamviewer/logfiles $out/share/teamviewer/config
    ln -sv /var/tmp/teamviewer10/logs/ $out/share/teamviewer/logfiles
    ln -sv /var/tmp/teamviewer10/config/ $out/share/teamviewer/config
  '';

  # the fixupPhase undoes the rpath patch
  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/teamviewer/tv_bin/teamviewerd
    patchelf --set-rpath "${stdenv.cc.cc}/lib64:${stdenv.cc.cc}/lib:${libX11}/lib:${libXext}/lib:${libXau}/lib:${libXdamage}/lib:${libXfixes}/lib" $out/share/teamviewer/tv_bin/teamviewerd
  '';

  meta = {
    homepage = "http://www.teamviewer.com";
    license = licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
    maintainers = with maintainers; [ jagajaga ];
  };
}
