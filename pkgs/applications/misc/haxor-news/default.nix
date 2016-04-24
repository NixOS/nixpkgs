{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.3.1";
  name = "haxor-news-${version}";

  src = fetchurl {
    url = "https://github.com/donnemartin/haxor-news/archive/0.3.1.tar.gz";
    sha256 = "0jglx8fy38sjyszvvg7mvmyk66l53kyq4i09hmgdz7hb1hrm9m2m";
  };

  propagatedBuildInputs = with pythonPackages; [
    click
    colorama
    requests2
    pygments
    prompt_toolkit_52
    six
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/donnemartin/haxor-news";
    description = "Browse Hacker News like a haxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };

}
