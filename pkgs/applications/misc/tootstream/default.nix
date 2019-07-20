{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname   = "tootstream";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner  = "magicalraccoon";
    repo   = "tootstream";
    rev    = "${version}";
    sha256 = "00ajry7ac9a8x661bkk1hgp6afaqxc1x34w0wbad40bprdvdzhl3";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    mastodonpy
    colored
    humanize
    emoji
  ];

  meta = with stdenv.lib; {
    description = "A commandline interface for interacting with Mastodon instances";
    homepage    = "https://github.com/magicalraccoon/tootstream";
    license     = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}
