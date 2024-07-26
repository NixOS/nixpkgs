{
  buildDotnetModule
  , fetchFromGitHub
  , fontconfig
  , lib
  , openal
  , stdenv
  , xorg
}:

buildDotnetModule rec {
  pname = "knossosnet";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    rev = "v${version}";
    hash = "sha256-Wq4WeRf+ELTxZhQyQf6XAOPmbJwX06qQ5GxRnnK3lyI=";
  };

  patches = [ ./targetframework.patch ];

  nugetDeps = ./deps.nix;
  executables = [ "Knossos.NET" ];

  runtimeDeps = [ fontconfig openal xorg.libX11 xorg.libICE xorg.libSM ];

  meta = with lib; {
    homepage = "https://github.com/KnossosNET/Knossos.NET";
    description = "A multi-platform launcher for Freespace 2 Open";
    license = licenses.gpl3Only;
    mainProgram = "Knossos.NET";
    maintainers = with maintainers; [ cdombroski ];
  };
}
