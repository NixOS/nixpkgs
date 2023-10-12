{ lib, fetchurl, appimageTools, makeWrapper }:

let
  pname = "youtube-music";
  version = "1.20.0";

  src = fetchurl {
    url = "https://github.com/th-ch/youtube-music/releases/download/v${version}/YouTube-Music-${version}.AppImage";
    hash = "sha256-eTPWLD9KUs2ZsLbYRkknnx5uDyrNSbFHPyv6gU+wL/c=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
(appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libappindicator ];

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    wrapProgram "$out/bin/${pname}" \
       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}"

    install -m 444 \
        -D ${appimageContents}/youtube-music.desktop \
        -t $out/share/applications
    substituteInPlace \
        $out/share/applications/youtube-music.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Electron wrapper around YouTube Music";
    homepage = "https://th-ch.github.io/youtube-music/";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    maintainers = [ maintainers.aacebedo ];
    mainProgram = "youtube-music";
  };
}).overrideAttrs ({ nativeBuildInputs ? [ ], ... }: {
  nativeBuildInputs = nativeBuildInputs ++ [ makeWrapper ];
})
