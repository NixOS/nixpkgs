{
  stdenv,
  fetchFromGitHub,
  nixosTests,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-ld";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "mic92";
    repo = "nix-ld";
    rev = version;
    hash = "sha256-NRkLjdMtVfC6dD1gEbYZWFEtbmC2xfD6ft1IP7l76Vw=";
  };

  patches = [ ./rust-1.83.patch ];

  cargoHash = "sha256-GOngDGRzWVuzGTX5xNb/nv5dJ6is6cH8K6kHTX3OoXE=";

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
