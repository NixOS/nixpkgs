{ config
, lib
, fetchurl
, callPackage
, vscode-utils
, asciidoctor
, nodePackages
, python3Packages
, jdk
, llvmPackages_8
, nixpkgs-fmt
, protobuf
, jq
, shellcheck
, moreutils
, racket-minimal
, clojure-lsp
, alejandra
}:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  #
  # Unless there is a good reason not to, we attempt to use the same name as the
  # extension's unique identifier (the name the extension gets when installed
  # from vscode under `~/.vscode`) and found on the marketplace extension page.
  # So an extension's attribute name should be of the form:
  # "${mktplcRef.publisher}.${mktplcRef.name}".
  #
  baseExtensions = self: lib.mapAttrs (_n: lib.recurseIntoAttrs)
    (callPackage ./generated.nix { inherit buildVscodeMarketplaceExtension; });

  overrides = callPackage ./overrides.nix { };
  aliases = self: super: {
    # aliases
    ms-vscode = lib.recursiveUpdate super.ms-vscode { inherit (super.golang) go; };
    Arjun = super.arjun;
    b4dm4n = lib.recursiveUpdate super.b4dm4n { vscode-nixpkgs-fmt = super.b4dm4n.nixpkgs-fmt; };
    eugleo.magic-racket = super.evzen-wybitul.magic-racket;
    jpoissonnier.vscode-styled-components = super.jpoissonnier.vscode-styled-components;
    elixir-lsp.vscode-elixir-ls = super.JakeBecker.elixir-ls;
    jakebecker.elixir-ls = super.JakeBecker.elixir-ls;
  };

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = (lib.optionals config.allowAliases [ aliases ]) ++ [ overrides ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
lib.fix toFix
