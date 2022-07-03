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
    (callPackage ./_maintainers/generated.nix { inherit buildVscodeMarketplaceExtension; });

  aliases = self: super: {
    # aliases
    ms-vscode = lib.recursiveUpdate super.ms-vscode { inherit (super.golang) go; };
  };

  # TODO: add overrides overlay, so that we can have a generated.nix
  # then apply extension specific modifcations to packages.

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = lib.optionals config.allowAliases [ aliases ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
lib.fix toFix
