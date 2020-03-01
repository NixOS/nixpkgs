{ callPackage, fetchFromGitHub, buildGoModule, buildEnv, stdenv}:

let
  pname = "rmapi";
  version = "0.0.7";

  repo = fetchFromGitHub {
    owner = "juruen";
    rev = "v${version}";
    repo = pname;
    sha256 = "0m51gmrsdwasrlamg70186f22lb21pw79vkrqr13iqg2cszdlrva";
  };
in
# The idea of the following was to keep the derivation.nix and deps.nix
# in juren/rmapi. Sadly, this does not work becuase hydra does not support
# import-from-derivation. For this reason, we have to manually copy the
# two files into nixpkgs.
# Reference:
# * https://nixos.wiki/wiki/Import_From_Derivation
# * https://discourse.nixos.org/t/is-importing-a-derivation-from-another-repository-bad-practice/5016/4
#
#
#  callPackage "${repo}/derivation.nix" {

  callPackage ./derivation.nix {
    buildGoModule = super: buildGoModule (super // {
      name = "${pname}-${version}";
      inherit version;
      meta = super.meta // {
        maintainers = [ stdenv.lib.maintainers.Enteee ];
      };

      # remove the folloing line once hydra supports IFDs
      src = repo;
    });
  }
