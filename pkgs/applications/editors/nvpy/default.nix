{ pkgs, fetchurl, tk, buildPythonApplication, pythonPackages }:

buildPythonApplication rec {
  version = "0.9.7";
  name = "nvpy-${version}";

  src = fetchurl {
    url = "https://github.com/cpbotha/nvpy/archive/v${version}.tar.gz";
    sha256 = "1rd3vlaqkg16iz6qcw6rkbq0jmyvc0843wa3brnvn1nz0kla243f";
  };

  buildInputs = [tk];

  propagatedBuildInputs = [
    pythonPackages.markdown
    pythonPackages.tkinter
    pythonPackages.docutils
  ];

  postInstall = ''
    install -dm755 "$out/share/licenses/nvpy/"
    install -m644 LICENSE.txt "$out/share/licenses/nvpy/LICENSE"

    install -dm755 "$out/share/doc/nvpy/"
    install -m644 README.rst "$out/share/doc/nvpy/README"

    wrapProgram $out/bin/nvpy --set TK_LIBRARY "${tk}/lib/${tk.libPrefix}"
  '';

  meta = with pkgs.lib; {
    description = "A simplenote-syncing note-taking tool inspired by Notational Velocity";
    homepage = "https://github.com/cpbotha/nvpy";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
