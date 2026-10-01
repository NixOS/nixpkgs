{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,

  systemd,
  bash,
  dbus,
  cosmic-session,
  niri,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cosmic-ext-extra-sessions";
  version = "0-unstable-2025-04-02";

  src = fetchFromGitHub {
    owner = "Drakulix";
    repo = "cosmic-ext-extra-sessions";
    rev = "66e065728d81eab86171e542dad08fb628c88494";
    hash = "sha256-6JiWdBry63NrnmK3mt9gGSDAcyx/f6L5QsIgZSUakQI=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm0644 $src/niri/cosmic-ext-niri.desktop $out/share/wayland-sessions/cosmic-ext-niri.desktop
    install -Dm0755 $src/niri/start-cosmic-ext-niri $out/bin/start-cosmic-ext-niri
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/wayland-sessions/cosmic-ext-niri.desktop \
    --replace-fail "/usr/local/bin/start-cosmic-ext-niri" "$out/bin/start-cosmic-ext-niri"

    substituteInPlace $out/bin/start-cosmic-ext-niri \
    --replace-fail "systemctl" "${systemd}/bin/systemctl" \
    --replace-fail "exec bash" "exec ${lib.getExe bash}" \
    --replace-fail "/usr/bin/dbus-run-session" "${dbus}/bin/dbus-run-session" \
    --replace-fail "/usr/bin/cosmic-session niri" "${lib.getExe cosmic-session} ${lib.getExe niri}"
  '';

  passthru = {
    providedSessions = [ "cosmic-ext-niri" ];

    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    mainProgram = "cosmic-ext-extra-sessions";
    description = "Inofficial session variants for cosmic-epoch";
    homepage = "https://github.com/Drakulix/cosmic-ext-extra-sessions";
    license = lib.licenses.gpl3;
    maintainers = [ lib.teams.cosmic ];
  };
})
