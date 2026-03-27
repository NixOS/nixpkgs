{
  lib,
  python3,
  fetchFromGitHub,
  testers,
  pokete,
  faketty,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pokete";
  version = "0.9.1";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "lxgr-linux";
    repo = "pokete";
    tag = finalAttrs.version;
    sha256 = "sha256-T18908Einsgful8hYMVHl0cL4sIYFvhpy0MbLIcVhxs=";
  };

  pythonPath = with python3.pkgs; [
    scrap-engine
    pynput
  ];

  buildPhase = ''
    ${python3.interpreter} -O -m compileall .
  '';

  installPhase = ''
    mkdir -p $out/share/pokete
    cp -r assets pokete_classes pokete_data mods *.py $out/share/pokete/
    mkdir -p $out/bin
    ln -s $out/share/pokete/pokete.py $out/bin/pokete
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/share/pokete "''${pythonPath[*]}"
  '';

  passthru.tests = {
    pokete-version = testers.testVersion {
      package = pokete;
      command = "${faketty}/bin/faketty pokete --help";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Terminal based Pokemon like game";
    mainProgram = "pokete";
    homepage = "https://lxgr-linux.github.io/pokete";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
