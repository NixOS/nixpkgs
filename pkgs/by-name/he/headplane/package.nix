{
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  git,
  headplane-agent,
  lib,
  makeWrapper,
  nixosTests,
  nodejs_22,
  pnpm_10,
  pnpmConfigHook,
  stdenv,
}:
let
  pname = "headplane";
  # Note, if you are upgrading this, you should upgrade headplane-agent at the same time
  version = "0.6.2";
  pnpmDepsHash = "sha256-CsmffCo9Se/4oiOqbcuhjPMuGmR2GL+YfcyWgzBTAh8=";
  src = fetchFromGitHub {
    owner = "tale";
    repo = "headplane";
    tag = "v${version}";
    hash = "sha256-2C/Pn2M2aHADtoljSFg9hz6xOaZp6IRI77jjy+LDAgw=";
  };

  headplaneSshWasm = buildGoModule {
    pname = "headplane-ssh-wasm";
    inherit version src;
    subPackages = [ "cmd/hp_ssh" ];
    vendorHash = "sha256-MvrqKMD+A+qBZmzQv+T9920U5uJop+pjfJpZdm2ZqEA=";
    env.CGO_ENABLED = 0;
    doCheck = false;
    buildPhase = ''
      export GOOS=js
      export GOARCH=wasm
      go build -o hp_ssh.wasm ./cmd/hp_ssh
    '';

    installPhase = ''
      runHook preInstall
      install -Dm444 hp_ssh.wasm "$out/hp_ssh.wasm"

      # Go's WebAssembly shim (wasm_exec.js) has no stable `go env` key, and
      # different Go packages may place it in different locations under GOROOT.
      #   1. Ask `go env GOROOT` for the active GOROOT.
      #   2. First try the path misc/wasm/wasm_exec.js.
      #   3. If that fails, fall back to searching under GOROOT to handle
      #      distro / OS / packaging layout variations.
      goRoot="$(go env GOROOT)"

      wasm_exec="$goRoot/misc/wasm/wasm_exec.js"
      if [ ! -e "$wasm_exec" ]; then
        wasm_exec="$(find "$goRoot" -path '*wasm_exec.js' -print -quit || true)"
      fi

      if [[ -z "$wasm_exec" || ! -e "$wasm_exec" ]]; then
        echo "ERROR: wasm_exec.js not found under GOROOT=$goRoot" >&2
        exit 1
      fi

      install -Dm444 "$wasm_exec" "$out/wasm_exec.js"
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    git
    makeWrapper
    nodejs_22
    pnpm_10
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    hash = pnpmDepsHash;
    fetcherVersion = 3;
  };

  buildPhase = ''
    runHook preBuild
    cp ${headplaneSshWasm}/hp_ssh.wasm app/hp_ssh.wasm
    cp ${headplaneSshWasm}/wasm_exec.js app/wasm_exec.js
    pnpm --offline build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/headplane}
    cp -r build $out/share/headplane/
    cp -r node_modules $out/share/headplane/
    cp -r drizzle $out/share/headplane/
    substituteInPlace $out/share/headplane/build/server/index.js \
      --replace "$PWD" "../.."
    makeWrapper ${lib.getExe nodejs_22} $out/bin/headplane \
      --chdir $out/share/headplane \
      --add-flags $out/share/headplane/build/server/index.js
    runHook postInstall
  '';

  passthru = {
    agent = headplane-agent;
    tests = { inherit (nixosTests) headplane; };
  };

  meta = {
    description = "Feature-complete Web UI for Headscale";
    homepage = "https://github.com/tale/headplane";
    changelog = "https://github.com/tale/headplane/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      igor-ramazanov
      stealthbadger747
    ];
    mainProgram = "headplane";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
