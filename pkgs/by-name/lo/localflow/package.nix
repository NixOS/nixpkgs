{
  lib,
  curl,
  fetchFromGitHub,
  libxkbcommon,
  makeBinaryWrapper,
  nix-update-script,
  pipewire,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "localflow";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ajbarryiii";
    repo = "LocalFlow";
    tag = "linux-v${finalAttrs.version}";
    hash = "sha256-Js/5hTs3L2tb+PpxPdOmq5EUwG5nPF4BXAU/NQyoZig=";
  };

  # The repository also holds the macOS and iOS apps.
  sourceRoot = "${finalAttrs.src.name}/linux";

  cargoHash = "sha256-Mi9ZbbJG6ucBBv/PhvYdgcaVPtvJtBnWITvbMGYspHg=";

  cargoBuildFlags = [
    "-p"
    "lf-daemon"
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
    pipewire
    wayland
  ];

  postInstall = ''
    unit=$out/lib/systemd/user/localflowd.service
    install -D -m 644 packaging/localflowd.service $unit
    substituteInPlace $unit \
      --replace-fail 'ExecStart=%h/.local/bin/localflowd' "ExecStart=$out/bin/localflowd"

    # The file name is the app ID the desktop portal's global shortcuts use.
    install -D -m 644 -t $out/share/applications packaging/com.ajbarryiii.localflow.desktop

    install -D -m 644 -t $out/share/doc/localflow/examples \
      packaging/hyprland.conf packaging/sway.conf packaging/niri.kdl packaging/river-init.sh
  '';

  # `localflowctl fetch-model` downloads the speech model with curl.
  postFixup = ''
    wrapProgram $out/bin/localflowctl --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  cargoTestFlags = [ "--workspace" ];

  # These tests start a private D-Bus session, a headless compositor or
  # PipeWire, which the sandbox does not have.
  env = {
    LF_SKIP_DBUS_TESTS = "1";
    LF_SKIP_COMPOSITOR_TESTS = "1";
    LF_SKIP_PIPEWIRE_TESTS = "1";
  };

  checkFlags = [
    # Measures wall-clock time and can fail on a busy builder.
    "--skip=worker::tests::correction::the_time_budget_stops_verification"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=linux-v(.*)" ];
  };

  meta = {
    description = "Local push-to-talk dictation for Wayland and X11 desktops";
    longDescription = ''
      LocalFlow types what you say into the focused window. Speech
      recognition runs on the CPU and nothing leaves the machine. The speech
      model is not included: run `localflowctl fetch-model` once to download
      it.
    '';
    homepage = "https://github.com/ajbarryiii/LocalFlow";
    changelog = "https://github.com/ajbarryiii/LocalFlow/blob/${finalAttrs.src.tag}/linux/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ajbarryiii ];
    mainProgram = "localflowd";
    # The speech recognition kernels are x86-64 only (AVX-512 and AVX2).
    platforms = [ "x86_64-linux" ];
  };
})
