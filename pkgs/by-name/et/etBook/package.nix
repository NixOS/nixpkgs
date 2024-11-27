{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "et-book";
  version = "unstable-2015-10-05";

  src = fetchFromGitHub {
    owner = "edwardtufte";
    repo = pname;
    rev = "7e8f02dadcc23ba42b491b39e5bdf16e7b383031";
    hash = "sha256-B6ryC9ibNop08TJC/w9LSHHwqV/81EezXsTUJFq8xpo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -t $out/share/fonts/truetype source/4-ttf/*.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Typeface used in Edward Tufte’s books";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jethro ];
  };
}
