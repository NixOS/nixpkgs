{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  yarn-berry_4,
  python3,
  pkg-config,
  libsecret,
}:

let
  version = "1.2.4"; # Language server version from packages/ansible-language-server/package.json
  vscodeVersion = "25.12.3"; # vscode-ansible release version
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ansible-language-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "vscode-ansible";
    tag = "v${vscodeVersion}";
    hash = "sha256-PLvNXLLuSG9vm4+LrzJbQ3vBxagnBA/QnpO8yiZbqRs=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-4ldRcpJgWibCetKSyOcGie+F+2FMstAUK/DyBZWqPbA=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
    (python3.withPackages (ps: with ps; [ setuptools ]))
    pkg-config
  ];

  buildInputs = [
    nodejs
    libsecret
  ];

  # Skip downloading electron and other binaries - we only need the language server
  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    yarn workspace @ansible/ansible-language-server compile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ansible-language-server
    cp -r packages/ansible-language-server/{out,bin,package.json} $out/lib/ansible-language-server/

    # Copy node_modules but remove broken workspace symlinks
    cp -r node_modules $out/lib/ansible-language-server/
    rm -f $out/lib/ansible-language-server/node_modules/@ansible/ansible-language-server
    rm -f $out/lib/ansible-language-server/node_modules/@ansible/ansible-mcp-server
    rm -f $out/lib/ansible-language-server/node_modules/.bin/ansible-language-server

    mkdir -p $out/bin
    makeBinaryWrapper ${nodejs}/bin/node $out/bin/ansible-language-server \
      --add-flags "$out/lib/ansible-language-server/out/server/src/server.js" \
      --add-flags "--stdio"

    runHook postInstall
  '';

  meta = {
    description = "Ansible Language Server";
    homepage = "https://github.com/ansible/vscode-ansible";
    license = lib.licenses.mit;
    maintainers = [ ];
    teams = [ lib.teams.cachix ];
    mainProgram = "ansible-language-server";
    platforms = lib.platforms.unix;
  };
})
