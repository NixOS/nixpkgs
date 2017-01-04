{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.13.0";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0rxncbzb4a7zlfxmnn5jm6yvwviaaj0v220vwv82hkjiwcdjj8jf";
  };

  propagatedBuildInputs = with pythonPackages; [
    beautifulsoup4
    mailcap-fix
    tornado
    requests2
    six
    praw
    kitchen
    praw
  ] ++ lib.optional (!pythonPackages.isPy3k) futures;

  meta = with lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds wedens ];
  };
}
