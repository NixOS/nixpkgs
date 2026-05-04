{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "niimblue";
  version = "0-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "MultiMote";
    repo = "niimblue";
    rev = "f2018dfa8c4f3190ce2c312a93fc85933624b44a";
    hash = "sha256-M7/mfsaRNTzEWpNFsJuBVSwnWlcBjwXxB2nrZbv7uRI=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/* $out
  '';

  __structuredAttrs = true;

  npmDepsHash = "sha256-6Rw6wbA6UEGboh6NYH73HyKGSv/mIyRkZoVkHjzgjm4=";

  meta = {
    description = "Design and print labels with NIIMBOT printers directly from your PC or mobile web browser";
    homepage = "https://github.com/MultiMote/niimblue";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "niimblue";
    platforms = lib.platforms.all;
  };
}
