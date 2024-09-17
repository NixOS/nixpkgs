{
  buildDotnetModule
  , fetchFromGitHub
  , lib
  , openal
}:

buildDotnetModule rec {
  pname = "knossosnet";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    rev = "v${version}";
    hash = "sha256-5FNb+L+ABkR/ubSZXuV4hlzy6pIWEXaTXl4piNsmkmw=";
  };

  patches = [ ./targetframework.patch ];

  nugetDeps = ./deps.nix;
  executables = [ "Knossos.NET" ];

  runtimeDeps = [ openal ];

  meta = with lib; {
    homepage = "https://github.com/KnossosNET/Knossos.NET";
    description = "Multi-platform launcher for Freespace 2 Open";
    license = licenses.gpl3Only;
    mainProgram = "Knossos.NET";
    maintainers = with maintainers; [ cdombroski ];
  };
}
