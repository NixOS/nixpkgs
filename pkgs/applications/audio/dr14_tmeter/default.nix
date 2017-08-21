{ stdenv, fetchFromGitHub, python3Packages, pkgs }:

python3Packages.buildPythonApplication rec {
  name = "dr14_tmeter-${version}";
  version = "1.0.16";

  disabled = !python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "simon-r";
    repo = "dr14_t.meter";
    rev = "v${version}";
    sha256 = "1nfsasi7kx0myxkahbd7rz8796mcf5nsadrsjjpx2kgaaw5nkv1m";
  };

  propagatedBuildInputs = with pkgs; [
    python3Packages.numpy flac vorbis-tools ffmpeg faad2 lame
  ];

  # There are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Compute the DR14 of a given audio file according to the procedure described by the Pleasurize Music Foundation";
    license = licenses.gpl3Plus;
    homepage = http://dr14tmeter.sourceforge.net/;
    maintainers = [ maintainers.adisbladis ];
  };
}
