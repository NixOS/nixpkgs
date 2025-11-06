{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  fuse,
  libxml2,
  pkg-config,
}:

let
  srcs = {
    boxfs2 = fetchFromGitHub {
      sha256 = "10af1l3sjnh25shmq5gdnpyqk4vrq7i1zklv4csf1n2nrahln8j8";
      rev = "d7018b0546d2dae956ae3da3fb95d2f63fa6d3ff";
      repo = "boxfs2";
      owner = "drotiro";
    };
    libapp = fetchFromGitHub {
      sha256 = "1p2sbxiranan2n2xsfjkp3c6r2vcs57ds6qvjv4crs1yhxr7cp00";
      rev = "febebe2bc0fb88d57bdf4eb4a2a54c9eeda3f3d8";
      repo = "libapp";
      owner = "drotiro";
    };
    libjson = fetchFromGitHub {
      sha256 = "1vhss3gq44nl61fbnh1l3qzwvz623gwhfgykf1lf1p31rjr7273w";
      rev = "75a7f50fca2c667bc5f32cdd6dd98f2b673f6657";
      repo = "libjson";
      owner = "vincenthz";
    };
  };
in
stdenv.mkDerivation {
  pname = "boxfs";
  version = "2-20150109";

  src = srcs.boxfs2;

  prePatch = with srcs; ''
    substituteInPlace Makefile --replace "git pull" "true"
    cp -a --no-preserve=mode ${libapp} libapp
    cp -a --no-preserve=mode ${libjson} libjson
  '';
  patches = [
    ./work-around-API-borkage.patch
    ./libapp-include-ctype.diff
  ];

  buildInputs = [
    curl
    fuse
    libxml2
  ];
  nativeBuildInputs = [ pkg-config ];

  buildFlags = [
    "static"
    "CC=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "CFLAGS=-D_BSD_SOURCE";

  installPhase = ''
    mkdir -p $out/bin
    install boxfs boxfs-init $out/bin
  '';

  meta = with lib; {
    description = "FUSE file system for box.com accounts";
    longDescription = ''
      Store files on box.com (an account is required). The first time you run
      boxfs, you will need to complete the authentication (oauth2) process and
      grant access to your box.com account. Just follow the instructions on
      the terminal and in your browser. When you've done using your files,
      unmount the file system with `fusermount -u mountpoint`.
    '';
    homepage = "https://github.com/drotiro/boxfs2";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
