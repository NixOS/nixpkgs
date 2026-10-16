{
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  dbus,
  bluez,
  kdePackages,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kairpods";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "kAirPods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+FifFWwd4aAEk5ihDGVbTrW8f3AVnPZwBoPgM6VECu0=";
  };

  cargoHash = "sha256-y/WO0y3IPdhXOnsa+//HLXWEk7gs+MH0K62QUcnveiw=";

  sourceRoot = "${finalAttrs.src.name}/service";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    bluez
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids
    cp -r ../plasmoid $out/share/plasma/plasmoids/org.kairpods.plasma

    install -Dm755 "target/${stdenv.hostPlatform.config}/release/kairpodsd" $out/bin/kairpodsd

    mkdir -p $out/lib/systemd/user
    substitute systemd/user/kairpodsd.service \
      $out/lib/systemd/user/kairpodsd.service \
      --replace-fail /usr/bin/kairpodsd $out/bin/kairpodsd

    runHook postInstall
  '';

  meta = {
    description = "Native AirPods® integration for KDE Plasma 6 powered by a modern, low-latency Rust backend.";
    homepage = "https://github.com/can1357/kAirPods";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hjsmarais ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
