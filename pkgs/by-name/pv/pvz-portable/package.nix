{
  lib,
  fetchurl,
  stdenvNoCC,
  symlinkJoin,
  makeWrapper,
  p7zip,
  pvz-portable-unwrapped,
  # set it to a dir or a zip containing main.pak and properties; can be a path or a derivation
  # example: ./Plants_vs._Zombies_1.2.0.1073_EN.zip
  # https://github.com/wszqkzqk/PvZ-Portable/blob/main/archlinux/README.md#prepare-game-assets
  gameAssets ? fetchurl {
    url = "https://web.archive.org/web/20220717170711/http://static-www.ec.popcap.com/binaries/popcap_downloads/PlantsVsZombiesSetup.exe";
    hash = "sha256-S0u00Z+2OeVpiYPjnXrQYcdme87BkFZWBTLHrQ1n0OQ=";
    meta.license = lib.licenses.unfree;
  },
  pvzDebug ? false,
  limboPage ? true,
  doFixBugs ? false,
}:

let
  phome = "$out/share/pvz-portable";

  unwrapped = pvz-portable-unwrapped.override { inherit pvzDebug limboPage doFixBugs; };

  assets = stdenvNoCC.mkDerivation {
    name = "pvz-portable-assets";

    src = gameAssets;

    nativeBuildInputs = [ p7zip ];

    postHook = ''
      unpackCmdHooks+=(_7zx)
      _7zx() {
        [[ -f "$curSrc" ]] && 7z x "$curSrc" -osource -ba -bd
      }
    '';

    installPhase = ''
      runHook preInstall

      dir="$(find -type f -name main.pak -printf %h -execdir test -d properties \; | head -n 1)"
      if [[ -z "$dir" ]]; then
        echo "main.pak and properties not found in $src"
        exit 1
      fi

      mkdir -p ${phome}
      cp -ar "$dir"/{main.pak,properties} ${phome}

      runHook postInstall
    '';
  };

in
symlinkJoin (finalAttrs: {
  pname = "pvz-portable";
  inherit (finalAttrs.passthru.unwrapped) version meta;

  paths = [
    finalAttrs.passthru.unwrapped
    finalAttrs.passthru.assets
  ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = "wrapProgram $out/bin/pvz-portable --add-flags -resdir=${phome}";

  passthru = { inherit unwrapped assets; };
})
