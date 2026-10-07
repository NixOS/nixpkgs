{
  buzz-cli,
  lib,
  jq,
  runCommand,
  rustPlatform,
  gitMinimal,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-credential-nostr";
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

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = [ gitMinimal ];

  cargoBuildFlags = [ "--package=git-credential-nostr" ];
  cargoTestFlags = [ "--package=git-credential-nostr" ];

  postInstall = ''
    wrapProgram $out/bin/git-credential-nostr \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  passthru.tests.nip98-credential =
    runCommand "git-credential-nostr-nip98"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          jq
        ];
      }
      ''
        # Test-only key (secret key 1).
        printf 'capability[]=authtype\nprotocol=https\nhost=example.com\npath=git/o/r.git\nwwwauth[]=Nostr method="POST"\n\n' \
          | NOSTR_PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000000001 git-credential-nostr get > reply
        grep -Fx 'authtype=Nostr' reply
        sed -n 's/^credential=//p' reply | base64 -d > event.json
        jq -e '.kind == 27235 and .pubkey == "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"' event.json
        jq -e 'any(.tags[]; . == ["u", "https://example.com/git/o/r.git"])' event.json
        touch $out
      '';

  meta = {
    description = "Git credential helper producing NIP-98 authentication headers for Nostr git repositories";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "git-credential-nostr";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
