{
  fetchurl,
  makeWrapper,
  appimageTools,

  pname,
  version,
  meta,
  passthru,
}:

appimageTools.wrapType2 rec {
  inherit
    pname
    version
    meta
    passthru
    ;

  src = fetchurl {
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-Miru-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha256-nLPqEI6u5NNQ/kPbXRWPG0pIwutKNK2J8JeTPN6wHlg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/miru"
      cp -r ${contents}/{locales,resources} "$out/share/lib/miru"
      cp -r ${contents}/usr/* "$out"
      cp "${contents}/${pname}.desktop" "$out/share/applications/"
      # https://github.com/ThaUnknown/miru/issues/562
      # Miru does not work under wayland currently, so force it to use X11
      wrapProgram $out/bin/miru --set ELECTRON_OZONE_PLATFORM_HINT x11
      substituteInPlace $out/share/applications/${pname}.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
    '';
}
