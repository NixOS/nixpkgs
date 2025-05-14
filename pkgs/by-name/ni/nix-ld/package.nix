{
  stdenv,
  fetchFromGitHub,
  nixosTests,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-ld";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-ld";
    rev = version;
    hash = "sha256-ULoitJD5bMu0pFvh35cY5EEYywxj4e2fYOpqZwKB1lk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cDbszVjZcomag0HZvXM+17SjDiGS07iPj78zgsXstHc=";

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

  meta = {
    description = "Run unpatched dynamic binaries on NixOS";
    homepage = "https://github.com/nix-community/nix-ld";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.linux;
  };
}
