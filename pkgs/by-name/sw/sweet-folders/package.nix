{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation {
  pname = "sweet-folders";
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet-folders";
    rev = "b2192ff1412472f036fdf9778c6b9dbcb6c044ec";
    hash = "sha256-QexfqXH5a1IEhKBRjWSMdrEvThvLRzd4M32Xti1DCGE=";
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
