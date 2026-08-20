{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  buildNpmPackage,
  nodejs,
  nix-update-script,
  nixosTests,
  versionCheckHook,
}:
let
  pname = "rqbit";

  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-zcd3oVNntKxV25UWan//H523ph227Yhub/3N0wLfPiU=";
  };

  rqbit-webui = buildNpmPackage {
    pname = "rqbit-webui";

    inherit version src nodejs;

    npmWorkspace = [ "crates/librqbit/webui" ];

    npmDepsHash = "sha256-4q8u2B3HB19mBaEAVl9EDtt38e8aYHpUMADNaT98P7M=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r ./crates/librqbit/webui/dist/** $out/dist

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-h0dPVqiQtkFo50CNHYn5Cqrm+l/j6RNJtFYUVyvioxI=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  preConfigure = ''
    mkdir -p crates/librqbit/webui/dist
    cp -R ${rqbit-webui}/dist/** crates/librqbit/webui/dist
  '';

  postPatch = ''
    # This script fascilitates the build of the webui,
    #  we've already built that
    rm crates/librqbit/build.rs
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd rqbit --$shell <($out/bin/rqbit completions $shell)
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  checkFlags = [
    # skip these tests since they require internet access
    "--skip=tests::e2e::test_e2e_download_tcp"
    "--skip=tests::e2e::test_e2e_download_utp"
    "--skip=tests::e2e_stream::test_e2e_stream"
    "--skip=upnp_server_adapter::tests::test_browse"
  ];

  # required by test `read_buf::tests::can_read_long_metainfo_correctlyv` in `aarch64-darwin`(sandbox=relaxed)
  __darwinAllowLocalNetworking = true;

  passthru = {
    webui = rqbit-webui;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "webui"
      ];
    };
    tests.testService = nixosTests.rqbit;
  };

  meta = {
    description = "Bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    changelog = "https://github.com/ikatson/rqbit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cafkafk
      toasteruwu
    ];
    mainProgram = "rqbit";
  };
}
