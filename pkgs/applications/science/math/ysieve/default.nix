{ lib
, stdenv
, fetchFromGitHub
, ytools
, gmp
}:

stdenv.mkDerivation rec {
  pname = "ysieve";
  version = "unstable-2021-09-17";
  outputs = [ "out" "lib" "dev" ];

  src = fetchFromGitHub {
    owner = "bbuhrow";
    repo = pname;
    rev = "275fb23f05fd870f3b3afba00c8dbe63994b434f";
    sha256 = "k+j1Cs+TPnXCnYolgpMibFrXECjMLrmGm8AUGUooGpk=";
  };

  buildInputs = [
    ytools
    gmp
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin ysieve
    install -Dt $lib/lib libysieve.*
    install -Dt $dev/include *.h

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/bbuhrow/ysieve";
    description = "YAFU's sieve of Eratosthenes in library form with standalone executable";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
