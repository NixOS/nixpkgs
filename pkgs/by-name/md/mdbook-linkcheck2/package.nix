{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-linkcheck2";
  version = "0.12.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "mdbook-linkcheck2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D0pteKtmBDkqcaonbNzL6tyo97x+qQhn6oY88+4VGFE=";
  };

  cargoHash = "sha256-XY1epCro/BqHm95HVP1eK0oVLSPYjD2hU7IdiEkgNMM=";

  propagatedNativeBuildInputs = [ cacert ];

  checkFlags = map (t: "--skip=${t}") [
    "check_all_links_in_a_valid_book"
    "correctly_find_broken_links"
  ];

  # see https://github.com/NixOS/nixpkgs/pull/531531#pullrequestreview-4492334034
  # should be dropped in the next update
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Backend for mdbook which will check your links for you";
    mainProgram = "mdbook-linkcheck2";
    homepage = "https://github.com/marxin/mdbook-linkcheck2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      scandiravian
      stepbrobd
    ];
  };
})
