{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  cmake,
  gmp,
  libidn2,
  libunistring,
  mbedtls,
  ncurses,
  nettle,
  readline,
  xxd,
  iproute2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pihole-ftl";
  version = "6.2.3";

  src = fetchFromGitHub {
    owner = "pi-hole";
    repo = "FTL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d1kpkBKuc30oIT1dRac8gkzh36Yyg80cizNRbyZ4424=";
  };

  patches = [
    # https://github.com/pi-hole/FTL/pull/2610: Fix authentication redirect when webhome is /
    ./disable-redirect-root.patch
  ];

  nativeBuildInputs = [
    cmake
    xxd
  ];

  buildInputs = [
    gmp
    libidn2
    libunistring
    mbedtls
    ncurses
    nettle
    readline
  ];

  cmakeFlags = [
    (lib.cmakeBool "STATIC" stdenv.hostPlatform.isStatic)
  ];

  postPatch = ''
    substituteInPlace src/version.c.in \
      --replace-quiet "@GIT_VERSION@" "v${finalAttrs.version}" \
      --replace-quiet "@GIT_DATE@" "1970-01-01" \
      --replace-quiet "@GIT_BRANCH@" "master" \
      --replace-quiet "@GIT_TAG@" "v${finalAttrs.version}" \
      --replace-quiet "@GIT_HASH@" "builtfromreleasetarball"

    # Remove hard-coded absolute path to the pihole script, rely on it being provided by $PATH
    # Use execvp instead of execv so PATH is followed
    substituteInPlace src/api/action.c \
      --replace-fail "/usr/local/bin/pihole" "pihole" \
      --replace-fail "execv" "execvp"

    substituteInPlace src/database/network-table.c \
      --replace-fail "ip neigh show" "${lib.getExe' iproute2 "ip"} neigh show" \
      --replace-fail "ip address show" "${lib.getExe' iproute2 "ip"} address show"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 555 -t $out/bin pihole-FTL

    runHook postInstall
  '';

  passthru = {
    settingsTemplate = ./pihole.toml;

    tests = nixosTests.pihole-ftl;
  };

  meta = {
    description = "Pi-hole FTL engine";
    homepage = "https://github.com/pi-hole/FTL";
    changelog = "https://github.com/pi-hole/FTL/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ averyvigolo ];
    platforms = lib.platforms.linux;
    mainProgram = "pihole-FTL";
  };
})
