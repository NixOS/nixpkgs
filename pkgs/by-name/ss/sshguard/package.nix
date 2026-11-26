{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
  flex,
  expect,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.6.0";
  pname = "sshguard";

  src = fetchurl {
    url = "mirror://sourceforge/sshguard/sshguard-${finalAttrs.version}.tar.gz";
    hash = "sha256-F89E4pznhTvS3xQleFlHoJftodT4f/sDqS1MmLrkZU0=";
  };

  doCheck = true;

  nativeCheckInputs = [ expect ];

  # The tests are expect scripts with a /usr/bin/env shebang
  preCheck = ''
    patchShebangs src
  '';

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  configureFlags = [ "--sysconfdir=/etc" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protects hosts from brute-force attacks";
    mainProgram = "sshguard";
    longDescription = ''
      SSHGuard can read log messages from various input sources. Log messages are parsed, line-by-line, for recognized patterns.
      If an attack, such as several login failures within a few seconds, is detected, the offending IP is blocked.
    '';
    homepage = "https://sshguard.net";
    changelog = "https://bitbucket.org/sshguard/sshguard/src/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = with lib.platforms; linux ++ darwin ++ freebsd ++ netbsd ++ openbsd;
  };
})
