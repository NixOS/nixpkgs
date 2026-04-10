{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage {
  pname = "readwise-cli";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "readwiseio";
    repo = "readwise-cli";
    rev = "v0.5.5";
    hash = "sha256-oPyhsKyaZRogn5y1JIJH0js0yrk5E298QEpIC9/4xXc=";
  };

  npmDepsHash = "sha256-eupjqOEE77pNzY9DBJdYdDraJtUVhbojaG/QCW+m+jw=";

  meta = {
    description = "Command-line interface for Readwise and Reader";
    homepage = "https://github.com/readwiseio/readwise-cli";
    mainProgram = "readwise";
    # No LICENSE file in the upstream repository
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ o-love ];
    platforms = lib.platforms.all;
  };
}
