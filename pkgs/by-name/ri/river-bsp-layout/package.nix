{ 
  lib
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
  bottom,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "river-bsp-layout";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "areif-dev";
    repo = pname;
    rev = version;
    hash = "sha256-2348939e0f23f1df61a71f139d58d1267b0de408455c4b8ea3db229421bf8631";
  };

  cargoHash = "sha256-cd1090816ed927703c0de800cef448b38662901946e6239ab3e81136e31d0fa9";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Foundation
  ];

  doCheck = false;

  postInstall = ''
  '';

  passthru.tests.version = testers.testVersion {
    package = river-bsp-layout;
  };

  meta = with lib; {
    description = "Custom River layout manager that creates a Binary Space Partition / Grid layout using river-layout-toolkit";
    homepage = "https://github.com/areif-dev/river-bsp-layout";
    changelog = "https://github.com/areif-dev/river-bsp-layout/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    mainProgram = "river-bsp-layout";
  };
}
