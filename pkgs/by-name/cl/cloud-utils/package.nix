{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, makeWrapper
, gawk
, gnused
, util-linux
, file
, wget
, python3
, qemu-utils
, e2fsprogs
, cdrkit
, gptfdisk
}:
let
  # according to https://packages.debian.org/sid/cloud-image-utils + https://packages.debian.org/sid/admin/cloud-guest-utils
  guestDeps = [
    e2fsprogs
    gptfdisk
    gawk
    gnused
    util-linux
  ];
  binDeps = guestDeps ++ [
    wget
    file
    qemu-utils
    cdrkit
  ];
in
stdenv.mkDerivation rec {
  # NOTICE: if you bump this, make sure to run
  # $ nix-build nixos/release-combined.nix -A nixos.tests.ec2-nixops
  # growpart is needed in initrd in nixos/system/boot/grow-partition.nix
  pname = "cloud-utils";
  version = "0.33";
  src = fetchFromGitHub {
    owner = "canonical";
    repo = "cloud-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-YqfkmYclPZu6Mc2bFYxtiuH7uvfa3V4YlD0aHuKn1hw=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];
  installFlags = [ "LIBDIR=$(out)/lib" "BINDIR=$(out)/bin" "MANDIR=$(out)/man/man1" "DOCDIR=$(out)/doc" ];

  # $guest output contains all executables needed for cloud-init and $out the rest + $guest
  # This is similar to debian's package split into cloud-image-utils and cloud-guest-utils
  # The reason is to reduce the closure size
  outputs = [ "out" "guest" ];

  postFixup = ''
    moveToOutput bin/ec2metadata $guest
    moveToOutput bin/growpart $guest
    moveToOutput bin/vcs-run $guest

    for i in $out/bin/*; do
      wrapProgram $i --prefix PATH : "${lib.makeBinPath binDeps}:$out/bin"
    done

    for i in $guest/bin/*; do
      wrapProgram $i --prefix PATH : "${lib.makeBinPath guestDeps}:$guest/bin"
      ln -s $i $out/bin
    done
  '';

  dontBuild = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Useful set of utilities for interacting with a cloud";
    homepage = "https://github.com/canonical/cloud-utils";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
