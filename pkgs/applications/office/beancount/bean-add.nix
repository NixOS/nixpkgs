{ stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  name = "bean-add-2016-10-03";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "41deacc09b992db5eede34fefbfb2c0faeba1652";
    sha256 = "09xdsskk5rc3xsf1v1vq7nkdxrxy8w2fixx2vdv8c97ak6a4hrca";
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

