{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.4.1";
  name = "haxor-news-${version}";

  src = fetchurl {
    url = "https://github.com/donnemartin/haxor-news/archive/${version}.tar.gz";
    sha256 = "0d3an7by33hjl8zg48y7ig6r258ghgbdkpp1psa9jr6n2nk2w9mr";
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
