{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
  withDpi ? true,
  libpcap,
  libprotoident,
  libflowmanager,
  libtrace,
  versionCheckHook,
  nix-update-script,
}:
let
  ndpi = callPackage ./ndpi_4_0.nix { };
in
buildGoModule (finalAttrs: {
  pname = "netcap";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "dreadl0ck";
    repo = "netcap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SCBKOIC/s+rfrVWmryp9EBp7ARpZZcxymsnZWtEHrhk=";
  };

  vendorHash = "sha256-MvHrJLhcFA0fEgK+YT0rwI6wIwTGMcLWQt6AYkx1eZM=";

  subPackages = [ "cmd" ];

  buildInputs = [
    libpcap
  ]
  ++ lib.optionals withDpi [
    ndpi
    libprotoident
    libflowmanager
    libtrace
  ];

  ldflags = [
    "-s -w"
  ];

  tags = lib.optionals (!withDpi) [
    "nodpi"
  ];

  CGO_LDFLAGS = lib.optionalString withDpi ''
    -L${ndpi}/lib -lndpi
    -L${libprotoident}/lib -lndpi
  '';

  CGO_CFLAGS = lib.optionalString withDpi ''
    -I${ndpi}/include
    -I${libprotoident}/include
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/net
  '';

  checkFlags =
    let
      skippedTests = [
        # couldn't open packet socket: operation not permitted
        "TestCaptureLive"
        # requires local test data
        "TestCapturePCAP"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/net";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework for secure and scalable network traffic analysis";
    homepage = "https://netcap.io";
    downloadPage = "https://github.com/dreadl0ck/netcap";
    changelog = "https://github.com/dreadl0ck/netcap/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "net";
  };
})
