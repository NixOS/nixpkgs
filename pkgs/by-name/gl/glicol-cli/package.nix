{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, darwin
, alsa-lib
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

  cargoHash = "sha256-fJ18SwVMotepUvdNPQumFWoOaotDzGTerb+Iy+qq5w0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AudioUnit
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
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
