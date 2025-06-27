{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  writeShellApplication,
  cacert,
  curl,
  gnused,
  jq,
  nix-prefetch-github,
  prefetch-npm-deps,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    # Currently there's no release tag
    rev = "121bba346411cce23e350b833dc5857ea2239f2f";
    hash = "sha256-2w28N6Fhm6k3wdTYtKH4uLPBIOdELd/aRFDs8UMWMmU=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-yoUAOo8OwUWG0gyI5AdwfRFzSZvSCd3HYzzpJRvdbiM=";
  };

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"

    cp -r node_modules "$out/lib/"

    rm -f "$out/lib/node_modules/@google/gemini-cli"
    rm -f "$out/lib/node_modules/@google/gemini-cli-core"

    cp -r packages/cli "$out/lib/node_modules/@google/gemini-cli"
    cp -r packages/core "$out/lib/node_modules/@google/gemini-cli-core"

    mkdir -p "$out/bin"
    ln -s ../lib/node_modules/@google/gemini-cli/dist/index.js "$out/bin/gemini"

    runHook postInstall
  '';

  postInstall = ''
    chmod +x "$out/bin/gemini"
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "gemini-cli-update-script";
    runtimeInputs = [
      cacert
      curl
      gnused
      jq
      nix-prefetch-github
      prefetch-npm-deps
    ];
    text = ''
      latest_version=$(curl -s "https://raw.githubusercontent.com/google-gemini/gemini-cli/main/package-lock.json" | jq -r '.version')
      latest_rev=$(curl -s "https://api.github.com/repos/google-gemini/gemini-cli/commits/main" | jq -r '.sha')

      src_hash=$(nix-prefetch-github google-gemini gemini-cli --rev "$latest_rev" | jq -r '.hash')

      temp_dir=$(mktemp -d)
      curl -s "https://raw.githubusercontent.com/google-gemini/gemini-cli/$latest_rev/package-lock.json" > "$temp_dir/package-lock.json"
      npm_deps_hash=$(prefetch-npm-deps "$temp_dir/package-lock.json")
      rm -rf "$temp_dir"

      sed -i "s|version = \".*\";|version = \"$latest_version\";|" "pkgs/by-name/ge/gemini-cli/package.nix"
      sed -i "s|rev = \".*\";|rev = \"$latest_rev\";|" "pkgs/by-name/ge/gemini-cli/package.nix"
      sed -i "/src = fetchFromGitHub/,/};/s|hash = \".*\";|hash = \"$src_hash\";|" "pkgs/by-name/ge/gemini-cli/package.nix"
      sed -i "/npmDeps = fetchNpmDeps/,/};/s|hash = \".*\";|hash = \"$npm_deps_hash\";|" "pkgs/by-name/ge/gemini-cli/package.nix"
    '';
  });

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
