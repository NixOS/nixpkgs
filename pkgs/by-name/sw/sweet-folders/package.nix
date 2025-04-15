{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "sweet-folders";
  version = "0-unstable-2025-02-15";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet-folders";
    rev = "40a5d36e50437901c7eaa1119bb9ae8006e2fe5c";
    hash = "sha256-Pb3xsNKM5yGT4uAUxrCds1JSSvU/whhTJcmqiM7EW+4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r Sweet-* $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Folders icons for Sweet GTK theme";
    homepage = "https://github.com/EliverLara/Sweet-folders";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
