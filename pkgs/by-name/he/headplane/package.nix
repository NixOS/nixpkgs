{
  buildGoModule,
  fetchFromGitHub,
  git,
  go,
  lib,
  makeWrapper,
  nodejs_22,
  pnpm_10,
  stdenv,
}:
let
  pname = "headplane";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "tale";
    repo = "headplane";
    tag = "v${version}";
    hash = "sha256-hsrnmEwKXJlPjV4aIfmS6GAE414ArVRGoPPpZGmV0x4=";
  };

  headplaneSshWasm = buildGoModule {
    pname = "headplane-ssh-wasm";
    inherit version src;
    subPackages = ["cmd/hp_ssh"];
    vendorHash = "sha256-MvrqKMD+A+qBZmzQv+T9920U5uJop+pjfJpZdm2ZqEA=";
    env.CGO_ENABLED = 0;

    nativeBuildInputs = [go];

    buildPhase = ''
      export GOOS=js
      export GOARCH=wasm
      go build -o hp_ssh.wasm ./cmd/hp_ssh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp hp_ssh.wasm "$out/"
      cp "${
        if builtins.pathExists "${go}/share/go/lib/wasm/wasm_exec.js"
        then "${go}/share/go/lib/wasm/wasm_exec.js"
        else if builtins.pathExists "${go}/lib/wasm/wasm_exec.js"
        then "${go}/lib/wasm/wasm_exec.js"
        else "${go}/share/go/misc/wasm/wasm_exec.js"
      }" "$out/wasm_exec.js"
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
    pnpm_10.configHook
    git
  ];

  dontCheckForBrokenSymlinks = true;

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-H06zDYElXXiZepqxH/uCdePW6jB6VjiAX7bXnVjxwq0=";
    fetcherVersion = 1;
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

  meta = {
    description = "Feature-complete Web UI for Headscale";
    homepage = "https://github.com/tale/headplane";
    changelog = "https://github.com/tale/headplane/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.igor-ramazanov lib.maintainers.stealthbadger747 ];
    mainProgram = "headplane";
    platforms = lib.platforms.unix;
  };
})
