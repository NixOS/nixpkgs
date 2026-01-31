{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  buildNpmPackage,
  nodejs,
  nix-update-script,
  nixosTests,
  installShellFiles,
  buildPackages,
}:
let
  pname = "rqbit";

  version = "9.0.0-beta.2";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-48gWvfPsmsQAifxHHCNpWYE8cGxdA4I4c27yqykSNK0=";
  };

  rqbit-webui = buildNpmPackage {
    pname = "rqbit-webui";

    inherit version src nodejs;

    npmWorkspace = [ "crates/librqbit/webui" ];

    npmDepsHash = "sha256-78mSuT6D49F0SWJIHBxZBKS0bZImwXXqk+lfmzL2R70=";

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

  cargoHash = "sha256-cOB4hgwGIT6NzNI45cp755ysABtXVXQ45cweJPqKdWU=";

  nativeBuildInputs =
    (lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ])
    ++ (lib.optionals (stdenv.hostPlatform.emulatorAvailable buildPackages) [ installShellFiles ]);

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

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd rqbit \
        --bash <(${emulator} $out/bin/rqbit completions bash) \
        --fish <(${emulator} $out/bin/rqbit completions fish) \
        --zsh <(${emulator} $out/bin/rqbit completions zsh)
    ''
  );

  doCheck = false;

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
