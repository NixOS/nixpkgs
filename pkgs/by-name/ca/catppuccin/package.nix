let
  validThemes = [
    "alacritty"
    "bat"
    "bottom"
    "btop"
    "element"
    "grub"
    "hyprland"
    "k9s"
    "kvantum"
    "lazygit"
    "lxqt"
    "plymouth"
    "qt5ct"
    "refind"
    "rofi"
    "starship"
    "thunderbird"
    "waybar"
  ];
in
{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  accent ? "blue",
  variant ? "macchiato",
  themeList ? validThemes,
}:
let
  pname = "catppuccin";

  validAccents = [
    "rosewater"
    "flamingo"
    "pink"
    "mauve"
    "red"
    "maroon"
    "peach"
    "yellow"
    "green"
    "teal"
    "sky"
    "sapphire"
    "blue"
    "lavender"
  ];
  validVariants = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];

  selectedSources = map (themeName: builtins.getAttr themeName sources) themeList;
  sources = {
    alacritty = fetchFromGitHub {
      name = "alacritty";
      owner = "catppuccin";
      repo = "alacritty";
      rev = "f6cb5a5c2b404cdaceaff193b9c52317f62c62f7";
      hash = "sha256-H8bouVCS46h0DgQ+oYY8JitahQDj0V9p2cOoD4cQX+Q=";
    };

    bat = fetchFromGitHub {
      name = "bat";
      owner = "catppuccin";
      repo = "bat";
      rev = "699f60fc8ec434574ca7451b444b880430319941";
      hash = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
    };

    bottom = fetchFromGitHub {
      name = "bottom";
      owner = "catppuccin";
      repo = "bottom";
      rev = "ed09bd5a5dd78d83acdc8ff5fdec40a6340ed1c2";
      hash = "sha256-Vi438I+YVvoD2xzq2t9hJ9R3a+2TlDdbakjFYFtjtXQ=";
    };

    btop = fetchFromGitHub {
      name = "btop";
      owner = "catppuccin";
      repo = "btop";
      rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
      hash = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
    };

    element = fetchFromGitHub {
      name = "element";
      owner = "catppuccin";
      repo = "element";
      rev = "70b7ee121dcef28c6c8191d60df2f88b23c89084";
      hash = "sha256-iUSPlmEvwL9akbPobkbDWPr6TTHA/LdCK2Nty7Zslls=";
    };

    grub = fetchFromGitHub {
      name = "grub";
      owner = "catppuccin";
      repo = "grub";
      rev = "2a5c8be8185dae49dd22030df45860df8c796312";
      hash = "sha256-20D1EcV8SWOd5BLdAc6FaQu3onha0+aS5yA/GK8Ra0g=";
    };

    hyprland = fetchFromGitHub {
      name = "hyprland";
      owner = "catppuccin";
      repo = "hyprland";
      rev = "c388ac55563ddeea0afe9df79d4bfff0096b146b";
      hash = "sha256-xSa/z0Pu+ioZ0gFH9qSo9P94NPkEMovstm1avJ7rvzM=";
    };

    k9s = fetchFromGitHub {
      name = "k9s";
      owner = "catppuccin";
      repo = "k9s";
      rev = "fdbec82284744a1fc2eb3e2d24cb92ef87ffb8b4";
      hash = "sha256-9h+jyEO4w0OnzeEKQXJbg9dvvWGZYQAO4MbgDn6QRzM=";
    };

    kvantum = fetchFromGitHub {
      name = "kvantum";
      owner = "catppuccin";
      repo = "Kvantum";
      rev = "a87694e0a3c97644dbb34f8835112d17b54ace68";
      hash = "sha256-eQmEeKC+L408ajlNg3oKMnDK6Syy2GV6FrR2TN5ZBCg=";
    };

    lazygit = fetchFromGitHub {
      name = "lazygit";
      owner = "catppuccin";
      repo = "lazygit";
      rev = "d3c95a67ea3f778f7705d8ef814f87ac5213436d";
      hash = "sha256-b2SoIeXT1BaoxvEeQ0VaPmnBND+7qUe342kOIkyOcAc=";
    };

    lxqt = fetchFromGitHub {
      name = "lxqt";
      owner = "catppuccin";
      repo = "lxqt";
      rev = "38cf86b3e499e0c0928a102c9c030e5dc6b79255";
      hash = "sha256-3TuUkOwk6BSc7BnLnTowGAkSlNTOtGTRlEcjJ6MNJ5g=";
    };

    plymouth = fetchFromGitHub {
      name = "plymouth";
      owner = "catppuccin";
      repo = "plymouth";
      rev = "e0f58d6fcf3dbc2d35dfc4fec394217fbfa92666";
      hash = "sha256-He6ER1QNrJCUthFoBBGHBINouW/tozxQy3R79F5tsuo=";
    };

    qt5ct = fetchFromGitHub {
      name = "qt5ct";
      owner = "catppuccin";
      repo = "qt5ct";
      rev = "0442cc931390c226d143e3a6d6e77f819c68502a";
      hash = "sha256-hXyPuI225WdMuVSeX1AwrylUzNt0VA33h8C7MoSJ+8A=";
    };

    refind = fetchFromGitHub {
      name = "refind";
      owner = "catppuccin";
      repo = "refind";
      rev = "ff0b593c19bb9b469ee0ee36068b8d373f0fadc5";
      hash = "sha256-itUMo0lA23bJzH0Ndq7L2IaEYoVdNPYxbB/VWkRfRso=";
    };

    rofi = fetchFromGitHub {
      name = "rofi";
      owner = "catppuccin";
      repo = "rofi";
      rev = "c24a212a6b07c2d45f32d01d7f10b4d88ddc9f45";
      hash = "sha256-WGYEA4Q7UvSaRDjP/DiEtfXjvmWbewtdyJWRpjhbZgg=";
    };

    starship = fetchFromGitHub {
      name = "starship";
      owner = "catppuccin";
      repo = "starship";
      rev = "e99ba6b210c0739af2a18094024ca0bdf4bb3225";
      hash = "sha256-1w0TJdQP5lb9jCrCmhPlSexf0PkAlcz8GBDEsRjPRns=";
    };

    thunderbird = fetchFromGitHub {
      name = "thunderbird";
      owner = "catppuccin";
      repo = "thunderbird";
      rev = "0289f3bd9566f9666682f66a3355155c0d0563fc";
      hash = "sha256-07gT37m1+OhRTbUk51l0Nhx+I+tl1il5ayx2ow23APY=";
    };

    waybar = fetchFromGitHub {
      name = "waybar";
      owner = "catppuccin";
      repo = "waybar";
      rev = "v1.1";
      hash = "sha256-9lY+v1CTbpw2lREG/h65mLLw5KuT8OJdEPOb+NNC6Fo=";
    };
  };
in
lib.checkListOfEnum "${pname}: variant" validVariants [ variant ] lib.checkListOfEnum
  "${pname}: accent"
  validAccents
  [ accent ]
  lib.checkListOfEnum
  "${pname}: themes"
  validThemes
  themeList

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "unstable-2025-02-21";

    srcs = selectedSources;

    unpackPhase = ''
      for s in $selectedSources; do
        b=$(basename $s)
        cp $s ''${b#*-}
      done
    '';

    installPhase = ''
      runHook preInstall

      local capitalizedVariant=$(sed 's/^\(.\)/\U\1/' <<< "${variant}")
      local capitalizedAccent=$(sed 's/^\(.\)/\U\1/' <<< "${accent}")

    ''
    + lib.optionalString (lib.elem "alacritty" themeList) ''
      mkdir -p "$out/alacritty"
      cp "${sources.alacritty}/catppuccin-${variant}.toml" "$out/alacritty/"

    ''
    + lib.optionalString (lib.elem "bat" themeList) ''
      mkdir -p "$out/bat"
      cp "${sources.bat}/themes/Catppuccin "$capitalizedVariant".tmTheme" "$out/bat/"

    ''
    + lib.optionalString (lib.elem "btop" themeList) ''
      mkdir -p "$out/btop"
      cp "${sources.btop}/themes/catppuccin_${variant}.theme" "$out/btop/"

    ''
    + lib.optionalString (lib.elem "bottom" themeList) ''
      mkdir -p "$out/bottom"
      cp "${sources.bottom}/themes/${variant}.toml" "$out/bottom/"

    ''
    + lib.optionalString (lib.elem "element" themeList) ''
      mkdir -p "$out/element"
      cp -r "${sources.element}/themes/${variant}/${accent}.json" "$out/element/"

    ''
    + lib.optionalString (lib.elem "grub" themeList) ''
      mkdir -p "$out/grub"
      cp -r "${sources.grub}/src/catppuccin-${variant}-grub-theme/"* "$out/grub/"

    ''
    + lib.optionalString (lib.elem "hyprland" themeList) ''
      mkdir -p "$out/hyprland"
      cp "${sources.hyprland}/themes/${variant}.conf" "$out/hyprland/"

    ''
    + lib.optionalString (lib.elem "k9s" themeList) ''
      mkdir -p "$out/k9s"
      cp "${sources.k9s}/dist/catppuccin-${variant}.yaml" "$out/k9s/"
      cp "${sources.k9s}/dist/catppuccin-${variant}-transparent.yaml" "$out/k9s/"

    ''
    + lib.optionalString (lib.elem "kvantum" themeList) ''
      mkdir -p "$out/share/Kvantum"
      cp -r "${sources.kvantum}/themes/catppuccin-${variant}-${accent}" "$out/share/Kvantum"

    ''
    + lib.optionalString (lib.elem "lazygit" themeList) ''
      mkdir -p "$out/lazygit/"{themes,themes-mergable}
      cp "${sources.lazygit}/themes/${variant}/${accent}.yml" "$out/lazygit/themes/"
      cp "${sources.lazygit}/themes-mergable/${variant}/${accent}.yml" "$out/lazygit/themes-mergable/"

    ''
    + lib.optionalString (lib.elem "lxqt" themeList) ''
      mkdir -p "$out/share/lxqt/themes/catppuccin-${variant}"
      cp -r "${sources.lxqt}/src/catppuccin-${variant}/"* "$out/share/lxqt/themes/catppuccin-${variant}"

    ''
    + lib.optionalString (lib.elem "plymouth" themeList) ''
      mkdir -p "$out/share/plymouth/themes/catppuccin-${variant}"
      cp ${sources.plymouth}/themes/catppuccin-${variant}/* $out/share/plymouth/themes/catppuccin-${variant}
      sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' $out/share/plymouth/themes/catppuccin-${variant}/catppuccin-${variant}.plymouth

    ''
    + lib.optionalString (lib.elem "qt5ct" themeList) ''
      mkdir -p "$out/qt5ct"
      cp "${sources.qt5ct}/themes/catppuccin-${variant}-${accent}.conf" "$out/qt5ct"

    ''
    + lib.optionalString (lib.elem "rofi" themeList) ''
      mkdir -p "$out/rofi"
      cp "${sources.rofi}/themes/catppuccin-${variant}.rasi" "$out/rofi"

    ''
    + lib.optionalString (lib.elem "refind" themeList) ''
      mkdir -p "$out/refind/assets"
      cp "${sources.refind}/${variant}.conf" "$out/refind"
      cp -r "${sources.refind}/assets/${variant}" "$out/refind/assets"

    ''
    + lib.optionalString (lib.elem "starship" themeList) ''
      mkdir -p "$out/starship"
      cp "${sources.starship}/themes/${variant}.toml" "$out/starship"

    ''
    + lib.optionalString (lib.elem "thunderbird" themeList) ''
      mkdir -p "$out/thunderbird"
      cp "${sources.thunderbird}/themes/${variant}/${variant}-${accent}.xpi" "$out/thunderbird"

    ''
    + lib.optionalString (lib.elem "waybar" themeList) ''
      mkdir -p "$out/waybar"
      cp "${sources.waybar}/themes/${variant}.css" "$out/waybar"

    ''
    + ''
      runHook postInstall
    '';

    meta = {
      description = "Soothing pastel themes";
      homepage = "https://github.com/catppuccin/catppuccin";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.khaneliman ];
    };
  }
