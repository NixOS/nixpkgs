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
  version = "0.13.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "mdbook-linkcheck2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HLV3LqMUbaUL/AMlid0oamceeWiac6zydjQYuujCp3M=";
  };

  cargoHash = "sha256-TcMiConcI8KMptOS67J+faPtCRnMCJxrWqFs3o19XMA=";

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
