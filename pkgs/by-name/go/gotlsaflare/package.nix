{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gotlsaflare";
<<<<<<< HEAD
  version = "2.8.2";
=======
  version = "2.8.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Stenstromen";
    repo = "gotlsaflare";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-r2stN75+5BLCogEXWFCnWKuUl26SXIrjxENbmU6zlXc=";
  };

  vendorHash = "sha256-Hr8SK4kHhXn8mxZrmyxZgs95tt1x2nBUoe4CW+4fOXA=";
=======
    hash = "sha256-1CvPQdaJJbh+Dsibgwan9T7yLiH+fTfAYtv1Rkuo8E4=";
  };

  vendorHash = "sha256-d+79m6K1+fy3vyXLKvwNx6mFiO3UO9lHJ07364jVJYM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gotlsaflare \
      --bash <($out/bin/gotlsaflare completion bash) \
      --fish <($out/bin/gotlsaflare completion fish) \
      --zsh <($out/bin/gotlsaflare completion zsh)
  '';

  meta = {
    description = "Update TLSA DANE records on cloudflare from x509 certificates";
    homepage = "https://github.com/Stenstromen/gotlsaflare";
    changelog = "https://github.com/Stenstromen/gotlsaflare/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ szlend ];
    mainProgram = "gotlsaflare";
  };
})
