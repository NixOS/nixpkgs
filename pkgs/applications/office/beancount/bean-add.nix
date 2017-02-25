{ stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  name = "bean-add-2017-01-20";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "752674259fb9512e076ef2048927fb791ad21507";
    sha256 = "1ja26dgl2j25873s5nav57pjaqb9rr3mdbmkawajz2gdkk9r7n61";
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

