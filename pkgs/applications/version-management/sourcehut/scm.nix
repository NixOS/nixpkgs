{ stdenv, fetchgit, buildPythonPackage
, srht, redis, pyyaml, buildsrht
, writeText }:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.19.11";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/scm.sr.ht";
    rev = version;
    sha256 = "a0JIZcO/3op409t+jq4/fImuppuGqfGxBPgBh67DGHM=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    pyyaml
    buildsrht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Shared support code for sr.ht source control services.";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
