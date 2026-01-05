{
  stdenvNoCC,
  clapper-unwrapped,
  wrapGAppsHook4,
  gobject-introspection,
  xorg,
  clapper-enhancers,
}:

stdenvNoCC.mkDerivation {
  pname = "clapper";
  inherit (clapper-unwrapped) version meta;

  src = clapper-unwrapped;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
    xorg.lndir
  ];

  buildInputs = [ clapper-unwrapped ] ++ clapper-unwrapped.buildInputs;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    lndir $src $out
    dbusfile=share/dbus-1/services/com.github.rafostar.Clapper.service
    rm $out/$dbusfile
    cp $src/$dbusfile $out/$dbusfile
    substituteInPlace $out/$dbusfile \
      --replace-fail $src/bin/clapper $out/bin/clapper

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default CLAPPER_ENHANCERS_PATH "${clapper-enhancers}/${clapper-enhancers.passthru.pluginPath}"
    )
  '';
}
