{ pkgs, fetchurl, tk, buildPythonApplication, pythonPackages }:

buildPythonApplication rec {
  version = "0.9.2";
  name = "nvpy-${version}";

  src = fetchurl {
    url = "https://github.com/cpbotha/nvpy/archive/v${version}.tar.gz";
    sha256 = "78e41b80fc5549cba8cfd92b52d6530e8dfc8e8f37e96e4b219f30c266af811d";
  };

  buildInputs = [tk];

  propagatedBuildInputs = [
    pythonPackages.markdown
    pythonPackages.tkinter
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
