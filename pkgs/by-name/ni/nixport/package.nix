{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
  nix,
  bubblewrap,
  zstd,
  gnutar,
  util-linux,
  coreutils,
  glibc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixport";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "aiv-tmc";
    repo = "nixport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KO0JzbndfJB1hgbyBABkIMf1QU7Rrz82SrItFhd38MY=";
  };

  cargoHash = "sha256-RkfqkEzSfAryUPrkeKvuTUQFKMEXskb52yeMDv0zzq0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/nixport \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          bubblewrap
          zstd
          gnutar
          util-linux
          coreutils
          glibc.bin
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable Nix applications in a single file";
    homepage = "https://github.com/aiv-tmc/nixport";
    changelog = "https://github.com/aiv-tmc/nixport/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aiv-tmc ];
    mainProgram = "nixport";
    platforms = lib.platforms.linux;
  };
})
