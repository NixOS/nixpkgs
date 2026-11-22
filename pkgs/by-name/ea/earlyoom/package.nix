{
  lib,
  fetchFromGitHub,
  pandoc,
  stdenv,
  nixosTests,
  # The man page requires pandoc to build and resides in a separate "man"
  # output which is pulled in on-demand. There is no need to disabled it unless
  # pandoc is hard to build on your platform.
  withManpage ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "earlyoom";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eNWg96+uQn/s+iBCm8TH26pXVVzBdqbeQxVP2t4W7YA=";
  };

  outputs = [ "out" ] ++ lib.optionals withManpage [ "man" ];

  patches = [ ./0000-fix-dbus-path.patch ];

  nativeBuildInputs = lib.optionals withManpage [ pandoc ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
    "SYSTEMDUNITDIR=${placeholder "out"}/etc/systemd/system"
  ]
  ++ lib.optional withManpage "MANDIR=${placeholder "man"}/share/man";

  passthru.tests = {
    inherit (nixosTests) earlyoom;
  };

  meta = {
    homepage = "https://github.com/rfjakob/earlyoom";
    description = "Early OOM Daemon for Linux";
    longDescription = ''
      earlyoom checks the amount of available memory and free swap up to 10
      times a second (less often if there is a lot of free memory). By default
      if both are below 10%, it will kill the largest process (highest
      oom_score). The percentage value is configurable via command line
      arguments.
    '';
    license = lib.licenses.mit;
    mainProgram = "earlyoom";
    maintainers = with lib.maintainers; [
      oxalica
    ];
    platforms = lib.platforms.linux;
  };
})
