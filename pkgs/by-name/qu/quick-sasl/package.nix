{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  pkg-config,
  cmake,
  arpa2cm,
  arpa2common,
  quickmem,
  cyrus_sasl,
  quickder,
  libkrb5,
  libev,
  e2fsprogs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quick-sasl";
  version = "0.14.0";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "quick-sasl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RVk44Ioaennw088HFxdAMU744aqw3ii8v8cJqjlVmno=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    libkrb5
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    quickmem
    cyrus_sasl
    quickder
    libev
    e2fsprogs
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Gentle wrapper around any SASL implementation";
    homepage = "https://gitlab.com/arpa2/Quick-SASL";
    changelog = "https://gitlab.com/arpa2/Quick-SASL/-/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "qsasl-server";
  };
})
