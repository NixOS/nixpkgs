{
  lib,
  melpaBuild,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  nix-update-script,
}:

let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;

  tsc-dyn = rustPlatform.buildRustPackage rec {
    pname = "tsc-dyn";
    version = "0.19.3";

    src = fetchFromGitHub {
      owner = "emacs-tree-sitter";
      repo = "emacs-tree-sitter";
      tag = version;
      hash = "sha256-WBwM6nHD9/lrpxMa/bu+dZj1Ulp0uPb1VOPEb4eDxak=";
    };

    cargoHash = "sha256-AZJoOWBnAp+oUR9LpQUJsx9gs3K5B9N+WW8j8TgImd4=";

    sourceRoot = "${src.name}/core";

    postInstall = ''
      pushd $out/lib
      mv --verbose libtsc_dyn${libExt} tsc-dyn${libExt}
      echo -n $version > DYN-VERSION
      popd
    '';
  };
in
melpaBuild {
  pname = "tsc";
  inherit (tsc-dyn) version src;

  files = ''("core/*.el" "${tsc-dyn}/lib/*")'';

  passthru = {
    inherit tsc-dyn;
    updateScript = nix-update-script { attrPath = "emacsPackages.tsc.tsc-dyn"; };
  };

  meta = {
    description = "Core APIs of the Emacs binding for tree-sitter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
