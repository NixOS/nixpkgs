{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, hglib
, scmsrht
, unidiff
, python
, unzip
, mercurial
, tinycss2
}:

buildPythonPackage rec {
  pname = "hgsrht";
  version = "0.32.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hg.sr.ht";
    rev = version;
    sha256 = "BJi5mXOWhr7ZhQ6fQql96XFo07cDvadzP+YkcGHJbik=";
    vc = "hg";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api hgsrht-keys" ""
  '';

  hgsrht-api = buildGoModule ({
    inherit src version;
    pname = "hgsrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-vuOYpnF3WjA6kOe9MVSuVMhJBQqCmIex+QUBJrP+VDs=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  hgsrht-keys = buildGoModule {
    inherit src version;
    # the patch updates goredis-6 to goredis-8 and then all dependencies
    # (go get -u) This is neccessary to allow use of redis connections over unix
    # sockets.
    #
    # This patch can probably be dropped at the next update, the almost
    # identical gitsrht-keys software already uses goredis-8.
    patches = [ ./patches/hgsrht-keys/0001-update.patch ];
    pname = "hgsrht-keys";
    modRoot = "hgsrht-keys";
    vendorSha256 = "sha256-Py+BMA/BW1W043DZHE+IMImy+AKIN6hAbL8KGAeVc0M=";
  };

  propagatedBuildInputs = [
    srht
    hglib
    scmsrht
    unidiff
    mercurial
    tinycss2
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share/sql
    cp schema.sql $out/share/sql/hg-schema.sql
    ln -s ${hgsrht-api}/bin/api $out/bin/hgsrht-api
    ln -s ${hgsrht-keys}/bin/hgsrht-keys $out/bin/hgsrht-keys
  '';

  pythonImportsCheck = [ "hgsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hg.sr.ht";
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
