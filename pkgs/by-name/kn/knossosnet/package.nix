{
  buildDotnetModule
  , fetchFromGitHub
  , lib
  , openal
}:

buildDotnetModule rec {
  pname = "knossosnet";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    rev = "v${version}";
    hash = "sha256-vlSiM6kskV4wfBZF7Rv5ICyqKG0Zhz/iU8kflYOaf0U=";
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
