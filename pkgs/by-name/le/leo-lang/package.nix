{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  curl,
}:

rustPlatform.buildRustPackage rec {
  pname = "leo-lang";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "ProvableHQ";
    repo = "leo";
    tag = "v${version}";
    hash = "sha256-PWm//tgtmDWYYe7RwMfIqrtivwvbqAyXqAVqHN/yR4Y=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-remove-update-subcommand.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-OY/JTnF1eBfS+AM7nPulcgpr03Xceuooc3E+ADL4Wvk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Functional, statically-typed programming language built for writing private applications";
    homepage = "https://github.com/ProvableHQ/leo";
    changelog = "https://github.com/ProvableHQ/leo/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ anstylian ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
}
