{
  lib,
  duckstation,
  fetchFromGitHub,
  fetchpatch,
  shaderc,
}:

{
  duckstation =
    let
      self = {
        pname = "duckstation";
        version = "0.1-6759";
        src = fetchFromGitHub {
          owner = "stenzek";
          repo = "duckstation";
          rev = "refs/tags/v${self.version}";
          #
          # Some files are filled by using Git commands; it requires deepClone.
          # More info at `checkout_ref` function in nix-prefetch-git.
          # However, `.git` is a bit nondeterministic (and Git itself makes no
          # guarrantees whatsoever).
          # Then, in order to enhance reproducibility, what we will do here is:
          #
          # - Execute the desired Git commands;
          # - Save the obtained info into files;
          # - Remove `.git` afterwards.
          #
          deepClone = true;
          postFetch = ''
            cd $out
            mkdir -p .nixpkgs-auxfiles/
            git rev-parse HEAD > .nixpkgs-auxfiles/git_hash
            git rev-parse --abbrev-ref HEAD | tr -d '\r\n' > .nixpkgs-auxfiles/git_branch
            git describe --dirty | tr -d '\r\n' > .nixpkgs-auxfiles/git_tag
            git log -1 --date=iso8601-strict --format=%cd > .nixpkgs-auxfiles/git_date
            find $out -name .git -print0 | xargs -0 rm -fr
          '';
          hash = "sha256-HETo7mChBASnr5prPUWcOhS4TIESFdrs1haEXQpnuzs=";
        };
      };
    in
    self;

  shaderc-patched = shaderc.overrideAttrs (
    old:
    let
      version = "2024.0";
      src = fetchFromGitHub {
        owner = "google";
        repo = "shaderc";
        rev = "v${version}";
        hash = "sha256-Cwp7WbaKWw/wL9m70wfYu47xoUGQW+QGeoYhbyyzstQ=";
      };
    in
    {
      pname = "shaderc-patched-for-duckstation";
      inherit version src;
      patches = (old.patches or [ ]) ++ [
        (fetchpatch {
          url = "file://${duckstation.src}/scripts/shaderc-changes.patch";
          hash = "sha256-Ps/D+CdSbjVWg3ZGOEcgbpQbCNkI5Nuizm4E5qiM9Wo=";
          excludes = [
            "CHANGES"
            "CMakeLists.txt"
            "libshaderc/CMakeLists.txt"
          ];
        })
      ];
    }
  );
}
