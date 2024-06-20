{
  lib,
  stdenv,
  fetchgit,
  build2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libstudxml";
  version = "1.1.0-b.10+2";

  src = fetchgit {
    url = "https://git.codesynthesis.com/libstudxml/libstudxml.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OsjMhQ3u/wLhOay7qg9sQMEhnAOdrO30dsKQ8aDWUOo=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ build2 ];

  # lib files are not marked as executable by default
  postInstall = ''
    chmod +x "$out"/lib/*
  '';

  meta = {
    description = "A streaming XML pull parser and streaming XML serializer implementation for modern, standard C++";
    homepage = "https://www.codesynthesis.com/projects/libstudxml/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
