{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "apl386";
  version = "0-unstable-2024-01-10";

  src = fetchFromGitHub {
    owner = "abrudz";
    repo = "APL386";
    rev = "43ebc6349506b0e7ab5c49f6b08f8afe66c4d9c5";
    hash = "sha256-MLHSYHFyI9eKdrE/yM7u4vu4Dz6riEk7XQTUuAXPfzM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://abrudz.github.io/APL386/";
    description = "APL385 Unicode font evolved";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
}
