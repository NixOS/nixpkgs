{
  fetchFromGitHub,
}:

{
  duckstation = let
    self = {
      pname = "duckstation";
      version = "0.1-6658";
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
        hash = "sha256-ZP9WYaz9e6x3x4UpuW2ep5sc+nUT2O+b0048bmkW0ac=";
      };
    };
  in
    self;
}
