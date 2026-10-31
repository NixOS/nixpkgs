{
  lib,
  stdenv,
  fetchurl,
  darwin,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.10";
  pname = "dnstracer";

  src = fetchurl {
    url = "https://www.mavetju.org/download/dnstracer-${finalAttrs.version}.tar.bz2";
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

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-lresolv";
  };

  meta = {
    description = "Determines where a given Domain Name Server (DNS) gets its information from, and follows the chain of DNS servers back to the servers which know the data";
    homepage = "http://www.mavetju.org/unix/general.php";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "dnstracer";
  };
})
