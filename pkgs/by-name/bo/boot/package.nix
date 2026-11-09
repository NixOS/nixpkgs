{
  lib,
  stdenv,
  fetchurl,
  jdk,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.7.2";
  pname = "boot";

  src = fetchurl {
    url = "https://github.com/boot-clj/boot-bin/releases/download/${finalAttrs.version}/boot.sh";
    sha256 = "1hqp3xxmsj5vkym0l3blhlaq9g3w0lhjgmp37g6y3rr741znkk8c";
  };

  inherit jdk;

  builder = ./builder.sh;

  propagatedBuildInputs = [ jdk ];

  meta = {
    description = "Build tooling for Clojure";
    mainProgram = "boot";
    homepage = "https://boot-clj.github.io/";
    license = lib.licenses.epl10;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ragge ];
  };
})
