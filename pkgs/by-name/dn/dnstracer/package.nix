{
  lib,
  stdenv,
  fetchurl,
  darwin,
  perl,
}:

stdenv.mkDerivation rec {
  version = "1.10";
  pname = "dnstracer";

  src = fetchurl {
    url = "https://www.mavetju.org/download/${pname}-${version}.tar.bz2";
    sha256 = "089bmrjnmsga2n0r4xgw4bwbf41xdqsnmabjxhw8lngg2pns1kb4";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    perl # for pod2man
  ];

  setOutputFlags = false;

  installPhase = ''
    install -Dm755 -t $out/bin dnstracer
    install -Dm755 -t $man/share/man/man8 dnstracer.8
  '';

  buildInputs = [ ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.libresolv ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-lresolv";

  meta = with lib; {
    description = "Determines where a given Domain Name Server (DNS) gets its information from, and follows the chain of DNS servers back to the servers which know the data";
    homepage = "http://www.mavetju.org/unix/general.php";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "dnstracer";
  };
}
