{
  lib,
  mopidy,
  python3Packages,
  fetchPypi,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Local";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18w39mxpv8p17whd6zfw5653d21q138f8xd6ili6ks2g2dbm25i9";
  };

  patches = [
    # Fix tests with newer Mopidy versions >=3.4.0 -- mopidy/mopidy-local#69
    (fetchpatch {
      name = "update-tests-for-mopidy-3.4.0.patch";
      url = "https://github.com/mopidy/mopidy-local/commit/f2c198f8eb253f62100afc58f652e73a76d5a090.patch";
      hash = "sha256-jrlZc/pd00S5q9nOfV1OXu+uP/SvH+Xbi7U52aZajj4=";
    })
  ];

  propagatedBuildInputs = [
    mopidy
    python3Packages.uritools
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
