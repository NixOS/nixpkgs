{
  lib,
  formats,
  stdenvNoCC,
  fetchFromGitHub,
  libsForQt5,
  /*
    An example of how you can override the background with a NixOS wallpaper
    *
    *  environment.systemPackages = [
    *    (pkgs.elegant-sddm.override {
    *      themeConfig.General = {
             background = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath}";
    *      };
    *    })
    *  ];
  */
  themeConfig ? null,
}:

let
  user-cfg = (formats.ini { }).generate "theme.conf.user" themeConfig;
in

stdenvNoCC.mkDerivation {
  pname = "elegant-sddm";
  version = "unstable-2024-02-08";

  src = fetchFromGitHub {
    owner = "surajmandalcell";
    repo = "Elegant-sddm";
    rev = "3102e880f46a1b72c929d13cd0a3fb64f973952a";
    hash = "sha256-yn0fTYsdZZSOcaYlPCn8BUIWeFIKcTI1oioTWqjYunQ=";
  };

  dontWrapQtApps = true;
  propagatedBuildInputs = [
    libsForQt5.qtgraphicaleffects
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes"
    cp -r Elegant/ "$out/share/sddm/themes/Elegant"
  ''
  + (lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/Elegant/theme.conf.user
  '')
  + ''
    runHook postInstall
  '';

  postFixup = ''
    mkdir -p $out/nix-support

    echo ${libsForQt5.qtgraphicaleffects} >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Sleek and stylish SDDM theme crafted in QML";
    homepage = "https://github.com/surajmandalcell/Elegant-sddm";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
