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
  version = "0.0.56";
in
buildGoModule {

  pname = "mcap-cli";

  inherit version;

  src = fetchFromGitHub {
    repo = "mcap";
    owner = "foxglove";
    rev = "releases/mcap-cli/v${version}";
    hash = "sha256-PPllUAkcuv/FXIjsuJFJ9KbzA6qHCaOBQz77N7D2JtA=";
  };

  vendorHash = "sha256-twuXJXiGhjTqlEZ3xD8G9CruSLxFC33PMs2GZadl1Ow=";

  nativeBuildInputs = [
    installShellFiles
  ];

  modRoot = "go/cli/mcap";

  tags = [
    "sqlite_omit_load_extension"
  ]
  ++ lib.optionals stdenv.isLinux [
    "netgo"
    "osusergo"
  ];

  ldflags = [ "-X github.com/foxglove/mcap/go/cli/mcap/cmd.Version=${version}" ];

  env = {
    CGO_ENABLED = "1";
    GOWORK = "off";
  };

  # copy the local versions of the workspace modules
  postConfigure = ''
    chmod -R u+w vendor
    rm -rf vendor/github.com/foxglove/mcap/go/{mcap,ros}
    cp -r ../../{mcap,ros} vendor/github.com/foxglove/mcap/go
  '';

  checkFlags = [
    # requires git-lfs and network
    # https://github.com/foxglove/mcap/issues/895
    "-skip=TestCat|TestInfo|TestRequiresDuplicatedSchemasForIndexedMessages|TestPassesIndexedMessagesWithRepeatedSchemas|TestSortFile"
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
