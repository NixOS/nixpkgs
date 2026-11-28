{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nanoda-lib";
  version = "0.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ammkrn";
    repo = "nanoda_lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YKoexQz/2Z+sxdNtJfNvkZRbLFff1SXaWRzTcrU9Oz4=";
  };

  cargoHash = "sha256-Low43L/Yd/OLjfE+9om1gztfrdFhZptjJJEZg92m3xg=";

  checkFlags = [
    # Error: "failed to open configuration file: Os { code: 2, kind: NotFound, message: \"No such file or directory\" }"
    "--skip=tests::declar::aesop_goal_unsafe"
    "--skip=tests::declar::mutual_def"
    "--skip=tests::natlit::e_nat_tests"
    "--skip=tests::pretty_printer::pp_prelude"
    "--skip=tests::stringlit::string_lit_tests"
    "--skip=tests::util::check_prelude"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library implementing type inference/checking functionality based on the Lean theorem prover";
    homepage = "https://github.com/ammkrn/nanoda_lib";
    changelog = "https://github.com/ammkrn/nanoda_lib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "nanoda_bin";
  };
})
