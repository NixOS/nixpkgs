{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage (finalAttrs: {
  pname = "safe-chain";
  version = "1.5.30";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AikidoSec";
    repo = "safe-chain";
    tag = finalAttrs.version;
    hash = "sha256-HMVnsRXZC6r+2OAbVyuQ4Ux2cKEzoZgvwMRdXhr0dLE=";
  };

  postPatch = ''
    substituteInPlace "packages/safe-chain/package.json" --replace-fail "\"version\": \"1.0.0\"" "\"version\": \"${finalAttrs.version}\""
  '';

  dontNpmBuild = true;
  npmDepsHash = "sha256-8WJ932QfvPUE3CG1Je5Np6KSD6zt6yxmVS8tAXZB4Gg=";
  npmWorkspace = "packages/safe-chain";

  postInstall = ''
    cp -r "packages" "$out/lib/node_modules/aikido-safe-chain-workspace"
    rm -rf "$out/lib/node_modules/aikido-safe-chain-workspace/node_modules/@aikidosec/safe-chain-e2e-tests"
  '';

  meta = {
    description = "Protect against malicious code installed via npm, yarn, pnpm, npx, pnpx, pip, uv and poetry with Aikido Safe Chain. Free to use, no tokens required.";
    homepage = "https://github.com/AikidoSec/safe-chain";
    mainProgram = "safe-chain";
    maintainers = [ lib.maintainers.quinnputer ];
    license = lib.licenses.agpl3Plus;
  };
})
