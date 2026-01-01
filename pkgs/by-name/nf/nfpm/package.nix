{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule rec {
  pname = "nfpm";
<<<<<<< HEAD
  version = "2.44.1";
=======
  version = "2.43.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "nfpm";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zgj+cwgTyCzg1s3ta0sUDvwNdQJrlhCmuI2Qgqrf28Q=";
  };

  vendorHash = "sha256-8Kt/TdL75Cs34Su7Pf2MSZaIrjpP/oFZygGdMZlxpAk=";
=======
    hash = "sha256-mLss9uh/yTU6aJDTBDGdfL0M6A3AIVOfuWR8r0KsyOk=";
  };

  vendorHash = "sha256-7OhiaB0PpwvFj+yLyoN0+/qpF+p/c/Vw+7Tn2XVYYjg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      ${emulator} $out/bin/nfpm man > nfpm.1
      installManPage ./nfpm.1
      installShellCompletion --cmd nfpm \
        --bash <(${emulator} $out/bin/nfpm completion bash) \
        --fish <(${emulator} $out/bin/nfpm completion fish) \
        --zsh  <(${emulator} $out/bin/nfpm completion zsh)
    '';

  meta = {
    description = "Simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    changelog = "https://github.com/goreleaser/nfpm/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      techknowlogick
      caarlos0
    ];
    license = with lib.licenses; [ mit ];
    mainProgram = "nfpm";
  };
}
