{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
  db,
}:

stdenv.mkDerivation rec {
  pname = "nvi";
  version = "1.81.6";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/n/nvi/nvi_${version}.orig.tar.gz";
    sha256 = "13cp9iz017bk6ryi05jn7drbv7a5dyr201zqd3r4r8srj644ihwb";
  };

  patches =
    # Apply patches from debian package
    map fetchurl (import ./debian-patches.nix);

  buildInputs = [
    ncurses
    db
  ];

  preConfigure = ''
    cd build.unix
  '';
  configureScript = "../dist/configure";
  configureFlags = [
    "vi_cv_path_preserve=/tmp"
    "--enable-widechar"
  ];

  meta = with lib; {
    description = "Berkeley Vi Editor";
    license = licenses.free;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/nvi.x86_64-darwin
  };
}
