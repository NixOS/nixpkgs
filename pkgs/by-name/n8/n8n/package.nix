{
  stdenv,
  lib,
  nixosTests,
  fetchFromGitHub,
  nodejs,
  pnpm,
  python3,
  nodePackages,
  cacert,
  xcbuild,
  libkrb5,
  libmongocrypt,
  postgresql,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n8n";
  version = "1.46.0";

  src = fetchFromGitHub {
    owner = "n8n-io";
    repo = "n8n";
    rev = "n8n@${finalAttrs.version}";
    hash = "sha256-9T/x2k7XIO+PV0olTQhb4WF1congTbXFvHqaxoaNbp4=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-oldvZC0B/r3fagI5hCn16wjQsD9n4q9foo73lJBJXeU=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    python3 # required to build sqlite3 bindings
    nodePackages.node-gyp # required to build sqlite3 bindings
    cacert # required for rustls-native-certs (dependency of turbo build tool)
    makeWrapper
  ] ++ lib.optional stdenv.isDarwin [ xcbuild ];

  buildInputs = [
    nodejs
    libkrb5
    libmongocrypt
    postgresql
  ];

  buildPhase = ''
    runHook preBuild

    pushd node_modules/sqlite3
    node-gyp rebuild
    popd

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,bin}
    cp -r {packages,node_modules} $out/lib

    makeWrapper $out/lib/packages/cli/bin/n8n $out/bin/n8n \
      --set N8N_RELEASE_TYPE "stable"

    runHook postInstall
  '';

  # makes libmongocrypt bindings not look for static libraries in completely wrong places
  BUILD_TYPE = "dynamic";

  passthru = {
    tests = nixosTests.n8n;
  };

  dontStrip = true;

  meta = with lib; {
    description = "Free and source-available fair-code licensed workflow automation tool";
    longDescription = ''
      Free and source-available fair-code licensed workflow automation tool.
      Easily automate tasks across different services.
    '';
    homepage = "https://n8n.io";
    changelog = "https://github.com/n8n-io/n8n/releases/tag/${finalAttrs.src.rev}";
    maintainers = with maintainers; [
      freezeboy
      gepbird
      k900
    ];
    license = licenses.sustainableUse;
    mainProgram = "n8n";
    platforms = lib.platforms.unix;
  };
})
