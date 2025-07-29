{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  cmake,
  pkg-config,
  glib,
  soapysdr,
  sdrplay,
  sdrplaySupport ? false,
  sqlite,
  zeromq,
  libacars,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dumpvdl2";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = "dumpvdl2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kb8FLVuG9tSZta8nmaKRCRZinF1yy4+NNxD5s7X82Wk=";
  };

  buildInputs = [
    glib
    soapysdr
    sqlite
    zeromq
    libacars
  ]
  ++ lib.optionals sdrplaySupport [ sdrplay ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/szpajder/dumpvdl2";
    description = "VDL Mode 2 message decoder and protocol analyzer";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.mafo ];
    mainProgram = "dumpvdl2";
  };
})
