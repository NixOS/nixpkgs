{ lib, stdenv, autoPatchelfHook, makeDesktopItem, copyDesktopItems, makeWrapper, alsa-lib, glib, glib-networking, gsettings-desktop-schemas, gtk3, libsecret, openjdk, sqlite, unixODBC, gtk2, xorg, glibcLocales, releasePath ? null }:

# To use this package, you need to download your own cplex installer from IBM
# and override the releasePath attribute to point to the location of the file.
#
# Note: cplex creates an individual build for each license which screws
# somewhat with the use of functions like requireFile as the hash will be
# different for every user.

stdenv.mkDerivation rec {
  pname = "cplex";
  version = "22.11";

  src =
    if releasePath == null then
      throw ''
        This nix expression requires that the cplex installer is already
        downloaded to your machine. Get it from IBM:
        https://www.ibm.com/support/pages/downloading-ibm-ilog-cplex-optimization-studio-2211

        Set `cplex.releasePath = /path/to/download;` in your
        ~/.config/nixpkgs/config.nix for `nix-*` commands, or
        `config.cplex.releasePath = /path/to/download;` in your
        `configuration.nix` for NixOS.
      ''
    else
      releasePath;

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems makeWrapper openjdk ];
  buildInputs = [ alsa-lib gsettings-desktop-schemas gtk2 sqlite unixODBC xorg.libXtst glibcLocales ];

  unpackPhase = "cp $src $name";

  postPatch = ''
    sed -i -e 's|/usr/bin/tr"|tr"         |' $name
  '';

  buildPhase = ''
    runHook preBuild

     export JAVA_TOOL_OPTIONS=-Djdk.util.zip.disableZip64ExtraFieldValidation=true
    sh $name LAX_VM "$(command -v java)" -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=$out

    runHook postBuild
  '';

  installPhase = let
    libraryPath = lib.makeLibraryPath [ stdenv.cc.cc glib gtk2 gtk3 libsecret xorg.libXtst ];
  in ''
    runHook preInstall

    mkdir -p $out/bin

    for pgm in \
      $out/opl/bin/x86-64_linux/oplrun \
      $out/opl/bin/x86-64_linux/oplrunjava \
      $out/opl/oplide/oplide \
      $out/cplex/bin/x86-64_linux/cplex \
      $out/cpoptimizer/bin/x86-64_linux/cpoptimizer
    do
      makeWrapperArgs=(
        --set-default LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive
      )

      if [[ "$pgm" = "$out/opl/oplide/oplide" ]]; then
        makeWrapperArgs+=(
          --prefix LD_LIBRARY_PATH : ${libraryPath}
          --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
          --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
        )
      fi

      makeWrapper "$pgm" "$out/bin/$(basename "$pgm")" "''${makeWrapperArgs[@]}"
    done

    mkdir -p $out/share/pixmaps
    ln -s $out/opl/oplide/icon.xpm $out/share/pixmaps/oplide.xpm

    mkdir -p $out/share/doc
    mv $out/doc $out/share/doc/$name

    mkdir -p $out/share/licenses
    mv $out/license $out/share/licenses/$name

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "oplide";
      desktopName = "IBM ILOG CPLEX Optimization Studio";
      genericName = "Optimization Software";
      icon = "oplide";
      exec = "oplide";
      categories = [ "Development" "IDE" "Math" "Science" ];
    })
  ];

  fixupPhase = ''
    runHook preFixup

    rm -r $out/Uninstall

    bins=(
      $out/bin/*
      $out/cplex/bin/x86-64_linux/cplex
      $out/cplex/bin/x86-64_linux/cplexamp
      $out/cpoptimizer/bin/x86-64_linux/cpoptimizer
      $out/opl/bin/x86-64_linux/oplrun
      $out/opl/bin/x86-64_linux/oplrunjava
      $out/opl/oplide/jre/bin/*
      $out/opl/oplide/oplide
    )

    find $out -type d -exec chmod 755 {} \;
    find $out -type f -exec chmod 644 {} \;
    chmod +111 "''${bins[@]}"

    runHook postFixup
  '';

  passthru = {
    libArch = "x86-64_linux";
    libSuffix = "${version}0";
  };

  meta = with lib; {
    description = "Optimization solver for mathematical programming";
    homepage = "https://www.ibm.com/be-en/marketplace/ibm-ilog-cplex";
    mainProgram = "cplex";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bfortz ];
  };
}
