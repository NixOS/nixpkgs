{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "posy-cursors";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "simtrami";
    repo = "posy-improved-cursor-linux";
    rev = "refs/tags/${version}";
    hash = "sha256-i0N/QB5uzqHapMCDl6h6PWPJ4GOAyB1ds9qlqmZacLY=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r Posy_Cursor* $out/share/icons
    runHook postInstall
  '';

  meta = with lib; {
    description = "Posy's Improved Cursors for Linux";
    homepage = "https://github.com/simtrami/posy-improved-cursor-linux";
    platforms = platforms.unix;
    license = licenses.unfree;
    maintainers = with maintainers; [ mkez ];
  };
}
