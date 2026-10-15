{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
  extraThumbgens ? 0,
}:
let
  zeroPad =
    num: width:
    let
      len = builtins.stringLength (toString num);
      padLen = lib.max 0 (width - len);
      padding = lib.concatStrings (builtins.genList (_: "0") padLen);
    in
    "${padding}${toString num}";
  width = builtins.stringLength (toString extraThumbgens);
  extraThumbgenScripts = builtins.genList (
    i: "gallery-thumbgen.${zeroPad (i + 1) width}.lua"
  ) extraThumbgens;
in
buildLua (finalAttrs: {
  pname = "mpv-gallery-view";
  version = "0-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "occivink";
    repo = "mpv-gallery-view";
    rev = "4a8e664d52679fff3f05f29aa7a54b86150704bc";
    hash = "sha256-u4PQtTKdE357G1X+Ag0Dexd/jhmZVsAXxdUgEp8bMPw=";
  };

  postPatch = ''
    substituteInPlace \
      scripts/contact-sheet.lua \
      scripts/playlist-view.lua \
      --replace-fail "~~/script-modules/?.lua;" "$out/share/mpv/script-modules/?.lua;"
  '';

  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/mpv/scripts scripts/*.lua
    install -Dm444 -t $out/share/mpv/script-modules script-modules/*.lua

    for thumbgen in ${lib.escapeShellArgs extraThumbgenScripts}; do
      ln -s $out/share/mpv/scripts/gallery-thumbgen.lua $out/share/mpv/scripts/"$thumbgen"
    done

    runHook postInstall
  '';

  scriptPath = "playlist-view.lua";
  extraScripts = [
    "contact-sheet.lua"
    "gallery-thumbgen.lua"
  ]
  ++ extraThumbgenScripts;

  passthru = {
    updateScript = unstableGitUpdater { };
    extraWrapperArgs = map (script: [
      "--add-flags"
      "--script=${finalAttrs.finalPackage}/share/mpv/scripts/${script}"
    ]) finalAttrs.extraScripts;
  };

  meta = {
    description = "Gallery-view scripts for mpv";
    homepage = "https://github.com/occivink/mpv-gallery-view";
    platforms = lib.platforms.all;
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ musjj ];
  };
})
