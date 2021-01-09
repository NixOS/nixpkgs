{ stdenv, fetchgit, buildPythonPackage
, python
, srht, asyncpg, aiosmtpd, pygit2, emailthreads }:

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.45.15";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    rev = version;
    sha256 = "0f3yl5nf385j7mhcrmda7zk58i1y6fm00i479js90xxhjifmqkq6";
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

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
