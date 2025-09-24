{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordzy-cursor-theme";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "guillaumeboehm";
    repo = "Nordzy-cursors";
    rev = "v${version}";
    sha256 = "sha256-pPcdlMa3H5RtbqIxvgxDkP4tw76H2UQujXbrINc3MxE=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r xcursors/* $out/share/icons
    cp -r hyprcursors/themes/* $out/share/icons
  '';

  meta = with lib; {
    description = "Cursor theme using the Nord color palette and based on Vimix and cz-Viator";
    homepage = "https://github.com/guillaumeboehm/Nordzy-cursors";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      alexnortung
    ];
  };
}
