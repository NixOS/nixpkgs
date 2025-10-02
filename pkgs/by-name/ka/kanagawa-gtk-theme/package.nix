{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gtk-engine-murrine,
  sassc,
  tweaks ? [ ],
  variant ? "default",
  size ? "standard",
}:
stdenvNoCC.mkDerivation {
  pname = "kanagawa-gtk-theme";
  version = "0-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "36ce4c341dca01e497109f62e3ca26c9614ebefc";
    hash = "sha256-iQbvKmHeyrNIFbuoqmX5jgmXWFjc0ZjAw4IxCOxic4k=";
  };

  nativeBuildInputs = [
    gtk3
    sassc
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall

    patchShebangs ./themes/install.sh
    ./themes/install.sh \
      --name Kanagawa \
      --tweaks ${lib.concatStringsSep " " tweaks} \
      --theme ${variant} \
      --size ${size} \
      --dest $out/share/themes

    runHook postInstall
  '';

  meta = with lib; {
    description = "GTK theme with the Kanagawa colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iynaix ];
    platforms = gtk3.meta.platforms;
  };
}
