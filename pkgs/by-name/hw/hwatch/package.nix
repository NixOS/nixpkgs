{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  testers,
  hwatch,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hwatch";
  version = "0.3.19";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = "hwatch";
    tag = finalAttrs.version;
    hash = "sha256-lMsBzMDMgpHxcQFtfZ4K7r2WRUaVR8Ry/kPvwfzPObI=";
  };

  cargoHash = "sha256-UnaZZEmX5XoTVFLEFj5JkJXJkjoUBwzJokfffJTPP4M=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd hwatch --"$shell" <("$out/bin/hwatch" --completion "$shell")
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = hwatch;
  };

  meta = {
    description = "Modern alternative to the watch command";
    longDescription = ''
      A modern alternative to the watch command, records the differences in
      execution results and can check this differences at after.
    '';
    homepage = "https://github.com/blacknon/hwatch";
    changelog = "https://github.com/blacknon/hwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "hwatch";
  };
})
