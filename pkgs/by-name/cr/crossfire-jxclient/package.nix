{
  stdenv,
  lib,
  fetchgit,
  makeWrapper,
  gradle,
  jre,
  ffmpeg,
}:

stdenv.mkDerivation rec {
  name = "crossfire-jxclient";
  version = "2025-01";

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/jxclient";
    rev = "01471f0fdf7a5fd8b4ea6d5b49bde7edead5c505";
    hash = "sha256-NGBj3NUBZIfS9J3FHqER8lblPuFEEH9dsTKFBqioiik=";
    # For some reason, submodule fetching fails in nix even though it works in
    # the shell. So we fetch the sounds repo separately below.
    fetchSubmodules = false;
  };

  sounds = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-sounds";
    rev = "b53f436e1d1cca098c641f34c46f15c828ea9c8f";
    hash = "sha256-zA+SaQAaNxNroHESCSonDiUsCuCzjZp+WZNzvsJHNXY=";
  };

  nativeBuildInputs = [
    jre
    gradle
    makeWrapper
    ffmpeg
  ];

  patchPhase = ''
    runHook prePatch

    rm -rf sounds
    ln -s ${sounds} sounds

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild
    gradle :createJar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/java $out/bin
    cp jxclient.jar $out/share/java/jxclient.jar

    makeWrapper ${jre}/bin/java $out/bin/crossfire-jxclient \
      --add-flags "-jar $out/share/java/jxclient.jar" \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp" \
      --set _JAVA_AWT_WM_NONREPARENTING 1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Java-based fullscreen client for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
