{
  lib,
  rustPlatform,
  clippy,
  rustfmt,
  nixosTests,
}:

let
  cargoToml = fromTOML (builtins.readFile ./Cargo.toml);
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = cargoToml.package.name;
  inherit (cargoToml.package) version;

  __structuredAttrs = true;

  src = lib.sourceFilesBySuffices ./. [
    ".rs"
    ".toml"
    ".lock"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  stripAllList = [ "bin" ];

  passthru.tests = {
    lint-format = finalAttrs.finalPackage.overrideAttrs (
      _: previousAttrs: {
        pname = previousAttrs.pname + "-lint-format";
        nativeCheckInputs = (previousAttrs.nativeCheckInputs or [ ]) ++ [
          clippy
          rustfmt
        ];
        checkPhase = ''
          cargo clippy
          cargo fmt --check
        '';
      }
    );
    inherit (nixosTests) activation-nixos-init;
  };

  binaries = [
    "initrd-init"
    "find-etc"
    "chroot-realpath"
  ];

  postInstall = ''
    for binary in "''${binaries[@]}"; do
      ln -s $out/bin/nixos-init $out/bin/$binary
    done
  '';

  meta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nikstur ];
    platforms = lib.platforms.linux;
  };
})
