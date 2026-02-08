{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

let
  pname = "psysh";
  version = "0.12.19";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${version}";
    hash = "sha256-Gdye6+fdqqxgHqq79XJgSkywP1IMMAIVexh0kEol0Jw=";
    forceFetchGit = true;
  };
in
php.buildComposerProject2 (finalAttrs: {
  inherit
    pname
    version
    src
    ;

  composerVendor = php.mkComposerVendor {
    inherit
      src
      version
      pname
      ;

    preConfigure = ''
      cp build/composer.json .
      cp build/composer.lock .
    '';

    vendorHash = "sha256-MbYMFQVUmRAV7qttJBEJxzimeFIA0K8wbrwC9yDirf8=";
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP";
    mainProgram = "psysh";
    maintainers = [ lib.maintainers.piotrkwiecinski ];
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
  };
})
