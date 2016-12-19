{ stdenv, lib, fetchFromGitHub, go-md2man
, go, pkgconfig, libapparmor, apparmor-parser, libseccomp }:

with lib;

stdenv.mkDerivation rec {
  name = "runc-${version}";
  version = "2016-06-15";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "cc29e3dded8e27ba8f65738f40d251c885030a28";
    sha256 = "18fwb3kq10zhhx184yn3j396gpbppy3y4ypb8m2b2pdms39s6pyx";
  };

  outputs = [ "out" "man" ];

  hardeningDisable = ["fortify"];

  buildInputs = [ go-md2man go pkgconfig libseccomp libapparmor apparmor-parser ];

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
    # remove references to go compiler
    while read file; do
      sed -ri "s,${go},$(echo "${go}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" $file
    done < <(find $out/bin -type f 2>/dev/null)
  '';

  meta = {
    homepage = https://runc.io/;
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
