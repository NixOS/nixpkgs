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
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "dmmulroy";
    repo = "jj-starship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z2nEavoTW+aXc0lbBQe0dTGIP0qKachCUSqa+EbWxfo=";
  };

  cargoHash = "sha256-N1kjoQGPmzLwmXwSXhy6kv1e4zl7uq4tBw+U5eFwgSo=";

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
