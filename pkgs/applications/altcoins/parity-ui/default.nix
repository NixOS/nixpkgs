{ stdenv, pkgs, fetchurl, lib, makeWrapper, nodePackages }:

let

uiEnv = pkgs.callPackage ./env.nix { };

in stdenv.mkDerivation rec {
  name = "parity-ui-${version}";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/parity-js/shell/releases/download/v${version}/parity-ui_${version}_amd64.deb";
    sha256 = "08gh438mqxj2h8i9hv826bx040wmkmdgsda5grj0k81459vds31l";
    name = "${name}.deb";
  };

  nativeBuildInputs = [ makeWrapper nodePackages.asar ];

  buildCommand = ''
    mkdir -p $out/usr/
    ar p $src data.tar.xz | tar -C $out -xJ .
    substituteInPlace $out/usr/share/applications/parity-ui.desktop \
      --replace "/opt/Parity UI" $out/bin
    mv $out/usr/* $out/
    mv "$out/opt/Parity UI" $out/share/parity-ui
    rm -r $out/usr/
    rm -r $out/opt/

    fixupPhase

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${uiEnv.libPath}:$out/share/parity-ui" \
      $out/share/parity-ui/parity-ui

    find $out/share/parity-ui -name "*.node" -exec patchelf --set-rpath "${uiEnv.libPath}:$out/share/parity-ui" {} \;

    paxmark m $out/share/parity-ui/parity-ui

    mkdir -p $out/bin
    ln -s $out/share/parity-ui/parity-ui $out/bin/parity-ui
  '';

  meta = with stdenv.lib; {
    description = "UI for Parity. Fast, light, robust Ethereum implementation";
    homepage = http://parity.io;
    license = licenses.gpl3;
    maintainers = [ maintainers.sorpaas ];
    platforms = platforms.linux;
  };
}
