{ pythonPackages, fetchurl, lib, nixosTests }:

with pythonPackages;

buildPythonApplication rec {
  pname = "rss2email";
  version = "3.13.1";

  propagatedBuildInputs = [ feedparser html2text ];
  checkInputs = [ beautifulsoup4 ];

  src = fetchurl {
    url = "mirror://pypi/r/rss2email/${pname}-${version}.tar.gz";
    sha256 = "3994444766874bb35c9f886da76f3b24be1cb7bbaf40fad12b16f2af80ac1296";
  };

  outputs = [ "out" "man" "doc" ];

  postPatch = ''
    # sendmail executable is called from PATH instead of sbin by default
    sed -e 's|/usr/sbin/sendmail|sendmail|' \
        -i rss2email/config.py
  '';

  postInstall = ''
    install -Dm 644 r2e.1 $man/share/man/man1/r2e.1
    # an alias for better finding the manpage
    ln -s -T r2e.1 $man/share/man/man1/rss2email.1

    # copy documentation
    mkdir -p $doc/share/doc/rss2email
    cp AUTHORS COPYING CHANGELOG README.rst $doc/share/doc/rss2email/
  '';

  checkPhase = ''
    runHook preCheck
    env PATH=$out/bin:$PATH python ./test/test.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "A tool that converts RSS/Atom newsfeeds to email";
    homepage = "https://pypi.python.org/pypi/rss2email";
    license = licenses.gpl2;
    maintainers = with maintainers; [ Profpatsch ekleog ];
  };
  passthru.tests = {
    smoke-test = nixosTests.rss2email;
  };
}
