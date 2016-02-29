{ pkgs, stdenv, fetchurl, unzip, buildEnv, makeWrapper, makeDesktopItem, geth }:

let
  mistEnv = buildEnv {
      name = "env-mist";
      paths = with pkgs; [
        stdenv.cc.cc glib dbus gtk atk pango freetype
        fontconfig gdk_pixbuf cairo cups expat alsaLib
        nspr gnome.GConf nss libnotify libcap geth systemd
        xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage
        xorg.libXtst xorg.libXcomposite xorg.libXi xorg.libXfixes
        xorg.libXrandr xorg.libXcursor
      ];
    };
in
stdenv.mkDerivation rec {
  name = "mist-${version}";
  version = "0.4.0";

  platform = "linux64";
  _name = "Ethereum-Wallet-${platform}-${_version}";
  _version = builtins.replaceStrings ["."] ["-"] version;

  src = fetchurl {
    url = "https://github.com/ethereum/mist/releases/download/${version}/${_name}.zip";
    sha256 = "0kknxc9hzlhkfpw6fm0qif7sc7h4wdhphmczai9sq8xbz7smgyvj";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/ethereum/mist/master/icons/wallet/icon.png";
    sha256 = "127yznh6f35wxcgbrkk5kim6py284z34rm0mb08qk0ff0akjk77z";
  };

  phases = [ "unpackPhase" "installPhase" ];
  buildInputs = [ mistEnv unzip makeWrapper ];

  installPhase = ''
    unzip "$src"
    mv "$PWD/${_name}" "$out"
    rm "$out/resources/node/geth/geth"
    ln -s "${geth}/bin/geth" "$out/resources/node/geth/geth"

    chmod +x "$out/Ethereum-Wallet"
    chmod +x "$out/libnode.so"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      "$out/Ethereum-Wallet"

    mkdir "$out/bin"
    ln -s "$out/Ethereum-Wallet" "$out/bin/mist"

    wrapProgram $out/bin/mist \
      --prefix "LD_LIBRARY_PATH" : "${mistEnv}/lib:${mistEnv}/lib64"

    mkdir -p "$out/share/applications"
    cp -r "${desktopItem}/share/applications" "$out/share/"
  '';

  desktopItem = makeDesktopItem {
    name = "mist";
    exec = "mist";
    icon = "${icon}";
    desktopName = "Mist";
    genericName = "Mist Browser";
    comment = meta.description;
    categories = "Categories=Internet;Other;";
  };

  meta = with stdenv.lib; {
    description = "Ethereum wallet";
    homepage = "https://ethereum.org/";
    maintainers = with maintainers; [ dvc ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
