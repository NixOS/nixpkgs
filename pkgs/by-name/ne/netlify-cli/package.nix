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
    nodejs_20,
    ...
  }:
  [
    (layers.derivation { inherit stdenv; })
    (this: old: {
      name = "netlify-cli";
      version = "18.0.0";

      deps = old.deps // {
        nodejs = nodejs_20;
      };

      npmFetch.hash = "sha256-ONLkCbmmY45/sRwaGUWhA187YVtCcdPVnD7ZMFoQ2Y0=";

      setup = {
        buildInputs = [ vips ];
        nativeBuildInputs = [ pkg-config ];
        src = fetchFromGitHub {
          owner = "netlify";
          repo = "cli";
          tag = "v${this.version}";
          hash = "sha256-LGnFVg7c+CMgjxkVdy/rdoo6uU5HaOwGKRDHRe5Hz3Y=";
        };
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
