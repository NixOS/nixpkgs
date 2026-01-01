{
  lib,
  buildGoModule,
  fetchFromGitHub,
<<<<<<< HEAD
  versionCheckHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule rec {
  pname = "docker-compose";
<<<<<<< HEAD
  version = "5.0.0";
=======
  version = "2.39.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-7g9l9SBxPY3jMS3DWZNI/fhOZN1oZo1qkUfhMfbzAaM=";
  };

  vendorHash = "sha256-EFbEd1UwrBnH6pSh+MvupYdie8SnKr8y6K9lQflBSlk=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  modPostBuild = ''
    patch -d vendor/github.com/docker/cli/ -p1 < ${./cli-system-plugin-dir-from-env.patch}
  '';

  ldflags = [
    "-X github.com/docker/compose/v5/internal.Version=${version}"
=======
    rev = "v${version}";
    hash = "sha256-NDNyXK4E7TkviESHLp8M+OI56ME0Hatoi9eWjX+G1zo=";
  };

  postPatch = ''
    # entirely separate package that breaks the build
    rm -rf pkg/e2e/
  '';

  vendorHash = "sha256-Uqzul9BiXHAJ1BxlOtRS68Tg71SDva6kg3tv7c6ar2E=";

  ldflags = [
    "-X github.com/docker/compose/v2/internal.Version=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "-s"
    "-w"
  ];

  doCheck = false;
<<<<<<< HEAD
  doInstallCheck = true;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-compose $out/bin/docker-compose
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    mainProgram = "docker-compose";
    homepage = "https://github.com/docker/compose";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    mainProgram = "docker-compose";
    homepage = "https://github.com/docker/compose";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
