{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.7.0";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "0fynymia3c2rynq9bm0jssd3rad7f7hhmjpkby7yj6g3jvk7jn4x";
  };

  propagatedBuildInputs = with pythonPackages; [
    tornado
    requests2
    six
    praw
    kitchen
    python.modules.curses
  ] ++ lib.optional (!pythonPackages.isPy3k) futures;

  meta = with lib; {
    homepage = https://github.com/michael-lazar/rtv;
    description = "Browse Reddit from your Terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
  };
}
