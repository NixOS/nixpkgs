{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  libsecret,
  nodejs,
  perl,
  pkg-config,
}:

buildNpmPackage (finalAttrs: {
  pname = "filen-cli";
  version = "0.0.34";

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = "filen-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iISW9EAk8haWUCh9I8qHhrBKLqHeBUC8sWA0MnXqQSA=";
  };

  npmDepsHash = "sha256-0DpiUjUFc0ThzP6/qrSEebKDq2fnr/CpcmtPFaIVHhU=";

  inherit nodejs;

  env.npm_config_build_from_source = "true";

  nativeBuildInputs = [
    makeWrapper
    pkg-config # for keytar
  ]
  ++ lib.optionals stdenv.buildPlatform.isDarwin [
    # for utf-8-validate
    # https://github.com/websockets/utf-8-validate/blob/1439ad4cdf99d421084ae3a5f81e2cf43199a690/binding.gyp#L17
    perl
  ];

  # for keytar
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libsecret ];

  postPatch = ''
    # The version string is substituted during publishing:
    # https://github.com/FilenCloudDienste/filen-cli/blob/c7d5eb2a2cd6d514321992815f16475f6909af36/.github/workflows/build-and-publish.yml#L24
    substituteInPlace package.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"' \
      --replace-fail '\"--external:*keytar.node\" --external:keytar' \
        '--loader:.node=copy'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    install -T -m755 dist/bundle.js $out/lib/index.js
    install -D -m755 dist/*.node $out/lib
    install -D -m644 package.json $out/lib
    makeWrapper "${lib.getExe nodejs}" $out/bin/filen \
      --add-flags $out/lib/index.js
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/filen";
  versionCheckProgramArg = "--version";

  # Writes $HOME/Library/Application Support on darwin
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
  };

  meta = {
    description = "CLI tool for interacting with the Filen cloud";
    homepage = "https://github.com/FilenCloudDienste/filen-cli";
    changelog = "https://github.com/FilenCloudDienste/filen-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eilvelia ];
    mainProgram = "filen";
  };
})
