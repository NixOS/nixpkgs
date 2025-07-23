{
  lib,
  stdenvNoCC,
  inkscape,
  xcursorgen,
  fetchFromGitHub,
  fetchpatch2,
}:
let
  styles = [
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

  # This is a patch from a fork of the upstream repository which addresses several issues with the
  # build script such as the fact that the style to build isn't hardcoded. We don't simply use this
  # fork as source, as the upstream repository is what we want to track.
  buildScriptPatch = fetchpatch2 {
    name = "use-more-flexible-build-script.patch";
    url = "https://github.com/KiranWells/Lyra-Cursors/commit/2735acb37a51792388497c666cc28370660217cb.patch?full_index=1";
    hash = "sha256-KCT4zNdep1TB7Oa4qrPw374ahT30o9/QrNTEgobp8zM=";
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

  nativeBuildInputs = [
    inkscape
    xcursorgen
  ];

  patches = [ buildScriptPatch ];

  dontConfigure = true;

  postPatch = ''
    patchShebangs build.sh
  '';

  buildPhase = ''
    runHook preBuild

    rm -r dist
    for THEME in ${lib.escapeShellArgs styles}; do
      ./build.sh "$THEME"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv dist/*-cursors $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Cursor theme inspired by macOS and based on capitaine-cursors";
    homepage = "https://github.com/yeyushengfan258/Lyra-Cursors";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lordmzte ];
  };
}
