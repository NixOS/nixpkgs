{
  lib,
  stdenv,
  fetchFromGitLab,
  bison,
  cmake,
  flex,
  arpa2cm,
  arpa2common,
  catch2,
  log4cpp,
  openldap,
  sqlite,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "steamworks";
  version = "0.97.2";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "steamworks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hD1nTyv/t7MQdopqivfSE0o4Qk1ymG8zQVg56lY+t9o=";
  };

  # src/common/logger.h:254:63: error: 'uint8_t' does not name a type
  postPatch = ''
    sed -i "38i #include <cstdint>" src/common/logger.h
  '';

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    flex
    log4cpp
    openldap
    sqlite
  ];

  # Currently doesn't build in `Release` since a macro is messing with some code
  # when building in `Release`.
  cmakeBuildType = "Debug";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configuration information distributed over LDAP in near realtime";
    homepage = "https://gitlab.com/arpa2/steamworks";
    changelog = "https://gitlab.com/arpa2/steamworks/-/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.ethancedwards8 ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.linux;
  };
})
