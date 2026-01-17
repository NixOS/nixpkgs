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
  version = "0-unstable-2025-11-27";

  src = fetchFromGitHub {
    owner = "swisskyrepo";
    repo = "InternalAllTheThings";
    rev = "9a97b9d16e5f9834b4ef2276b6cd1b98a0748b6e";
    hash = "sha256-NaQeRmO1JtKYZyTAhKXovDi7pZ9Zbu7Yi4iHORCU67A=";
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
    platforms = mkdocs.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
