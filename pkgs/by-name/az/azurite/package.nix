{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  darwin,
  libsecret,
  pkg-config,
  python3,
}:

buildNpmPackage rec {
  pname = "azurite";
  version = "3.33.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "Azurite";
    rev = "v${version}";
    hash = "sha256-aH9FAT49y4k87lzerQdgLqi+ZlucORQX4w1NBFtEfMw=";
  };

  npmDepsHash = "sha256-jfa04iWz0aOiFD1YkXn5YEXqQcrY+rIDbVmmUaA5sYc=";

  nativeBuildInputs = [
    pkg-config
    python3
  ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libsecret
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin;
      [
        Security
        apple_sdk.frameworks.AppKit
      ]
    );

  meta = {
    description = "An open source Azure Storage API compatible server";
    homepage = "https://github.com/Azure/Azurite";
    changelog = "https://github.com/Azure/Azurite/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danielalvsaaker ];
    mainProgram = "azurite";
  };
}
