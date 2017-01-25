{ stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  name = "bean-add-2016-12-02";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "8038dabf5838c880c8e750c0e65cf0da4faf40b9";
    sha256 = "016ybq570xicj90x4kxrbxhzdvkjh0d6v3r6s3k3qfzz2c5vwh09";
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

