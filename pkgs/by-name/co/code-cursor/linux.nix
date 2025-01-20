{
  stdenvNoCC,
  appimageTools,
  makeWrapper,
  sources,
  source,
  pname,
  version,
  meta,
}:
let
  appimageContents = appimageTools.extractType2 {
    inherit version pname;
    src = source;
  };
in
stdenvNoCC.mkDerivation rec {
  inherit pname version meta;

  src = appimageTools.wrapType2 {
    inherit version pname;
    src = source;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/cursor
    cp -a ${appimageContents}/locales $out/share/cursor
    cp -a ${appimageContents}/resources $out/share/cursor
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/cursor.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/cursor.desktop --replace-fail "AppRun" "cursor"

    wrapProgram $out/bin/cursor \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update"

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };
}
