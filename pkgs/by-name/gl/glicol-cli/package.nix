{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "glicol-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "glicol";
    repo = "glicol-cli";
    rev = "v${version}";
    hash = "sha256-v90FfF4vP5UPy8VnQFvYMKiCrledgNMpWbJR59Cv6a0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-u6H+4cikI/jmcKpA2Ty2DjZF8wLiNylFMInA6sdNl0k=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AudioUnit
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ];

  meta = with lib; {
    description = "Cross-platform music live coding in terminal";
    homepage = "https://github.com/glicol/glicol-cli";
    changelog = "https://github.com/glicol/glicol-cli/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "glicol-cli";
  };
}
