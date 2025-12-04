{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  jq,
  git,
  ripgrep,
  pkg-config,
  glib,
  libsecret,
}:

buildNpmPackage (finalAttrs: {
  pname = "qwen-code";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "QwenLM";
    repo = "qwen-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VUI7Br3k3g87tQW1AEccTTojOKNO0HA4jwA7PvYrlN8=";
  };

  npmDepsHash = "sha256-Fv3Tca0LlVwpKOoDyG8wiojn0pip8IH79lxqxISd8O0=";

  nativeBuildInputs = [
    jq
    pkg-config
    git
  ];

  buildInputs = [
    ripgrep
    glib
    libsecret
  ];

  postPatch = ''
    # patches below remove node-pty and keytar dependencies which cause build fail on Darwin
    # should be conditional on platform but since package-lock.json is patched it changes its hash
    # though seems like these dependencies are not really required by the package
    ${jq}/bin/jq '
      del(.packages."node_modules/node-pty") |
      del(.packages."node_modules/@lydell/node-pty") |
      del(.packages."node_modules/@lydell/node-pty-darwin-arm64") |
      del(.packages."node_modules/@lydell/node-pty-darwin-x64") |
      del(.packages."node_modules/@lydell/node-pty-linux-arm64") |
      del(.packages."node_modules/@lydell/node-pty-linux-x64") |
      del(.packages."node_modules/@lydell/node-pty-win32-arm64") |
      del(.packages."node_modules/@lydell/node-pty-win32-x64") |
      del(.packages."node_modules/keytar") |
      walk(
        if type == "object" and has("dependencies") then
          .dependencies |= with_entries(select(.key | (contains("node-pty") | not) and (contains("keytar") | not)))
        elif type == "object" and has("optionalDependencies") then
          .optionalDependencies |= with_entries(select(.key | (contains("node-pty") | not) and (contains("keytar") | not)))
        else .
        end
      ) |
      walk(
        if type == "object" and has("peerDependencies") then
          .peerDependencies |= with_entries(select(.key | (contains("node-pty") | not) and (contains("keytar") | not)))
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
    cp -r dist/* $out/share/qwen-code/
    # Install production dependencies only
    npm prune --production
    cp -r node_modules $out/share/qwen-code/
    # Remove broken symlinks that cause issues in Nix environment
    find $out/share/qwen-code/node_modules -type l -delete || true
    patchShebangs $out/share/qwen-code
    ln -s $out/share/qwen-code/cli.js $out/bin/qwen

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
