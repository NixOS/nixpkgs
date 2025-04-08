{
  lib,
  fetchzip,
  stdenvNoCC,
  perl,
}:

let
  perlWithPkgs = perl.withPackages (
    ps: with ps; [
      ConfigGeneral
      GD
      MathVecStat
      SetIntSpan
    ]
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "carpalx";
  version = "0.12";

  src = fetchzip {
    url = "https://mk.bcgsc.ca/carpalx/distribution/carpalx-${finalAttrs.version}.tgz";
    hash = "sha256-7OQUWr+kEqwNYtltut/KQvq8n4gH0hB2XpY6ZUg4icQ=";
  };

  buildInputs = [ perlWithPkgs ];

  outputs = [
    "bin"
    "corpus" # corpus of English-in-Latin-script documents
    "etc" # includes tutorials
    "out"
  ];

  postInstall = ''
    cp -Tr "$src" "$out"
    cp -Tr "$src/bin" "$bin"
    cp -Tr "$src/corpus" "$corpus"
    cp -Tr "$src/etc" "$etc"
  '';

  meta = {
    homepage = "https://mk.bcgsc.ca/carpalx/";
    mainProgram = "carpalx";
    license = lib.licenses.gpl2Plus;
    description = "Keyboard layout optimizer — save your carpals";
    longDescription = ''
      The carpalx project introduces a quantitative model for typing effort and
      applies it to (a) evaluate QWERTY and popular alternatives, such as
      Dvorak and Colemak and (b) find the keyboard layouts that minimize typing
      effort for a given set of input documents. In the work presented here,
      these documents are English text, but they can be anything, such as
      corpora in French, Spanish and even programming languages, like C or
      Python.

      While there are many alternate layouts, the Carpalx project proposes new
      layouts and a fully-baked parametric model of typing effort. Way!
    '';
    maintainers = with lib.maintainers; [ toastal ];
  };
})
