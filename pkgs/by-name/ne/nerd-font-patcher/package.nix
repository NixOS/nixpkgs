{
  python3Packages,
  lib,
  fetchzip,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nerd-font-patcher";
  version = "3.4.0";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${finalAttrs.version}/FontPatcher.zip";
    sha256 = "sha256-koZj0Tn1HtvvSbQGTc3RbXQdUU4qJwgClOVq1RXW6aM=";
    stripRoot = false;
  };

  propagatedBuildInputs = with python3Packages; [ fontforge ];

  pyproject = false;

  patches = [
    ./use-nix-paths.patch
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share $out/lib
    install -Dm755 font-patcher $out/bin/nerd-font-patcher
    cp -ra src/glyphs $out/share/
    cp -ra bin/scripts/name_parser $out/lib/
  '';

  meta = {
    description = "Font patcher to generate Nerd font";
    mainProgram = "nerd-font-patcher";
    homepage = "https://nerdfonts.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ck3d ];
  };
})
