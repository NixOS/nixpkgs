{
  lib,
  buildSddmThemePackage,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  just,
  catppuccin-whiskers,
  flavor ? "mocha",
  accent ? "mauve",

  # deprecated in favor of `.withConfig`
  font ? null,
  fontSize ? null,
  background ? null,
  disableBackground ? null,
  loginBackground ? null,
  userIcon ? null,
  clockEnabled ? null,
}:
buildSddmThemePackage (finalAttrs: {
  pname = "catppuccin-sddm";
  version = "1.1.2";

  src = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-src";
    inherit (finalAttrs) version;

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      tag = "v${finalAttrs.version}";
      hash = "sha256-7S0DKyb+4lP+5HCPAJRw/KDls2ZO9kksdlwYSz2uQC8=";
    };

    nativeBuildInputs = [
      just
      catppuccin-whiskers
    ];

    postPatch = ''
      substituteInPlace justfile \
        --replace-fail '#!/usr/bin/env bash' '#!${lib.getExe bash}'
    '';

    buildPhase = ''
      runHook preBuild

      just build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r themes "$out"

      runHook postInstall
    '';
  };

  srcThemeDir = "themes/catppuccin-${flavor}-${accent}";

  configPath = "theme.conf";
  configOverrides =
    let
      legacyConfig = lib.filterAttrs (_: value: value != null) {
        Font = font;
        FontSize = fontSize;
        Background = background;
        CustomBackground = lib.mapNullable (disable: !disable) disableBackground;
        LoginBackground = loginBackground;
        UserIcon = userIcon;
        ClockEnabled = clockEnabled;
      };
    in
    lib.warnIf (legacyConfig != { })
      "catppuccin-sddm: `font`, `fontSize`, `background`, `disableBackground`, `loginBackground`, `userIcon` and `clockEnabled` are deprecated, use `catppuccin-sddm.withConfig { ... }` instead"
      legacyConfig;

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gipphe ];
    platforms = lib.platforms.linux;
  };
})
