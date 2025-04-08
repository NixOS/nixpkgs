{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "riff";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "riff";
    rev = "v${version}";
    hash = "sha256-ThHkEvu+lWojHmEgcrwdZDPROfxznB7vv78msyZf90A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JghCYYDf2keV9UFU5m+qDIIb7+V0aPwVzR41J01pXcI=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  postInstall = ''
    wrapProgram $out/bin/riff --set-default RIFF_DISABLE_TELEMETRY true
  '';

  meta = with lib; {
    description = "Tool that automatically provides external dependencies for software projects";
    mainProgram = "riff";
    homepage = "https://riff.sh";
    changelog = "https://github.com/DeterminateSystems/riff/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
