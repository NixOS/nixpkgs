{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lazycli";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazycli";
    rev = "v${finalAttrs.version}";
    sha256 = "1qq167hc7pp9l0m40ysphfljakmm8hjjnhpldvb0kbc825h0z8z5";
  };

  cargoHash = "sha256-L6qY1yu+8L7DajX//Yov0KgI2bR8yipSzbZC2c+LZZs=";

  checkFlags = [
    # currently broken: https://github.com/jesseduffield/lazycli/pull/20
    "--skip=command::test_run_command_fail"
  ];

  meta = {
    description = "Tool to static turn CLI commands into TUIs";
    homepage = "https://github.com/jesseduffield/lazycli";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lazycli";
  };
})
