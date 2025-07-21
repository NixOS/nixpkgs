# - The csdp program used for the Micromega tactic is statically referenced.
#   However, rocq can build without csdp by setting it to null.
#   In this case some Micromega tactics will search the user's path for the csdp program and will fail if it is not found.
# - The exact version can be specified through the `version` argument to
#   the derivation; it defaults to the latest stable version.

{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  writeText,
  pkg-config,
  customOCamlPackages ? null,
  ocamlPackages_4_14,
  ncurses,
  csdp ? null,
  version,
  rocq-version ? null,
}@args:
let
  lib = import ../../../../build-support/rocq/extra-lib.nix { inherit (args) lib; };

  release = {
    "9.0.0".sha256 = "sha256-GRwYSvrJGiPD+I82gLOgotb+8Ra5xHZUJGcNwxWqZkU=";
    "9.1+rc1".sha256 = "sha256-GShKHQ9EdvyNe9WlkzF6KLYybc5dPeVrh4bpkVy6pY4=";
  };
  releaseRev = v: "V${v}";
  fetched =
    import ../../../../build-support/coq/meta-fetch/default.nix
      {
        inherit
          lib
          stdenv
          fetchzip
          fetchurl
          ;
      }
      {
        inherit release releaseRev;
        location = {
          owner = "coq";
          repo = "coq";
        };
      }
      args.version;
  version = fetched.version;
  rocq-version =
    args.rocq-version or (if version != "dev" then lib.versions.majorMinor version else "dev");
  csdpPatch = lib.optionalString (csdp != null) ''
    substituteInPlace plugins/micromega/sos.ml --replace-warn "; csdp" "; ${csdp}/bin/csdp"
    substituteInPlace plugins/micromega/coq_micromega.ml --replace-warn "System.is_in_system_path \"csdp\"" "true"
  '';
  ocamlPackages = if customOCamlPackages != null then customOCamlPackages else ocamlPackages_4_14;
  ocamlNativeBuildInputs = [
    ocamlPackages.ocaml
    ocamlPackages.findlib
    ocamlPackages.dune_3
  ];
  ocamlPropagatedBuildInputs = [ ocamlPackages.zarith ];
  self = stdenv.mkDerivation {
    pname = "rocq";
    inherit (fetched) version src;

    passthru = {
      inherit rocq-version;
      inherit ocamlPackages ocamlNativeBuildInputs;
      inherit ocamlPropagatedBuildInputs;
      emacsBufferSetup = pkgs: ''
        ; Propagate rocq paths to children
        (inherit-local-permanent coq-prog-name "${self}/bin/rocq repl")
        (inherit-local-permanent coq-dependency-analyzer "${self}/bin/rocq dep")
        (inherit-local-permanent coq-compiler "${self}/bin/rocq c")
        ; If the coq-library path was already set, re-set it based on our current rocq
        (when (fboundp 'get-coq-library-directory)
          (inherit-local-permanent coq-library-directory (get-coq-library-directory))
          (coq-prog-args))
        (mapc (lambda (arg)
          (when (file-directory-p (concat arg "/lib/coq/${rocq-version}/user-contrib"))
            (setenv "ROCQPATH" (concat (getenv "ROCQPATH") ":" arg "/lib/coq/${rocq-version}/user-contrib")))) '(${
              lib.concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)
            }))
        ; TODO Abstract this pattern from here and nixBufferBuilders.withPackages!
        (defvar nixpkgs--rocq-buffer-count 0)
        (when (eq nixpkgs--rocq-buffer-count 0)
          (make-variable-buffer-local 'nixpkgs--is-nixpkgs-rocq-buffer)
          (defun nixpkgs--rocq-inherit (buf)
            (inherit-local-inherit-child buf)
            (with-current-buffer buf
              (setq nixpkgs--rocq-buffer-count (1+ nixpkgs--rocq-buffer-count))
              (add-hook 'kill-buffer-hook 'nixpkgs--decrement-rocq-buffer-count nil t))
            buf)
          ; When generating a scomint buffer, do inherit-local inheritance and make it a nixpkgs-rocq buffer
          (defun nixpkgs--around-scomint-make (orig &rest r)
            (if nixpkgs--is-nixpkgs-rocq-buffer
                (progn
                  (advice-add 'get-buffer-create :filter-return #'nixpkgs--rocq-inherit)
                  (apply orig r)
                  (advice-remove 'get-buffer-create #'nixpkgs--rocq-inherit))
              (apply orig r)))
          (advice-add 'scomint-make :around #'nixpkgs--around-scomint-make)
          ; When we have no more rocq buffers, tear down the buffer handling
          (defun nixpkgs--decrement-rocq-buffer-count ()
            (setq nixpkgs--rocq-buffer-count (1- nixpkgs--rocq-buffer-count))
            (when (eq nixpkgs--rocq-buffer-count 0)
              (advice-remove 'scomint-make #'nixpkgs--around-scomint-make)
              (fmakunbound 'nixpkgs--around-scomint-make)
              (fmakunbound 'nixpkgs--rocq-inherit)
              (fmakunbound 'nixpkgs--decrement-rocq-buffer-count))))
        (setq nixpkgs--rocq-buffer-count (1+ nixpkgs--rocq-buffer-count))
        (add-hook 'kill-buffer-hook 'nixpkgs--decrement-rocq-buffer-count nil t)
        (setq nixpkgs--is-nixpkgs-rocq-buffer t)
        (inherit-local 'nixpkgs--is-nixpkgs-rocq-buffer)
      '';
    };

    nativeBuildInputs = [ pkg-config ] ++ ocamlNativeBuildInputs;
    buildInputs = [ ncurses ];

    propagatedBuildInputs = ocamlPropagatedBuildInputs;

    postPatch = ''
      UNAME=$(type -tp uname)
      RM=$(type -tp rm)
      substituteInPlace tools/beautify-archive --replace-warn "/bin/rm" "$RM"
      ${csdpPatch}
    '';

    setupHook = writeText "setupHook.sh" ''
      addRocqPath () {
        if test -d "''$1/lib/coq/${rocq-version}/user-contrib"; then
          export ROCQPATH="''${ROCQPATH-}''${ROCQPATH:+:}''$1/lib/coq/${rocq-version}/user-contrib/"
        fi
      }

      addEnvHooks "$targetOffset" addRocqPath
    '';

    preConfigure = ''
      patchShebangs dev/tools/
    '';

    prefixKey = "-prefix ";

    enableParallelBuilding = true;

    createFindlibDestdir = true;

    buildPhase = ''
      runHook preBuild
      make dunestrap
      dune build -p rocq-runtime,rocq-core -j $NIX_BUILD_CORES
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      dune install --prefix $out rocq-runtime rocq-core
      ln -s $out/lib/rocq-runtime $OCAMLFIND_DESTDIR/rocq-runtime
      ln -s $out/lib/rocq-core $OCAMLFIND_DESTDIR/rocq-core
      runHook postInstall
    '';

    meta = with lib; {
      description = "The Rocq Prover";
      longDescription = ''
        The Rocq Prover is an interactive theorem prover, or proof assistant. It provides
        a formal language to write mathematical definitions, executable
        algorithms and theorems together with an environment for
        semi-interactive development of machine-checked proofs.
      '';
      homepage = "https://rocq-prover.org";
      license = licenses.lgpl21;
      branch = rocq-version;
      maintainers = with maintainers; [
        proux01
        roconnor
        vbgl
        Zimmi48
      ];
      platforms = platforms.unix;
      mainProgram = "rocq";
    };
  };
in
self
