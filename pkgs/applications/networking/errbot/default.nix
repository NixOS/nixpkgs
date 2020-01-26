{ lib, fetchFromGitHub, python, glibcLocales }:

let
  # errbot requires markdown<3, and is not compatible with it either.
  py = python.override {
    packageOverrides = self: super: {
      markdown = super.markdown.overridePythonAttrs (oldAttrs: rec {
        version = "2.6.11";
        src = super.fetchPypi {
          pname = "Markdown";
          inherit version;
          sha256 = "108g80ryzykh8bj0i7jfp71510wrcixdi771lf2asyghgyf8cmm8";
        };
      });
    };
  };

in
py.pkgs.buildPythonApplication rec {
  pname = "errbot";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "errbotio";
    repo = "errbot";
    rev = version;
    sha256 = "1s4dl1za5imwsv6j3y7m47dy91hmqd5n221kkqm9ni4mpzgpffz0";
  };

  LC_ALL = "en_US.utf8";

  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = with py.pkgs; [
    webtest requests jinja2 flask dulwich
    pyopenssl colorlog markdown ansi pygments
    daemonize pygments-markdown-lexer telegram irc slackclient
    sleekxmpp pyasn1 pyasn1-modules hypchat
  ];

  checkInputs = with py.pkgs; [ mock pytest ];
  # avoid tests that do network calls
  checkPhase = ''
    pytest tests -k 'not backup and not broken_plugin and not plugin_cycle'
  '';

  meta = with lib; {
    description = "Chatbot designed to be simple to extend with plugins written in Python";
    homepage = http://errbot.io/;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
