{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  python3Packages,
  yq,
}:
let
  inherit (python3Packages) mkdocs mkdocs-material pymdown-extensions;
in
stdenvNoCC.mkDerivation {
  pname = "payloadsallthethings";
  version = "2025.1";

  src = fetchFromGitHub {
    owner = "swisskyrepo";
    repo = "PayloadsAllTheThings";
    tag = "4.2";
    hash = "sha256-LBPlGfmIyzgRhUdAJmPxjDB7D8iRHcSA8Tf5teMnFzA=";
  };

  patches = [ ./mkdocs.patch ];

  nativeBuildInputs = [
    mkdocs
    mkdocs-material
    pymdown-extensions

    yq
  ];

  outputs = [
    "out"
    "doc"
  ];

  buildPhase = ''
    yq -yi '.docs_dir = "source"' mkdocs.yml
    mkdir overrides
    mv mkdocs.yml ..
    cd ..
    mkdocs build --theme material
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $doc/share/payloadsallthethings
    cp -r site/* $doc/share/payloadsallthethings

    mkdir -p $out/share/payloadsallthethings
    rm source/CONTRIBUTING.md source/custom.css
    cp -r source/* $out/share/payloadsallthethings
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/swisskyrepo/PayloadsAllTheThings";
    description = "List of useful payloads and bypass for Web Application Security and Pentest/CTF";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      shard7
      felbinger
    ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
