{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gperf,
  arpa2cm,
  quickder,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lillydap";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "lillydap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tu20jkz8UFa+oTuqZulDdmTeza3yH5U677lqY48J2Jo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gperf
  ];

  buildInputs = [
    arpa2cm
    quickder
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Little LDAP: Event-driven, lock-free kernel for dynamic data servers, clients, filters";
    homepage = "https://gitlab.com/arpa2/lillydap";
    changelog = "https://gitlab.com/arpa2/lillydap/-/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
  };
})
