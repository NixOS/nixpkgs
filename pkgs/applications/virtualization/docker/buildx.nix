{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-buildx";
<<<<<<< HEAD
  version = "0.30.1";
=======
  version = "0.29.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "docker";
    repo = "buildx";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SffXgJWPPB+ZImknbYWU8AyypAfk2coXxyqWy6UCNMk=";
=======
    hash = "sha256-H7U44g4rw15c3Snx88YgAanSw4dWanmTugpGBIwfI6A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doCheck = false;

  vendorHash = null;

  ldflags = [
    "-w"
    "-s"
    "-X github.com/docker/buildx/version.Package=github.com/docker/buildx"
    "-X github.com/docker/buildx/version.Version=v${version}"
  ];

  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/buildx $out/libexec/docker/cli-plugins/docker-buildx

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-buildx $out/bin/docker-buildx
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    mainProgram = "docker-buildx";
    homepage = "https://github.com/docker/buildx";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    mainProgram = "docker-buildx";
    homepage = "https://github.com/docker/buildx";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      ivan-babrou
      developer-guy
    ];
  };
}
