{ lib, stdenv, fetchurl, fetchpatch, ncurses, db }:

stdenv.mkDerivation rec {
  pname = "nvi";
  version = "1.81.6";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/n/nvi/nvi_${version}.orig.tar.gz";
    sha256 = "13cp9iz017bk6ryi05jn7drbv7a5dyr201zqd3r4r8srj644ihwb";
  };

  patches = [
    # Fix runtime error with modern versions of db.
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/nvi/raw/f33/f/nvi-03-db4.patch";
      sha256 = "1vpnly3dcldwl8gwl0jrh5yh0vhgbdhsh6xn7lnwhrawlvk6d55y";
    })

    # Fix build with Glibc.
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/nvi/raw/f33/f/nvi-20-glibc_has_grantpt.patch";
      sha256 = "1ypqj263wh53m5rgiag5c4gy1rksj2waginny1lcj34n72p2dsml";
    })
  ];

  buildInputs = [ ncurses db ];

  preConfigure = ''
    cd build.unix
  '';
  configureScript = "../dist/configure";
  configureFlags = [ "vi_cv_path_preserve=/tmp" ];

  meta = with lib; {
    description = "Berkeley Vi Editor";
    license = licenses.free;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/nvi.x86_64-darwin
  };
}
