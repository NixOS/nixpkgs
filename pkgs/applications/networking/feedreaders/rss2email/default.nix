{ pythonPackages, fetchurl, fetchpatch, lib, nixosTests }:

with pythonPackages;

buildPythonApplication rec {
  pname = "rss2email";
  version = "3.12.2";

  propagatedBuildInputs = [ feedparser html2text ];
  checkInputs = [ beautifulsoup4 ];

  src = fetchurl {
    url = "mirror://pypi/r/rss2email/${pname}-${version}.tar.gz";
    sha256 = "12w6x80wsw6xm17fxyymnl45aavsagg932zw621wcjz154vjghjr";
  };

  patches = [
    (fetchpatch {
      name = "rss2email-feedparser6.patch";
      url = "https://github.com/rss2email/rss2email/pull/149/commits/338343c92f956c31ff5249ef4bcf7aeea81f687e.patch";
      sha256 = "0h8b3g9332vdrkqbh6lp00k97asrhmlxi13zghrgc78ia13czy3z";
    })
    (fetchpatch {
      name = "rss2email-feedparser6-test.patch";
      url = "https://github.com/rss2email/rss2email/pull/149/commits/8c99651eced3f29f05ba2c0ca02abb8bb9a18967.patch";
      sha256 = "1scljak6xyqxlilg3j39v4qm9a9jks1bnvnrh62hyf3g53yw2xlg";
    })
  ];

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

  postCheck = ''
    env PATH=$out/bin:$PATH python ./test/test.py
  '';

  meta = with lib; {
    description = "A tool that converts RSS/Atom newsfeeds to email";
    homepage = "https://pypi.python.org/pypi/rss2email";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jb55 Profpatsch ekleog ];
  };
  passthru.tests = {
    smoke-test = nixosTests.rss2email;
  };
}
