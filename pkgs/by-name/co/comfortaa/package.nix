{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "comfortaa";
  version = "unstable-2021-07-29";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "comfortaa";
    rev = "2a87ac6f6ea3495150bfa00d0c0fb53dd0a2f11b";
    postFetch = ''
      # Remove the OTF fonts as they are not needed and cause a hash mismatch
      rm -rf $out/fonts/{OTF,otf}
      # Remove old fonts
      rm -rf $out/old
    '';
    hash = "sha256-2f85w1LILpkGdleNMqbmnwtp1EV76P+kazyhCzcXWfo=";
  };

  dontBuild = true;

  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/comfortaa
    cp FONTLOG.txt README.md $out/share/doc/comfortaa

    runHook postInstall
  '';

  meta = {
    homepage = "http://aajohan.deviantart.com/art/Comfortaa-font-105395949";
    description = "Clean and modern font suitable for headings and logos";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
}
