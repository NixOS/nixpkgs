{
  stdenv,
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
  makeBinaryWrapper,
  nix-update-script,
  withTurbo ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phpstan";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan";
    tag = finalAttrs.version;
    hash = "sha256-9ewU9PfMPxcZo34hvtzOIfrNoWuQ/InDylvH/r6B3xk=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    install -D ./phpstan.phar $out/libexec/phpstan/phpstan.phar
    makeWrapper ${lib.getExe finalAttrs.passthru.php} $out/bin/phpstan \
      --add-flags "$out/libexec/phpstan/phpstan.phar" \
      --prefix PATH : ${
        lib.makeBinPath [
          finalAttrs.passthru.php
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    # Each PHPStan release accepts exactly one turbo-ext build, its tags mirror
    # the PHPStan versions. Built here only for the PHP PHPStan runs on.
    # A version override has to override this one as well, e.g.
    # passthru = old.passthru // {
    #   turboSrc = old.passthru.turboSrc.override { tag = "…"; hash = "…"; };
    # };
    # or disable the extension with `phpstan.override { withTurbo = false; }`.
    turboSrc = fetchFromGitHub {
      owner = "phpstan";
      repo = "turbo-ext";
      tag = finalAttrs.version;
      hash = "sha256-uTLP2GcVSw7yJh1hwkf9qJ0DB/D3p1xDY9F+6HUJmbY=";
    };

    turbo = php.buildPecl {
      pname = "phpstan_turbo";
      inherit (finalAttrs) version;
      src = finalAttrs.passthru.turboSrc;

      doCheck = false;

      meta = {
        broken = lib.versionOlder php.version "8.3";
        description = "Native PHP extension that makes PHPStan faster";
        homepage = "https://github.com/phpstan/turbo-ext";
        license = lib.licenses.mit;
        inherit (finalAttrs.meta) maintainers;
      };
    };

    # PHPStan runs without the extension on a PHP it does not support
    php =
      if withTurbo && !finalAttrs.passthru.turbo.meta.broken then
        php.withExtensions ({ enabled, ... }: enabled ++ [ finalAttrs.passthru.turbo ])
      else
        php;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "turbo"
      ];
    };
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
