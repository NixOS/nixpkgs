{
  lib,
  buildPackages,
  stdenvNoCC,
  wineWow64Packages,
  writeShellScript,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update,

  dnspy,
  is32Bit ? false,
  overrideWine ? wineWow64Packages.staging,
}:
let
  wine = overrideWine;

  wrapper = writeShellScript "dnspy-wrapper" ''
    export WINE="${lib.getExe wine}"
    export WINEPREFIX="''${DNSPY_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/dnSpy"}/wine"
    export WINEDEBUG=-all

    if [ ! -d "$WINEPREFIX" ]; then
      mkdir -p "$WINEPREFIX"
      ${lib.getExe' wine "wineboot"} -u
    fi

    exec "$WINE" "''${ENTRYPOINT:-${lib.getExe dnspy}}" "$@"
  '';
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (dnspy) pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    icon_name="dnSpy${lib.optionalString is32Bit "-x86"}"
    ${lib.getExe' buildPackages.icoutils "icotool"} -x "${dnspy.src}/dnSpy/dnSpy/Images/$icon_name.ico"
    for f in "$icon_name"_*.png; do
      res=$(basename "$f" | cut -d "_" -f3 | cut -d "x" -f1-2)
      install -vD "$f" "$out/share/icons/hicolor/$res/apps/$pname.png"
    done

    install -vD "${wrapper}" "$out/bin/${finalAttrs.meta.mainProgram}"

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = finalAttrs.pname;
    desktopName = "dnSpy" + (lib.optionalString is32Bit " (32-bit)");
    comment = finalAttrs.meta.description;
    icon = dnspy.pname;
    exec = finalAttrs.meta.mainProgram;
    categories = [ "Development" ];
  };

  passthru = {
    unwrapped = dnspy;

    updateScript = writeShellScript "update-dnspy" ''
      ${lib.getExe nix-update} "dnspy.unwrapped"
      "$(nix-build -A "$UPDATE_NIX_ATTR_PATH.unwrapped.fetch-deps" --no-out-link)"
    '';
  };

  meta = dnspy.meta // {
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    mainProgram = "dnSpy" + (lib.optionalString is32Bit "32");
  };
})
