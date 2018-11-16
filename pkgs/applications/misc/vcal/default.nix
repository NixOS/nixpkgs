{ stdenv, lib, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "vcal-${version}";
  version = "2.8";

  src = fetchurl {
    url    = "https://waynemorrison.com/software/vcal";
    sha256 = "0jrm0jzqxb1xjp24hwbzlxsh22gjssay9gj4zszljzdm68r5afvc";
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
    pod2man --name=vcal --release=${version} ${src} > $out/share/man/man1/vcal.1

    runHook postInstall
  '';

  # There are no tests
  doCheck = false;

  meta = with lib; {
    description = "Parser for VCalendar and ICalendar files, usable from the command line";
    homepage = https://waynemorrison.com/software/;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
