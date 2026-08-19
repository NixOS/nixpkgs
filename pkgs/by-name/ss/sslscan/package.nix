{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sslscan";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    tag = finalAttrs.version;
    hash = "sha256-qrd0NJS7M3nKFpAOpd8raGLrMj6PixTqiuus25lv+PA=";
  };

  buildInputs = [
    (openssl.override { withZlib = true; })
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    mainProgram = "sslscan";
    homepage = "https://github.com/rbsec/sslscan";
    changelog = "https://github.com/rbsec/sslscan/blob/${finalAttrs.version}/Changelog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fpletz
    ];
  };
})
