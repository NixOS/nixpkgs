{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "netease-cloud-music";
  version = "3.1.8.3330";

  src = fetchurl {
    url = "https://d1.music.126.net/dmusic/NeteaseCloudMusic_Music_official_${finalAttrs.version}.dmg";
    hash = "sha256-htcIUyoOuEQ/kgaDBphYLiC5G1AtUsFqTeqOPcSd/vs=";

    # The download server rejects curl's default user agent.
    curlOptsList = [
      "-A"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
    ];
  };

  dontUnpack = true;
  dontStrip = true;
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    unpackDir="$TMPDIR/unpacked"
    mkdir -p "$unpackDir"
    # 7zz reports an HFS+ metadata error after it extracts the app bundle.
    7zz x -y -o"$unpackDir" "$src" >/dev/null 2>&1 || test -n "$(find "$unpackDir" -type d -name NeteaseMusic.app -print -quit)"
    app="$(find "$unpackDir" -type d -name NeteaseMusic.app -print -quit)"
    test -n "$app"

    mkdir -p "$out/Applications"
    cp -a "$app" "$out/Applications/"

    runHook postInstall
  '';

  postFixup = ''
    /usr/bin/codesign --verify --deep --strict "$out/Applications/NeteaseMusic.app"
  '';

  meta = {
    description = "Official desktop client for NetEase Cloud Music";
    homepage = "https://music.163.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ nikopit ];
  };
})
