{ lib
, stdenv
, git
, fetchurl
, wrapGAppsHook
, alsa-lib
, at-spi2-atk
, cairo
, cups
, dbus
, expat
, gdk-pixbuf
, glib
, gtk3
, mesa
, nss
, nspr
, xorg
, libdrm
, libsecret
, libxkbcommon
, pango
, systemd
, hunspellDicts
, useHunspell ? true
, languages ? [ "en_US" ]
, withNemoAction ? true
, makeDesktopItem
, copyDesktopItems
, asar
, python3
}:

let
  pname = "pulsar";
  version = "1.109.0";

  sourcesPath = {
    x86_64-linux.tarname = "Linux.${pname}-${version}.tar.gz";
    x86_64-linux.hash = "sha256-pIm3mI1YdfapxXgIciSHtI4LeqMw5RdYTnH+eHUQ4Yo=";
    aarch64-linux.tarname = "ARM.Linux.${pname}-${version}-arm64.tar.gz";
    aarch64-linux.hash = "sha256-KIY/qzfl7CU0YwIgQlNHoAMhLfrTbQe7ZZvzdkUVw+M=";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  newLibpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libsecret
    mesa
    nss
    nspr
    libdrm
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxshmfence
    libxkbcommon
    xorg.libxkbfile
    pango
    stdenv.cc.cc.lib
    systemd
  ];

  # Hunspell
  hunspellDirs = builtins.map (lang: "${hunspellDicts.${lang}}/share/hunspell") languages;
  hunspellTargetDirs = "$out/opt/Pulsar/resources/app.asar.unpacked/node_modules/spellchecker/vendor/hunspell_dictionaries";
  hunspellCopyCommands = lib.concatMapStringsSep "\n" (lang: "cp -r ${lang}/* ${hunspellTargetDirs};") hunspellDirs;
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = with sourcesPath; fetchurl {
    url = "https://github.com/pulsar-edit/pulsar/releases/download/v${version}/${tarname}";
    inherit hash;
  };

  patches = [
    ./001-patch-wrapper.patch
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    copyDesktopItems
    asar
  ];

  buildInputs = [
    gtk3
    xorg.libxkbfile
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/Pulsar
    mv * $out/opt/Pulsar

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # needed for gio executable to be able to delete files
      --prefix "PATH" : "${lib.makeBinPath [ glib ]}"
    )
  '' + lib.optionalString useHunspell ''
    # On all platforms, we must inject our dictionnaries
    ${hunspellCopyCommands}
  '';

  postFixup = ''
    opt=$out/opt/Pulsar
    # Patch the prebuilt binaries
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${newLibpath}:$opt" \
      --add-needed libffmpeg.so \
      --add-needed libxshmfence.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libxkbfile.so.1 \
      --add-needed libsecret-1.so.0 \
      $opt/pulsar
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${newLibpath}" \
      $opt/resources/app/ppm/bin/node
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $opt/resources/app.asar.unpacked/node_modules/symbols-view/vendor/ctags-linux

  '' + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    # Replace the bundled git with the one from nixpkgs
    dugite=$opt/resources/app.asar.unpacked/node_modules/dugite
    rm -f $dugite/git/bin/git
    ln -s ${git}/bin/git $dugite/git/bin/git
    rm -f $dugite/git/libexec/git-core/git
    ln -s ${git}/bin/git $dugite/git/libexec/git-core/git

    # We have to patch a prebuilt binary in the asar archive
    # But asar complains because the node_gyp unpacked dependency uses a prebuilt Python3 itself

    rm $opt/resources/app.asar.unpacked/node_modules/tree-sitter-bash/build/node_gyp_bins/python3
    ln -s ${python3.interpreter} $opt/resources/app.asar.unpacked/node_modules/tree-sitter-bash/build/node_gyp_bins/python3
  '' + ''
    # Patch the bundled node executables
    find $opt -name "*.node" -exec patchelf --set-rpath "${newLibpath}:$opt" {} \;
    # Also patch the node executable for apm
    patchelf --set-rpath "${newLibpath}:$opt" $opt/resources/app/ppm/bin/node

    # The pre-packaged ASAR bundle comes with prebuild binaries, expecting libstdc++.so.6
    asarBundle=$TMPDIR/asarbundle
    asar e $opt/resources/app.asar $asarBundle
    find $asarBundle -name "*.node" -exec patchelf --set-rpath "${newLibpath}:$opt" --add-needed libstdc++.so.6 {} \;
    unlink $asarBundle/node_modules/document-register-element/dre # Self referencing symlink, breaking asar rebundling
    asar p $asarBundle $opt/resources/app.asar
    rm -rf $asarBundle

    # We have patched the original wrapper, but now it needs the "PULSAR_PATH" env var
    mkdir -p $out/bin
    wrapProgram $opt/resources/pulsar.sh \
      --prefix "PULSAR_PATH" : "$opt/pulsar"
    ln -s $opt/resources/pulsar.sh $out/bin/pulsar
    ln -s $opt/resources/app/ppm/bin/apm $out/bin/ppm

    # Copy the icons
    mkdir -p $out/share/icons/hicolor/scalable/apps $out/share/icons/hicolor/1024x1024/apps
    cp $opt/resources/pulsar.svg $out/share/icons/hicolor/scalable/apps/pulsar.svg
    cp $opt/resources/pulsar.png $out/share/icons/hicolor/1024x1024/apps/pulsar.png
  '' + lib.optionalString withNemoAction ''
    # Copy the nemo action file
    mkdir -p $out/share/nemo/actions
    cp ${./pulsar.nemo_action} $out/share/nemo/actions/pulsar.nemo_action
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Pulsar";
      desktopName = "Pulsar";
      exec = "pulsar";
      icon = "pulsar";
      comment = "A Community-led Hyper-Hackable Text Editor";
      genericName = "Text Editor";
      categories = [ "Development" "TextEditor" "Utility" ];
      mimeTypes = [ "text/plain" ];
    })
  ];

  passthru.updateScript = ./update.mjs;

  meta = with lib; {
    description = "A Community-led Hyper-Hackable Text Editor";
    longDescription = ''
      A Community-led Hyper-Hackable Text Editor, Forked from Atom, built on Electron.
      Designed to be deeply customizable, but still approachable using the default configuration.
    '';
    homepage = "https://github.com/pulsar-edit/pulsar";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colamaroro ];
  };
}
