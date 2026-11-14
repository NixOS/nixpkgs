{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eschalot";
  version = "1.2.0.20191006";

  src = fetchFromGitHub {
    owner = "ReclaimYourPrivacy";
    repo = "eschalot";
    rev = "a45bad5b9a3e4939340ddd8a751ceffa3c0db76a";
    hash = "sha256-TwhYkFRYqU4LtdAPpAO8qYHz7K48MNNrtacswb4CcfE=";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    install -D -t $out/bin eschalot worgen
  '';

  meta = {
    description = "Tor hidden service name generator";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
