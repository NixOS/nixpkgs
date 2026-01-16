{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "exo-2";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "Exo-2.0";
    rev = "f83ea8a02d3e1d6963ab6e910038521f27e283a2";
    hash = "sha256-zQ9hb2NH4tPf/G/EQPqpY1oH5QrUyNkzMkEKB/QbOfE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype fonts/ttf/*.ttf
    install -Dm444 -t $out/share/fonts/variable fonts/variable/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Exo 2 is a complete redrawing of Exo";
    longDescription = ''
      Exo 2 is a complete redrawing of Exo, a contemporary
      geometric sans serif typeface that tries to convey a
      technological/futuristic feeling while keeping an
      elegant design. Exo is a very versatile font, so it
      has 9 weights (the maximum on the web) and each with
      a true italic version. Exo 2 has a more organic look
      that will perform much better at small text sizes and
      in long texts.
    '';
    homepage = "https://github.com/googlefonts/Exo-2.0";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
