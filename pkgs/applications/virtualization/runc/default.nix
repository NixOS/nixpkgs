{ stdenv, lib, fetchFromGitHub, fetchpatch, removeReferencesTo, go-md2man
, go, pkgconfig, libapparmor, apparmor-parser, libseccomp }:

with lib;

stdenv.mkDerivation rec {
  name = "runc-${version}";
  version = "1.0.0-rc4";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
    sha256 = "0dh24x0zw90hs7618pnqvjhd2nx8dpz3b5jwc1vbs8dawj8prir2";
  };

  outputs = [ "out" "man" ];

  hardeningDisable = ["fortify"];

  buildInputs = [ removeReferencesTo go-md2man go pkgconfig libseccomp libapparmor apparmor-parser ];

  makeFlags = ''BUILDTAGS+=seccomp BUILDTAGS+=apparmor'';

  preConfigure = ''
    # Extract the source
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/github.com/opencontainers"
    mv "$sourceRoot" "go/src/github.com/opencontainers/runc"
    export GOPATH=$NIX_BUILD_TOP/go:$GOPATH
  '';

  preBuild = ''
    cd go/src/github.com/opencontainers/runc
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
