{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  intltool,
  ntfs3g,
  util-linux,
  cryptsetup,
  mediaDir ? "/media/",
  lockDir ? "/var/lock/pmount",
  whiteList ? "/etc/pmount.allow",
}:

# constraint mention in the configure.ac
assert lib.hasSuffix "/" mediaDir;

stdenv.mkDerivation rec {
  pname = "pmount";
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://debian/pool/main/p/pmount/pmount_${version}.orig.tar.bz2";
    sha256 = "db38fc290b710e8e9e9d442da2fb627d41e13b3ee80326c15cc2595ba00ea036";
  };

  patches =
    let
      # https://salsa.debian.org/debian/pmount/-/tree/debian/master/debian/patches
      fetchDebPatch =
        { name, hash }:
        fetchpatch {
          inherit name hash;
          url = "https://salsa.debian.org/debian/pmount/-/raw/430e4634aa7a2e6a5a91852c5b0fd3698b186000/debian/patches/${name}";
        };
    in
    map fetchDebPatch [
      {
        name = "02-fix-spelling-binary-errors.patch";
        hash = "sha256-ukGHDqsG3Eo/0bhv2GPwX0N6uZOI+3BowMY+l1wtd9o=";
      }
      {
        name = "03-fix-spelling-manpage-error.patch";
        hash = "sha256-rsa3t165+yWBOnRV3SnOMmYSuNuydZtnOdydUzcjDaQ=";
      }
      {
        name = "04-fix-implicit-function-declaration.patch";
        hash = "sha256-Le8gVIW72oZGymN7gM5uOGNEhrzOTirnilNedUkSpco=";
      }
      {
        name = "05-exfat-support.patch";
        hash = "sha256-Yl9QuA8tMIej4nQIbYibcUVFJdgnVaN+34/xoJp5NbU=";
      }
      {
        name = "06-C99-implicit-function-declaration-fixes.patch";
        hash = "sha256-xFFfl9BkBqbUSAKaJwvKNgHyWbxUO5wKyEpwz3anwdM=";
      }
      {
        name = "07-Add-probing-for-Btrfs.patch";
        hash = "sha256-9SKyLAVmZTGgsAi9aCxkw1OzWVcegoZy2DaupiS9kPA=";
      }
      {
        name = "08-Support-btlkOpen-alongside-of-luksOpen.patch";
        hash = "sha256-2PJky3lRUKkOB2Js86XN8gqmYMxpsUbLJ39XnrirCDw=";
      }
      {
        name = "09-Probe-for-f2fs.patch";
        hash = "sha256-VMnrSEaIPwEfbUi+Q88vQdSBQgq4+jJ19Bjc/ueemnw=";
      }
    ];

  nativeBuildInputs = [
    intltool
    util-linux
  ];
  buildInputs = [ util-linux ];

  configureFlags = [
    "--with-media-dir=${mediaDir}"
    "--with-lock-dir=${lockDir}"
    "--with-whitelist=${whiteList}"
    "--with-mount-prog=${util-linux}/bin/mount"
    "--with-umount-prog=${util-linux}/bin/umount"
    "--with-mount-ntfs3g=${ntfs3g}/sbin/mount.ntfs-3g"
    "--with-cryptsetup-prog=${cryptsetup}/bin/cryptsetup"
  ];

  postConfigure = ''
    # etc/Mafile.am is hardcoded and it does not respect the --prefix option.
    substituteInPlace ./etc/Makefile --replace DESTDIR prefix
    # Do not change ownership & Do not add the set user ID bit
    substituteInPlace ./src/Makefile --replace '-o root -g root -m 4755 ' '-m 755 '
  '';

  doCheck = false; # fails 1 out of 1 tests with "Error: could not open fstab-type file: No such file or directory"

  meta = {
    homepage = "https://bazaar.launchpad.net/~fourmond/pmount/main/files";
    description = "Mount removable devices as normal user";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ratakor ];
  };
}
