{
  lib,
  stdenvNoCC,
  opence-unwrapped,
  copyDesktopItems,
  makeDesktopItem,
  replaceVars,
  runtimeShell,
  image ? null,
}:

stdenvNoCC.mkDerivation {
  pname = "opence";
  inherit (opence-unwrapped) version;

  strictDeps = true;
  __structuredAttrs = true;

  src =
    if image != null then
      image
    else
      throw ''
        OpenCE requires an Xbox disc image of Halo: Combat Evolved.
        Supply your own image with opence.override { image = /path/to/halo.iso; }.
        The free engine is available separately as opence-unwrapped.
      '';

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
    opence-unwrapped
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "opence";
      desktopName = "OpenCE";
      comment = "Play Halo: Combat Evolved";
      exec = "opence";
      icon = "opence";
      categories = [
        "Game"
        "ActionGame"
      ];
    })
  ];

  launcher = replaceVars ./launcher.sh {
    bash = runtimeShell;
    opence = lib.getExe opence-unwrapped;
    out = null;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/opence"
    opence --extract-xiso "$src" "$out/share/opence"
    install -Dm755 "$launcher" "$out/bin/opence"
    substituteInPlace "$out/bin/opence" --replace-fail '@out@' "$out"
    cp -as ${opence-unwrapped}/share/icons "$out/share/icons"

    runHook postInstall
  '';

  meta = opence-unwrapped.meta // {
    license = lib.licenses.unfree;
  };
}
