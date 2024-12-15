{
  python3Packages,
  lib,
  fetchzip,
}:

python3Packages.buildPythonApplication rec {
  pname = "nerd-font-patcher";
  version = "3.2.1";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FontPatcher.zip";
    sha256 = "sha256-3s0vcRiNA/pQrViYMwU2nnkLUNUcqXja/jTWO49x3BU=";
    stripRoot = false;
  };

  propagatedBuildInputs = with python3Packages; [ fontforge ];

  format = "other";

  postPatch = ''
    sed -i font-patcher \
      -e 's,__dir__ + "/src,"'$out'/share/,'
    sed -i font-patcher \
      -e  's,/bin/scripts/name_parser,/../lib/name_parser,'
  '';
  # Note: we cannot use $out for second substitution

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
