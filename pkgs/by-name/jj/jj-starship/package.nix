{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
  apple-sdk,
  libiconv,
  versionCheckHook,
  withGit ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-starship";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "dmmulroy";
    repo = "jj-starship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oI/6zLVvQWJt3+LtVLfv5eCia/Bwmb88NJaY0lpEz1c=";
  };

  cargoHash = "sha256-GuZnQOzX24Z9PhEKPYHr44UPCSxem81EWMgGW/ixk2c=";

  buildNoDefaultFeatures = !withGit;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals withGit [ libgit2 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
    libiconv
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/dmmulroy/jj-starship/releases/tag/${finalAttrs.src.tag}";
    description = "Unified Starship prompt module for Git and Jujutsu repositories that is optimized for latency";
    homepage = "https://github.com/dmmulroy/jj-starship";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "jj-starship";
  };
})
