{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  gamescope,
  coreutils,
  gnugrep,
  util-linux,
  procps,
  systemd,
  dbus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gamescope-session";
  version = "unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "ChimeraOS";
    repo = "gamescope-session";
    rev = "73d2da84ace7f41006a0f85bd2fdb19ef593a464";
    hash = "sha256-MxSJRBjawVFY7vJw6kcoV47f6GdCkEhrkGEYJHA1qeI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin \
      $out/lib/systemd/user \
      $out/share/gamescope-session-plus \
      $out/share/gamescope/scripts/50-custom

    install -Dm755 usr/bin/gamescope-session-plus $out/libexec/gamescope-session-plus
    install -Dm755 usr/share/gamescope-session-plus/gamescope-session-plus \
      $out/share/gamescope-session-plus/gamescope-session-plus
    install -Dm644 usr/share/gamescope-session-plus/device-quirks \
      $out/share/gamescope-session-plus/device-quirks
    install -Dm644 usr/lib/systemd/user/gamescope-session-plus@.service \
      $out/lib/systemd/user/gamescope-session-plus@.service
    install -Dm644 usr/share/gamescope/scripts/50-custom/50-disable-explicit-sync.lua \
      $out/share/gamescope/scripts/50-custom/50-disable-explicit-sync.lua

    # device-quirks is shipped by this package, so the session script has to
    # source it from the store. The sessions.d lookups are deliberately left
    # alone: CLIENT_CONFIG_DIR_USR is the interface with the session packages
    # (gamescope-session-steam, OpenGamepadUI-session), while
    # CLIENT_CONFIG_DIR_ETC and CLIENT_CONFIG_DIR_LOCAL are real paths.
    substituteInPlace $out/share/gamescope-session-plus/gamescope-session-plus \
      --replace-fail "/usr/share/gamescope-session-plus/device-quirks" \
        "$out/share/gamescope-session-plus/device-quirks"

    # The unit must run the session script from this package.
    substituteInPlace $out/lib/systemd/user/gamescope-session-plus@.service \
      --replace-fail "/usr/share/gamescope-session-plus/gamescope-session-plus" \
        "$out/share/gamescope-session-plus/gamescope-session-plus"

    # The unit is started by systemd, which does not inherit the environment
    # of its caller, so the gamescope binary and the tools the session script
    # uses have to be provided by the unit itself.
    printf '\nEnvironment=GAMESCOPE_BIN=%s\nEnvironment=PATH=%s\n' \
      "${gamescope}/bin/gamescope" \
      "${
        lib.makeBinPath [
          coreutils
          gnugrep
          util-linux
          procps
        ]
      }" \
      >> $out/lib/systemd/user/gamescope-session-plus@.service

    makeWrapper $out/libexec/gamescope-session-plus $out/bin/gamescope-session-plus \
      --set GAMESCOPE_BIN "${gamescope}/bin/gamescope" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          util-linux
          systemd
          dbus
        ]
      }

    runHook postInstall
  '';

  passthru.tests = {
    install =
      runCommand "gamescope-session-install-test"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          session=${finalAttrs.finalPackage}/share/gamescope-session-plus/gamescope-session-plus
          unit=${finalAttrs.finalPackage}/lib/systemd/user/gamescope-session-plus@.service
          wrapper=${finalAttrs.finalPackage}/bin/gamescope-session-plus
          launcher=${finalAttrs.finalPackage}/libexec/gamescope-session-plus

          # The session script must still be valid shell.
          bash -n "$session"

          # The wrapper must exec the upstream launcher, not itself.
          grep -q "exec \"${finalAttrs.finalPackage}/libexec/gamescope-session-plus\"" "$wrapper"
          ! grep -q "exec \"${finalAttrs.finalPackage}/bin/gamescope-session-plus\"" "$wrapper"

          # The launcher must still be the upstream one, i.e. the one that
          # starts the session unit.
          grep -q "systemctl --user --wait start" "$launcher"

          # The unit must run the script from the store ...
          grep -q "ExecStart=${finalAttrs.finalPackage}/share/gamescope-session-plus/gamescope-session-plus" "$unit"
          ! grep -q "/usr/share/gamescope-session-plus/gamescope-session-plus" "$unit"

          # ... the script must source device-quirks from the store ...
          grep -q "${finalAttrs.finalPackage}/share/gamescope-session-plus/device-quirks" "$session"

          # ... and the sessions.d lookup must stay a real path, because it is the
          # interface with the session packages and with /etc.
          grep -q "CLIENT_CONFIG_DIR_USR=/usr/share/gamescope-session-plus/sessions.d" "$session"

          touch $out
        '';
  };

  meta = {
    description = "Common gamescope session files from ChimeraOS: entry point, systemd user unit and device quirks; it does not provide a login session on its own";
    homepage = "https://github.com/ChimeraOS/gamescope-session";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "gamescope-session-plus";
    maintainers = with lib.maintainers; [ tjswysqh-afk ];
  };
})
