{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome,
  sassc,
  gnome-themes-extra,
  gtk-engine-murrine,
  colorVariants ? [ ], # default: install all icons
}:

let
  pname = "nightfox-gtk-theme";
  colorVariantList = [
    "dark"
    "light"
  ];

in
lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2024-06-27";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Nightfox-GTK-Theme";
      rev = "ef4e6e1fa3efe2a5d838d61191776abfe4d87766";
      hash = "sha256-RsDEHauz9jQs1rqsoKbL/s0Vst3GzJXyGsE3uFtLjCY=";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    nativeBuildInputs = [
      gnome.gnome-shell
      sassc
    ];
    buildInputs = [ gnome-themes-extra ];

    dontBuild = true;

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cd themes
      ./install.sh -n Nightfox -c ${
        lib.concatStringsSep " " (if colorVariants != [ ] then colorVariants else colorVariantList)
      } --tweaks macos -d "$out/share/themes"
      runHook postInstall
    '';

    meta = with lib; {
      description = "A GTK theme based on the Nightfox colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Nightfox-GTK-Theme";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [ d3vil0p3r ];
      platforms = platforms.unix;
    };
  }
