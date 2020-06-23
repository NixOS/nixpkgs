{ stdenv, fetchgit, buildPythonPackage
, python
, srht, asyncpg, aiosmtpd, pygit2, emailthreads }:

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.45.9";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    rev = version;
    sha256 = "2Wb1hBx4GuRvVC0pD7gpE9dj5ketW/4ozxuVq2X5dDM=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
    asyncpg
    aiosmtpd
    emailthreads
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
