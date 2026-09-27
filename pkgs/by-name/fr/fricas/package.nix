{
  lib,
  stdenv,
  fetchFromGitHub,
  sbcl,
  libx11,
  libxpm,
  libice,
  libsm,
  libxt,
  libxau,
  libxdmcp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fricas";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "fricas";
    repo = "fricas";
    tag = finalAttrs.version;
    hash = "sha256-vpClJwB91pCgc6DWy0I2XTfSWkt+7nEAkUK9zz4qh4A=";
  };

  buildInputs = [
    sbcl
    libx11
    libxpm
    libice
    libsm
    libxt
    libxau
    libxdmcp
  ];

  dontStrip = true;

  meta = {
    homepage = "https://fricas.github.io";
    description = "Advanced computer algebra system";
    changelog = "https://github.com/fricas/fricas/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "fricas";
  };
})
