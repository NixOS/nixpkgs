{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "projectable";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "dzfrias";
    repo = "projectable";
    rev = version;
    hash = "sha256-GM/dPmLnv1/Qj6QhBxPu5kO/SDnbY7Ntupf1FGkmrUY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-b/jB34Y1QXJsOLBliNeOxm1l4TIoEex5y6pDVPC4UVw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices
    ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "TUI file manager built for projects";
    homepage = "https://github.com/dzfrias/projectable";
    changelog = "https://github.com/dzfrias/projectable/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "prj";
  };
}
