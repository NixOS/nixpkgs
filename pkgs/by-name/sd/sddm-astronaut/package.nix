{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  kdePackages,
  formats,
  nix-update-script,
  themeConfig ? null,
  embeddedTheme ? "astronaut",
}:
let
  configFile = (formats.ini { }).generate "" { General = themeConfig; };
  basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
  sedString = "ConfigFile=Themes/";
in
stdenvNoCC.mkDerivation {
  pname = "sddm-astronaut";
  version = "0-unstable-2026-06-17";

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "cd46736b4135a71700d2225d60eb8e85917585eb";
    hash = "sha256-5ys3pP5GgkrIua/4II8KiQbWCwK8PZK6Sj3lCMe9q1c=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ installFonts ];

  propagatedBuildInputs = with kdePackages; [
    # avoid .dev outputs propagation
    qtsvg.out
    qtmultimedia.out
    qtvirtualkeyboard.out
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p ${basePath}
    cp -r $src/* ${basePath}
  ''
  + lib.optionalString (embeddedTheme != "astronaut") ''

    # Replaces astronaut.conf with embedded theme in metadata.desktop on line 9.
    # ConfigFile=Themes/astronaut.conf.
    sed -i "s|^${sedString}.*\\.conf$|${sedString}${embeddedTheme}.conf|" ${basePath}/metadata.desktop
  ''
  + lib.optionalString (themeConfig != null) ''
    chmod u+w ${basePath}/Themes/
    ln -sf ${configFile} ${basePath}/Themes/${embeddedTheme}.conf.user
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Modern looking qt6 sddm theme";
    homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      danid3v
      uxodb
      qweered
    ];
  };
}
