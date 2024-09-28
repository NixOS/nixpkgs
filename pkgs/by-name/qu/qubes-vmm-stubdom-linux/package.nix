# Qubes standard stubdom is too hard to build using nix infrastructure.
# In the future, it will be better to replace it with NixOS based stubdom, or maybe based on dockerTools build system?
{fetchurl, stdenv, rpmextract}:
let
  version = "4.3.0-1";
  stubdom = fetchurl {
    url = "https://ftp.qubes-os.org/repo/yum/r4.3/current-testing/dom0/fc41/rpm/xen-hvm-stubdom-linux-${version}.fc41.x86_64.rpm";
    hash = "sha256-iVMOuZmqgXIrlKFL+ftoBA3qntKjwB3dmz5KEfra26E=";
  };
  stubdom-full = fetchurl {
    url = "https://ftp.qubes-os.org/repo/yum/r4.3/current-testing/dom0/fc41/rpm/xen-hvm-stubdom-linux-full-${version}.fc41.x86_64.rpm";
    hash = "sha256-wRHnc9dM5NEIHsiSEjQ1aasD73xdpKEq1IFbfjpn7ag=";
  };
in
stdenv.mkDerivation {
  name = "qubes-vmm-stubdom-linux";
  src = null;
  unpackPhase = "true";
  buildPhase = "true";

  nativeBuildInputs = [rpmextract];

  installPhase = ''
    mkdir $out
    rpmextract ${stubdom}
    rpmextract ${stubdom-full}
    mv usr/libexec $out/
  '';
}
