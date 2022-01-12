{ pkgs, fetchFromGitHub, python3Packages }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  version = "2.1.0";
  pname = "nvpy";

  src = fetchFromGitHub {
    owner = "cpbotha";
    repo = pname;
    rev = "v${version}";
    sha256 = "02njvybd8yaqdnc5ghwrm8225z57gg4w7rhmx3w5jqzh16ld4mhh";
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
