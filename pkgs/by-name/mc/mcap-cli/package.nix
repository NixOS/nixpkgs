{
  stdenv,
  lib,
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
let
  version = "0.0.46";
in
buildGoModule {

  pname = "mcap-cli";

  inherit version;

  src = fetchFromGitHub {
    repo = "mcap";
    owner = "foxglove";
    rev = "releases/mcap-cli/v${version}";
    hash = "sha256-UdR5A2ZtCcnQIjPxlwcntZb78CXzJBvRy73GJUqvjuM=";
  };

  vendorHash = "sha256-ofJYarmnOHONu2lZ76GvSua0ViP1gr6968xAuQ/VRNk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  modRoot = "go/cli/mcap";

  env.GOWORK = "off";

  # copy the local versions of the workspace modules
  postConfigure = ''
    chmod -R u+w vendor
    rm -rf vendor/github.com/foxglove/mcap/go/{mcap,ros}
    cp -r ../../{mcap,ros} vendor/github.com/foxglove/mcap/go
  '';

  checkFlags = [
    # requires git-lfs and network
    # https://github.com/foxglove/mcap/issues/895
    "-skip=TestCat|TestInfo"
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd mcap \
        --bash <(${emulator} $out/bin/mcap completion bash) \
        --fish <(${emulator} $out/bin/mcap completion fish) \
        --zsh <(${emulator} $out/bin/mcap completion zsh)
    ''
  );
  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "MCAP CLI tool to inspect and fix MCAP files";
    homepage = "https://github.com/foxglove/mcap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      squalus
      therishidesai
    ];
    mainProgram = "mcap";
  };

}
