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
  version = "2018-06-26"; # not 1.0.1 because of new flask syntax

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sagenb";
    rev = "b360a0172e15501fb0163d02dce713a561fee2af";
    sha256 = "12anydw0v9w23rbc0a94bqmjhjdir9h820c5zdhipw9ccdcc2jlf";
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
    # work with latest flask-babel
    (fetchpatch {
      url = "https://github.com/sagemath/sagenb/commit/ba065eca63dd34a383e4c7ba7561430a90fcd087.patch";
      sha256 = "1lamzsrgymdd618imrasjp6ivhw2aynh83gkybsd7pm1rzjcq4x8";
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
