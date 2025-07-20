{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchurl,
  gtk3,
  getent,
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

  # Note(sewer56):
  # Fetch the papirus-folders script from upstream
  # Per instructions in the papirus-folders project.
  papirus-folders-script = fetchurl {
    url = "https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/0f838ee5679229e3a3e97e3b333c222c9e9615b4/papirus-folders";
    sha256 = "sha256-swpoSKAGkDAqzP/AUFSSGLCxFNMXiyi9OhaJGBeCGwY=";
  };
in
lib.checkListOfEnum "${pname}: accent colors" validAccents [ accent ] lib.checkListOfEnum
  "${pname}: flavors"
  validFlavors
  [ flavor ]
  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "unstable-2024-08-06";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "papirus-folders";
      rev = "f83671d17ea67e335b34f8028a7e6d78bca735d7";
      sha256 = "sha256-FiZdwzsaMhS+5EYTcVU1LVax2H1FidQw97xZklNH2R4=";
    };

    # This gets stuck on fixup for some reason. Please help.
    dontFixup = true;
    nativeBuildInputs = [
      gtk3
      getent
    ];

    postPatch = ''
      # Copy the upstream papirus-folders script (pinned), per papirus-folders documentation
      cp ${papirus-folders-script} ./papirus-folders
      chmod +x ./papirus-folders
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
