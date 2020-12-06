{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-somafm";
  version = "2.0.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-SomaFM";
    sha256 = "1j88rrliys8hqvnb35k1xqw88bvrllcb4rb53lgh82byhscsxlf3";
  };

  propagatedBuildInputs = [
    mopidy
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = "Mopidy extension for playing music from SomaFM";
    license = licenses.mit;
    maintainers = [ maintainers.nickhu ];
  };
}

