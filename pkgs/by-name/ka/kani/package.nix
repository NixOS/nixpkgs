{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  patchelf,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kani";
  version = "0.67.0";

  __structuredAttrs = true;

  src = fetchCrate {
    pname = "kani-verifier";
    inherit (finalAttrs) version;
    hash = "sha256-m0khwmHJAiEtICN/f2IE70A2/0JNKwaL3so429YtdOY=";
  };
  cargoHash = "sha256-KAFLA97yi74riDkBO3EJ9Uv6SdVQrJ1wLNJ68Jf9yWk=";

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
