{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gtk3,
  papirus-icon-theme,
  flavor ? "mocha",
  accent ? "blue",
}:
let
  validAccents = [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ];
  validFlavors = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];
  pname = "catppuccin-papirus-folders";
in
lib.checkListOfEnum "${pname}: accent colors" validAccents [ accent ] lib.checkListOfEnum
  "${pname}: flavors"
  validFlavors
  [ flavor ]

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "unstable-2023-08-02";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "papirus-folders";
      rev = "fcf96737fffc343a1bf129732c37d19f2d77fa5c";
      sha256 = "sha256-3yjIGzN+/moP2OVGDIAy4zPqUroSjx3c2mJjdZGhTsY=";
    };

    nativeBuildInputs = [ gtk3 ];

    postPatch = ''
      patchShebangs ./papirus-folders
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/icons
      cp -r --no-preserve=mode ${papirus-icon-theme}/share/icons/Papirus* $out/share/icons
      cp -r src/* $out/share/icons/Papirus
      for theme in $out/share/icons/*; do
          USER_HOME=$HOME DISABLE_UPDATE_ICON_CACHE=1 \
            ./papirus-folders -t $theme -o -C cat-${flavor}-${accent}
          gtk-update-icon-cache --force $theme
      done
      runHook postInstall
    '';

    meta = with lib; {
      description = "Soothing pastel theme for Papirus Icon Theme folders";
      homepage = "https://github.com/catppuccin/papirus-folders";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ rubyowo ];
    };
  }
