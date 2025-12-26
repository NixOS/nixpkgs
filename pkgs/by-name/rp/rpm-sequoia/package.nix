{
  stdenv,
  fetchFromGitHub,
  lib,
  nettle,
  nix-update-script,
  rustPlatform,
  pkg-config,
  runCommand,
}:

rustPlatform.buildRustPackage rec {
  pname = "rpm-sequoia";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "rpm-sequoia";
    tag = "v${version}";
    hash = "sha256-/PdbCBpEWig+acLvrN5nhJ6ca+tAh2bpqDLTRJoFuWU=";
  };

  cargoHash = "sha256-Qi46nlgX/k2rRAvCToXkfZpjt7ERu25/4WUIIQUOC/I=";

  patches = [
    ./objdump.patch
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  propagatedBuildInputs = [ nettle ];

  # Tests will parse the symbols, on darwin we have two issues:
  # - library name is hardcoded to librpm_sequoia.so
  # - The output of the objdump differs and the parsing logic needs to be adapted
  doCheck = !stdenv.hostPlatform.isDarwin;

  outputs = [
    "out"
    "dev"
  ];

  # Ensure the generated .pc file gets the correct prefix
  env.PREFIX = placeholder "out";

  # Install extra files, the same as this is done on fedora:
  # https://src.fedoraproject.org/rpms/rust-rpm-sequoia/blob/f41/f/rust-rpm-sequoia.spec#_81
  preInstall =
    # Install the generated pc file for consumption by the dependents
    ''
      install -Dm644 target/release/rpm-sequoia.pc -t $dev/lib/pkgconfig
    ''
    +
      # Dependents will rely on the versioned symlinks
      lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
        install -d $out/lib
        find target/release/ \
          -maxdepth 1 \
          -type l -name 'librpm_sequoia.*' \
          -exec cp --no-dereference {} $out/lib/ \;
      ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -d $out/lib
      ln -s librpm_sequoia.dylib $out/lib/librpm_sequoia.${version}.dylib
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenPGP backend for rpm using Sequoia PGP";
    homepage = "https://sequoia-pgp.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ baloo ];
  };
}
