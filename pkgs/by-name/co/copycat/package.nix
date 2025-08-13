{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ccat";
  version = "004";

  src = fetchFromGitHub {
    owner = "DeeKahy";
    repo = "CopyCat";
    tag = version;
    hash = "sha256-HLT88ghyT9AwvBTf7NrFkSPqMAh90GrBqZVXN5aaG3w=";
  };

  cargoHash = "sha256-gjFVvP2h+HJdDdNVtqTT1E1s4ZYXfWuhtMBRJkWRcDw=";

  meta = {
    description = "Utility to copy project tree contents to clipboard";
    homepage = "https://github.com/DeeKahy/CopyCat";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.deekahy ];
    mainProgram = "ccat";
  };
}
