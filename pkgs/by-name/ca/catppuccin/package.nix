let
  validThemes = [
    "bat"
    "bottom"
    "btop"
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
    bat = fetchFromGitHub {
      name = "bat";
      owner = "catppuccin";
      repo = "bat";
      rev = "2bafe4454d8db28491e9087ff3a1382c336e7d27";
      hash = "sha256-yHt3oIjUnljARaihalcWSNldtaJfVDfmfiecYfbzGs0=";
    };

    bottom = fetchFromGitHub {
      name = "bottom";
      owner = "catppuccin";
      repo = "bottom";
      rev = "c0efe9025f62f618a407999d89b04a231ba99c92";
      hash = "sha256-VaHX2I/Gn82wJWzybpWNqU3dPi3206xItOlt0iF6VVQ=";
    };

    btop = fetchFromGitHub {
      name = "btop";
      owner = "catppuccin";
      repo = "btop";
      rev = "1.0.0";
      hash = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
    };

    grub = fetchFromGitHub {
      name = "grub";
      owner = "catppuccin";
      repo = "grub";
      rev = "v1.0.0";
      hash = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
    };

    hyprland = fetchFromGitHub {
      name = "hyprland";
      owner = "catppuccin";
      repo = "hyprland";
      rev = "v1.2";
      hash = "sha256-07B5QmQmsUKYf38oWU3+2C6KO4JvinuTwmW1Pfk8CT8=";
    };

    k9s = fetchFromGitHub {
      name = "k9s";
      owner = "catppuccin";
      repo = "k9s";
      rev = "590a762110ad4b6ceff274265f2fe174c576ce96";
      hash = "sha256-EBDciL3F6xVFXvND+5duT+OiVDWKkFMWbOOSruQ0lus=";
    };

    kvantum = fetchFromGitHub {
      name = "kvantum";
      owner = "catppuccin";
      repo = "Kvantum";
      rev = "d1e174c85311de9715aefc1eba4b8efd6b2730fc";
      hash = "sha256-IrHo8pnR3u90bq12m7FEXucUF79+iub3I9vgH5h86Lk=";
    };

    lazygit = fetchFromGitHub {
      name = "lazygit";
      owner = "catppuccin";
      repo = "lazygit";
      rev = "v2.0.0";
      hash = "sha256-gM0HplHhcpvtpmIVdlX/p59h0v+ihKEidS1imqPYlBg=";
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
      rev = "67759fbe15eb9490d096ef8014d9f92fc5748fe7";
      hash = "sha256-IzoyVOi44Uay7DTfzR9RdRLSjORsdBM4pPrgeXk5YMI=";
    };

    qt5ct = fetchFromGitHub {
      name = "qt5ct";
      owner = "catppuccin";
      repo = "qt5ct";
      rev = "89ee948e72386b816c7dad72099855fb0d46d41e";
      hash = "sha256-t/uyK0X7qt6qxrScmkTU2TvcVJH97hSQuF0yyvSO/qQ=";
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
      rev = "5350da41a11814f950c3354f090b90d4674a95ce";
      hash = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
    };

    starship = fetchFromGitHub {
      name = "starship";
      owner = "catppuccin";
      repo = "starship";
      rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
      hash = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
    };

    thunderbird = fetchFromGitHub {
      name = "thunderbird";
      owner = "catppuccin";
      repo = "thunderbird";
      rev = "d61882ad9fd35909a75da6bb95fca38db552135c";
      hash = "sha256-wn8//8lHScbbB1nEiDY8DphnLUMKZBFMc1GPaTRjTOY=";
    };

    waybar = fetchFromGitHub {
      name = "waybar";
      owner = "catppuccin";
      repo = "waybar";
      rev = "v1.0";
      hash = "sha256-vfwfBE3iqIN1cGoItSssR7h0z6tuJAhNarkziGFlNBw=";
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
    version = "unstable-2024-03-12";

    srcs = selectedSources;

    unpackPhase = ''
      for s in $selectedSources; do
        b=$(basename $s)
        cp $s ''${b#*-}
      done
    '';

    installPhase =
      ''
        runHook preInstall

        local capitalizedVariant=$(sed 's/^\(.\)/\U\1/' <<< "${variant}")
        local capitalizedAccent=$(sed 's/^\(.\)/\U\1/' <<< "${accent}")

      ''
      + lib.optionalString (lib.elem "bat" themeList) ''
        mkdir -p $out/bat
        cp "${sources.bat}/themes/Catppuccin "$capitalizedVariant".tmTheme" "$out/bat/"

      ''
      + lib.optionalString (lib.elem "btop" themeList) ''
        mkdir -p $out/btop
        cp "${sources.btop}/themes/catppuccin_${variant}.theme" "$out/btop/"

      ''
      + lib.optionalString (lib.elem "bottom" themeList) ''
        mkdir -p $out/bottom
        cp "${sources.bottom}/themes/${variant}.toml" "$out/bottom/"

      ''
      + lib.optionalString (lib.elem "grub" themeList) ''
        mkdir -p $out/grub
        cp -r ${sources.grub}/src/catppuccin-${variant}-grub-theme/* "$out/grub/"

      ''
      + lib.optionalString (lib.elem "hyprland" themeList) ''
        mkdir -p $out/hyprland
        cp "${sources.hyprland}/themes/${variant}.conf" "$out/hyprland/"

      ''
      + lib.optionalString (lib.elem "k9s" themeList) ''
        mkdir -p $out/k9s
        cp "${sources.k9s}/dist/catppuccin-${variant}.yaml" "$out/k9s/"
        cp "${sources.k9s}/dist/catppuccin-${variant}-transparent.yaml" "$out/k9s/"

      ''
      + lib.optionalString (lib.elem "kvantum" themeList) ''
        mkdir -p $out/share/Kvantum
        cp -r ${sources.kvantum}/src/Catppuccin-"$capitalizedVariant"-"$capitalizedAccent" $out/share/Kvantum

      ''
      + lib.optionalString (lib.elem "lazygit" themeList) ''
        mkdir -p $out/lazygit/{themes,themes-mergable}
        cp "${sources.lazygit}/themes/${variant}/${accent}.yml" "$out/lazygit/themes/"
        cp "${sources.lazygit}/themes-mergable/${variant}/${accent}.yml" "$out/lazygit/themes-mergable/"

      ''
      + lib.optionalString (lib.elem "lxqt" themeList) ''
        mkdir -p $out/share/lxqt/themes/catppuccin-${variant}
        cp -r ${sources.lxqt}/src/catppuccin-${variant}/* $out/share/lxqt/themes/catppuccin-${variant}/

      ''
      + lib.optionalString (lib.elem "plymouth" themeList) ''
        mkdir -p $out/share/plymouth/themes/catppuccin-${variant}
        cp ${sources.plymouth}/themes/catppuccin-${variant}/* $out/share/plymouth/themes/catppuccin-${variant}
        sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' $out/share/plymouth/themes/catppuccin-${variant}/catppuccin-${variant}.plymouth

      ''
      + lib.optionalString (lib.elem "qt5ct" themeList) ''
        mkdir -p $out/qt5ct
        cp ${sources.qt5ct}/themes/Catppuccin-"$capitalizedVariant".conf $out/qt5ct/

      ''
      + lib.optionalString (lib.elem "rofi" themeList) ''
        mkdir -p $out/rofi
        cp ${sources.rofi}/basic/.local/share/rofi/themes/catppuccin-${variant}.rasi $out/rofi/

      ''
      + lib.optionalString (lib.elem "refind" themeList) ''
        mkdir -p $out/refind/assets
        cp ${sources.refind}/${variant}.conf $out/refind/
        cp -r ${sources.refind}/assets/${variant} $out/refind/assets/

      ''
      + lib.optionalString (lib.elem "starship" themeList) ''
        mkdir -p $out/starship
        cp ${sources.starship}/palettes/${variant}.toml $out/starship/

      ''
      + lib.optionalString (lib.elem "thunderbird" themeList) ''
        mkdir -p $out/thunderbird
        cp ${sources.thunderbird}/themes/${variant}/${variant}-${accent}.xpi $out/thunderbird/

      ''
      + lib.optionalString (lib.elem "waybar" themeList) ''
        mkdir -p $out/waybar
        cp ${sources.waybar}/${variant}.css $out/waybar/

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
