{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  cmake,
  writableTmpDirAsHomeHook,
  git,
  nixosTests,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starship";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YoLi4wxBK9TFTtZRm+2N8HO5ZiC3V2GMqKFKKLHq++s=";
  };

  nativeBuildInputs = [
    installShellFiles
    cmake
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ writableTmpDirAsHomeHook ];

  # tries to access HOME only in aarch64-darwin environment when building mac-notification-sys
  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    export HOME=$TMPDIR
  '';

  postInstall =
    ''
      presetdir=$out/share/starship/presets/
      mkdir -p $presetdir
      cp docs/public/presets/toml/*.toml $presetdir
    ''
    + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
      let
        emulator = stdenv.hostPlatform.emulator buildPackages;
      in
      ''
        installShellCompletion --cmd starship \
          --bash <(${emulator} $out/bin/starship completions bash) \
          --fish <(${emulator} $out/bin/starship completions fish) \
          --zsh <(${emulator} $out/bin/starship completions zsh)
      ''
    );

  useFetchCargoVendor = true;
  cargoHash = "sha256-B2CCrSH2aTcGEX96oBxl/27hNMdDpdd2vxdt0/nlN6I=";

  nativeCheckInputs = [ git ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = {
    description = "Minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    downloadPage = "https://github.com/starship/starship";
    changelog = "https://github.com/starship/starship/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      danth
      Br1ght0ne
      Frostman
      awwpotato
    ];
    mainProgram = "starship";
  };
})
