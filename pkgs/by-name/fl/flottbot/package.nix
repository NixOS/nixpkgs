{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
}:
buildGoModule (finalAttrs: {
  pname = "flottbot";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "target";
    repo = "flottbot";
    rev = finalAttrs.version;
    hash = "sha256-gOy03qrAzkZk99hVNe/tG1YLoUD5CMCE9AeONAJyeE4=";
  };

  patches = [
    # patch out debug.ReadBuildInfo since version information is not available with buildGoModule
    (replaceVars ./version.patch {
      version = finalAttrs.version;
      vcsHash = finalAttrs.version; # Maybe there is a way to get the git ref from src? idk.
    })
  ];

  vendorHash = "sha256-vXezNFEM/m5doVgt6T2+Q0PwP3lYALkhHD0cP4ul+JE=";

  subPackages = [ "cmd/flottbot" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Chatbot framework written in Go";
    homepage = "https://github.com/target/flottbot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bryanhonof ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "flottbot";
    platforms = lib.platforms.unix;
  };
})
