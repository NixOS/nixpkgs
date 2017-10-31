{ stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  name = "bean-add-2017-10-31";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "9ac64272a17e76f8292bd94deb5aee45c14130d2";
    sha256 = "1vcwbbi2jsf87yq8f2hyf7nz9br1973sb20qjnsx5fxlmcpn47jh";
  };

  propagatedBuildInputs = with python3Packages; [ python ];

  installPhase = ''
    mkdir -p $out/bin/
    cp bean-add $out/bin/bean-add
    chmod +x $out/bin/bean-add
  '';

  meta = {
    homepage = https://github.com/simon-v/bean-add/;
    description = "beancount transaction entry assistant";

    # The (only) source file states:
    #   License: "Do what you feel is right, but don't be a jerk" public license.

    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

