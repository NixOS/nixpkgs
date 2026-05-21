{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fnm";
  version = "1.39.0";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = "fnm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-sCPrHy1+hdv6schBxOP1+Y1hpag4/hdKPhG/PZhqKQA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-AVSphRupcncOmlIh4GXcPab2ePhS1jgaQLBKv2sRwuo=";

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = {
    description = "Fast and simple Node.js version manager";
    mainProgram = "fnm";
    homepage = "https://github.com/Schniz/fnm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kidonng ];
  };
})
