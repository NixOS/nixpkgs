{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
  graphviz,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-big-picture";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "git-big-picture";
    repo = "git-big-picture";
    tag = "v${version}";
    hash = "sha256-aBwSw7smeRkkXSPY02Cs+jFI1wvgj1JisUny+R8G59E=";
  };

  build-system = with python3Packages; [ setuptools ];

  postFixup = ''
    wrapProgram $out/bin/git-big-picture \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          graphviz
        ]
      }
  '';

  meta = {
    description = "Tool for visualization of Git repositories";
    homepage = "https://github.com/git-big-picture/git-big-picture";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nthorne ];
    mainProgram = "git-big-picture";
  };
}
