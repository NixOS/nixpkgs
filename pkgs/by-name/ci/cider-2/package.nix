{
  appimageTools,
  lib,
  requireFile,
  makeWrapper,
}:

appimageTools.wrapType2 rec {
  pname = "cider-2";
  version = "3.0.2";

  src = requireFile {
    name = "cider-linux-x64.AppImage";
    url = "https://cidercollective.itch.io/cider";
    sha256 = "1rfraf1r1zmp163kn8qg833qxrxmx1m1hycw8q9hc94d0hr62l2x";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract {
        inherit version src;
        # HACK: this looks for a ${pname}.desktop, where `cider-2.desktop` doesn't exist
        pname = "Cider";
      };
    in
    ''
      wrapProgram $out/bin/${pname} \
         --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
         --add-flags "--no-sandbox --disable-gpu-sandbox" # Cider 2 does not start up properly without these from my preliminary testing

      install -m 444 -D ${contents}/Cider.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=Cider' 'Exec=${pname}'
      install -Dm444 ${contents}/usr/share/icons/hicolor/256x256/cider.png \
                     $out/share/icons/hicolor/256x256/apps/cider.png
    '';

  meta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    license = lib.licenses.unfree;
    mainProgram = "cider-2";
    maintainers = with lib.maintainers; [
      itsvic-dev
      l0r3v
    ];
    platforms = [ "x86_64-linux" ];
  };
}
