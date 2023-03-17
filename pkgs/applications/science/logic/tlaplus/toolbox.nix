{ lib
, fetchzip
, makeShellWrapper
, makeDesktopItem
, stdenv
, gtk3
, libXtst
, glib
, zlib
, wrapGAppsHook
}:

let
  desktopItem = makeDesktopItem rec {
    name = "TLA+Toolbox";
    exec = "tla-toolbox";
    icon = "tla-toolbox";
    comment = "IDE for TLA+";
    desktopName = name;
    genericName = comment;
    categories = [ "Development" ];
    startupWMClass = "TLA+ Toolbox";
  };


in
stdenv.mkDerivation rec {
  pname = "tla-toolbox";
  version = "1.7.1";
  src = fetchzip {
    url = "https://tla.msr-inria.inria.fr/tlatoolbox/products/TLAToolbox-${version}-linux.gtk.x86_64.zip";
    sha256 = "02a2y2mkfab5cczw8g604m61h4xr0apir49zbd1aq6mmgcgngw80";
  };

  buildInputs = [ gtk3 ];

  nativeBuildInputs = [
    makeShellWrapper
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -r "$src" "$out/toolbox"
    chmod -R +w "$out/toolbox"

    fixupPhase
    gappsWrapperArgsHook

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      "$out/toolbox/toolbox"

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "${lib.makeLibraryPath [ zlib ]}:$(patchelf --print-rpath $(find "$out/toolbox" -name java))" \
      "$(find "$out/toolbox" -name java)"

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      "$(find "$out/toolbox" -name jspawnhelper)"

    makeShellWrapper $out/toolbox/toolbox $out/bin/tla-toolbox \
      --chdir "$out/toolbox" \
      --add-flags "-data ~/.tla-toolbox" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk3 libXtst glib zlib ]}"  \
      "''${gappsWrapperArgs[@]}"

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

    runHook postInstall
  '';

  meta = {
    homepage = "http://research.microsoft.com/en-us/um/people/lamport/tla/toolbox.html";
    description = "IDE for the TLA+ tools";
    longDescription = ''
      Integrated development environment for the TLA+ tools, based on Eclipse. You can use it
      to create and edit your specs, run the PlusCal translator, view the pretty-printed
      versions of your modules, run the TLC model checker, and run TLAPS, the TLA+ proof system.
    '';
    # http://lamport.azurewebsites.net/tla/license.html
    license = with lib.licenses; [ mit ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
