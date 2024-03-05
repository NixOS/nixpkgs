{ stdenvNoCC
, lib
, wrapGAppsHook
, gdk-pixbuf
, librsvg
, xorg
, shared-mime-info
}:

timeshift-unwrapped:
runtimeDeps:
stdenvNoCC.mkDerivation {
  inherit (timeshift-unwrapped) pname version;

  dontUnpack = true;

  nativeBuildInputs = [
    xorg.lndir
    wrapGAppsHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    lndir "${timeshift-unwrapped}" "$out"
    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs=(
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    )
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ gdk-pixbuf librsvg shared-mime-info ]}"
      "''${makeWrapperArgs[@]}"
    )
    wrapProgram "$out/bin/timeshift" "''${makeWrapperArgs[@]}"
    wrapProgram "$out/bin/timeshift-gtk" "''${gappsWrapperArgs[@]}"
  '';

  inherit (timeshift-unwrapped) meta;
}
