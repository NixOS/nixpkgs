{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.14.1";
  name = "rtv-${version}";

  src = fetchFromGitHub {
    owner = "michael-lazar";
    repo = "rtv";
    rev = "v${version}";
    sha256 = "03106sdsvj4zjjaqqg7qvm3n959plvy08a6n28ir1yf67kwzsx8a";
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
