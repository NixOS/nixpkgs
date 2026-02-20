{
  stdenv,
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phpstan";
  version = "2.1.39";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan";
    tag = finalAttrs.version;
    hash = "sha256-aOAD4ZDjsm47tn44qgHnQEx9D04qAI5ErRG/oP/h1Nk=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    install -D ./phpstan.phar $out/libexec/phpstan/phpstan.phar
    makeWrapper ${lib.getExe php} $out/bin/phpstan \
      --add-flags "$out/libexec/phpstan/phpstan.phar" \
      --prefix PATH : ${
        lib.makeBinPath [
          php
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/phpstan/phpstan/releases/tag/${finalAttrs.version}";
    description = "PHP Static Analysis Tool";
    homepage = "https://github.com/phpstan/phpstan";
    longDescription = ''
      PHPStan focuses on finding errors in your code without actually
      running it. It catches whole classes of bugs even before you write
      tests for the code. It moves PHP closer to compiled languages in the
      sense that the correctness of each line of the code can be checked
      before you run the actual line.
    '';
    license = lib.licenses.mit;
    mainProgram = "phpstan";
    maintainers = with lib.maintainers; [
      patka
      piotrkwiecinski
    ];
  };
})
