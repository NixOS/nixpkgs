{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nix-search-tv";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vWKMGj2fBUbsAvwoYjgT+L4hH0A96u4rDOaT0wnj7iw=";
  };

  vendorHash = "sha256-SSKDo4A8Nhvylghrw6d7CdHpZ7jObEr5V3r0Y9cH80Y=";

  subPackages = [ "cmd/nix-search-tv" ];

  env.GOEXPERIMENT = "jsonv2";

  ldflags = [
    "-s"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fuzzy search for Nix packages";
    homepage = "https://github.com/3timeslazy/nix-search-tv";
    changelog = "https://github.com/3timeslazy/nix-search-tv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nix-search-tv";
  };
})
