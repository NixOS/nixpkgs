{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nixosTests,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-ld";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mic92";
    repo = "nix-ld";
    rev = version;
    hash = "sha256-rmSXQ4MYQe/OFDBRlqqw5kyp9b/aeEg0Fg9c167xofg=";
  };

  patches = [
    # Backport fix for Rust 1.81
    (fetchpatch {
      url = "https://github.com/nix-community/nix-ld/commit/9583c80eafc4f904a013713c084e9dc5e47c3675.patch";
      hash = "sha256-glZNdNh+dAmi1xjgcitLymsaQIrEQx4M5VFDOxpDk1Q=";
    })
  ];

  cargoHash = "sha256-BVulfs4zm3Iruq00H49QcxR3V+iZvePtLBTytdXfLP4=";

  hardeningDisable = [ "stackprotector" ];

  NIX_SYSTEM = stdenv.system;
  RUSTC_BOOTSTRAP = "1";

  preCheck = ''
    export NIX_LD=${stdenv.cc.bintools.dynamicLinker}
  '';

  postInstall = ''
    mkdir -p $out/libexec
    ln -s $out/bin/nix-ld $out/libexec/nix-ld

    mkdir -p $out/nix-support

    ldpath=/${stdenv.hostPlatform.libDir}/$(basename ${stdenv.cc.bintools.dynamicLinker})
    echo "$ldpath" > $out/nix-support/ldpath
    mkdir -p $out/lib/tmpfiles.d/
    cat > $out/lib/tmpfiles.d/nix-ld.conf <<EOF
      L+ $ldpath - - - - $out/libexec/nix-ld
    EOF
  '';

  passthru.tests = nixosTests.nix-ld;

  meta = with lib; {
    description = "Run unpatched dynamic binaries on NixOS";
    homepage = "https://github.com/Mic92/nix-ld";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
