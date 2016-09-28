{ pkgs, stdenv, alsaLib, atk, cairo, cups, dbus, dpkg, expat, fetchurl,
fontconfig, freetype, gdk_pixbuf, gnome, glib, gtk, go-ethereum, libcap,
libnotify, libudev, nspr, nss, unzip, buildEnv, makeDesktopItem, makeWrapper,
pango, patchelf, systemd, xorg}:

let
  deps = [
        stdenv.cc.cc glib dbus gtk atk pango freetype
        fontconfig gdk_pixbuf cairo cups expat alsaLib
        nspr gnome.GConf nss libnotify libcap pango go-ethereum systemd
        xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage
        xorg.libXtst xorg.libXcomposite xorg.libXi xorg.libXfixes
        xorg.libXrandr xorg.libXcursor xorg.libXScrnSaver
      ];
in stdenv.mkDerivation rec {
  name = "mist-browser-${version}";
  version = "0.8.3";

  is64Bit = (stdenv.system == "x86_64-linux");
  platform = (if is64Bit then "linux64" else "linux32");
  _name = "Mist-${platform}-${_version}";
  _version = builtins.replaceStrings ["."] ["-"] version;

  src = fetchurl {
    url = "https://github.com/ethereum/mist/releases/download/v${version}/${_name}.deb";
    sha256 = "0kyszkjqhas74gazr80y853z2nycn6fh2mysn5pplpqkhmpz3yl8";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/ethereum/mist/master/icons/wallet/icon.png";
    sha256 = "0flyrzy43vxn1gp5qpaiyvhsac588sqgnlpqd13gdr2pay3l5xaz";
  };

  phases = [ "unpackPhase" "installPhase" ];
  buildInputs = [ dpkg makeWrapper patchelf ];

  libpath = stdenv.lib.makeLibraryPath deps;

  unpackPhase = "dpkg -x ${src} ./";

  gethPath = if is64Bit then "nodes/geth/linux-x64/geth"
             else "nodes/geth/geth";

  installPhase = ''
    mv "$PWD/opt/Mist" "$out"
    rm "$out/${gethPath}"
    ln -s "${go-ethereum}/bin/geth" "$out/${gethPath}"

    chmod +x "$out/Mist"
    chmod +x "$out/libnode.so"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      "$out/Mist"

    mkdir "$out/bin"
    ln -s "$out/Mist" "$out/bin/mist"

    wrapProgram $out/bin/mist \
      --prefix "LD_LIBRARY_PATH" : $libpath
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
    description = "Ethereum browser and wallet";
    homepage = "https://ethereum.org/";
    maintainers = with maintainers; [ dvc ryepdx ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
