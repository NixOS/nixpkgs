{ stdenv, python3Packages, fetchurl }:

with python3Packages;
buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "cheat";
  version = "2.2.1";

  propagatedBuildInputs = with python3Packages; [ docopt pygments ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w4k1h02p2gjv5wcr1c7r0ynb7v50qajx4hpyxz0ndh96f6x30pl";
  };
  # no tests available
  doCheck = false;

  meta = with stdenv.lib; {
    description = "cheat allows you to create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [gpl3 mit];
    homepage = https://github.com/chrisallenlane/cheat;
  };
}
