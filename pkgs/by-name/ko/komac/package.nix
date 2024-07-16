{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, openssl
, rustPlatform
, darwin
, versionCheckHook
}:

let
  version = "2.2.1";
  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    rev = "v${version}";
    hash = "sha256-dPX8/JUQ+vugd+M/jIjBf4/sNbac0FVQ0obhyAAGI84=";
  };
in
rustPlatform.buildRustPackage {
  inherit version src;

  pname = "komac";

  cargoHash = "sha256-CDPN90X3m/9FRLolAVCIcAuajZbB5OAgLcFXq2ICS8g=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Community Manifest Creator for WinGet";
    homepage = "https://github.com/russellbanks/Komac";
    changelog = "https://github.com/russellbanks/Komac/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kachick ];
    mainProgram = "komac";
  };
}
