# Functions to build elisp files to locally configure emcas buffers.
# See https://github.com/shlevy/nix-buffer

{ lib, writeText }:

{
  withPackages = pkgs: let
      coqs = builtins.filter (x: (builtins.parseDrvName x.name).name == "coq") pkgs;
      coq = builtins.head coqs;
      pg-setup = if builtins.length coqs == 0 then "" else ''
        (setq-local coq-prog-name "${coq}/bin/coqtop")
        (setq-local coq-dependency-analyzer "${coq}/bin/coqdep")
        (setq-local coq-compiler "${coq}/bin/coqc")
	(setq-local coq-library-directory (get-coq-library-directory))
	(coq-prog-args)
      '';
    in writeText "dir-locals.el" ''
      (make-local-variable 'process-environment)
      (setenv "PATH" (concat "${lib.makeSearchPath "bin" pkgs}:" (getenv "PATH")))
      (setq-local exec-path (append '(${builtins.concatStringsSep " " (map (p: "\"${p}/bin\"") pkgs)}) exec-path))
      ${pg-setup}
    '';
}
