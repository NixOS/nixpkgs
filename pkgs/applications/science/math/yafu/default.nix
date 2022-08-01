{ lib
, stdenv
, fetchFromGitHub
, gmp
, zlib
, ecm
, msieve
, ysieve
, ytools
}:

stdenv.mkDerivation rec {
  pname = "yafu";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "bbuhrow";
    repo = pname;
    rev = "c240bc757ab4613f1fadaec4e9c036bed5cdee0e";
    sha256 = "RaqCXbTtz+3yE9DujcHGMa5z1K+W7QMMe0pv4iYsO5g=";
  };

  postPatch = ''
    # Replace hardcoded GMP linker flag
    substituteInPlace Makefile --replace "/users/buhrow/src/c/gmp_install/gmp-6.2.0/lib/libgmp.a" "-lgmp"
  '';

  buildInputs = [
    ytools
    ysieve
    gmp
    zlib
    ecm
    msieve
  ];

  makeFlags = [
    "NFS=1"
    "yafu"
  ];

  NIX_LDFLAGS = "-lz";

  installPhase = ''
    runHook preInstall

    install -Dm755 yafu $out/bin/yafu
    install -D yafu.ini $out/share/yafu/yafu.ini

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/bbuhrow/yafu";
    description = "Automated integer factorization";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
