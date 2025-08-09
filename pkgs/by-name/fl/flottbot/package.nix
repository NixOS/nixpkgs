{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
}:
buildGoModule rec {
  pname = "flottbot";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "target";
    repo = "flottbot";
    rev = version;
    hash = "sha256-gOy03qrAzkZk99hVNe/tG1YLoUD5CMCE9AeONAJyeE4=";
  };

  patches = [
    # patch out debug.ReadBuildInfo since version information is not available with buildGoModule
    (replaceVars ./version.patch {
      version = version;
      vcsHash = version; # Maybe there is a way to get the git ref from src? idk.
    })
  ];

  vendorHash = "sha256-vXezNFEM/m5doVgt6T2+Q0PwP3lYALkhHD0cP4ul+JE=";

  subPackages = [ "cmd/flottbot" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Chatbot framework written in Go";
    homepage = "https://github.com/target/flottbot";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanhonof ];
    sourceProvenance = [ sourceTypes.fromSource ];
    mainProgram = "flottbot";
    platforms = platforms.unix;
  };
}
