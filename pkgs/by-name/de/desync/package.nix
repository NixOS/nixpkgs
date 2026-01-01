{
<<<<<<< HEAD
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
=======
  lib,
  buildGoModule,
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule rec {
  pname = "desync";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.9.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aRxWq9gGfglfBixS7xOoj8r29rJRAfGj4ydcSFf/7P0=";
  };

  vendorHash = "sha256-ywID0txn7L6+QkYNvGvO5DTsDQBZLU+pGwNd3q7kLKI=";

  nativeBuildInputs = [ installShellFiles ];
=======
    hash = "sha256-TwzD9WYi4cdDPKKV2XoqkGWJ9CzIwoxeFll8LqNWf/E=";
  };

  vendorHash = "sha256-CBw5FFGQgvdYoOUZ6E1F/mxqzNKOwh2IZbsh0dAsLEE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nix builder doesn't have access to test data; tests fail for reasons unrelated to binary being bad.
  doCheck = false;

<<<<<<< HEAD
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd desync \
      --bash <($out/bin/desync completion bash) \
      --fish <($out/bin/desync completion fish) \
      --zsh <($out/bin/desync completion zsh)

    mkdir -p $out/share/man/man1
    $out/bin/desync manpage --section 1 $out/share/man/man1
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Content-addressed binary distribution system";
    mainProgram = "desync";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = "https://github.com/folbricht/desync";
    changelog = "https://github.com/folbricht/desync/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chaduffy ];
  };
}
