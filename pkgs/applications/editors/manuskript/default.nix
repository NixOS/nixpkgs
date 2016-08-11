{ stdenv, zlib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "manuskript";
  version = "0.3.0";

  src = fetchFromGitHub {
    repo = name;
    owner = "olivierkes";
    rev = version;
    sha256 = "0bqxc4a8kyi6xz1zs0dp85wxl9h4v8lzc6073bbcsn1zg4y59ys7";
  };

  propagatedBuildInputs = [
    python3Packages.pyqt5
    python3Packages.lxml
    zlib
  ];

  buildPhase = '''';

  installPhase = ''
    mkdir -p $out
    cp -av * $out/
  '';

  doCheck = false;

  meta = {
    description = "A open-source tool for writers";
    homepage = http://www.theologeek.ch/manuskript;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.steveej ];
    platforms = stdenv.lib.platforms.linux;
  };
}
