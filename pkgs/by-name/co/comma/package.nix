{
  stdenv,
  comma,
  fetchFromGitHub,
  installShellFiles,
  fzy,
  lib,
  nix-index-unwrapped,
  nix,
  rustPlatform,
  testers,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comma";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XZB0zx4wyNzy0LggAmh2gT2aEWAqVI9NljRoOkeK0c8=";
  };

  cargoHash = "sha256-lY5HwWZm9X0xusLcC6MciAgSWEskNElrjhe9fexR6g8=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace ./src/main.rs \
      --replace-fail '"nix-locate"' '"${lib.getExe' nix-index-unwrapped "nix-locate"}"' \
      --replace-fail '"nix"' '"${lib.getExe nix}"' \
      --replace-fail '"nix-env"' '"${lib.getExe' nix "nix-env"}"' \
      --replace-fail '"fzy"' '"${lib.getExe fzy}"'
  '';

  postInstall = ''
    ln -s $out/bin/comma $out/bin/,

    mkdir -p $out/share/comma

    cp $src/etc/command-not-found.sh $out/share/comma
    cp $src/etc/command-not-found.nu $out/share/comma
    cp $src/etc/command-not-found.fish $out/share/comma

    patchShebangs $out/share/comma/command-not-found.sh
    substituteInPlace \
      "$out/share/comma/command-not-found.sh" \
      "$out/share/comma/command-not-found.nu" \
      "$out/share/comma/command-not-found.fish" \
      --replace-fail "comma --ask" "$out/bin/comma --ask"
  ''
  + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    ${stdenv.hostPlatform.emulator buildPackages} "$out/bin/comma" --mangen > comma.1
    installManPage comma.1
  '';

  passthru.tests = {
    version = testers.testVersion { package = comma; };
  };

  meta = {
    homepage = "https://github.com/nix-community/comma";
    description = "Runs programs without installing them";
    license = lib.licenses.mit;
    mainProgram = "comma";
    maintainers = with lib.maintainers; [ artturin ];
  };
})
