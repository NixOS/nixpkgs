{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  fetchFromGitHub,
  nix-update-script,
  nvd,
  # Make optional as nom is AGPL. This mirrors nix-community/nh/package.nix
  use-nom ? true,
  nix-output-monitor ? null,
  buildPackages,
}:
assert use-nom -> nix-output-monitor != null;
let
  runtimeDeps = [ nvd ] ++ lib.optionals use-nom [ nix-output-monitor ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BCD0tfDNlQHFM75THRtXM3GegMg/KbREsYllg7Az9ao=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  preFixup = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mkdir completions
      ${emulator} $out/bin/nh completions bash > completions/nh.bash
      ${emulator} $out/bin/nh completions zsh > completions/nh.zsh
      ${emulator} $out/bin/nh completions fish > completions/nh.fish

      installShellCompletion completions/*
    ''
  );

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-cNYPxM2DOLdyq0YcZ0S/WIa3gAx7aTzPp7Zhbtu4PKg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/nix-community/nh/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Yet another nix cli helper";
    homepage = "https://github.com/nix-community/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [
      drupol
      NotAShelf
      viperML
    ];
  };
})
