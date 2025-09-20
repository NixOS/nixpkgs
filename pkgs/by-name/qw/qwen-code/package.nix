{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  jq,
  ripgrep,
}:

buildNpmPackage (finalAttrs: {
  pname = "qwen-code";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "QwenLM";
    repo = "qwen-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qsa4bAk0QUUZCtoEREBd+8s0AwwVr1os5TO7Luo/UrY=";
  };

  patches = [
    # similar to upstream gemini-cli some node deps are missing resolved and integrity fields
    # upstream the problem is solved in master and in v0.4+, eventually the fix should arrive to qwen
    ./add-missing-resolved-integrity-fields.patch
  ];

  npmDepsHash = "sha256-uLKxUD0e9YSEQz4dxsGXYojcYS6noqsWhtmsc20He0k=";

  nativeBuildInputs = [
    jq
  ];

  buildInputs = [ ripgrep ];

  postPatch = ''
    # Remove @lvce-editor/ripgrep dependency (no network on buildPhase
    substituteInPlace package.json --replace-fail '"@lvce-editor/ripgrep": "^1.6.0",' ""
    substituteInPlace packages/core/package.json --replace-fail '"@lvce-editor/ripgrep": "^1.6.0",' ""
    substituteInPlace packages/core/src/tools/ripGrep.ts \
      --replace-fail "import { rgPath } from '@lvce-editor/ripgrep';" "const rgPath = 'rg';"

    # patches below remove node-pty dependency which causes build fail on Darwin
    # should be conditional on platform but since package-lock.json is patched it changes its hash
    # though seems like this dependency is not really required by the package
    ${jq}/bin/jq '
      del(.packages."node_modules/node-pty") |
      del(.packages."node_modules/@lydell/node-pty") |
      del(.packages."node_modules/@lydell/node-pty-darwin-arm64") |
      del(.packages."node_modules/@lydell/node-pty-darwin-x64") |
      del(.packages."node_modules/@lydell/node-pty-linux-arm64") |
      del(.packages."node_modules/@lydell/node-pty-linux-x64") |
      del(.packages."node_modules/@lydell/node-pty-win32-arm64") |
      del(.packages."node_modules/@lydell/node-pty-win32-x64") |
      walk(
        if type == "object" and has("dependencies") then
          .dependencies |= with_entries(select(.key | contains("node-pty") | not))
        elif type == "object" and has("optionalDependencies") then
          .optionalDependencies |= with_entries(select(.key | contains("node-pty") | not))
        else .
        end
      )
    ' package-lock.json > package-lock.json.tmp && mv package-lock.json.tmp package-lock.json
  '';

  buildPhase = ''
    runHook preBuild

    npm run generate
    npm run bundle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/qwen-code
    cp -r bundle/* $out/share/qwen-code/
    patchShebangs $out/share/qwen-code
    ln -s $out/share/qwen-code/gemini.js $out/bin/qwen

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Coding agent that lives in digital world";
    homepage = "https://github.com/QwenLM/qwen-code";
    mainProgram = "qwen";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      lonerOrz
      taranarmo
    ];
  };
})
