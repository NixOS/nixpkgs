{
    lib,
    stdenvNoCC,
    fetchurl,
}:

stdenvNoCC.mkDerivation {
    pname = "bibata-modern-catppuccin-mocha-blue";
    version = "unstable-2026-08-10";

    src = fetchurl {
      url =
      "https://github.com/dimunyx/Bibata-Modern-Catppuccin-Mocha-Blue/raw/refs/heads/main/pkgs/Bibata-Modern-Catppuccin-Mocha-Blue.tar.xz";
      hash = "sha256-gNdBFXAaaeRKIgYM8Nwl8X+Wupa3CLHeJ49A35/Ams8=";
    };

    installPhase = ''
      install -dm 0755 "$out/share/icons"
      tar -xJf "$src" -C "$out/share/icons"
    '';

    meta = {
      description = "Bibata Modern Catppuccin Mocha Blue cursor theme";
      homepage = "https://github.com/dimunyx/Bibata-Modern-Catppuccin-Mocha-Blue";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      maintainers = [ ];
    };
}
