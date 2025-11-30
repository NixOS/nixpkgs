{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  makeWrapper,
}:
let
  pname = "clickup";
  version = "3.5.120";

  src = fetchurl {
    # Using archive.org because the website doesn't store older versions of the software.
    url = "https://web.archive.org/web/20250802083833/https://desktop.clickup.com/linux";
    hash = "sha256-LVHgXqTxDTsnVJ3zx74TzaSrEs2OD0wl0eioPd4+484=";
  };

  appimage = appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: [ pkgs.xorg.libxkbfile ];
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = appimage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -r ${appimageContents}/locales $out/share/${pname}
    cp -r ${appimageContents}/resources $out/share/${pname}
    cp -r --no-preserve=mode ${appimageContents}/usr/share/icons $out/share/
    find $out/share/icons -name desktop.png -execdir mv {} clickup.png \;

    install -m 444 -D ${appimageContents}/desktop.desktop $out/share/applications/clickup.desktop

    substituteInPlace $out/share/applications/clickup.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=clickup' \
      --replace-fail 'Icon=desktop' 'Icon=clickup'

    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} --no-update"

    runHook postInstall
  '';

  meta = {
    description = "All in one project management solution";
    homepage = "https://clickup.com";
    license = lib.licenses.unfree;
    mainProgram = "clickup";
    maintainers = with lib.maintainers; [ heisfer ];
    platforms = [ "x86_64-linux" ];
  };
}
