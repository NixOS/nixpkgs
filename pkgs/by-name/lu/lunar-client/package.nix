{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:

appimageTools.wrapType2 rec {
  pname = "lunarclient";
<<<<<<< HEAD
  version = "3.5.16";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}-ow.AppImage";
    hash = "sha512-V0aeQTFRAoheUsI/gFZMaTTgWaCxQXEirkKr2mFnUhBXdesYGwnKmIJk0v1JOtK2RQT0V536yEMsRJVZgfscNw==";
=======
  version = "3.5.9";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}-ow.AppImage";
    hash = "sha512-Gl9bJ8Hn3aVn/oKxBNb7CjJHLQ6NjFH/x45euWjCYaTtxF3qOTzuEm2VrivpghiviZIUGPWHP7rOKH8OWzPjLQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/lunarclient \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
      install -Dm444 ${contents}/lunarclient.desktop -t $out/share/applications/
      install -Dm444 ${contents}/lunarclient.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/lunarclient.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lunarclient' \
    '';

  passthru.updateScript = ./update.sh;

<<<<<<< HEAD
  meta = {
    description = "Free Minecraft client with mods, cosmetics, and performance boost";
    homepage = "https://www.lunarclient.com/";
    license = with lib.licenses; [ unfree ];
    mainProgram = "lunarclient";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Free Minecraft client with mods, cosmetics, and performance boost";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    mainProgram = "lunarclient";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      Technical27
      surfaceflinger
    ];
    platforms = [ "x86_64-linux" ];
  };
}
