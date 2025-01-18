{
  lib,
  stdenv,
  git,
  git-lfs,
  fetchurl,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  cairo,
  coreutils,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libgbm,
  nss,
  nspr,
  xorg,
  libdrm,
  libsecret,
  libxkbcommon,
  pango,
  systemd,
  hunspellDicts,
  useHunspell ? true,
  languages ? [ "en_US" ],
  withNemoAction ? true,
  makeDesktopItem,
  copyDesktopItems,
  asar,
  python3,
}:

let
  pname = "pulsar";
  version = "1.124.0";

  sourcesPath =
    {
      x86_64-linux.tarname = "Linux.${pname}-${version}.tar.gz";
      x86_64-linux.hash = "sha256-AUJczZp4kbT/eq8iUNiuPts1cfgNnw/ZkzItY74T1Zw=";
      aarch64-linux.tarname = "ARM.Linux.${pname}-${version}-arm64.tar.gz";
      aarch64-linux.hash = "sha256-DmbtgogNckeOCj5PibRmTBWgohQ9s06DkCuudR5nCos=";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

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
    libgbm
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
    stdenv.cc.cc
    systemd
  ];

  # Hunspell
  hunspellDirs = builtins.map (lang: "${hunspellDicts.${lang}}/share/hunspell") languages;
  hunspellTargetDirs = "$out/opt/Pulsar/resources/app.asar.unpacked/node_modules/spellchecker/vendor/hunspell_dictionaries";
  hunspellCopyCommands = lib.concatMapStringsSep "\n" (
    lang: "cp -r ${lang}/* ${hunspellTargetDirs};"
  ) hunspellDirs;
in
stdenv.mkDerivation {
  inherit pname version;

  src =
    with sourcesPath;
    fetchurl {
      url = "https://github.com/pulsar-edit/pulsar/releases/download/v${version}/${tarname}";
      inherit hash;
    };

  nativeBuildInputs = [
    wrapGAppsHook3
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

  preFixup =
    ''
      gappsWrapperArgs+=(
        # needed for gio executable to be able to delete files
        --prefix "PATH" : "${lib.makeBinPath [ glib ]}"
      )
    ''
    + lib.optionalString useHunspell ''
      # On all platforms, we must inject our dictionnaries
      ${hunspellCopyCommands}
    '';

  postFixup =
    ''
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
        $opt/resources/app.asar.unpacked/node_modules/symbol-provider-ctags/vendor/ctags-linux

      # Replace the bundled git with the one from nixpkgs
      dugite=$opt/resources/app.asar.unpacked/node_modules/dugite
      rm -f $dugite/git/bin/git
      ln -s ${git}/bin/git $dugite/git/bin/git

      # Not only do we need to replace the git binary itself, we also need to replace
      # all the symlinks in dugite/git/libexec/git-core.
      for file in "$dugite/git/libexec/git-core"/*; do
        if [ -x "$file" ] && file "$file" | grep -q "ELF"; then
            # Remove ELF executable
            rm "$file"

            # Get the corresponding filename in nixpkgs's git
            filename=$(basename "$file")
            git_executable="${git}/libexec/git-core/$filename"

            # Create symlink to $git_executable
            ln -s "$git_executable" "$file"

            echo "Replaced $file with symlink to $git_executable"
          fi
      done

      # Was symlinked in previous loop, but actually, nixpkgs has a separate package for git-lfs
      # Unlink to avoid a "File exists" error and relink correctly
      unlink $dugite/git/libexec/git-core/git-lfs
      ln -s ${git-lfs}/bin/git-lfs $dugite/git/libexec/git-core/git-lfs
    ''
    + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
      # We have to patch a prebuilt binary in the asar archive
      # But asar complains because the node_gyp unpacked dependency uses a prebuilt Python3 itself

      rm $opt/resources/app.asar.unpacked/node_modules/tree-sitter-bash/build/node_gyp_bins/python3
      ln -s ${python3.interpreter} $opt/resources/app.asar.unpacked/node_modules/tree-sitter-bash/build/node_gyp_bins/python3
    ''
    + ''
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

      # Pulsar uses `PULSAR_PATH` to know where it is intalled
      mkdir -p $out/bin
      wrapProgram $opt/resources/pulsar.sh \
        --suffix "PATH" : "${lib.makeBinPath [ coreutils ]}" \
        --set "PULSAR_PATH" "$opt"
      ln -s $opt/resources/pulsar.sh $out/bin/pulsar
      ln -s $opt/resources/app/ppm/bin/apm $out/bin/ppm

      # Copy the icons
      mkdir -p $out/share/icons/hicolor/scalable/apps $out/share/icons/hicolor/1024x1024/apps
      cp $opt/resources/pulsar.svg $out/share/icons/hicolor/scalable/apps/pulsar.svg
      cp $opt/resources/pulsar.png $out/share/icons/hicolor/1024x1024/apps/pulsar.png
    ''
    + lib.optionalString withNemoAction ''
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
      categories = [
        "Development"
        "TextEditor"
        "Utility"
      ];
      mimeTypes = [ "text/plain" ];
    })
  ];

  passthru.updateScript = ./update.mjs;

  meta = {
    description = "Community-led Hyper-Hackable Text Editor";
    longDescription = ''
      A Community-led Hyper-Hackable Text Editor, Forked from Atom, built on Electron.
      Designed to be deeply customizable, but still approachable using the default configuration.
    '';
    homepage = "https://github.com/pulsar-edit/pulsar";
    changelog = "https://github.com/pulsar-edit/pulsar/blob/v${version}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bryango
      pbsds
    ];
    knownVulnerabilities = [
      # electron 12.2.3, efforts are in place to bump it
      "CVE-2023-5217"
      "CVE-2022-21718"
      "CVE-2022-29247"
      "CVE-2022-29257"
      "CVE-2022-36077"
      "CVE-2023-29198"
      "CVE-2023-39956"
    ];
  };
}
