{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtlsrpt";
  version = "0.5.0";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "sys4";
    repo = "libtlsrpt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h7bWxxllKFj8+/FfC4yHSmz+Qij1BcgV4OCQZr1OkA8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  separateDebugInfo = true;

  meta = {
    description = "Low-level C Library to implement TLSRPT into a MTA";
    homepage = "https://github.com/sys4/libtlsrpt";
    changelog = "https://github.com/sys4/libtlsrpt/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
})
