{ lib, fetchFromGitHub, python, glibcLocales }:

let
  py = python.override {
    packageOverrides = self: super: {
      # errbot requires markdown<3, and is not compatible with it either.
      markdown = super.markdown.overridePythonAttrs (oldAttrs: rec {
        version = "2.6.11";
        src = super.fetchPypi {
          pname = "Markdown";
          inherit version;
          sha256 = "108g80ryzykh8bj0i7jfp71510wrcixdi771lf2asyghgyf8cmm8";
        };
      });

      # errbot requires slackclient 1.x, see https://github.com/errbotio/errbot/pull/1367
      # latest 1.x release would be 1.3.2, but it requires an older websocket_client than the one in nixpkgs
      # so let's just vendor the known-working version until they've migrated to 2.x.
      slackclient = super.slackclient.overridePythonAttrs (oldAttrs: rec {
        version = "1.2.1";
        pname = "slackclient";
        src = fetchFromGitHub {
          owner  = "slackapi";
          repo   = "python-slackclient";
          rev    = version;
          sha256 = "073fwf6fm2sqdp5ms3vm1v3ljh0pldi69k048404rp6iy3cfwkp0";
        };

        propagatedBuildInputs = with self; [ websocket_client requests six ];

        checkInputs = with self; [ pytest codecov coverage mock pytestcov pytest-mock responses flake8 ];
        # test_server.py fails because it needs connection (I think);
        checkPhase = ''
          py.test --cov-report= --cov=slackclient tests --ignore=tests/test_server.py
        '';
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
    platforms = platforms.linux;
    # flaky on darwin, "RuntimeError: can't start new thread"
  };
}
