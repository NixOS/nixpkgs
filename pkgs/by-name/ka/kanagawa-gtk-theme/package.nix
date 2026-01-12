{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gtk-engine-murrine,
}:
stdenvNoCC.mkDerivation {
  pname = "kanagawa-gtk-theme";
  version = "0-unstable-2023-07-03";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "35936a1e3bbd329339991b29725fc1f67f192c1e";
    hash = "sha256-BZRmjVas8q6zsYbXFk4bCk5Ec/3liy9PQ8fqFGHAXe0=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes

    runHook postInstall
  '';

  meta = {
    description = "GTK theme with the Kanagawa colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iynaix ];
    platforms = gtk3.meta.platforms;
  };
}
