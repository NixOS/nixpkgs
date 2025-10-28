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
  gitUpdater,
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

  patches = [
    # https://gitlab.com/arpa2/steamworks/-/merge_requests/13
    ./1001-Add-missing-logger-methods.patch
  ];

  postPatch = ''
    # src/common/logger.h:254:63: error: 'uint8_t' does not name a type
    # https://gitlab.com/arpa2/steamworks/-/merge_requests/11
    sed -i "40i #include <cstdint>" src/common/logger.h

    # ld: cannot find -lLog4cpp: No such file or directory
    # https://gitlab.com/arpa2/steamworks/-/merge_requests/12
    substituteInPlace src/common/CMakeLists.txt \
      --replace-fail 'Catch2::Catch2 Log4cpp' 'Catch2::Catch2 Log4cpp::Log4cpp'
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

  checkInputs = [
    catch2
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

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
