{ mkPackage }:
mkPackage (
  {
    lib,
    layers,
    stdenv,
    fetchFromGitHub,
    nix-update-script,
    pkg-config,
    vips,
    callPackage,
    testers,
    ...
  }:
  [
    (layers.derivation { inherit stdenv; })
    (this: old: {
      name = "netlify-cli";
      version = "23.15.0";

      npmFetch.hash = "sha256-yKDLaNIofYLsoWvxaZUfY+LyVd/s4NGD+LEmd9Y7CAA=";

      stdenvArgs = {
        buildInputs = [ vips ];
        nativeBuildInputs = [ pkg-config ];
        src = fetchFromGitHub {
          owner = "netlify";
          repo = "cli";
          tag = "v${this.version}";
          hash = "sha256-y81VmYt5NDXNcipPY4DIWDICF3a0eETJVQRFRATi1Dk=";
        };

        # Prevent postinstall script from running before package is built
        # See https://github.com/netlify/cli/blob/v23.9.2/scripts/postinstall.js#L70
        # This currently breaks completions: https://github.com/NixOS/nixpkgs/issues/455005
        postPatch = ''
          touch .git
        '';
      };

      public = old.public // {
        tests = {
          version = testers.testVersion { package = this.public; };
          run = callPackage ./test.nix { netlify-cli = this.public; };
        };
        updateScript = nix-update-script { };
      };

      meta = {
        description = "Netlify command line tool";
        homepage = "https://github.com/netlify/cli";
        changelog = "https://github.com/netlify/cli/blob/v${this.version}/CHANGELOG.md";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ roberth ];
        mainProgram = "netlify";
      };
    })
    layers.buildNpmPackage
  ]
)
