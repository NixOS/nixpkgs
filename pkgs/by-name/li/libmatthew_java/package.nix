{
  lib,
  stdenv,
  fetchurl,
  jdk8,
}:
let
  jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libmatthew-java";
  version = "0.8";

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/libmatthew-java/libmatthew-java-${finalAttrs.version}.tar.gz/8455b8751083ce25c99c2840609271f5/libmatthew-java-${finalAttrs.version}.tar.gz";
    sha256 = "1yldkhsdzm0a41a0i881bin2jklhp85y3ah245jd6fz3npcx7l85";
  };
  JAVA_HOME = jdk;
  PREFIX = "\${out}";
  buildInputs = [ jdk ];

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
