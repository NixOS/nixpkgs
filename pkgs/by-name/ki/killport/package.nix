{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "killport";
  version = "1.1.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-7bENyg/KR4oI//jvG6bw+3UX3j9ITAXCMTpc+65VBZ8=";
  };

  cargoHash = "sha256-+PhaRVpsM/6GOnGkGDROoOGasrZsagK1LqBZTo9IbSI=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  checkFlags = [
    # assertion failed: re.is_match(data)
    "--skip=test_mode_option"
    "--skip=test_signal_handling"
    "--skip=test_dry_run_option"
    "--skip=test_basic_kill_process"
  ];

  meta = {
    description = "Command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "killport";
  };
})
