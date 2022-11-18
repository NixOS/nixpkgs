{ lib, stdenv, fetchurl, autoPatchelfHook, dpkg, gcc-unwrapped, zlib, pkg-config, openssl, python310 }:

# TODO: Build Sapling from source
# This is currently hard. The canonical way to build, `make install-oss`, pulls
# dependencies from the network which isn't hermetic. It also copies a bunch of
# artifacts (conch_paser.so, edenscm-isl, ghstack, and a few others) into the
# target, which would need to be replicated.
let
  version = "20221116-203146-2c1a971a";
  binaryVersion = "0.0-${builtins.replaceStrings ["-"] ["."] version}";
in
stdenv.mkDerivation rec {
  name = "sapling";
  inherit version;

  src = fetchurl {
    url = "https://github.com/facebook/sapling/releases/download/${version}/sapling_${binaryVersion}_amd64.Ubuntu22.04.deb";
    sha256 = "sha256-Lj8psxadt3AKF+0bjysxp0wLWbpeMoTXjAe9VB8rI28=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    gcc-unwrapped
    zlib
    openssl
    python310
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    mv $out/usr/* $out
    rm -rf $out/usr
  '';

  meta = {
    description = "A scalable, user-friendly source control system";
    homepage = "https://sapling-scm.com/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pbar ];
    platforms = [ "x86_64-linux" ];
  };
}
