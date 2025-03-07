{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "justify";
  version = "unstable-2022-03-19";

  src = fetchFromGitea {
    domain = "tildegit.org";
    owner = "jns";
    repo = "justify";
    rev = "0d397c20ed921c8e091bf18e548d174e15810e62";
    sha256 = "sha256-406OhJt2Ila/LIhfqJXhbFqFxJJiRyMVI4/VK8Y43kc=";
  };

  postPatch = ''
    sed '1i#include <algorithm>' -i src/stringHelper.h # gcc12
  '';

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -D justify $out/bin/justify
  '';

  meta = with lib; {
    homepage = "https://tildegit.org/jns/justify";
    description = "Simple text alignment tool that supports left/right/center/fill justify alignment";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    mainProgram = "justify";
    maintainers = with maintainers; [ xfnw ];
  };
}
