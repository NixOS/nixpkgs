{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "rust-advisory-db";
  version = "0-unstable-2026-10-28";

  src = fetchFromGitHub {
    owner = "rustsec";
    repo = "advisory-db";
    rev = "40f5be6fb12ed93fc591bf4ab23b7d793b3f2239";
    hash = "sha256-aZHFFhnurUQaXWiJLyFSX+8jEHJ7ZRkC94S6NlChod0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';

  meta = {
    description = "Repository of security advisories filed against Rust crates";
    homepage = "https://rustsec.org/advisories/";
    downloadPage = "https://github.com/rustsec/advisory-db";
    maintainers = [ lib.maintainers.RossSmyth ];
    license = lib.licenses.cc0;
  };
}
