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
    version = "0.19.4";

    src = fetchFromGitHub {
      owner = "emacs-tree-sitter";
      repo = "emacs-tree-sitter";
      tag = version;
      hash = "sha256-7B9Q8ke8gY9cFIAjpyH21P240goKUEKgppfqP3PSxYA=";
    };

    cargoHash = "sha256-mjR8PehbhY1o/5L2l/OMh/NwjjmQXErPHh00cAD94pw=";

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
