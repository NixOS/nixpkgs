{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  libusb1,
  iproute2,
}:

buildGoModule (finalAttrs: {
  pname = "go-ios";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "danielpaulus";
    repo = "go-ios";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5fMsHSwJUH/JBaZXyB11rHCNOqzHF3MYI9gg29hj0O4=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Bl9nlRnclqVgFF6mS6DX6oS+1c26DoISqDBY2rMS2yw=";

  excludedPackages = [
    "restapi"
    "test/e2e"
  ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail 'const version = ' 'var version = '
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace ncm/linux_commands.go \
      --replace-fail "ip " "${lib.getExe' iproute2 "ip"} "
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace ios/tunnel/tunnel_darwin.go \
      --replace-fail "ifconfig" "/sbin/ifconfig"
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  postInstall = ''
    # aligns the binary with what is expected from go-ios
    mv $out/bin/go-ios $out/bin/ios
  '';

  # skips all the integration tests (requires iOS device) (`-tags=fast`)
  # as well as tests that requires networking
  checkFlags =
    let
      skippedTests = [
        "TestWorksWithoutProxy"
        "TestUsesProxy"
      ];
    in
    [ "-tags=fast" ] ++ [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Operating system independent implementation of iOS device features";
    homepage = "https://github.com/danielpaulus/go-ios";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
    mainProgram = "ios";
  };
})
