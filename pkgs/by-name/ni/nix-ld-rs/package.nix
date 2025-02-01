{
  stdenv,
  fetchFromGitHub,
  nixosTests,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage {
  name = "nix-ld-rs";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-ld-rs";
    rev = "f7154a6aedba4917c8cc72b805b79444b5bfafca";
    sha256 = "sha256-tx6gO6NR4BnYVhoskyvQY9l6/8sK0HwoDHvsYcvIlgo=";
  };

  cargoHash = "sha256-4IDu5qAgF4Zq4GOsimuy8NiRCN9PXM+8oVzD2GO3QmM=";

  hardeningDisable = [ "stackprotector" ];

  NIX_SYSTEM = stdenv.system;
  RUSTC_BOOTSTRAP = "1";

  preCheck = ''
    export NIX_LD=${stdenv.cc.bintools.dynamicLinker}
  '';

  postInstall = ''
    mkdir -p $out/libexec
    ln -s $out/bin/nix-ld-rs $out/libexec/nix-ld-rs
    ln -s $out/bin/nix-ld-rs $out/libexec/nix-ld

    mkdir -p $out/nix-support

    ldpath=/${stdenv.hostPlatform.libDir}/$(basename ${stdenv.cc.bintools.dynamicLinker})
    echo "$ldpath" > $out/nix-support/ldpath
    mkdir -p $out/lib/tmpfiles.d/
    cat > $out/lib/tmpfiles.d/nix-ld.conf <<EOF
      L+ $ldpath - - - - $out/libexec/nix-ld-rs
    EOF
  '';

  passthru.tests = nixosTests.nix-ld;

  meta = with lib; {
    description = "Run unpatched dynamic binaries on NixOS (rust version)";
    homepage = "https://github.com/nix-community/nix-ld-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
