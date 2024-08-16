{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  sassc,
  gnome-themes-extra,
  gtk-engine-murrine,
  colorVariants ? [] # default: install all icons
}:

let
  pname = "gruvbox-gtk-theme";
  colorVariantList = [
    "dark"
    "light"
  ];

in
lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-06-27";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "f568ccd7bf7570d8a27feb62e318b07b88e24b94";
    hash = "sha256-4vGwPggHdNjtQ03UFgN4OH5+ZEkdIlivCdYuZ0Dsd5Q=";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  nativeBuildInputs = [ sassc ];
  buildInputs = [ gnome-themes-extra ];

  dontBuild = true;

  postPatch = ''
    patchShebangs themes/install.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cd themes
    ./install.sh -n Gruvbox -c ${lib.concatStringsSep " " (if colorVariants != [] then colorVariants else colorVariantList)} --tweaks macos -d "$out/share/themes"
    runHook postInstall
  '';

  meta = {
    description = "GTK theme based on the Gruvbox colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      math-42
      d3vil0p3r
    ];
  };
}
