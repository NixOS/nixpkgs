{ lib, stdenv, fetchurl, jdk, glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "bluej";
  version = "5.0.3";

  src = fetchurl {
    # We use the deb here. First instinct might be to go for the "generic" JAR
    # download, but that is actually a graphical installer that is much harder
    # to unpack than the deb.
    url = "https://www.bluej.org/download/files/BlueJ-linux-${builtins.replaceStrings ["."] [""] version}.deb";
    sha256 = "sha256-OarqmptxZc7xEEYeoCVqHXkAvfzfSYx5nUp/iWPyoqw=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ glib ];

  sourceRoot = ".";
  preUnpack = ''
    unpackCmdHooks+=(_tryDebData)
    _tryDebData() {
      if ! [[ "$1" =~ \.deb$ ]]; then return 1; fi
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

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapper ${jdk}/bin/java $out/bin/bluej \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Djavafx.embed.singleThread=true -Dawt.useSystemAAFontSettings=on -Xmx512M -cp $out/share/bluej/bluej.jar bluej.Boot"
  '';

  meta = with lib; {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2ClasspathPlus;
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.unix;
  };
}
