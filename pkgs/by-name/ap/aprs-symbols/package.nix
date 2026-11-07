{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "aprs-symbols";
  version = "2024-unstable";

  src = fetchFromGitHub {
    owner = "hessu";
    repo = "aprs-symbols";
    rev = "f2286a9cd43eb6ba4501250b4c39fff111e3796c";
    sha256 = "sha256-ORjnFC8l0l+qL2xmZZwJBfpe4vgoExMpIKuGO+B5mwY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    mkdir -p $out/share/aprs-symbols
    cp README.md COPYRIGHT.md $out/share/aprs-symbols/
    cp -r png $out/share/aprs-symbols/
  '';

  meta = {
    description = "The aprs.fi high-resolution symbol set";
    longDescription = ''
      This is a new APRS symbol graphics set, which can be used by any APRS applications.
      It targets modern high-resolution displays, including Retina and 4K displays.
    '';
    homepage = "https://github.com/hessu/aprs-symbols";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mafo ];
  };
}
