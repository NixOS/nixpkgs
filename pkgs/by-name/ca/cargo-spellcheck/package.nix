{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-o4gvTF9Zb6bZ9443zos4bz37w3bXKumW2x425MM5/FY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wEcHMzeSj/JO/ZBPmQAiHaixtOTCT2+rTd1LDCY9wqc=";

  patches = [
    # fixes compilation of tests
    # https://github.com/drahnr/cargo-spellcheck/pull/342
    (fetchpatch2 {
      name = "fix-test-compilation.patch";
      url = "https://github.com/drahnr/cargo-spellcheck/pull/342/commits/aed8f3ca7a50fae38a5c6e0b974ed9773cd6c659.patch";
      hash = "sha256-840t8uPg0EiiVppmMT38C1P16vps7F+g0o313tzghjE=";
    })
  ];

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip=checker::hunspell::tests::hunspell_binding_is_sane"
  ];

  meta = with lib; {
    description = "Checks rust documentation for spelling and grammar mistakes";
    mainProgram = "cargo-spellcheck";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      newam
      matthiasbeyer
    ];
  };
}
