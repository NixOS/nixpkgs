{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
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
  version = "0-unstable-2025-12-06";

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "d73842c761f7d7859f3bdd80e4360f09180fad41";
    hash = "sha256-+94WVxOWfVhIEiVNWwnNBRmN+d1kbZCIF10Gjorea9M=";
  };

  dontWrapQtApps = true;

  propagatedBuildInputs = with kdePackages; [
    # avoid .dev outputs propagation
    qtsvg.out
    qtmultimedia.out
    qtvirtualkeyboard.out
  ];

  installPhase = ''
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
