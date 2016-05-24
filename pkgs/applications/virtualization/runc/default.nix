{ stdenv, fetchFromGitHub, md2man
, go, libapparmor, apparmor-parser, libseccomp }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "runc-${rev}";
  rev = "baf6536d";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "${rev}";
    sha256 = "09fm7f1k4lvx8v3crqb0cli1x2brlz8ka7f7qa8d2sb6ln58h7w7";
  };
  outputs = [ "out" "man" ];
  buildInputs = [ md2man go libseccomp libapparmor apparmor-parser ];

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

  meta = with stdenv.lib; {
    homepage = https://runc.io/;
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
