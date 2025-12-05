{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  python3Packages,
}:
let
  inherit (python3Packages) mkdocs mkdocs-material;
in
stdenvNoCC.mkDerivation {
  pname = "internalallthethings";
  version = "0-unstable-2025-08-03";

  src = fetchFromGitHub {
    owner = "swisskyrepo";
    repo = "InternalAllTheThings";
    rev = "73dace3eb95540bde6c8982f471f7758467f0ed1";
    hash = "sha256-Vs4UKlQefwrlsuEr5aFbdr0kYF5wVzOe1HRjBQSMpIo=";
  };

  patches = [ ./mkdocs.patch ];

  nativeBuildInputs = [
    mkdocs
    mkdocs-material
  ];

  outputs = [
    "out"
    "doc"
  ];

  buildPhase = ''
    mkdocs build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $doc/share/internalallthethings
    cp -r site/* $doc/share/internalallthethings

    mkdir -p $out/share/internalallthethings
    rm -r mkdocs.yml site
    cp -r * $out/share/internalallthethings
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/swisskyrepo/InternalAllTheThings";
    description = "Active Directory and Internal Pentest Cheatsheets";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
