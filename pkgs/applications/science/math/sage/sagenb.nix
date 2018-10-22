{ stdenv
, fetchpatch
, python
, buildPythonPackage
, fetchFromGitHub
, mathjax
, twisted
, flask
, flask-oldsessions
, flask-openid
, flask-autoindex
, flask-babel
}:

# Has a cyclic dependency with sage (not expressed here) and is not useful outside of sage.
# Deprecated, hopefully soon to be removed. See
# https://trac.sagemath.org/ticket/25837

buildPythonPackage rec {
  pname = "sagenb";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sagenb";
    rev = version;
    sha256 = "1a0zk1i6c8j3blhqnk1rk91sb99mvshv7pnklyj2g6sxpbdhllhg";
  };

  propagatedBuildInputs = [
    twisted
    flask
    flask-oldsessions
    flask-openid
    flask-autoindex
    flask-babel
  ];

  # tests depend on sage
  doCheck = false;

  patches = [
    # https://github.com/sagemath/sagenb/pull/461
    (fetchpatch {
      name = "sphinx-1.8.1.patch";
      url = "https://github.com/sagemath/sagenb/pull/461/commits/3f458f8260a3624927b6519f1e35576d72a4beec.patch";
      sha256 = "1s19dk35i0yvxb49d6l76xq861sivn9gqj0r1jb2gyah60n62inr";
    })
  ];

  meta = with stdenv.lib; {
    description = "Sage Notebook";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ timokau ];
  };

  # let sagenb use mathjax
  postInstall = ''
    mkdir -p "$out/${python.sitePackages}/sagenb/data"
    ln -s ${mathjax}/lib/node_modules/mathjax "$out/${python.sitePackages}/sagenb/data/mathjax"
  '';
}
