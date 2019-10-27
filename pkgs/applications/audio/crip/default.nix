{ stdenv
, fetchurl
, makeWrapper

, perlPackages

, cdparanoia
, coreutils
, eject
, flac
, gnugrep
, nano
, sox
, vorbis-tools
, vorbisgain
, which
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "crip-3.9";
  src = fetchurl {
    url = "http://bach.dynet.com/crip/src/${name}.tar.gz";
    sha256 = "0pk9152wll6fmkj1pki3fz3ijlf06jyk32v31yarwvdkwrk7s9xz";
  };

  buildInputs = [ perlPackages.perl perlPackages.CDDB_get ];
  nativeBuildInputs = [ makeWrapper ];

  toolDeps = makeBinPath [
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

  scripts = [ "crip" "editcomment" "editfilenames" ];

  installPhase = ''
    mkdir -p $out/bin/

    for script in ${escapeShellArgs scripts}; do
      cp $script $out/bin/

      substituteInPlace $out/bin/$script \
        --replace '$editor = "vim";' '$editor = "${nano}/bin/nano";'

      wrapProgram $out/bin/$script \
        --set PERL5LIB "${perlPackages.makePerlPath [ perlPackages.CDDB_get ]}" \
        --set PATH "${toolDeps}"
    done
  '';

  meta = {
    homepage = http://bach.dynet.com/crip/;
    description = "Terminal-based ripper/encoder/tagger tool for creating Ogg Vorbis/FLAC files";
    license = stdenv.lib.licenses.gpl1;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ maintainers.endgame ];
  };
}
