{ lib, stdenvNoCC, fetchurl, unzip, }:

stdenvNoCC.mkDerivation rec {
  pname = "sarasa-term-sc-nerd";
  version = "v1.1.0";

  src = fetchurl {
    url = "https://github.com/laishulu/Sarasa-Term-SC-Nerd/releases/download/${version}/sarasa-term-sc-nerd.ttf.tar.gz";
    hash = "sha256-ADS5KTYQMTELd8MjAE+ugEwC5Gr8qDpN5kPirvgogAc=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Font based on Sarasa Term SC font.";
    longDescription = "Sarasa Term SC Nerd font is based on Sarasa Term SC font. Nerd fonts
    patch program is modified, Nerd fonts is merged into Sarasa Term SC by this program,
    and then some post-processing is done to form the final font.

    This font is especially suitable for Simplified Chinese users to use in terminal or code editor.";
    homepage = "https://github.com/laishulu/Sarasa-Term-SC-Nerd";
    license = licenses.ofl;
    maintainers = with maintainers; [ mkenkel ];
    platforms = platforms.all;
  };
}

