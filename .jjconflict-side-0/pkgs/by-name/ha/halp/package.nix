{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, unixtools
}:

rustPlatform.buildRustPackage rec {
  pname = "halp";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "halp";
    rev = "v${version}";
    hash = "sha256-SeBponGeQWKjbiS4GL8YA7y92BqLL+ja6ZSKAI3CeRM=";
  };

  cargoHash = "sha256-/mzbLsIc0PW5yx/m9eq3IWYM6i1MKvmOY+17/Bwjguk=";

  patches = [
    # patch tests to point to the correct target directory
    ./fix-target-dir.patch
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    unixtools.script
  ];

  # tests are failing on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # requires internet access
    "--skip=helper::docs::cheat::tests::test_fetch_cheat_sheet"
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

  meta = with lib; {
    description = "CLI tool to get help with CLI tools";
    homepage = "https://github.com/orhun/halp";
    changelog = "https://github.com/orhun/halp/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "halp";
  };
}
