{
  stdenvNoCC,
  lib,
  wrapGAppsHook3,
  gdk-pixbuf,
  librsvg,
  xorg,
  shared-mime-info,
}:

timeshift-unwrapped: runtimeDeps:
stdenvNoCC.mkDerivation {
  inherit (timeshift-unwrapped) pname version outputs;

  dontUnpack = true;

  nativeBuildInputs = [
    wrapGAppsHook3
    xorg.lndir
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.concatMapStrings (outputName: ''
    mkdir -p "''$${outputName}"
    lndir -silent "${timeshift-unwrapped.${outputName}}" "''$${outputName}"
  '') timeshift-unwrapped.outputs
  + ''
    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs=(
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    )
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${
        lib.makeSearchPath "share" [
          gdk-pixbuf
          librsvg
          shared-mime-info
        ]
      }"
      "''${makeWrapperArgs[@]}"
    )
    wrapProgram "$out/bin/timeshift" "''${makeWrapperArgs[@]}"
    wrapProgram "$out/bin/timeshift-gtk" "''${gappsWrapperArgs[@]}"
    # Substitute app_command to look for the `timeshift-gtk` in $out.
    unlink "$out/bin/timeshift-launcher"
    substitute ${lib.getExe' timeshift-unwrapped "timeshift-launcher"} "$out/bin/timeshift-launcher" \
      --replace-fail "app_command=${lib.getExe' timeshift-unwrapped "timeshift-gtk"}" "app_command=$out/bin/timeshift-gtk"
    chmod +x "$out/bin/timeshift-launcher"
  '';

  inherit (timeshift-unwrapped) meta;
}
