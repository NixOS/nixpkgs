{ pkgs, fetchFromGitHub, python3Packages }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  version = "2.2.0";
  pname = "nvpy";

  src = fetchFromGitHub {
    owner = "cpbotha";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-eWvD1k0wbzo0G46/LEOlHl1wLvc4JHLL1fg6wuCHiQY=";
  };


  propagatedBuildInputs = with pythonPackages; [
    markdown
    docutils
    simplenote
    tkinter
  ];

  # No tests
  doCheck = false;

  postInstall = ''
    install -dm755 "$out/share/licenses/nvpy/"
    install -m644 LICENSE.txt "$out/share/licenses/nvpy/LICENSE"

    install -dm755 "$out/share/doc/nvpy/"
    install -m644 README.rst "$out/share/doc/nvpy/README"
  '';

  meta = with pkgs.lib; {
    description = "A simplenote-syncing note-taking tool inspired by Notational Velocity";
    homepage = "https://github.com/cpbotha/nvpy";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
