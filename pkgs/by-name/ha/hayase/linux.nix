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
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-hayase-${version}-linux.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha256-RlANC9NNzLTtFvOwz6UoCaW6Zr6K5IhihUABGoXhCv0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/hayase"
      cp -r ${contents}/{locales,resources} "$out/share/lib/hayase"
      cp -r ${contents}/usr/* "$out"
      cp "${contents}/hayase.desktop" "$out/share/applications/"
      # https://github.com/ThaUnknown/miru/issues/562
      # Hayase does not work under wayland currently, so force it to use X11
      wrapProgram $out/bin/hayase --set ELECTRON_OZONE_PLATFORM_HINT x11
      substituteInPlace $out/share/applications/hayase.desktop --replace 'Exec=AppRun' 'Exec=hayase'
    '';
}
