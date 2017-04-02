{ stdenv, lib, fetchFromGitHub, fetchpatch, removeReferencesTo, go-md2man
, go, pkgconfig, libapparmor, apparmor-parser, libseccomp }:

with lib;

stdenv.mkDerivation rec {
  name = "runc-${version}";
  version = "1.0.0-rc2";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
    sha256 = "06bxc4g3frh4i1lkzvwdcwmzmr0i52rz4a4pij39s15zaigm79wk";
  };

  patches = [
    # Two patches to fix CVE-2016-9962
    # From https://bugzilla.suse.com/show_bug.cgi?id=1012568
    (fetchpatch {
      name = "0001-libcontainer-nsenter-set-init-processes-as-non-dumpa.patch";
      url = "https://bugzilla.suse.com/attachment.cgi?id=709048&action=diff&context=patch&collapsed=&headers=1&format=raw";
      sha256 = "1cfsmsyhc45a2929825mdaql0mrhhbrgdm54ly0957j2f46072ck";
    })
    (fetchpatch {
      name = "0002-libcontainer-init-only-pass-stateDirFd-when-creating.patch";
      url = "https://bugzilla.suse.com/attachment.cgi?id=709049&action=diff&context=patch&collapsed=&headers=1&format=raw";
      sha256 = "1ykwg1mbvsxsnsrk9a8i4iadma1g0rgdmaj19dvif457hsnn31wl";
    })
  ];

  outputs = [ "out" "man" ];

  hardeningDisable = ["fortify"];

  buildInputs = [ removeReferencesTo go-md2man go pkgconfig libseccomp libapparmor apparmor-parser ];

  makeFlags = ''BUILDTAGS+=seccomp BUILDTAGS+=apparmor'';

  preBuild = ''
    patchShebangs .
    substituteInPlace libcontainer/apparmor/apparmor.go \
      --replace /sbin/apparmor_parser ${apparmor-parser}/bin/apparmor_parser
  '';

  installPhase = ''
    install -Dm755 runc $out/bin/runc

    # Include contributed man pages
    man/md2man-all.sh -q
    manRoot="$man/share/man"
    mkdir -p "$manRoot"
    for manDir in man/man?; do
      manBase="$(basename "$manDir")" # "man1"
      for manFile in "$manDir"/*; do
        manName="$(basename "$manFile")" # "docker-build.1"
        mkdir -p "$manRoot/$manBase"
        gzip -c "$manFile" > "$manRoot/$manBase/$manName.gz"
      done
    done
  '';

  preFixup = ''
    find $out/bin -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    homepage = https://runc.io/;
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
