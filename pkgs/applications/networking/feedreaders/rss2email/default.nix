{ pythonPackages, fetchurl, lib, nixosTests }:

with pythonPackages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "rss2email";
  version = "3.9"; # TODO: on next bump, the manpage will be updated.
  # Update nixos/modules/services/mail/rss2email.nix to point to it instead of
  # to the online r2e.1

  propagatedBuildInputs = [ feedparser beautifulsoup4 html2text ];

  src = fetchurl {
    url = "mirror://pypi/r/rss2email/${name}.tar.gz";
    sha256 = "02wj9zhmc2ym8ba1i0z9pm1c622z2fj7fxwagnxbvpr1402ahmr5";
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
    cp AUTHORS COPYING CHANGELOG README $doc/share/doc/rss2email/
  '';

  # The tests currently fail, see
  # https://github.com/rss2email/rss2email/issues/14
  # postCheck = ''
  #   env PYTHONPATH=.:$PYTHONPATH python ./test/test.py
  # '';

  meta = with lib; {
    description = "A tool that converts RSS/Atom newsfeeds to email.";
    homepage = https://pypi.python.org/pypi/rss2email;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jb55 Profpatsch ];
  };
  passthru.tests = {
    smoke-test = nixosTests.rss2email;
  };
}
