{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "repak";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "trumank";
    repo = "repak";
    rev = "refs/tags/v${version}";
    hash = "sha256-nl05EsR52YFSR9Id3zFynhrBIvaqVwUOdjPlSp19Gcc=";
  };

  cargoHash = "sha256-4RA3Nv4Wes3etrnZSnHRjJ3ukA6stJXDj3ftaCxGwuY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unreal Engine .pak file library and CLI in rust";
    homepage = "https://github.com/trumank/repak";
    changelog = "https://github.com/trumank/repak/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ florensie ];
    mainProgram = "repak";
  };
}
