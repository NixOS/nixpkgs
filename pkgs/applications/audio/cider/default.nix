{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
}:

appimageTools.wrapType2 rec {
  pname = "cider";
  version = "1.6.2";

  src = fetchurl {
    url = "https://github.com/ciderapp/Cider/releases/download/v${version}/Cider-${version}.AppImage";
    sha256 = "sha256-43QmTnFp8raEyZO5NK/UlRM8Ykd0y4iaYlL3MpROmsk=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "A new look into listening and enjoying Apple Music in style and performance.";
    homepage = "https://github.com/ciderapp/Cider";
    license = licenses.agpl3Only;
    mainProgram = "cider";
    maintainers = [ maintainers.cigrainger ];
    platforms = [ "x86_64-linux" ];
  };
}
