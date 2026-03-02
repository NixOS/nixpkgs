{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "apl386";
  version = "0-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "abrudz";
    repo = "APL386";
    rev = "c5bca014b6610ee170985c3ce32a8bb14dbd7b94";
    hash = "sha256-5aiydx8TyJG0H0F261Xg5fGWBbAIZCtVHgWs7B6+83w=";
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
