{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  ncurses,
  db,
}:

# XXX: sendmail?

let
  pname = "nvi";
  version = "1.81.6";
  deb_version = "23";

  base_url = "mirror://debian/pool/main/n/${pname}/${pname}_${version}";

  debian-extras = fetchzip {
    url = "${base_url}-${deb_version}.debian.tar.xz";
    hash = "sha256-dR7vZtCV5PjUDlNTWxubxH7eucizkPRaMlyNdziud84=";
  };
in
stdenv.mkDerivation rec {
  inherit pname;
  inherit version;

  src = fetchurl {
    url = "${base_url}.orig.tar.gz";
    sha256 = "13cp9iz017bk6ryi05jn7drbv7a5dyr201zqd3r4r8srj644ihwb";
  };

  buildInputs = [
    ncurses
    db
  ];

  # Debian maintains lots of patches for nvi. Let's include all of them.
  prePatch = ''
    patches="$patches $(cat ${debian-extras}/patches/series | sed 's|^|${debian-extras}/patches/|')"
  '';

  preConfigure = ''
    cd build.unix
  '';
  configureScript = "../dist/configure";
  configureFlags = [
    "--disable-curses"
    "--disable-shared"
    "--enable-static"
    "--enable-widechar"
    "--disable-threads"
    "--without-x"
    "--with-gnu-ld=yes"
    # "ac_cv_path_vi_cv_path_sendmail=sendmail"
    "vi_cv_path_preserve=/tmp"
    "vi_cv_path_shell=/bin/sh"
    "vi_cv_revoke=no"
  ];

  meta = with lib; {
    description = "Berkeley Vi Editor";
    license = licenses.free;
    maintainers = with maintainers; [ suominen ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/nvi.x86_64-darwin
  };
}
