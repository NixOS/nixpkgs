{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,

  perlPackages,

  cdparanoia,
  coreutils,
  eject,
  flac,
  gnugrep,
  nano,
  sox,
  vorbis-tools,
  vorbisgain,
  which,
}:

stdenv.mkDerivation rec {
  pname = "crip";
  version = "3.9";
  src = fetchurl {
    url = "http://bach.dynet.com/${pname}/src/${pname}-${version}.tar.gz";
    sha256 = "0pk9152wll6fmkj1pki3fz3ijlf06jyk32v31yarwvdkwrk7s9xz";
  };

  buildInputs = [
    perlPackages.perl
    perlPackages.CDDB_get
  ];
  nativeBuildInputs = [ makeWrapper ];

  toolDeps = lib.makeBinPath [
    cdparanoia
    coreutils
    eject
    flac
    gnugrep
    sox
    vorbis-tools
    vorbisgain
    which
  ];

  scripts = [
    "crip"
    "editcomment"
    "editfilenames"
  ];

  installPhase = ''
    mkdir -p $out/bin/

    for script in ${lib.escapeShellArgs scripts}; do
      cp $script $out/bin/

      substituteInPlace $out/bin/$script \
        --replace-fail '$editor = "vim";' '$editor = "${nano}/bin/nano";'

      wrapProgram $out/bin/$script \
        --set PERL5LIB "${perlPackages.makePerlPath [ perlPackages.CDDB_get ]}" \
        --set PATH "${toolDeps}"
    done
  '';

  meta = {
    homepage = "http://bach.dynet.com/crip/";
    description = "Terminal-based ripper/encoder/tagger tool for creating Ogg Vorbis/FLAC files";
    license = lib.licenses.gpl1Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.endgame ];
  };
}
