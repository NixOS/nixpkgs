{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "copyright-update";
  version = "2016.1018";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "jaalto";
    repo = "project--copyright-update";
    rev = "release/${version}";
    sha256 = "1kj6jlgyxrgvrpv7fcgbibfqqa83xljp17v6sas42dlb105h6sgd";
  };

  buildInputs = [ perl ];

  installFlags = [
    "INSTALL=install"
    "prefix=$(out)"
  ];

  meta = with lib; {
    homepage = "https://github.com/jaalto/project--copyright-update";
    description = "Updates the copyright information in a set of files";
    mainProgram = "copyright-update";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
