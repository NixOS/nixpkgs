{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nxdomain";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "0va7nkbdjgzrf7fnbxkh1140pbc62wyj86rdrrh5wmg3phiziqkb";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ dnspython ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  postCheck = ''
    echo example.org > simple.list
    python -m nxdomain --format dnsmasq --out dnsmasq.conf --simple ./simple.list
    grep -q 'address=/example.org/' dnsmasq.conf
  '';

  meta = {
    homepage = "https://github.com/zopieux/nxdomain";
    description = "Domain (ad) block list creator";
    mainProgram = "nxdomain";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zopieux ];
  };
})
