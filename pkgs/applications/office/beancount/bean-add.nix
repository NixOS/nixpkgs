{ stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  name = "bean-add-2017-09-13";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "035f07a9e48a9dd23b49a27ba9c070ee9ddc4cc7";
    sha256 = "0lj8940bn2h8541am4x0sfqpfk5xfnyfdnf3jpajfgx6wyjm2frg";
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

