{
  lib,
  fetchFromGitHub,
  materia-theme,
  dart-sass,
}:
materia-theme.overrideAttrs (old: {
  pname = "materia-theme-transparent";
  version = "0-unstable-2021-03-22";

  src = fetchFromGitHub {
    owner = "ckissane";
    repo = "materia-theme-transparent";
    rev = "c5d95bbddd59a717bfc4976737af429a89ba74e0";
    hash = "sha256-SuBt3DOVgxZdkcKWMysDF5S4A4y/VHZwRUmvtx8w52s=";
  };

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    dart-sass
  ];

  meta = {
    description = "Transparent Material Design theme for GNOME/GTK based desktop environments";
    homepage = "https://github.com/ckissane/materia-theme-transparent";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.marrobHD
    ];
  };
})
