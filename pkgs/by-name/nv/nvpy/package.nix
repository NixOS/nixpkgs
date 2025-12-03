{
  pkgs,
  fetchFromGitHub,
  python3Packages,
}:

let
  pythonPackages = python3Packages;
in
pythonPackages.buildPythonApplication rec {
  pname = "nvpy";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpbotha";
    repo = "nvpy";
    tag = "v${version}";
    sha256 = "sha256-guNdLu/bCk89o5M3gQU7J0W4h7eZdLHM0FG5IAPLE7c=";
  };

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
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

  pythonImportsCheck = [ "nvpy" ];

  meta = with pkgs.lib; {
    description = "Simplenote-syncing note-taking tool inspired by Notational Velocity";
    homepage = "https://github.com/cpbotha/nvpy";
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "nvpy";
  };
}
