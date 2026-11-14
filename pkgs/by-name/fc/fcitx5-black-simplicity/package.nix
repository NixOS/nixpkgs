{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "fcitx5-black-simplicity";
  version = "0-unstable-2021-11-23";

  src = fetchFromGitHub {
    owner = "fuzakebito";
    repo = "fcitx5-Black-Simplicity";
    rev = "27e279c4e4f1c2318b19360367a0b9a5ef83efbb";
    hash = "sha256-XWnYaUBwXDJwy4n37WKW3DEKkUdUEOFvR/8v5ibF96k=";
  };

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fcitx5/themes/
    cp -rv ./Black-Simplicity/ $out/share/fcitx5/themes/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Monochrome skin that gives a simpler look to fcitx5";
    homepage = "https://github.com/fuzakebito/fcitx5-Black-Simplicity";
    license = licenses.unfree;
    maintainers = with maintainers; [ alexandrutocar ];
    platforms = platforms.all;
  };
}
