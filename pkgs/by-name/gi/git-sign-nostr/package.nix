{
  buzz-cli,
  lib,
  fetchpatch2,
  runCommand,
  rustPlatform,
  gitMinimal,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-sign-nostr";
  # Shares the Buzz workspace source and Cargo lockfile with buzz-cli.
  inherit (buzz-cli)
    version
    src
    cargoHash
    preBuild
    env
    ;

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # Restore BIP-340 curve point validation under nostr 0.44 (block/buzz#6175).
    # https://github.com/block/buzz/pull/8031
    (fetchpatch2 {
      name = "git-sign-nostr-restore-bip340-validation.patch";
      url = "https://github.com/block/buzz/commit/c37be32090d6e3598b3251dc4372a52141d225d8.patch?full_index=1";
      includes = [ "crates/git-sign-nostr/*" ];
      hash = "sha256-GlWyW2T8k/+fIs8dPI9sDnVdd52S8Eegi0yBGG4X37s=";
    })
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = [ gitMinimal ];

  cargoBuildFlags = [ "--package=git-sign-nostr" ];
  cargoTestFlags = [ "--package=git-sign-nostr" ];

  postInstall = ''
    wrapProgram $out/bin/git-sign-nostr \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  passthru.tests.sign-and-verify =
    runCommand "git-sign-nostr-sign-and-verify"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          gitMinimal
        ];
      }
      ''
        export HOME=$TMPDIR
        git init -q repo && cd repo
        git config user.name test
        git config user.email test@example.com
        git config gpg.format x509
        git config gpg.x509.program git-sign-nostr
        # Test-only key (secret key 1).
        git config user.signingkey 79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
        NOSTR_PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000000001 git commit -q -S --allow-empty -m test
        # Quoted: stdenv enables nullglob, which would drop an unquoted `%G?`.
        test "$(git log -1 --format='%G?')" = G
        touch $out
      '';

  meta = {
    description = "NIP-GS git commit/tag signing program using Nostr secp256k1 keys";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "git-sign-nostr";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
