# - coqide compilation can be disabled by setting buildIde to false
# - The csdp program used for the Micromega tactic is statically referenced.
#   However, coq can build without csdp by setting it to null.
#   In this case some Micromega tactics will search the user's path for the csdp program and will fail if it is not found.
# - The exact version can be specified through the `version` argument to
#   the derivation; it defaults to the latest stable version.

{ stdenv, fetchFromGitHub, writeText, pkgconfig
, ocamlPackages, ncurses
, buildIde ? true
, csdp ? null
, version ? "8.6"
}:

let version_info = {
    "8.5" =
      { sha256 = "0my2xxzdvcyahkx62s1f01aabxprg82126kpx0kz1f7282pa08ly"; };
    "8.5pl1" =
      { sha256 = "1976ki5xjg2r907xj9p7gs0kpdinywbwcqlgxqw75dgp0hkgi00n"; };
    "8.5pl2" =
      { sha256 = "109rrcrx7mz0fj7725kjjghfg5ydwb24hjsa5hspa27b4caah7rh"; };
    "8.5pl3" =
      { sha256 = "15c3rdk59nifzihsp97z4vjxis5xmsnrvpb86qiazj143z2fmdgw"; };
    "8.6" =
      { sha256 = "148mb48zpdax56c0blfi7v67lx014lnmrvxxasi28hsibyz2lvg4"; };
    "2017-06-06" =
      { sha256 = "1idy22m0fmm7n85gmml7r4fbk71w43rv195smnbs70prfbw4mwhm";
        rev = "2f23c27e08f66402b8fba4745681becd402f4c5c";
        coq-version = "trunk";
        # as obtained with git show $rev:configure.ml | sed '14q;d'
        unstable = true;
      };
  };
in

if !builtins.hasAttr version version_info
then throw "unknown version ${version}" else

let this_version_info =
  # Default revision and coq-version
  { rev = "V${version}";
    coq-version = builtins.substring 0 3 version;
    unstable = false;
  } // version_info."${version}";
in

with this_version_info;

let
  camlp5 = ocamlPackages.camlp5_strict;
  ideFlags = if buildIde then "-lablgtkdir ${ocamlPackages.lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  csdpPatch = if csdp != null then ''
    substituteInPlace plugins/micromega/sos.ml --replace "; csdp" "; ${csdp}/bin/csdp"
    substituteInPlace plugins/micromega/coq_micromega.ml --replace "System.is_in_system_path \"csdp\"" "true"
  '' else "";
self = stdenv.mkDerivation {
  name = "coq${if unstable then "-unstable" else ""}-${version}";

  inherit coq-version;
  inherit camlp5;
  inherit (ocamlPackages) ocaml;
  passthru = {
    inherit (ocamlPackages) findlib;
    emacsBufferSetup = pkgs: ''
      ; Propagate coq paths to children
      (inherit-local-permanent coq-prog-name "${self}/bin/coqtop")
      (inherit-local-permanent coq-dependency-analyzer "${self}/bin/coqdep")
      (inherit-local-permanent coq-compiler "${self}/bin/coqc")
      ; If the coq-library path was already set, re-set it based on our current coq
      (when (fboundp 'get-coq-library-directory)
        (inherit-local-permanent coq-library-directory (get-coq-library-directory))
        (coq-prog-args))
      (mapc (lambda (arg)
        (when (file-directory-p (concat arg "/lib/coq/${coq-version}/user-contrib"))
          (setenv "COQPATH" (concat (getenv "COQPATH") ":" arg "/lib/coq/${coq-version}/user-contrib")))) '(${stdenv.lib.concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
      ; TODO Abstract this pattern from here and nixBufferBuilders.withPackages!
      (defvar nixpkgs--coq-buffer-count 0)
      (when (eq nixpkgs--coq-buffer-count 0)
        (make-variable-buffer-local 'nixpkgs--is-nixpkgs-coq-buffer)
        (defun nixpkgs--coq-inherit (buf)
          (inherit-local-inherit-child buf)
          (with-current-buffer buf
            (setq nixpkgs--coq-buffer-count (1+ nixpkgs--coq-buffer-count))
            (add-hook 'kill-buffer-hook 'nixpkgs--decrement-coq-buffer-count nil t))
          buf)
        ; When generating a scomint buffer, do inherit-local inheritance and make it a nixpkgs-coq buffer
        (defun nixpkgs--around-scomint-make (orig &rest r)
          (if nixpkgs--is-nixpkgs-coq-buffer
              (progn
                (advice-add 'get-buffer-create :filter-return #'nixpkgs--coq-inherit)
                (apply orig r)
                (advice-remove 'get-buffer-create #'nixpkgs--coq-inherit))
            (apply orig r)))
        (advice-add 'scomint-make :around #'nixpkgs--around-scomint-make)
        ; When we have no more coq buffers, tear down the buffer handling
        (defun nixpkgs--decrement-coq-buffer-count ()
          (setq nixpkgs--coq-buffer-count (1- nixpkgs--coq-buffer-count))
          (when (eq nixpkgs--coq-buffer-count 0)
            (advice-remove 'scomint-make #'nixpkgs--around-scomint-make)
            (fmakunbound 'nixpkgs--around-scomint-make)
            (fmakunbound 'nixpkgs--coq-inherit)
            (fmakunbound 'nixpkgs--decrement-coq-buffer-count))))
      (setq nixpkgs--coq-buffer-count (1+ nixpkgs--coq-buffer-count))
      (add-hook 'kill-buffer-hook 'nixpkgs--decrement-coq-buffer-count nil t)
      (setq nixpkgs--is-nixpkgs-coq-buffer t)
      (inherit-local 'nixpkgs--is-nixpkgs-coq-buffer)
    '';
  };

  src = fetchFromGitHub {
    owner = "coq";
    repo = "coq";
    inherit sha256 rev;
  };

  buildInputs = [ pkgconfig ocamlPackages.ocaml ocamlPackages.findlib camlp5 ncurses ocamlPackages.lablgtk ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    substituteInPlace configure.ml --replace '"md5 -q"' '"md5sum"'
    ${csdpPatch}
  '';

  setupHook = writeText "setupHook.sh" ''
    addCoqPath () {
      if test -d "''$1/lib/coq/${coq-version}/user-contrib"; then
        export COQPATH="''${COQPATH}''${COQPATH:+:}''$1/lib/coq/${coq-version}/user-contrib/"
      fi
    }

    envHooks=(''${envHooks[@]} addCoqPath)
  '';

  preConfigure = ''
    configureFlagsArray=(
      -opt
      ${ideFlags}
    )
  '';

  prefixKey = "-prefix ";

  buildFlags = "revision coq coqide bin/votour";

  postInstall = ''
    cp bin/votour $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Coq proof assistant";
    longDescription = ''
      Coq is a formal proof management system.  It provides a formal language
      to write mathematical definitions, executable algorithms and theorems
      together with an environment for semi-interactive development of
      machine-checked proofs.
    '';
    homepage = "http://coq.inria.fr";
    license = licenses.lgpl21;
    branch = coq-version;
    maintainers = with maintainers; [ roconnor thoughtpolice vbgl Zimmi48 ];
    platforms = platforms.unix;
  };
}; in self
