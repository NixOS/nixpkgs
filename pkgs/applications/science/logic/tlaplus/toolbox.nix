{ lib, fetchzip, makeWrapper, makeDesktopItem, stdenv
, jre, swt, gtk, libXtst, glib
}:

let
  version = "1.5.7";
  arch = "x86_64";

  desktopItem = makeDesktopItem rec {
    name = "TLA+Toolbox";
    exec = "tla-toolbox";
    icon = "tla-toolbox";
    comment = "IDE for TLA+";
    desktopName = name;
    genericName = comment;
    categories = "Application;Development";
    extraEntries = ''
      StartupWMClass=TLA+ Toolbox
    '';
  };


in stdenv.mkDerivation {
  name = "tla-toolbox-${version}";
  src = fetchzip {
    url = "https://tla.msr-inria.inria.fr/tlatoolbox/products/TLAToolbox-${version}-linux.gtk.${arch}.zip";
    sha256 = "0lg9sizpw5mkcnwwvmgqigkizjyz2lf1wrg48h7mg7wcv3macy4q";
  };

  buildInputs = [ makeWrapper  ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp -r "$src" "$out/toolbox"
    chmod +w "$out/toolbox" "$out/toolbox/toolbox"

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      "$out/toolbox/toolbox"

    makeWrapper $out/toolbox/toolbox $out/bin/tla-toolbox \
      --run "set -x; cd $out/toolbox" \
      --add-flags "-data ~/.tla-toolbox" \
      --prefix PATH : "${jre}/bin" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ swt gtk libXtst glib ]}"

    echo -e "\nCreating TLA Toolbox icons..."
    pushd "$src"
    for icon_in in $(find . -path "./plugins/*/icons/full/etool16/tla_launch_check_wiz_*.png")
    do
      icon_size=$(echo $icon_in | grep -Po "wiz_\K[0-9]+")
      icon_out="$out/share/icons/hicolor/$icon_size""x$icon_size/apps/tla-toolbox.png"
      mkdir -p "$(dirname $icon_out)"
      cp "$icon_in" "$icon_out"
    done
    popd

    echo -e "\nCreating TLA Toolbox desktop entry..."
    cp -r "${desktopItem}/share/applications"* "$out/share/applications"
  '';

  meta = {
    homepage = http://research.microsoft.com/en-us/um/people/lamport/tla/toolbox.html;
    description = "IDE for the TLA+ tools";
    longDescription = ''
      Integrated development environment for the TLA+ tools, based on Eclipse. You can use it
      to create and edit your specs, run the PlusCal translator, view the pretty-printed
      versions of your modules, run the TLC model checker, and run TLAPS, the TLA+ proof system.
    '';
    # http://lamport.azurewebsites.net/tla/license.html
    license = with lib.licenses; [ mit ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.badi ];
  };
}
