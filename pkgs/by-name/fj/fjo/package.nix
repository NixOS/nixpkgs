{
  lib,
  stdenv,
  fetchFromGitea,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "fjo";
  version = "0.3.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "VoiDD";
    repo = "fjo";
    rev = "v${version}";
    hash = "sha256-KjH78yqfZoN24TBYyFZuxf7z9poRov0uFYQ8+eq9p/o=";
  };

  cargoHash = "sha256-2G/TdajAqKiSoTL5FnukfS/eHkTNaGOj9EFpKsdb02k=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "CLI Tool for Codeberg similar to gh and glab";
    homepage = "https://codeberg.org/VoiDD/fjo";
    license = lib.licenses.agpl3Only;
    mainProgram = "berg";
    maintainers = with lib.maintainers; [ ehmry ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
