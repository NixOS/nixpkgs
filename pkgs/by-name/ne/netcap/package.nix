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
  ndpi,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "netcap";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dreadl0ck";
    repo = "netcap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Uc6xx14Ye1PK7iwRSwKCUkXZLGI7kEiw4kOueGYc9A=";
  };

  vendorHash = "sha256-AwColblpH/2zQOxLwiICw+8HSl1qOCVNVqBuCTYTatI=";

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

  env.GOWORK = "off";

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
