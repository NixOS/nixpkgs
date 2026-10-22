{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  libiconv,
  openssl,
  gitMinimal,
  pkg-config,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "convco";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "convco";
    repo = "convco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vzxIZdXmWASnafaeXt/QBgg9WXyMFwPclFeD+4oF4V0=";
  };

  cargoHash = "sha256-f/jfriJeBgR3OkWj5S/NkTc/bhGjqU/yQHUfddUo2yQ=";

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    gitMinimal
  ];

  checkFlags = [
    # disable test requiring networking
    "--skip=git::tests::test_find_last_unordered_prerelease"
    "--skip=git::tests::test_find_matching_prerelease"
    "--skip=git::tests::test_find_matching_prerelease_without_matching_release"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hoverbear
      cafkafk
    ];
  };
})
