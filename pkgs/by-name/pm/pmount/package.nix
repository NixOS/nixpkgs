{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  intltool,
  ntfs3g,
  util-linux,
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
          url = "https://salsa.debian.org/debian/pmount/-/raw/ba05283d4a53aba5349d4397a98d9f45206fb29f/debian/patches/${name}";
        };
    in
    map fetchDebPatch [
      {
        name = "10_fix-spelling-binary-errors.patch";
        hash = "sha256-G4GsUe1ZdYB7Qv333X1hUjOELITR8A2pqyfEnMDTwHI=";
      }
      {
        name = "20_fix-spelling-manpage-error.patch";
        hash = "sha256-9phF8s7MFSjkhPP24cipeBUps5W1L7YmAE0B1QPx5jk=";
      }
      {
        name = "fix-implicit-function-declaration.patch";
        hash = "sha256-kdwdS9G1X5RtQFKzF6oMIUubGNP7n1ZQNHu8sN1oV4Q=";
      }
      {
        name = "30_exfat-support.patch";
        hash = "sha256-kg9gLhOtdrEDlZfUnT910xI5rNR1zgKKRx2kvFQjbi8=";
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
  };
}
