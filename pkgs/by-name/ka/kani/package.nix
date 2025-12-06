{
  lib,
  rustPlatform,
  fetchCrate,
  fetchpatch2,
  makeBinaryWrapper,
  patchelf,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kani";
  version = "0.66.0";

  src = fetchCrate {
    pname = "kani-verifier";
    inherit (finalAttrs) version;
    hash = "sha256-mBulUFutwdHhaUtpe9r96kLmF/ZouW7NPiqA9Gb5TyY=";
  };
  cargoHash = "sha256-HNkdsJh45YNujEsbwOB5ZBv7YH2d2eWRyUwhSAS+LNQ=";

  patches = [
    # Kani does not patch downloaded executables if it find /lib64/ld-linux-x86-64.so.2
    # but on some NixOS installations this linker does not to anything.
    # Make Kani patch them if it detects a NixOS stub linker.
    # Will probably be included 0.67.
    (fetchpatch2 {
      name = "kani-stub-ld.patch";
      url = "https://github.com/model-checking/kani/commit/76a4adc4de498b16b9ad3cf9ae77e53ed9c54c7a.patch";
      hash = "sha256-hTkzfjlEWNEd0FshaR9+EVUEdblTk/weV0Ij7E/H9dQ=";
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];
  buildInputs = [
    patchelf
  ];

  # Kani's builtin solution for patching binaries on Nix relies on NIX_CC being present.
  preFixup = ''
    for file in $out/bin/* ; do
      wrapProgram $file --set NIX_CC $NIX_CC --prefix PATH : ${lib.makeBinPath [ patchelf ]}
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A bit-precise model checker for Rust";
    homepage = "https://github.com/model-checking/kani";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ sandarukasa ];
    changelog = "https://github.com/model-checking/kani/releases/tag/kani-${finalAttrs.version}";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "kani";
  };
})
