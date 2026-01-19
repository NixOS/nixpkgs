{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  unixtools,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "halp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "halp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tJ95rvYjqQn0ZTlEdqfs/LbyfBP7PqnevxX8b1VfokA=";
  };

  cargoHash = "sha256-sJdZjTzfawwBK8KxQP7zvn+kByCMSxrrQjY1t9RWmhU=";

  patches = [
    # patch tests to point to the correct target directory
    ./fix-target-dir.patch
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ unixtools.script ];

  # tests are failing on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # requires internet access
    "--skip=helper::docs::cheat::tests::test_fetch_cheat_sheet"
    "--skip=helper::docs::cheat_sh::tests::test_fetch_cheat_sheet"
    "--skip=helper::docs::cheatsheets::tests::test_fetch_cheatsheets"
    "--skip=helper::docs::eg::tests::test_eg_page_fetch"
  ];

  postPatch = ''
    substituteInPlace src/helper/args/mod.rs \
      --subst-var-by releaseDir target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$cargoCheckType
  '';

  preCheck = ''
    export NO_COLOR=1
    export OUT_DIR=target
  '';

  postInstall = ''
    mkdir -p man completions

    OUT_DIR=man $out/bin/halp-mangen
    OUT_DIR=completions $out/bin/halp-completions

    installManPage man/halp.1
    installShellCompletion \
      completions/halp.{bash,fish} \
      --zsh completions/_halp

    rm $out/bin/halp-{completions,mangen,test}
  '';

  meta = {
    description = "CLI tool to get help with CLI tools";
    homepage = "https://github.com/orhun/halp";
    changelog = "https://github.com/orhun/halp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "halp";
  };
})
