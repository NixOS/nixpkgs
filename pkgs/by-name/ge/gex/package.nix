{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = "gex";
    rev = "v${version}";
    hash = "sha256-Xer7a3UtFIv3idchI7DfZ5u6qgDW/XFWi5ihtcREXqo=";
  };

  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script { };

  buildInputs =
    [
      libgit2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  cargoPatches = [
    ./patch-libgit2.patch
  ];

  cargoHash = "sha256-GEQ4Zv14Dzo9mt1YIDmXEBHLPD6G0/O1ggmUTnSYD+k=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    changelog = "https://github.com/Piturnah/gex/releases/tag/${src.rev}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      azd325
      bot-wxt1221
      evanrichter
      piturnah
    ];
    mainProgram = "gex";
  };
}
