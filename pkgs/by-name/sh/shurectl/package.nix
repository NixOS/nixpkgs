{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  alsa-lib,
  libpulseaudio,
  udev,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "shurectl";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "Humblemonk";
    repo = "shurectl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KV7kS31Bw+wIueatsZK0GlbPdmkWPww5lxuETbwBsls=";
  };

  cargoHash = "sha256-0gHX4hbyNysH3N+COj/xCdx3pniZcJZbj63j53iUx0I=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
    udev
  ];

  # The mock-device integration tests need a feature not enabled in release builds.
  checkFeatures = [ "qa" ];

  # The PTY smoke test uses HOME as the child process's working directory.
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 62-shure.rules "$out/lib/udev/rules.d/62-shure.rules"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Terminal UI for configuring Shure USB audio interfaces and microphones";
    homepage = "https://github.com/Humblemonk/shurectl";
    changelog = "https://github.com/Humblemonk/shurectl/blob/${finalAttrs.src.tag}/doc/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "shurectl";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
