{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  just,
  catppuccin-whiskers,
  kdePackages,
  flavor ? "mocha",
  accent ? "mauve",
  font ? "Noto Sans",
  fontSize ? "9",
  background ? null,
  loginBackground ? false,
}:
stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-sddm";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "v${version}";
    hash = "sha256-J2DkKptVjWFcA2R71Vv7e0DCZJKeIl5TwjbnzI1kYmw=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    just
    catppuccin-whiskers
  ];

  propagatedBuildInputs = [
    kdePackages.qtsvg
  ];

  preBuild = ''
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

    mkdir -p "$out/share/sddm/themes/"
    cp -r themes/catppuccin-${flavor}-${accent} "$out/share/sddm/themes/catppuccin-${flavor}-${accent}"

    configFile=$out/share/sddm/themes/catppuccin-${flavor}-${accent}/theme.conf

    substituteInPlace $configFile \
      --replace-fail 'Font="Noto Sans"' 'Font="${font}"' \
      --replace-fail 'FontSize=9' 'FontSize=${fontSize}'

    ${lib.optionalString (background != null) ''
      substituteInPlace $configFile \
        --replace-fail 'Background="backgrounds/wall.jpg"' 'Background="${background}"' \
        --replace-fail 'CustomBackground="false"' 'CustomBackground="true"'
    ''}

    ${lib.optionalString loginBackground ''
      substituteInPlace $configFile \
        --replace-fail 'LoginBackground="false"' 'LoginBackground="true"'
    ''}

    runHook postInstall
  '';

  postFixup = ''
    mkdir -p $out/nix-support
    echo ${kdePackages.qtsvg} >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ elysasrc ];
    platforms = lib.platforms.linux;
  };
}
