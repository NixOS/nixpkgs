{
  bun,
  lib,
  fetchFromGitHub,
  mystmd,
  nodejs,
  stdenv,
  testers,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mystmd";
  version = "1.8.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "mystmd";
    tag = "mystmd@${finalAttrs.version}";
    hash = "sha256-OmREjNDgmq5+nidBZh4DUy9bMtDeHMrGWZEqKo5TUrQ=";
  };

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-node_modules";

    nativeBuildInputs = [
      bun
      nodejs
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --no-progress --frozen-lockfile --no-cache

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash =
      {
        x86_64-linux = "sha256-4EQkvsoji9M4VCrdwyHm+ncd4XFjgAf34Kt+YeM3qjs=";
        aarch64-linux = "sha256-xm4T1BL3AyRsYOERz4LhG4ZJQkSMzspoA+l60OND3E0=";
        x86_64-darwin = "sha256-L+zY9O5ridMvZEhGH0R56P3XiDlYF3UrFZwmOYlqxYY=";
        aarch64-darwin = "sha256-ZUx+jF7IcEbUCnUUeW0uOFgEpO9UIJpP3/VpUJ5ulAM=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    nodejs
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.node_modules}/node_modules .
    patchShebangs node_modules
    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r node_modules $out/lib/
    cp -r packages $out/lib/
    install -D packages/mystmd/dist/myst.cjs $out/bin/myst

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command line tools for working with MyST Markdown";
    homepage = "https://github.com/jupyter-book/mystmd";
    changelog = "https://github.com/jupyter-book/mystmd/blob/${finalAttrs.src.rev}/packages/myst-cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "myst";
  };
})
