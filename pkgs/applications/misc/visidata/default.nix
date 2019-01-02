{ buildPythonApplication, lib, fetchFromGitHub
, dateutil, pyyaml, openpyxl, xlrd, h5py, fonttools, lxml, pandas, pyshp
}:
buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "visidata";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "1pflv7nnv9nyfhynrdbh5pgvjxzj53hgqd972dis9rwwwkla26ng";
  };

  propagatedBuildInputs = [dateutil pyyaml openpyxl xlrd h5py fonttools
    lxml pandas pyshp ];

  doCheck = false;

  meta = {
    inherit version;
    description = "Interactive terminal multitool for tabular data";
    license = lib.licenses.gpl3 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "http://visidata.org/";
  };
}
