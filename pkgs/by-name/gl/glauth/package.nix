{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "glauth";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "glauth";
    repo = "glauth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UUTL+ZnHRSYuD/TUYpsuo+Nu90kpA8ZL4XaGz6in3ME=";
  };

  vendorHash = "sha256-Lijy0LFy0PgWogdzYRNPFOkLym6Gf9qG4R+Bm91eYJg=";

  postPatch = ''
    substituteInPlace v2/internal/version/const.go \
      --replace-fail '"v2.3.1"' '"v${finalAttrs.version}"'
  '';

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
  versionCheckProgramArg = "--version";

  meta = with lib; {
    description = "Lightweight LDAP server for development, home use, or CI";
    homepage = "https://github.com/glauth/glauth";
    changelog = "https://github.com/glauth/glauth/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      bjornfor
      christoph-heiss
      xddxdd
    ];
    mainProgram = "glauth";
  };
})
