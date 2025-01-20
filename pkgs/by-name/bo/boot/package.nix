{
  lib,
  stdenv,
  fetchurl,
  jdk,
}:

stdenv.mkDerivation rec {
  version = "2.7.2";
  pname = "boot";

  src = fetchurl {
    url = "https://github.com/boot-clj/boot-bin/releases/download/${version}/boot.sh";
    sha256 = "1hqp3xxmsj5vkym0l3blhlaq9g3w0lhjgmp37g6y3rr741znkk8c";
  };

  inherit jdk;

  builder = ./builder.sh;

  propagatedBuildInputs = [ jdk ];

  meta = with lib; {
    description = "Build tooling for Clojure";
    mainProgram = "boot";
    homepage = "https://boot-clj.github.io/";
    license = licenses.epl10;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ragge ];
  };
}
