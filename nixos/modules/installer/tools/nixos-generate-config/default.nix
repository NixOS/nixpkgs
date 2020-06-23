with import <nixpkgs> {};

let
  # FIXME:
  # move nixos-generate-config manpages out of this since users can disable manpages
  # and updating manpages generate unnecessary rebuild of this package itself.
  nixos-manpages = (import <nixpkgs/nixos> {}).config.system.build.manual.manpages;
  vendoredCrates =
    let
      lockFile = builtins.fromTOML (builtins.readFile ./Cargo.lock);

      files = map (pkg: pkgs.fetchurl {
        url = "https://crates.io/api/v1/crates/${pkg.name}/${pkg.version}/download";
        sha256 = pkg.checksum;
      }) (builtins.filter (pkg: pkg.source or "" == "registry+https://github.com/rust-lang/crates.io-index") lockFile.package);

    in pkgs.runCommand "cargo-vendor-dir" {}
      ''
        mkdir -p $out/vendor

        cat > $out/vendor/config <<EOF
        [source.crates-io]
        replace-with = "vendored-sources"

        [source.vendored-sources]
        directory = "vendor"
        EOF

        ${toString (builtins.map (file: ''
          mkdir $out/vendor/tmp
          tar xvf ${file} -C $out/vendor/tmp
          dir=$(echo $out/vendor/tmp/*)

          # Add just enough metadata to keep Cargo happy.
          printf '{"files":{},"package":"${file.outputHash}"}' > "$dir/.cargo-checksum.json"

          # Clean up some cruft from the winapi crates. FIXME: find
          # a way to remove winapi* from our dependencies.
          if [[ $dir =~ /winapi ]]; then
            find $dir -name "*.a" -print0 | xargs -0 rm -f --
          fi

          mv "$dir" $out/vendor/

          rm -rf $out/vendor/tmp
        '') files)}
      '';

in stdenv.mkDerivation {
  name = "nixos-generate-config";

  src = ./.;

  nativeBuildInputs = [
    rustc cargo
  ];

  buildPhase = ''
    ln -sfn ${vendoredCrates}/vendor/ vendor
    export CARGO_HOME=$(pwd)/vendor
    cargo build --release --offline
  '';

  installPhase = ''
    install -D -m755 ./target/release/nixos-generate-config \
       $out/bin/nixos-generate-config
  '';

  NIXOS_MANPAGES = "${nixos-manpages}/share/man";
  MAN_EXECUTABLE = "${man-db}/bin/man";

  doCheck = true;
  checkInputs = [
    man-db
  ];
  checkPhase = ''
    cargo test --release -- --nocapture
  '';
}
