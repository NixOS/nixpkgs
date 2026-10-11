{
  bashInteractive,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bash-completor";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "adoyle-h";
    repo = "bash-completor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nE+UPjDglFEPXyKZk1cs22eUaUxnWEjikMKcku4Pmy0=";
  };

  postPatch = ''
    patchShebangs --build tools/build-dist
  '';

  nativeBuildInputs = [
    bashInteractive
    installShellFiles
  ];

  buildPhase = ''
    runHook preBuild

    make VERSION=v${finalAttrs.version} dist/bash-completor
    patchShebangs --build dist/bash-completor

    make dist/bash-completor.completion.bash

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 dist/bash-completor -t $out/bin
    installShellCompletion --name bash-completor.bash dist/bash-completor.completion.bash

    runHook postInstall
  '';

  meta = {
    description = "Create bash completion scripts in a declarative way";
    homepage = "https://github.com/adoyle-h/bash-completor";
    changelog = "https://github.com/adoyle-h/bash-completor/blob/v${finalAttrs.version}/CHANGELOG.md#v${finalAttrs.version}";
    mainProgram = "bash-completor";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nicknb ];
  };
})
