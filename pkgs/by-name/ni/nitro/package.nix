{
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nitro";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "nitro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RabBawI3qXJwsbHpfuSEBM3n0RQ+Rk7kW8tHHcIIJJI=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Compile with size optimisations for minimal targets
  buildFlags = lib.optionalString stdenv.hostPlatform.isStatic "tiny";
  installPhase = ''
    runHook preInstall
    installBin nitro nitroctl

    mv halt.8 nitro-halt.8
    installManPage nitro.8 nitro-halt.8 nitroctl.1
    runHook postInstall
  '';

  meta = {
    mainProgram = "nitro";
    description = "Tiny but flexible init system and process supervisor";
    homepage = "https://github.com/leahneukirchen/nitro";
    changelog = "https://raw.githubusercontent.com/leahneukirchen/nitro/refs/tags/v${finalAttrs.version}/NEWS.md";
    maintainers = [ lib.maintainers.boomshroom ];
    license = lib.licenses.bsd0;
    platforms = lib.platforms.linux;
  };
})
