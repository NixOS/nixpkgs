{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.10.0";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "1gm5jyqqssf69lfx0svhzsb9m0dffm6zsf9jqnwh6gjihfz25a45";
  };

  propagatedBuildInputs = with pythonPackages; [
    tornado
    requests2
    six
    praw
    kitchen
    python.modules.curses
    praw
  ] ++ lib.optional (!pythonPackages.isPy3k) futures;

  meta = with lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds wedens ];
  };
}
