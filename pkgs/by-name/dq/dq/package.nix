{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dq";
  version = "20251001";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "dq";
    tag = finalAttrs.version;
    hash = "sha256-+3NGtHx9DI7s3V8aIJkW25apYAoFuLuiQ4TGsr981c8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 dq dqcache dqcache-makekey dqcache-start -t $out/bin
    installManPage man/*

    runHook postInstall
  '';

  meta = {
    description = "Recursive DNS/DNSCurve server and comandline tool";
    homepage = "https://github.com/janmojzis/dq";
    changelog = "https://github.com/janmojzis/dq/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      bsd0
      cc0
      mit
      mit0
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
})
