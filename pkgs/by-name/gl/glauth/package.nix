{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "glauth";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "glauth";
    repo = "glauth";
    tag = "GLAuth-v${finalAttrs.version}";
    hash = "sha256-GZhp0IQ89zm31ysZr9oA7wExmg/r2jCa5UDq61ubAH0=";
  };

  vendorHash = "sha256-cVqXkTCnVCHfUuJBzH7/cvZ5AdhiBiIlalNmH2vaOVA=";

  # Builds without go workspace fail with mysterious errors
  overrideModAttrs = _: {
    buildPhase = ''
      go work vendor -e -v
    '';
  };

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests fail in the sandbox.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Lightweight LDAP server for development, home use, or CI";
    homepage = "https://github.com/glauth/glauth";
    changelog = "https://github.com/glauth/glauth/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bjornfor
      christoph-heiss
      xddxdd
    ];
    mainProgram = "glauth";
  };
})
