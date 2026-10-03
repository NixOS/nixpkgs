{
  rustPlatform,
  fetchFromGitLab,
  dbus,
  pkg-config,
  nix-update-script,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dmemcg-booster";
  version = "0.1.3";
  cargoHash = "sha256-NHK4734Jvi4RJieGn0RjYU0PzQFqaE4exHG77dmukig=";

  src = fetchFromGitLab {
    domain = "gitlab.steamos.cloud";
    owner = "holo";
    repo = "dmemcg-booster";
    tag = finalAttrs.version;
    hash = "sha256-JDT+JKxgaETinIHiP0Pqb7fPNrvcI6AQu90nmoA/YuI=";
  };

  __structuredAttrs = true;

  env.PKG_CONFIG_PATH = "${dbus.dev}/lib/pkgconfig";
  nativeBuildInputs = [ pkg-config ];

  installPhase = ''
    install -Dm755 target/x86_64-unknown-linux-gnu/release/dmemcg-booster "$out/bin/dmemcg-booster"

    # Set up systemd services
    install -Dm644 dmemcg-booster-system.service "$out/lib/systemd/system/dmemcg-booster-system.service"
    install -Dm644 dmemcg-booster-user.service "$out/lib/systemd/user/dmemcg-booster-user.service"
  '';
  fixupPhase = ''
    substituteInPlace $out/lib/systemd/system/dmemcg-booster-system.service \
      --replace-fail "/usr/bin/dmemcg-booster" "$out/bin/dmemcg-booster"
    substituteInPlace $out/lib/systemd/user/dmemcg-booster-user.service \
      --replace-fail "/usr/bin/dmemcg-booster" "$out/bin/dmemcg-booster"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "dmemcg-booster";
    description = "Service for enabling and controlling dmem cgroup limits for boosting foreground games";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ name-tar-xz ];
  };
})
