{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "et-book";
  version = "0-unstable-2015-10-05";

  src = fetchFromGitHub {
    owner = "edwardtufte";
    repo = "et-book";
    rev = "7e8f02dadcc23ba42b491b39e5bdf16e7b383031";
    hash = "sha256-B6ryC9ibNop08TJC/w9LSHHwqV/81EezXsTUJFq8xpo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -t $out/share/fonts/truetype source/4-ttf/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Typeface used in Edward Tufte’s books";
    homepage = "https://edwardtufte.github.io/et-book/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jethro ];
  };
}
