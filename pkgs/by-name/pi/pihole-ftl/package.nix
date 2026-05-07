{
  cmake,
  fetchFromGitHub,
  gmp,
  lib,
  libidn2,
  libunistring,
  mbedtls,
  ncurses,
  nettle,
  nix-update-script,
  nixosTests,
  readline,
  stdenv,
  versionCheckHook,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pihole-ftl";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "pi-hole";
    repo = "FTL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OpbBd+HS/gwcWNe/6VB3glout1sifJ8o5EnKuXfyZ/o=";
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
      --replace-fail "@GIT_VERSION@" "v${finalAttrs.version}" \
      --replace-fail "@GIT_DATE@" "1970-01-01" \
      --replace-fail "@GIT_BRANCH@" "master" \
      --replace-fail "@GIT_TAG@" "v${finalAttrs.version}" \
      --replace-fail "@GIT_HASH@" "builtfromreleasetarball"

    # Remove hard-coded absolute path to the pihole script, rely on it
    # being provided by $PATH.  Use execvp instead of execv so PATH is
    # followed.
    substituteInPlace src/api/action.c \
      --replace-fail "/usr/local/bin/pihole" "pihole" \
      --replace-fail "execv" "execvp"
  '';

  installPhase = ''
    runHook preInstall

    install -D pihole-FTL $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  passthru = {
    settingsTemplate = ./pihole.toml;
    tests = nixosTests.pihole-ftl;
    updateScript = nix-update-script { };
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
