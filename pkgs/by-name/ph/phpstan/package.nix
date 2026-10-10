{
  stdenv,
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phpstan";
  version = "2.2.16";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan";
    tag = finalAttrs.version;
    hash = "sha256-tM++queSVxe/K8Qkoh3bpsgMbjqdAKd0fXOyGbUfvXk=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall =
    let
      # PHPStan Turbo needs PHP 8.3 or newer
      phpWithTurbo =
        if lib.versionAtLeast php.version "8.3" then
          php.withExtensions ({ enabled, ... }: enabled ++ [ finalAttrs.passthru.turbo ])
        else
          php;
    in
    ''
      install -D ./phpstan.phar $out/libexec/phpstan/phpstan.phar
      makeWrapper ${lib.getExe phpWithTurbo} $out/bin/phpstan \
        --add-flags "$out/libexec/phpstan/phpstan.phar" \
        --prefix PATH : ${
          lib.makeBinPath [
            phpWithTurbo
          ]
        }
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    # PHPStan's native extension. PHPStan uses it only when its version
    # matches the phar, so it is built from the tag of the same release.
    turbo = php.buildPecl {
      pname = "phpstan_turbo";
      inherit (finalAttrs) version;

      src = fetchFromGitHub {
        owner = "phpstan";
        repo = "turbo-ext";
        tag = finalAttrs.version;
        hash = "sha256-IpZ71u6WzhRD0uNAGf0K5GoiuSj0+l3pkHrKBQyiJ8k=";
      };

      meta = {
        description = "Native extension that speeds up PHPStan";
        homepage = "https://github.com/phpstan/turbo-ext";
        license = lib.licenses.mit;
      };
    };

    updateScript = nix-update-script { extraArgs = [ "--subpackage=turbo" ]; };
  };

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
