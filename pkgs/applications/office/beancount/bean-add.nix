{ stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  name = "bean-add-2017-04-06";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "67c3cd345dc370f8cd967a31549c1d0b86b07024";
    sha256 = "0902lvwmf7k1h6gn3ilwzk20pxphbxsa3rn68jfhhfqpr6xpqf93";
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

