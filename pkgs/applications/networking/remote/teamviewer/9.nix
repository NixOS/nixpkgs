{ stdenv, fetchurl, libX11, libXtst, libXext, libXdamage, libXfixes, wineUnstable, makeWrapper, libXau
, bash, patchelf, config }:

let
  topath = "${wineUnstable}/bin";

  toldpath = stdenv.lib.concatStringsSep ":" (map (x: "${x}/lib") 
    [ stdenv.gcc.gcc libX11 libXtst libXext libXdamage libXfixes wineUnstable ]);
in
stdenv.mkDerivation {
  name = "teamviewer-9.0.32150";
  src = fetchurl {
    url = config.teamviewer9.url or "http://download.teamviewer.com/download/version_9x/teamviewer_linux_x64.deb";
    sha256 = config.teamviewer9.sha256 or "0wpwbx0xzn3vlzavszxhfvfcaj3pijlpwvlz5m7w19mb6cky3q13";
  };

  buildInputs = [ makeWrapper patchelf ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/share/teamviewer9 $out/bin
    cp -a opt/teamviewer9/* $out/share/teamviewer9
    rm -R $out/share/teamviewer9/tv_bin/wine/{bin,lib,share}

    cat > $out/bin/teamviewer << EOF
    #!${bash}/bin/sh
    export LD_LIBRARY_PATH=${toldpath}\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
    export PATH=${topath}\''${PATH:+:\$PATH}
    $out/share/teamviewer9/tv_bin/script/teamviewer "\$@"
    EOF
    chmod +x $out/bin/teamviewer

    patchelf --set-rpath "${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXext}/lib:${libXau}/lib:${libXdamage}/lib:${libXfixes}/lib" $out/share/teamviewer9/tv_bin/teamviewerd
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/share/teamviewer9/tv_bin/teamviewerd
    ln -s $out/share/teamviewer9/tv_bin/teamviewerd $out/bin/
  '';

  meta = {
    homepage = "http://www.teamviewer.com";
    license = stdenv.lib.licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
  };
}
