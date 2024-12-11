{
  lib,
  python3,
  fetchFromGitHub,
  testers,
  pokete,
  faketty,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pokete";
  version = "0.9.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "lxgr-linux";
    repo = "pokete";
    rev = "refs/tags/${version}";
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
    wrapPythonProgramsIn $out/share/pokete "$pythonPath"
  '';

  passthru.tests = {
    pokete-version = testers.testVersion {
      package = pokete;
      command = "${faketty}/bin/faketty pokete --help";
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Terminal based Pokemon like game";
    mainProgram = "pokete";
    homepage = "https://lxgr-linux.github.io/pokete";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
