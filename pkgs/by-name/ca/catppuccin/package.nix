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
      rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
      hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
    };

    bottom = fetchFromGitHub {
      name = "bottom";
      owner = "catppuccin";
      repo = "bottom";
      rev = "eadd75acd0ecad4a58ade9a1d6daa3b97ccec07c";
      hash = "sha256-dfukdk70ug1lRGADKBnvMhkl+3tsY7F+UAwTS2Qyapk=";
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
      rev = "0a37ab19f654e77129b409fed371891c01ffd0b9";
      hash = "sha256-jgM22pvCQvb0bjQQXoiqGMgScR9AgCK3OfDF5Ud+/mk=";
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
      rev = "c7cb144b041395e83e4f510a62526b7adfb79911";
      hash = "sha256-YNUkri+no+rNLTJHf6cPdy4AmQLzPiRK1Jbp2o8e1LE=";
    };

    lazygit = fetchFromGitHub {
      name = "lazygit";
      owner = "catppuccin";
      repo = "lazygit";
      rev = "c24895902ec2a3cb62b4557f6ecd8e0afeed95d5";
      hash = "sha256-4eJEOEfwLBc4EoQ32TpuhXS3QDvQ8FtT7EgpotEKV7o=";
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
      rev = "cb585307edebccf74b8ae8f66ea14f21e6666535";
      hash = "sha256-wDj6kQ2LQyMuEvTQP6NifYFdsDLT+fMCe3Fxr8S783w=";
    };

    refind = fetchFromGitHub {
      name = "refind";
      owner = "catppuccin";
      repo = "refind";
      rev = "e92ad6f4673e30fbc79e69c9cbe3780fb9a3f05f";
      hash = "sha256-34+MkvWEp3xq6Di1uWKR4ieaG4t2rufnRRN1/V0WRfw=";
    };

    rofi = fetchFromGitHub {
      name = "rofi";
      owner = "catppuccin";
      repo = "rofi";
      rev = "71fb15577ccb091df2f4fc1f65710edbc61b5a53";
      hash = "sha256-81eeFjwM/haPjIEWkZPp1JSDwhWbWDAuKtWiCg7P9Q0=";
    };

    starship = fetchFromGitHub {
      name = "starship";
      owner = "catppuccin";
      repo = "starship";
      rev = "5906cc369dd8207e063c0e6e2d27bd0c0b567cb8";
      hash = "sha256-FLHjbClpTqaK4n2qmepCPkb8rocaAo3qeV4Zp1hia0g=";
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
      rev = "ee8ed32b4f63e9c417249c109818dcc05a2e25da";
      hash = "sha256-za0y6hcN2rvN6Xjf31xLRe4PP0YyHu2i454ZPjr+lWA=";
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
    version = "unstable-2025-10-07";

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
      homepage = "https://catppuccin.com";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [
        khaneliman
        SchweGELBin
      ];
    };
  }
