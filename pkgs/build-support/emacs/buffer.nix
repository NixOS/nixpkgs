# Functions to build elisp files to locally configure emcas buffers.
# See https://github.com/shlevy/nix-buffer

{ lib, writeText, inherit-local }:

{
  withPackages = pkgs: let
      extras = map (x: x.emacsBufferSetup pkgs) (builtins.filter (builtins.hasAttr "emacsBufferSetup") pkgs);
    in writeText "dir-locals.el" ''
      (require 'inherit-local "${inherit-local}/share/emacs/site-lisp/elpa/inherit-local-${inherit-local.version}/inherit-local.elc")

      ; Only set up nixpkgs buffer handling when we have some buffers active
      (defvar nixpkgs--buffer-count 0)
      (when (eq nixpkgs--buffer-count 0)
        ; When generating a new temporary buffer (one whose name starts with a space), do inherit-local inheritance and make it a nixpkgs buffer
        (defun nixpkgs--around-generate (orig name)
          (if (eq (aref name 0) ?\s)
              (let ((buf (funcall orig name)))
                (when (inherit-local-inherit-child buf)
                  (with-current-buffer buf
                    (make-local-variable 'kill-buffer-hook)
                    (setq nixpkgs--buffer-count (1+ nixpkgs--buffer-count))
                    (add-hook 'kill-buffer-hook 'nixpkgs--decrement-buffer-count)))
                buf)
            (funcall orig name)))
        (advice-add 'generate-new-buffer :around #'nixpkgs--around-generate)
        ; When we have no more nixpkgs buffers, tear down the buffer handling
        (defun nixpkgs--decrement-buffer-count ()
          (setq nixpkgs--buffer-count (1- nixpkgs--buffer-count))
          (when (eq nixpkgs--buffer-count 0)
            (advice-remove 'generate-new-buffer #'nixpkgs--around-generate)
            (fmakunbound 'nixpkgs--around-generate)
            (fmakunbound 'nixpkgs--decrement-buffer-count))))
      (setq nixpkgs--buffer-count (1+ nixpkgs--buffer-count))
      (make-local-variable 'kill-buffer-hook)
      (add-hook 'kill-buffer-hook 'nixpkgs--decrement-buffer-count)

      ; Add packages to PATH and exec-path
      (make-local-variable 'process-environment)
      (put 'process-environment 'permanent-local t)
      (inherit-local 'process-environment)
      (setenv "PATH" (concat "${lib.makeSearchPath "bin" pkgs}:" (getenv "PATH")))
      (inherit-local-permanent exec-path (append '(${builtins.concatStringsSep " " (map (p: "\"${p}/bin\"") pkgs)}) exec-path))

      ${lib.concatStringsSep "\n" extras}
    '';
}
