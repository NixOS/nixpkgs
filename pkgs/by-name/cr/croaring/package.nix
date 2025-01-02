{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "croaring";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "RoaringBitmap";
    repo = "CRoaring";
    rev = "v${version}";
    hash = "sha256-WaFyJ/6zstJ05e3vfrwhaZKQsjRAEvVTs688Hw0fr94=";
  };

  # roaring.pc.in cannot handle absolute CMAKE_INSTALL_*DIRs, nor
  # overridden CMAKE_INSTALL_FULL_*DIRs. With Nix, they are guaranteed
  # to be absolute so the following patch suffices (see #144170).
  patches = [ ./fix-pkg-config.patch ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  preConfigure = ''
    mkdir -p dependencies/.cache
    ln -s ${
      fetchFromGitHub {
        owner = "clibs";
        repo = "cmocka";
        rev = "f5e2cd7";
        hash = "sha256-Oq0nFsZhl8IF7kQN/LgUq8VBy+P7gO98ep/siy5A7Js=";
      }
    } dependencies/.cache/cmocka
  '';

  meta = with lib; {
    description = "Compressed bitset library for C and C++";
    homepage = "https://roaringbitmap.org/";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ maintainers.orivej ];
    platforms = platforms.all;
  };
}
