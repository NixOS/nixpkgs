<<<<<<< HEAD
{ lib, fetchurl, appimageTools, makeWrapper }:

let
  pname = "youtube-music";
  version = "1.20.0";

  src = fetchurl {
    url = "https://github.com/th-ch/youtube-music/releases/download/v${version}/YouTube-Music-${version}.AppImage";
    hash = "sha256-eTPWLD9KUs2ZsLbYRkknnx5uDyrNSbFHPyv6gU+wL/c=";
=======
{ lib, fetchurl, appimageTools, }:

let
  pname = "youtube-music";
  version = "1.19.0";

  src = fetchurl {
    url = "https://github.com/th-ch/youtube-music/releases/download/v${version}/YouTube-Music-${version}.AppImage";
    sha256 = "sha256-o/a+6EKPEcE9waXQK3hxtp7FPqokteoUAt0iOJk8bYw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
<<<<<<< HEAD
(appimageTools.wrapType2 rec {
=======
appimageTools.wrapType2 rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  inherit pname version src;
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libappindicator ];

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
<<<<<<< HEAD
    wrapProgram "$out/bin/${pname}" \
       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}"

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "youtube-music";
  };
}).overrideAttrs ({ nativeBuildInputs ? [ ], ... }: {
  nativeBuildInputs = nativeBuildInputs ++ [ makeWrapper ];
})
=======
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
