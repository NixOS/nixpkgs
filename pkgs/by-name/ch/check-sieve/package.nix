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
stdenv.mkDerivation rec {
  pname = "check-sieve";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "dburkart";
    repo = "check-sieve";
    tag = "check-sieve-${version}";
    hash = "sha256-vmfHXjcZ5J/+kO3/a0p8krLOuC67+q8SxcPJgW+UaTw=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  nativeCheckInputs = [
    (python3.withPackages (p: [ p.setuptools ]))
  ];

  # https://github.com/dburkart/check-sieve/issues/67
  # Remove after the next (>0.10) release
  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  installPhase = ''
    runHook preInstall
    install -Dm755 check-sieve -t $out/bin
    runHook postInstall
  '';

  preCheck = ''
    substituteInPlace test/AST/util.py \
      --replace-fail "/usr/bin/diff" "${diffutils}/bin/diff"
    # Disable flaky tests: https://github.com/dburkart/check-sieve/issues/68
    # Remove after the next (>0.10) release
    rm -rf test/{6785,7352}
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=check-sieve-(.*)" ];
  };

  meta = {
    description = "Syntax checker for mail sieves";
    mainProgram = "check-sieve";
    homepage = "https://github.com/dburkart/check-sieve";
    changelog = "https://github.com/dburkart/check-sieve/blob/${src.tag}/ChangeLog";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ eilvelia ];
  };
}
