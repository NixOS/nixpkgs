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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "fricas";
    repo = "fricas";
    tag = finalAttrs.version;
    hash = "sha256-v4/zVgrwQZ4fnuLXDip164UKsLDzN99KfP2R0URumyE=";
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
