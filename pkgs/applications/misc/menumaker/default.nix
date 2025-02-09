{ lib, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "menumaker";
  version = "0.99.13";

  src = fetchurl {
    url = "mirror://sourceforge/menumaker/${pname}-${version}.tar.gz";
    sha256 = "sha256-JBXs5hnt1snbnB1hi7q7HBI7rNp0OoalLeIM0uJCdkE=";
  };

  format = "other";

  meta = with lib; {
    description = "Heuristics-driven menu generator for several window managers";
    homepage = "https://menumaker.sourceforge.net";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
