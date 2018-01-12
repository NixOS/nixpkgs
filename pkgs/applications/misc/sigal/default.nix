{ lib, buildPythonApplication, fetchurl, pythonPackages }:

buildPythonApplication rec {
  version = "1.0.1";
  name    = "sigal-${version}";

  src = fetchurl {
    url = "mirror://pypi/s/sigal/${name}.tar.gz";
    sha256 = "198g2r8bii6a0p44mlk1wg07jjv95xpfvnqhhxxziqpizc776b34";
  };

  buildInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = with pythonPackages; [
    jinja2
    markdown
    pillow
    pilkit
    clint
    click
    blinker
  ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    homepage    = http://sigal.saimon.org/en/latest/index.html;
    license     = licenses.mit;
    maintainers = with maintainers; [ domenkozar matthiasbeyer ];
  };
}

