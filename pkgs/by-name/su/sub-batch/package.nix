{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sub-batch";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kl";
    repo = "sub-batch";
    rev = "v${version}";
    sha256 = "sha256-TOcK+l65iKON1kgBE4DYV/BXACnvqPCshavnVdpnGH4=";
  };

  cargoHash = "sha256-eT4u/IHj+yqeLQZ7E4cWAJFMT503zHq7HYyIhsoaj6s=";

  meta = with lib; {
    description = "Match and rename subtitle files to video files and perform other batch operations on subtitle files";
    homepage = "https://github.com/kl/sub-batch";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "sub-batch";
  };
}
