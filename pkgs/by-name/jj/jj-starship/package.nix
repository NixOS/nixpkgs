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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dmmulroy";
    repo = "jj-starship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YfcFlJsPCRfqhN+3JUWE77c+eHIp5RAu2rq/JhSxCec=";
  };

  cargoHash = "sha256-XMz6b63raPkgmUzB6L3tOYPxTenytmGWOQrs+ikcSts=";

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
