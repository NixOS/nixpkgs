{
  lib,
  stdenv,
  fetchFromGitHub,
  lz4,
}:

stdenv.mkDerivation {
  pname = "nx2elf";
  version = "0-unstable-2021-11-21";

  src = fetchFromGitHub {
    owner = "shuffle2";
    repo = "nx2elf";
    rev = "735aaa0648a5a6c996b48add9465db86524999f6";
    sha256 = "sha256-cS8FFIEgDWva0j9JXhS+s7Y4Oh+mNhFaKRI7BF2hqvs=";
  };

  buildInputs = [ lz4 ];

  postPatch = ''
    # pkg-config is not supported, so we'll manually devendor lz4
    cp ${lz4.src}/lib/lz4.{h,c} .
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D nx2elf $out/bin/nx2elf
  '';

  meta = with lib; {
    homepage = "https://github.com/shuffle2/nx2elf";
    description = "Convert Nintendo Switch executable files to ELFs";
    license = licenses.unfree; # No license specified upstream
    platforms = [ "x86_64-linux" ]; # Should work on Darwin as well, but this is untested. aarch64-linux fails.
    maintainers = [ ];
    mainProgram = "nx2elf";
  };
}
