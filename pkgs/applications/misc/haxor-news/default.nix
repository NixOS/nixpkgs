{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.4.2";
  name = "haxor-news-${version}";

  src = fetchurl {
    url = "https://github.com/donnemartin/haxor-news/archive/${version}.tar.gz";
    sha256 = "0543k5ys044f2a1q8k36djnnq2h2dffnwbkva9snjjy30nlwwdgs";
  };

  propagatedBuildInputs = with pythonPackages; [
    click
    colorama
    requests
    pygments
    prompt_toolkit
    six
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/donnemartin/haxor-news;
    description = "Browse Hacker News like a haxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };

}
