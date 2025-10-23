{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  libusb1,
  iproute2,
  net-tools,
}:

buildGoModule rec {
  pname = "go-ios";
  version = "1.0.182";

  src = fetchFromGitHub {
    owner = "danielpaulus";
    repo = "go-ios";
    rev = "v${version}";
    sha256 = "sha256-GUCZiuW6IDVxVsFZN7QMRt5EFovxjUopC4jQD+/lZv8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-/aVaTC9lfoXQvhDVQm31HmXBnDYYOv6RH69Nm3I/K7s=";

  excludedPackages = [
    "restapi"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace ncm/linux_commands.go \
      --replace-fail "ip " "${lib.getExe' iproute2 "ip"} "

    substituteInPlace ios/tunnel/tunnel.go \
      --replace-fail "ifconfig" "${lib.getExe' net-tools "ifconfig"}"
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

  meta = with lib; {
    description = "Operating system independent implementation of iOS device features";
    homepage = "https://github.com/danielpaulus/go-ios";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
    mainProgram = "ios";
  };
}
