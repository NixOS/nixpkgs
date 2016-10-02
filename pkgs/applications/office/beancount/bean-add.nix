{ stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  name = "bean-add-2016-10-01";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "ea0c21090a9af171e60f325a3a4de810a565aba7";
    sha256 = "11xx3p29z40xwc9m9ajn1lrkphyyi6kr9ww7f761lj3y8h7q5jcr";
  };

  propagatedBuildInputs = with python3Packages; [ python readline ];

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

