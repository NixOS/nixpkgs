<<<<<<< HEAD
{ lib, stdenv, fetchurl, openjdk, glib, wrapGAppsHook, zstd }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "5.2.0";
=======
{ lib, stdenv, fetchurl, jdk, glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "5.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.bluej.org/download/files/BlueJ-linux-${builtins.replaceStrings ["."] [""] version}.deb";
<<<<<<< HEAD
    sha256 = "sha256-sOT86opMa9ytxJlfURIsD06HiP+j+oz3lQ0DqmLV1wE=";
  };

  nativeBuildInputs = [ zstd wrapGAppsHook ];
  buildInputs = [ glib ];

  sourceRoot = ".";

=======
    sha256 = "sha256-OarqmptxZc7xEEYeoCVqHXkAvfzfSYx5nUp/iWPyoqw=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ glib ];

  sourceRoot = ".";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preUnpack = ''
    unpackCmdHooks+=(_tryDebData)
    _tryDebData() {
      if ! [[ "$1" =~ \.deb$ ]]; then return 1; fi
<<<<<<< HEAD
      ar xf $src
      if ! [[ -e data.tar.zst ]]; then return 1; fi
      unpackFile data.tar.zst
    }
  '';

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out

    makeWrapper ${openjdk}/bin/java $out/bin/bluej \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Dawt.useSystemAAFontSettings=on -Xmx512M \
                   --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED \
                   -cp $out/share/bluej/boot.jar bluej.Boot"
=======
      ar xf "$1"
      if ! [[ -e data.tar.xz ]]; then return 1; fi
      unpackFile data.tar.xz
    }
  '';

  installPhase = ''
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    mkdir -p "$out"

    if shopt -q dotglob; then dotglobOpt=$?; else dotglobOpt=$?; fi
    shopt -s dotglob
    for file in usr/*; do
      cp -R "$file" "$out"
    done
    if (( !dotglobOpt )); then shopt -u dotglob; fi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

<<<<<<< HEAD
=======
  dontWrapGApps = true;

  preFixup = ''
    makeWrapper ${jdk}/bin/java $out/bin/bluej \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Djavafx.embed.singleThread=true -Dawt.useSystemAAFontSettings=on -Xmx512M -cp $out/share/bluej/bluej.jar bluej.Boot"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2ClasspathPlus;
    maintainers = with maintainers; [ chvp ];
<<<<<<< HEAD
    platforms = platforms.linux;
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
