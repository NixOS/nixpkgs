{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  libgit2,
  zlib,
  zstd,
  installShellFiles,
  makeBinaryWrapper,
  git,
  gnugrep,
  cosign,
  skopeo,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bluebuild";
  version = "0.9.42";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "blue-build";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aak/kKlTuv+SMU63s7okejvdCH+aIOHTE2798wTT46s=";
  };

  cargoHash = "sha256-TSkPhKPnduaOPOyqdxCvaLO+TSAwsyJROaSqO4gF0tM=";

  buildFeatures = [ "v1_0_0" ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = [
    aws-lc
    libgit2
    zlib
    zstd
  ];

  nativeCheckInputs = [ cosign ];
  cargoTestFlags = [ "--workspace" ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/bluebuild README.md
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bluebuild \
      --bash <($out/bin/bluebuild completions bash) \
      --fish <($out/bin/bluebuild completions fish) \
      --zsh <($out/bin/bluebuild completions zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/bluebuild \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          gnugrep
          cosign
          skopeo
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Build custom atomic Linux images from recipes";
    homepage = "https://blue-build.org/";
    changelog = "https://github.com/blue-build/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _4evy ];
    mainProgram = "bluebuild";
    platforms = lib.platforms.linux;
  };
})
