{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, pkg-config
, libusb1
}:

buildGoModule rec {
  pname = "go-ios";
  version = "1.0.150";

  src = fetchFromGitHub {
    owner = "danielpaulus";
    repo = "go-ios";
    rev = "v${version}";
    sha256 = "sha256-xa2/qshZ4k+Df5l817BXlotR6L/CX6Lw2+tWDYnr96I=";
  };

  proxyVendor = true;
  vendorHash = "sha256-/aVaTC9lfoXQvhDVQm31HmXBnDYYOv6RH69Nm3I/K7s=";

  excludedPackages = [
    "restapi"
  ];

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
  checkFlags = let
    skippedTests = [
      "TestWorksWithoutProxy"
      "TestUsesProxy"
    ];
  in [ "-tags=fast" ]
  ++ [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Operating system independent implementation of iOS device features";
    homepage = "https://github.com/danielpaulus/go-ios";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
    mainProgram = "ios";
  };
}
