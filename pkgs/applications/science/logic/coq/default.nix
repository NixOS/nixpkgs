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
, version
}:

let
  sha256 = {
   "8.5pl1"    = "1976ki5xjg2r907xj9p7gs0kpdinywbwcqlgxqw75dgp0hkgi00n";
   "8.5pl2"    = "109rrcrx7mz0fj7725kjjghfg5ydwb24hjsa5hspa27b4caah7rh";
   "8.5pl3"    = "15c3rdk59nifzihsp97z4vjxis5xmsnrvpb86qiazj143z2fmdgw";
   "8.6"       = "148mb48zpdax56c0blfi7v67lx014lnmrvxxasi28hsibyz2lvg4";
   "8.6.1"     = "0llrxcxwy5j87vbbjnisw42rfw1n1pm5602ssx64xaxx3k176g6l";
   "8.7.0"     = "1h18b7xpnx3ix9vsi5fx4zdcbxy7bhra7gd5c5yzxmk53cgf1p9m";
   "8.7.1"     = "0gjn59jkbxwrihk8fx9d823wjyjh5m9gvj9l31nv6z6bcqhgdqi8";
   "8.7.2"     = "0a0657xby8wdq4aqb2xsxp3n7pmc2w4yxjmrb2l4kccs1aqvaj4w";
   "8.8+beta1" = "19ipmx6bf8wjpk8y29hcginxk7hps4jh1bbihn5icx4qysm81165";
  }."${version}";
  coq-version = builtins.substring 0 3 version;
  camlp5 = ocamlPackages.camlp5_strict;
  ideFlags = if buildIde then "-lablgtkdir ${ocamlPackages.lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  csdpPatch = if csdp != null then ''
    substituteInPlace plugins/micromega/sos.ml --replace "; csdp" "; ${csdp}/bin/csdp"
    substituteInPlace plugins/micromega/coq_micromega.ml --replace "System.is_in_system_path \"csdp\"" "true"
  '' else "";
self = stdenv.mkDerivation {
  name = "coq-${version}";

  inherit coq-version;
  inherit camlp5;
  inherit (ocamlPackages) ocaml;
  passthru = {
    inherit (ocamlPackages) findlib num;
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
    rev = "V${version}";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocamlPackages.ocaml ocamlPackages.findlib camlp5 ncurses ocamlPackages.num ]
  ++ stdenv.lib.optional buildIde ocamlPackages.lablgtk;

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

    addEnvHooks "$targetOffset" addCoqPath
  '';

  preConfigure = ''
    configureFlagsArray=(
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
    homepage = http://coq.inria.fr;
    license = licenses.lgpl21;
    branch = coq-version;
    maintainers = with maintainers; [ roconnor thoughtpolice vbgl Zimmi48 ];
    platforms = platforms.unix;
  };
}; in self
