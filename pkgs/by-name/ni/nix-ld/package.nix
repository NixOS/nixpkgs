{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "nix-ld";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "mic92";
    repo = "nix-ld";
    rev = version;
    hash = "sha256-h+odOVyiGmEERMECoFOj5P7FPiMR8IPRzroFA4sKivg=";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [
    "-Dnix-system=${stdenv.system}"
  ];

  hardeningDisable = [
    "stackprotector"
  ];

  postInstall = ''
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
