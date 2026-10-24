{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bashka";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "bashka";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NFwLY7C7f41o+s2P0ko5sNtoYV5k6ZbrG79YqwSHqng=";
  };

  cargoHash = "sha256-HndILkETkZIhko03/kxhPRiqg58wRqRDPslFXEkrp1A=";

  nativeCheckInputs = [ curl ];

  # Flaky upstream test (fails outside of the Nix environment as well).
  checkFlags = [
    "--skip=piped_install_captures_origin_and_update_reruns_it"
  ];

  meta = {
    description = "Static verification of bash installation scripts to guard against curl | bash risks";
    changelog = "https://github.com/dmtrKovalenko/bashka/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/dmtrKovalenko/bashka";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xcl0716 ];
    platforms = lib.platforms.unix;
    mainProgram = "bashka";
  };
})
