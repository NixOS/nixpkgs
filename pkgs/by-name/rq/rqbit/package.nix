{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  aws-lc,
  cacert,
  buildNpmPackage,
  nodejs,
  nix-update-script,
  nixosTests,
  versionCheckHook,
}:
let
  pname = "rqbit";

  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-qY40Yx+OyiwNP/pht0RFMJhgcFsKPz4rymUmANEJOBw=";
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

  cargoHash = "sha256-nG2phD/dwNxas5fGtSqtRxpAniXjv1KbvVDuRF7fiSg=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    aws-lc
  ];

  # so we dont need openssl and aws-lc
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "rust-tls"
    "webui"
  ];

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

  nativeCheckInputs = [ cacert ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

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
