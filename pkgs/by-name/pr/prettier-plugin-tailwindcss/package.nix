{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  nix-update-script,
  nodejs,
  pnpmConfigHook,
  pnpm_11,
  stdenv,
}:

let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-tailwindcss";
  version = "0.8.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "prettier-plugin-tailwindcss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mqK3R1+VJ8PqKhkltZnQpTAn8mbQC4VfptoaqmxqobM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-ZhtyQsEnIoA9SpyD+oaXFzGSDAfufWnwiL7C8ImLZ7E=";
  };

  buildPhase = ''
    runHook preBuild

    NODE_ENV=production pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/prettier-plugin-tailwindcss

    # Required for `pnpm deploy` to work without the `--legacy` flag
    pnpm config set --location=project inject-workspace-packages true

    pnpm --filter=prettier-plugin-tailwindcss --prod \
      deploy $out/lib/node_modules/prettier-plugin-tailwindcss/

    # Workaround for "Cannot find package 'prettier' imported from ..."
    cp -rL node_modules/prettier $out/lib/node_modules/prettier-plugin-tailwindcss/node_modules/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter plugin for Tailwind CSS";
    homepage = "https://github.com/tailwindlabs/prettier-plugin-tailwindcss";
    changelog = "https://github.com/tailwindlabs/prettier-plugin-tailwindcss/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ starryreverie ];
  };
})
