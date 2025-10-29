{
  lib,
  stdenv,
  fetchurl,
  jdk8,
}:
let
  jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
in
stdenv.mkDerivation rec {
  pname = "libmatthew-java";
  version = "0.8";

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/libmatthew-java/libmatthew-java-${version}.tar.gz/8455b8751083ce25c99c2840609271f5/libmatthew-java-${version}.tar.gz";
    sha256 = "1yldkhsdzm0a41a0i881bin2jklhp85y3ah245jd6fz3npcx7l85";
  };
  JAVA_HOME = jdk;
  PREFIX = "\${out}";
  buildInputs = [ jdk ];

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.sander ];
    license = licenses.mit;
  };
}
