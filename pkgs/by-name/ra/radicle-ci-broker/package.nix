{
  lib,
  rustPlatform,
  fetchFromRadicle,
  stdenv,
  jq,
  gitMinimal,
  sqlite,
  radicle-node,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-broker";
  version = "0.24.0";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "zwTxygwuz5LDGBq255RA2CbNGrz8";
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E9i5EhzI+9PX2Sm2nNyB5SMi6F/EmjifeD0futPBi6k=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git_head
      rm -rf $out/.git
    '';
  };

  cargoHash = "sha256-RlqomX4XiKn/YuCdBh6H/y+8JFBwC06eDEAmhz71UXs=";

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail "let hash = " "let hash = \"$(<$src/.git_head)\"; "

    substituteInPlace ci-broker.md \
      --replace-fail 'PATH: /bin' "" \
      --replace-fail '"PATH": "/bin"' ""
  '';

  preCheck = ''
    ln -s "$PWD/target/${stdenv.hostPlatform.rust.rustcTarget}/$cargoBuildType" target/debug

    rad auth --alias alice --stdin </dev/null
  '';

  nativeCheckInputs = [
    jq
    gitMinimal
    sqlite
    radicle-node
    writableTmpDirAsHomeHook
  ];

  checkFlags = [ "--skip=acceptance_criteria_for_upgrades" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) radicle-ci-broker; };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Radicle CI broker";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwTxygwuz5LDGBq255RA2CbNGrz8";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwTxygwuz5LDGBq255RA2CbNGrz8/tree/NEWS.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "cib";
  };
})
