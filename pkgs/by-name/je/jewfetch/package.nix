{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage {
  pname = "jewfetch";
  version = "0-unstable-2026-06-13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "salandarman";
    repo = "jewfetch";
    rev = "5993815858deeb522171f12f15b9fbd3638c293b";
    hash = "sha256-bC2hFqbEbv4Eak8vMRkoeQVr5XXvb4f6cPSdMHxK39o=";
  };

  cargoHash = "sha256-jKGIQ3cBCMHNZ0j9HzwG2t3gQ6grFIhqU1TwUcJSIaQ=";

  postInstall = ''
    mkdir -p $out/share/jewfetch
    cp src/config.json $out/share/jewfetch/
  '';

  meta = {
    description = "A fetch tool developed for jews";
    homepage = "https://github.com/salandarman/jewfetch";
    mainProgram = "jewfetch";
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yarn ];
  };
}
