{
  python3Packages,
  lib,
  fetchzip,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nerd-font-patcher";
  version = "3.5.1";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${finalAttrs.version}/FontPatcher.zip";
    hash = "sha256-gZ41oZPnsVLcchA58eJ1Vl28ccqePpOZd/ZCEKYywX4=";
    stripRoot = false;
  };

  propagatedBuildInputs = with python3Packages; [ fontforge ];

  pyproject = false;

  patches = [
    ./use-nix-paths.patch
  ];
  postPatch = ''
    substituteInPlace font-patcher \
      --replace-fail "'glyphnames.json'" "'../share/glyphnames.json'"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share $out/lib
    install -Dm755 font-patcher $out/bin/nerd-font-patcher
    install -Dm644 glyphnames.json $out/share/glyphnames.json
    cp -ra src/glyphs $out/share/
    cp -ra bin/scripts/{braille,name_parser} $out/lib/
    runHook postInstall
  '';

  meta = {
    description = "Font patcher to generate Nerd font";
    mainProgram = "nerd-font-patcher";
    homepage = "https://nerdfonts.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ck3d ];
  };
})
