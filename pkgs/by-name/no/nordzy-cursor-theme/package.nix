{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordzy-cursor-theme";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-cursors";
    rev = "v${version}";
    sha256 = "sha256-q9PEEyxejRQ8UCwbqsfOCL7M70pLCOLyCx8gEFmZkWA=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r Nordzy-cursors{,-white,-lefthand} $out/share/icons
  '';

  meta = with lib; {
    description = "Cursor theme using the Nord color palette and based on Vimix and cz-Viator";
    homepage = "https://github.com/alvatip/Nordzy-cursors";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      alexnortung
    ];
  };
}
