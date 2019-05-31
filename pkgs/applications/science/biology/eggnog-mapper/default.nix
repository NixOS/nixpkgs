{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper, python27Packages, wget, diamond, hmmer }:

python27Packages.buildPythonApplication rec {
  pname = "eggnog-mapper";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "eggnogdb";
    repo = "eggnog-mapper";
    rev = "${version}";
    sha256 = "1aaaflppy84bhkh2hb5gnzm4xgrz0rz0cgfpadr9w8cva8p0sqdv";
  };

  patches = (fetchpatch {
    url = "https://github.com/eggnogdb/eggnog-mapper/commit/6972f601ade85b65090efca747d2302acb58507f.patch";
    sha256 = "0abnmn0bh11jihf5d3cggiild1ykawzv5f5fhb4cyyi8fvy4hcxf";
  });

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ python27Packages.biopython wget diamond hmmer ];

  # make emapper find diamond & hmmer
  makeWrapperArgs = [
    ''--prefix PATH ':' "${diamond}/bin"''
    ''--prefix PATH ':' "${hmmer}/bin"''
    ];

  # Tests rely on some of the databases being available, which is not bundled
  # with this package as (1) in total, they represent >100GB of data, and (2)
  # the user can download only those that interest them.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Fast genome-wide functional annotation through orthology assignment";
    license = licenses.gpl2;
    homepage = https://github.com/eggnogdb/eggnog-mapper/wiki;
    maintainers = with maintainers; [ luispedro ];
    platforms = platforms.all;
  };
}
