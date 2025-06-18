{
  fetchurl,
  lib,
  stdenv,
  perl,
  perlPackages,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "namazu";
  version = "2.0.21";

  src = fetchurl {
    url = "http://namazu.org/stable/${pname}-${version}.tar.gz";
    sha256 = "1xvi7hrprdchdpzhg3fvk4yifaakzgydza5c0m50h1yvg6vay62w";
  };

  buildInputs = [
    perl
    perlPackages.FileMMagic
  ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mknmz --set PERL5LIB ${
      perlPackages.makeFullPerlPath [ perlPackages.FileMMagic ]
    }
  '';

  meta = {
    description = "Full-text search engine";

    longDescription = ''
      Namazu is a full-text search engine intended for easy use.  Not
      only does it work as a small or medium scale Web search engine,
      but also as a personal search system for email or other files.
    '';

    license = lib.licenses.gpl2Plus;
    homepage = "http://namazu.org/";

    platforms = lib.platforms.gnu ++ lib.platforms.linux; # arbitrary choice
    maintainers = [ ];
  };
}
