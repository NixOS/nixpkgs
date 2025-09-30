{
  lib,
  stdenv,
  fetchFromGitLab,
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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quick-sasl";
  version = "0.13.2";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "quick-sasl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kMKZRromm/hb9PZwvWAzmJorSqTB8xMIbWASfSjajiQ=";
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

  passthru.updateScript = nix-update-script { };

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
