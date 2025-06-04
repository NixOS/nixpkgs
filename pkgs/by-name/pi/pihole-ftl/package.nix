{
  lib,
  stdenv,
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
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pihole-ftl";
  version = "6.1";

  src = fetchFromGitHub {
    owner = "pi-hole";
    repo = "FTL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b3/kyDQa6qDK2avvDObWLvwUpAn6TFr1ZBdQC9AZWa4=";
  };

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
      --replace-fail "ip neigh show" "${iproute2}/bin/ip neigh show" \
      --replace-fail "ip address show" "${iproute2}/bin/ip address show"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 555 -t $out/bin pihole-FTL

    runHook postInstall
  '';

  passthru.settingsTemplate = ./pihole.toml;

  meta = {
    description = "Pi-hole FTL engine";
    homepage = "https://github.com/pi-hole/FTL";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ williamvds ];
    platforms = lib.platforms.linux;
    mainProgram = "pihole-FTL";
  };
})
