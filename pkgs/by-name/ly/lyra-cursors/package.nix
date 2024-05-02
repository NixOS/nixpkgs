{ lib
, stdenvNoCC
, inkscape
, xcursorgen
, fetchFromGitHub
, fetchurl
, styles ? [ ]
}:
let
  validStyles = [
    "LyraB"
    "LyraF"
    "LyraG"
    "LyraP"
    "LyraQ"
    "LyraR"
    "LyraS"
    "LyraX"
    "LyraY"
  ];

  selectedStyles =
    if (styles == [ ]) then
      validStyles
    else
      let unknown = lib.subtractLists validStyles styles; in
      if (unknown != [ ]) then
        throw "Unknown style(s): ${lib.concatStringsSep " " unknown}"
      else styles;

  # This is a buildscript from a fork of the upstream repository which addresses several issues
  # such as the fact that the style to build isn't hardcoded. We don't simply use this fork as
  # source, as the upstream repository is what we want to track.
  buildScript = stdenvNoCC.mkDerivation {
    name = "lyra-cursors-build.sh";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/KiranWells/Lyra-Cursors/bf6ff46dd890f034bd75005136986cef242dda14/build.sh";
      hash = "sha256-7W64IwheaKQdcD8X7+zIVfcXAMMiCFK9Uk2JCH3SuZ0=";
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      cp "$src" "$out"
      chmod +x "$out"
      patchShebangs "$out"

      runHook postInstall
    '';
  };
in
stdenvNoCC.mkDerivation {
  pname = "lyra-cursors";
  version = "0-unstable-2021-12-04";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Lyra-Cursors";
    rev = "c096c54034f95bd35699b3226250e5c5ec015d9a";
    hash = "sha256-lfaX8ouE0JaQwVBpAGsrLIExQZ2rCSFKPs3cch17eYg=";
  };

  nativeBuildInputs = [ inkscape xcursorgen ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    rm -r dist
    for THEME in ${lib.escapeShellArgs selectedStyles}; do
      ${buildScript} "$THEME"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv dist/*-cursors $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "A cursor theme inspired by macOS and based on capitaine-cursors";
    homepage = "https://github.com/yeyushengfan258/Lyra-Cursors";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ lordmzte ];
  };
}
