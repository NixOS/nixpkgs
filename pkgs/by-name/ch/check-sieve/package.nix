{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  diffutils,
  flex,
  python3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "check-sieve";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dburkart";
    repo = "check-sieve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dElVfLSVtlELleuxCScR6BGuLsJ+KRqcNA8y0lgrBfI=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  nativeCheckInputs = [
    (python3.withPackages (p: [ p.setuptools ]))
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  installPhase = ''
    runHook preInstall
    install -Dm755 check-sieve -t $out/bin
    runHook postInstall
  '';

  preCheck = ''
    substituteInPlace test/{AST,simulate}/util.py \
      --replace-fail "/usr/bin/diff" "${diffutils}/bin/diff"
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(.*)" ];
  };

  meta = {
    description = "Syntax checker for mail sieves";
    mainProgram = "check-sieve";
    homepage = "https://github.com/dburkart/check-sieve";
    changelog = "https://github.com/dburkart/check-sieve/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ eilvelia ];
  };
})
