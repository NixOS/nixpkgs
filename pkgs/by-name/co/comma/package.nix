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
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dNek1a8Yt3icWc8ZpVe1NGuG+eSoTDOmAAJbkYmMocU=";
  };

  cargoHash = "sha256-SJBfWjOVrv2WMIh/cQbaFK8jn3oSbmJpdJM7pkJppDs=";

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
