{
  stdenv,
  fetchzip,
  openssl,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hashpump";
  version = "1.2.0";

  # Github repository got removed
  src = fetchzip {
    url = "https://web.archive.org/web/20201018005212/https://github.com/bwall/HashPump/archive/v1.20.tar.gz";
    hash = "sha256-xL/1os17agwFtdq0snS3ZJzwJhk22ujxfWLH65IMMEM=";
  };

  makeFlags = [ "INSTALLLOCATION=${placeholder "out"}/bin/" ];

  buildInputs = [ openssl ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./hashpump --test
    runHook postCheck
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Tool to exploit the hash length extension attack in various hashing algorithms";
    homepage = "https://github.com/bwall/HashPump";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.linux;
    mainProgram = "hashpump";
  };
})
