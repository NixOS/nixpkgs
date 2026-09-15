{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  asciidoctor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtlsrpt";
  version = "0.5.1";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "sys4";
    repo = "libtlsrpt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U11VMaLGnWMe4EALaOQUFJ35hDUX2jAYadGJNYDpeK0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    asciidoctor
  ];

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
