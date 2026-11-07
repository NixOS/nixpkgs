{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  stdenv,
}:
buildNpmPackage (finalAttrs: {
  pname = "node-re2";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "uhop";
    repo = "node-re2";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-076Zm5c9uCJ/OQeLTZnYgUubIL2ron+wKA1gTe3x41U=";
  };

  npmDepsHash = "sha256-QLzoOO5Mb13U1NfShuohJrqP+s1wRemwb8XRrqhKYkE=";

  env.NODE_PLATFORM = with stdenv.hostPlatform.node; "${platform}-${arch}";

  installPhase = ''
    runHook preInstall

    # NOTE: this uses build platform's node. Let's hope that the node ABI version is identical between platforms
    nodeApi=$(node -e 'console.log(process.versions.modules)')

    # Taken from https://github.com/uhop/install-artifact-from-github/wiki/install%E2%80%90from%E2%80%90cache#command-line-parameters
    targetName="$NODE_PLATFORM-$nodeApi"

    install -Dm755 build/Release/re2.node "$out/$targetName"

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Node.js bindings for RE2 (binary only)";
    homepage = "https://github.com/uhop/node-re2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.all;
  };
})
