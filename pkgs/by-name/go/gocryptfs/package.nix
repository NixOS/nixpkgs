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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lStaMj2f8lQZx2E42o4ikPmFQzydlN3PFKwFvUx37SI=";
  };

  vendorHash = "sha256-ir7FR7ndbPhzUOCVPrYO0SEe03wDFIP74I4X6HJxtE8=";

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
