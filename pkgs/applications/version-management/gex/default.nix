{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Xer7a3UtFIv3idchI7DfZ5u6qgDW/XFWi5ihtcREXqo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # force the libgit2-sys crate to use the system libgit2 library
  LIBGIT2_NO_VENDOR = 1;

  cargoHash = "sha256-HNz1wwn0eUhNR6ZLLPMse8LmAS4CzADx0ZR9gJgJQCg=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    changelog = "https://github.com/Piturnah/gex/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 evanrichter piturnah ];
    mainProgram = "gex";
  };
}
