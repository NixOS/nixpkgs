{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "popl";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AkqFRPK0tVdalL+iyMou0LIUkPkFnYYdSqwEbFbgzqI=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src/include/popl.hpp $out/include/popl.hpp

    runHook postInstall
  '';

  meta = with lib; {
    description = "Header-only C++ program options parser library";
    homepage = "https://github.com/badaix/popl";
    changelog = "https://github.com/badaix/popl/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
