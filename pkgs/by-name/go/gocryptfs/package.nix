{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fuse,
  makeWrapper,
  openssl,
  pandoc,
  pkg-config,
  libfido2,
}:

buildGoModule rec {
  pname = "gocryptfs";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H3J+1a4Y6/BqgU7D9j/PNtP6Ci3EjrtO/ADx3GpJMgI=";
  };

  vendorHash = "sha256-WfTJ8TuFupEa391XQMDl3hKTjrmRHJqvYb1haAGHW/U=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    pandoc
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [ libfido2 ];

  ldflags = [
    "-X main.GitVersion=${version}"
    "-X main.GitVersionFuse=[vendored]"
    "-X main.BuildDate=unknown"
  ];

  subPackages = [
    "."
    "gocryptfs-xray"
    "contrib/statfs"
  ];

  postBuild = ''
    pushd Documentation/
    mkdir -p $out/share/man/man1
    # taken from Documentation/MANPAGE-render.bash
    pandoc MANPAGE.md -s -t man -o $out/share/man/man1/gocryptfs.1
    pandoc MANPAGE-XRAY.md -s -t man -o $out/share/man/man1/gocryptfs-xray.1
    pandoc MANPAGE-STATFS.md -s -t man -o $out/share/man/man1/statfs.1
    popd
  '';

  # use --suffix here to ensure we don't shadow /run/wrappers/bin/fusermount,
  # as the setuid wrapper is required to use gocryptfs as non-root on NixOS
  postInstall = ''
    wrapProgram $out/bin/gocryptfs \
      --suffix PATH : ${lib.makeBinPath [ fuse ]}
    ln -s $out/bin/gocryptfs $out/bin/mount.fuse.gocryptfs
  '';

  meta = with lib; {
    description = "Encrypted overlay filesystem written in Go";
    license = licenses.mit;
    homepage = "https://nuetzlich.net/gocryptfs/";
    maintainers = with maintainers; [
      flokli
      offline
      prusnak
    ];
    platforms = platforms.unix;
  };
}
