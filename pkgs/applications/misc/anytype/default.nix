<<<<<<< HEAD
{ lib, fetchurl, appimageTools, makeWrapper }:

let
  pname = "anytype";
  version = "0.34.3";
  name = "Anytype-${version}";
  nameExecutable = pname;
  src = fetchurl {
    url = "https://anytype-release.fra1.cdn.digitaloceanspaces.com/Anytype-${version}.AppImage";
    name = "Anytype-${version}.AppImage";
    sha256 = "sha256-YJMpCEQ6eJYISGeYgvS6TcQwU2eD6fjgHrHRKA6CQJU=";
=======
{ lib, fetchurl, appimageTools }:

let
  pname = "anytype";
  version = "0.31.0";
  name = "Anytype-${version}";
  nameExecutable = pname;
  src = fetchurl {
    url = "https://at9412003.fra1.digitaloceanspaces.com/Anytype-${version}.AppImage";
    name = "Anytype-${version}.AppImage";
    sha256 = "sha256-s8al0R9G478A+PymQcdcdRpw6tpKkG+WIZsXZYEvf/o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
<<<<<<< HEAD
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    install -m 444 -D ${appimageContents}/anytype.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/anytype.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/anytype.png \
      $out/share/icons/hicolor/512x512/apps/anytype.png
=======
    install -m 444 -D ${appimageContents}/anytype2.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/anytype2.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/anytype2.png \
      $out/share/icons/hicolor/512x512/apps/anytype2.png
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "P2P note-taking tool";
    homepage = "https://anytype.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ bbigras ];
    platforms = [ "x86_64-linux" ];
  };
}
