{
  python3Packages,
  lib,
  fetchzip,
}:

python3Packages.buildPythonApplication rec {
  pname = "nerd-font-patcher";
  version = "3.4.0";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FontPatcher.zip";
    sha256 = "sha256-koZj0Tn1HtvvSbQGTc3RbXQdUU4qJwgClOVq1RXW6aM=";
    stripRoot = false;
  };

  propagatedBuildInputs = with python3Packages; [ fontforge ];

  format = "other";

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

  meta = with lib; {
    description = "Font patcher to generate Nerd font";
    mainProgram = "nerd-font-patcher";
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ ck3d ];
  };
}
