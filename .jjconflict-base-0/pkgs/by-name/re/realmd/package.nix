{
  autoreconfHook,
  fetchFromGitLab,
  glib,
  lib,
  libkrb5,
  nix-update-script,
  openldap,
  pkg-config,
  polkit,
  samba,
  stdenv,
  systemdLibs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "realmd";
  version = "0.17.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "realmd";
    repo = "realmd";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-lmNlrXOOUSDk/8H/ge0IRA64bnau9nYUIkW6OyVxbBg=";
  };

  patches = [
    # Remove unused tap driver/valgrind checks to make tests work
    ./remove-tap-driver.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    libkrb5
    openldap
    polkit
    samba
    systemdLibs
  ];

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-private-dir=${placeholder "out"}/lib/realmd"
    "--with-systemd-unit-dir=${placeholder "out"}/lib/systemd/system"

    # realmd doesn't fails without proper defaults and distro configuration files
    # These settings will be overriden by the NixOS module
    "--with-distro=redhat"

    # Documentation is disabled
    # We need to run gdbus-codegen & xmlto in **offline mode** to make it work
    # See https://github.com/NixOS/nixpkgs/pull/301631
    "--disable-doc"
  ];

  hardeningDisable = [
    # causes redefinition of _FORTIFY_SOURCE
    "fortify3"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://gitlab.freedesktop.org/realmd/realmd/-/blob/${finalAttrs.version}/NEWS";
    description = "DBus service for configuring Kerberos and other online identities";
    homepage = "https://gitlab.freedesktop.org/realmd/realmd";
    license = lib.licenses.lgpl21Only;
    mainProgram = "realm";
    maintainers = [ lib.maintainers.anthonyroussel ];
    platforms = lib.platforms.linux;
  };
})
