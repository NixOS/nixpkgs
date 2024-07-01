{ lib
, fetchFromGitHub
, nix-update-script
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hclust2";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SegataLab";
    repo = "hclust2";
    rev = "refs/tags/${version}";
    hash = "sha256-xdS36Sfxg4bz5ztRbCdD3uq4Dx50E8n501ScMArjwso=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    numpy
    scipy
    pandas
    matplotlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/SegataLab/hclust2/releases/tag/${version}";
    description = "Tool for plotting heat-maps with several useful options to produce high quality figures that can be used in publication";
    downloadPage = "https://pypi.org/project/hclust2/#files";
    homepage = "https://github.com/SegataLab/hclust2";
    license = licenses.mit;
    mainProgram = "hclust2.py";
    maintainers = with maintainers; [ pandapip1 ];
    inherit (python3.meta) platforms;
  };
}
