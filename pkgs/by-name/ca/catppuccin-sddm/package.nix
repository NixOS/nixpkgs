{ lib
, stdenvNoCC
, fetchFromGitHub
, libsForQt5
, flavors ? [ "latte" "frappe" "macchiato" "mocha" ]
}:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-sddm";
  version = "0-unstable-2023-12-05";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
    hash = "sha256-Jf4xfgJEzLM7WiVsERVkj5k80Fhh1edUl6zsSBbQi6Y=";
  };

  # From https://github.com/catppuccin/sddm/blob/95bfcba80a3b0cb5d9a6fad422a28f11a5064991/README.md
  # qtquickcontrols2 is already included with SDDM
  propagatedUserEnvPkgs = with libsForQt5; [ qtgraphicaleffects qtsvg ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes/"
    cp -r ${lib.concatMapStringsSep " " (flavor: "src/catppuccin-${flavor}") flavors} "$out/share/sddm/themes/"

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
  };
}
