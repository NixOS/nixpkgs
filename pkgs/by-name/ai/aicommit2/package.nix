{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aicommit2";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "tak-bro";
    repo = "aicommit2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/bl0Qo4y3rDdGXIKTdjC5wtbeW1NUaIMkw5uzSQ+8Dk=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-y3IftcRhsDDyMZ2AE07WyY94mp0j6M6UVno7Qp8d/G8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];
  buildInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/aicommit2}
    cp -r {dist,node_modules} $out/lib/aicommit2

    ln -s $out/lib/aicommit2/dist/cli.mjs $out/bin/aicommit2
    ln -s $out/lib/aicommit2/dist/cli.mjs $out/bin/aic2

    runHook postInstall
  '';

  meta = {
    description = "Reactive CLI that generates git commit messages with AI";
    homepage = "https://github.com/tak-bro/aicommit2";
    changelog = "https://github.com/tak-bro/aicommit2/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "aicommit2";
    platforms = lib.platforms.all;
  };
})
