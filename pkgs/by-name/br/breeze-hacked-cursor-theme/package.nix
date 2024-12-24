{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  inkscape,
  xcursorgen,
  accentColor ? null,
  baseColor ? null,
  borderColor ? null,
  logoColor ? null,
}:

stdenvNoCC.mkDerivation rec {
  pname = "breeze-hacked-cursor-theme";
  version = "unstable-2024-1-28";

  src = fetchFromGitHub {
    owner = "clayrisser";
    repo = pname;
    rev = "79dcc8925136ebe12612c6f124036c1aa816ebbe";
    hash = "sha256-gm50qgHdbjDYMz/ksbDD8tMqY9AqJ23DKl4rPFNEDX8=";
  };

  postPatch =
    ''
      patchShebangs build.sh recolor-cursor.sh
      substituteInPlace Makefile \
        --replace "~/.icons" "$out/share/icons"
      ./recolor-cursor.sh \
    ''
    + lib.optionalString (accentColor != null) ''
      --accent-color "${accentColor}" \
    ''
    + lib.optionalString (baseColor != null) ''
      --base-color "${baseColor}" \
    ''
    + lib.optionalString (borderColor != null) ''
      --border-color "${borderColor}" \
    ''
    + lib.optionalString (logoColor != null) ''
      --logo-color "${logoColor}"
    '';

  nativeBuildInputs = [
    inkscape
    xcursorgen
  ];

  meta = with lib; {
    homepage = "https://github.com/clayrisser/breeze-hacked-cursor-theme";
    description = "Breeze Hacked cursor theme";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ anomalocaris ];
    platforms = platforms.linux;
  };
}
