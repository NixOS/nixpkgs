{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "xmlformat";
  version = "1.9-unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "someth2say";
    repo = "xmlformat";
    rev = "172a7db1bde6abe91836048a20afe2805a963e76";
    hash = "sha256-gtG4PaSqrnRoUWiVtrs8/k3qc8j8++5eJj9pqEo20Bk=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/xmlformat.pl $out/bin/xmlformat
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Configurable formatter (or 'pretty-printer') for XML documents";
    homepage = "https://github.com/someth2say/xmlformat";
    license = lib.licenses.gpl3Only;
    mainProgram = "xmlformat";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = lib.platforms.all;
  };
}
