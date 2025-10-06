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
    version = "0.18.0";

    src = fetchFromGitHub {
      owner = "emacs-tree-sitter";
      repo = "emacs-tree-sitter";
      rev = version;
      hash = "sha256-LrakDpP3ZhRQqz47dPcyoQnu5lROdaNlxGaQfQT6u+k=";
    };

    cargoHash = "sha256-Tua3ZFfSyWVYXU9mPLWXE6ejGlXowTNe3nvZBaicmSQ=";

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
