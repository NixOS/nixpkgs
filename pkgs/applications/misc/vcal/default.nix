{ stdenv, lib, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "vcal-${version}";
  version = "2.7";

  src = fetchurl {
    url    = "http://waynemorrison.com/software/vcal";
    sha256 = "0fknrlad7vb84ngh242xjaq96vkids85ksnxaflk2cr9wcwxfmix";
  };

  nativeBuildInputs = [ perl ]; # for pod2man

  unpackPhase = ":";
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/man/man1}
    substitute ${src} $out/bin/vcal \
      --replace /usr/bin/perl ${perl}/bin/perl
    chmod 0755 $out/bin/*
    pod2man -n vcal ${src} > $out/share/man/man1/vcal.1

    runHook postInstall
  '';

  # There are no tests
  doCheck = false;

  meta = with lib; {
    description = "Parser for VCalendar and ICalendar files, usable from the command line";
    homepage = http://waynemorrison.com/software/;
    license = licenses.unfree; # "These are made publicly available for personal use."
    maintainers = with maintainers; [ peterhoeg ];
  };
}
