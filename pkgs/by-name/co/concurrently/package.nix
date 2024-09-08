{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,
  nodejs,
  pnpm_8,
}:

let
  pnpm = pnpm_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "concurrently";
  version = "8.2.2";

  src = fetchFromGitHub {
    owner = "open-cli-tools";
    repo = "concurrently";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-VoyVYBOBMguFKnG2VItk1L5BbF72nO7bYJpb7adqICs=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-F1teWIABkK0mqZcK3RdGNKmexI/C59QWSrrD1jYbHt0=";
  };

  patches = [
    (fetchpatch2 {
      name = "use-pnpm-8.patch";
      url = "https://github.com/open-cli-tools/concurrently/commit/0b67a1a5a335396340f4347886fb9d0968a57555.patch";
      hash = "sha256-mxid2Yl9S6+mpN7OLUCrJ1vS0bQ/UwNiGJ0DL6Zn//Q=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.configHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/concurrently"
    cp -r dist node_modules "$out/lib/concurrently"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/concurrently" \
      --add-flags "$out/lib/concurrently/dist/bin/concurrently.js"
    ln -s "$out/bin/concurrently" "$out/bin/con"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/open-cli-tools/concurrently/releases/tag/v${finalAttrs.version}";
    description = "Run commands concurrently";
    homepage = "https://github.com/open-cli-tools/concurrently";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
    mainProgram = "concurrently";
  };
})
