{ lib, fetchFromGitHub, buildGoPackage, go-md2man
, pkgconfig, libapparmor, apparmor-parser, libseccomp, which }:

with lib;

buildGoPackage rec {
  pname = "runc";
  version = "1.0.0-rc9";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
    sha256 = "1ss5b46cbbckyqlwgj8dbd5l59c5y0kp679hcpc0ybaj53pmwxj7";
  };

  goPackagePath = "github.com/opencontainers/runc";
  outputs = [ "bin" "out" "man" ];

  hardeningDisable = ["fortify"];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ go-md2man libseccomp libapparmor apparmor-parser which ];

  makeFlags = [ "BUILDTAGS+=seccomp" "BUILDTAGS+=apparmor" ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    substituteInPlace libcontainer/apparmor/apparmor.go \
      --replace /sbin/apparmor_parser ${apparmor-parser}/bin/apparmor_parser
    make ${toString makeFlags} runc
  '';

  installPhase = ''
    install -Dm755 runc $bin/bin/runc

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

  meta = {
    homepage = https://runc.io/;
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline vdemeester saschagrunert ];
    platforms = platforms.linux;
  };
}
