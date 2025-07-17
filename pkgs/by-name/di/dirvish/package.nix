{
  fetchurl,
  lib,
  stdenv,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "dirvish";
  version = "1.2.1";

  src = fetchurl {
    url = "http://dirvish.org/dirvish${version}.tgz";
    sha256 = "6b7f29c3541448db3d317607bda3eb9bac9fb3c51f970611ffe27e9d63507dcd";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs =
    [ perl ]
    ++ (with perlPackages; [
      GetoptLong
      TimeParseDate
      TimePeriod
    ]);

  executables = [
    "dirvish"
    "dirvish-runall"
    "dirvish-expire"
    "dirvish-locate"
  ];
  manpages = [
    "dirvish.8"
    "dirvish-runall.8"
    "dirvish-expire.8"
    "dirvish-locate.8"
    "dirvish.conf.5"
  ];

  buildPhase = ''
    HEADER="#!${perl}/bin/perl

    \$CONFDIR = \"/etc/dirvish\";

    "

    for executable in $executables; do
      (
        echo "$HEADER"
        cat $executable.pl loadconfig.pl
      ) > $executable
      chmod +x $executable
    done
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp --target-directory=$out/bin $executables

    for manpage in $manpages; do
      if [[ $manpage =~ \.([[:digit:]]+)$ ]]; then
        section=''${BASH_REMATCH[1]}
        mkdir -p $out/man/man$section
        cp --target-directory=$out/man/man$section $manpage
      else
        echo "Couldn't determine man page section by filename"
        exit 1
      fi
    done
  '';

  postFixup = ''
    for executable in $executables; do
      wrapProgram $out/bin/$executable \
        --set PERL5LIB "$PERL5LIB"
    done
  '';

  meta = with lib; {
    description = "Fast, disk based, rotating network backup system";
    homepage = "http://dirvish.org/";
    license = lib.licenses.osl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.winpat ];
  };
}
