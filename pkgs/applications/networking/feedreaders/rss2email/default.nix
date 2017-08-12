{ pythonPackages, fetchurl, lib }:

with pythonPackages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "rss2email";
  version = "3.9";

  propagatedBuildInputs = [ feedparser beautifulsoup4 html2text ];

  src = fetchurl {
    url = "mirror://pypi/r/rss2email/${name}.tar.gz";
    sha256 = "02wj9zhmc2ym8ba1i0z9pm1c622z2fj7fxwagnxbvpr1402ahmr5";
  };

  postInstall = ''
    install -Dm 644 r2e.1 $out/share/man/man1/r2e.1
    # an alias for better finding the manpage
    ln -s -T r2e.1 $out/share/man/man1/rss2email.1
  '';

  meta = with lib; {
    description = "A tool that converts RSS/Atom newsfeeds to email.";
    homepage = https://pypi.python.org/pypi/rss2email;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jb55 profpatsch ];
  };
}
