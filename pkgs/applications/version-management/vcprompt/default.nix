{
  lib,
  stdenv,
  fetchhg,
  autoconf,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "vcprompt";
  version = "1.2.1";

  src = fetchhg {
    url = "http://hg.gerg.ca/vcprompt/";
    rev = version;
    sha256 = "03xqvp6bfl98bpacrw4n82qv9cw6a4fxci802s3vrygas989v1kj";
  };

  buildInputs = [
    sqlite
    autoconf
  ];

  preConfigure = ''
    autoconf
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = ''
      A little C program that prints a short string with barebones information
      about the current working directory for various version control systems
    '';
    homepage = "http://hg.gerg.ca/vcprompt";
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.gpl2Plus;
    mainProgram = "vcprompt";
  };
}
