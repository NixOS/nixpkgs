# Emacs {#sec-emacs}

## Configuring Emacs {#sec-emacs-config}

The Emacs package comes with some extra helpers to make it easier to configure. `emacs.pkgs.withPackages` allows you to manage packages from ELPA. This means that you will not have to install that packages from within Emacs. For instance, if you wanted to use `company` `counsel`, `flycheck`, `ivy`, `magit`, `projectile`, and `use-package` you could use this as a `~/.config/nixpkgs/config.nix` override:

```nix
{
  packageOverrides = pkgs: with pkgs; {
    myEmacs = emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
      company
      counsel
      flycheck
      ivy
      magit
      projectile
      use-package
    ]));
  }
}
```

You can install it like any other packages via `nix-env -iA myEmacs`. However, this will only install those packages. It will not `configure` them for us. To do this, we need to provide a configuration file. Luckily, it is possible to do this from within Nix! By modifying the above example, we can make Emacs load a custom config file. The key is to create a package that provides a `default.el` file in `/share/emacs/site-start/`. Emacs knows to load this file automatically when it starts.

```nix
{
  packageOverrides = pkgs: with pkgs; rec {
    myEmacsConfig = writeText "default.el" ''
      ;; initialize package

      (require 'package)
      (package-initialize 'noactivate)
      (eval-when-compile
        (require 'use-package))

      ;; load some packages

      (use-package company
        :bind ("<C-tab>" . company-complete)
        :diminish company-mode
        :commands (company-mode global-company-mode)
        :defer 1
        :config
        (global-company-mode))

      (use-package counsel
        :commands (counsel-descbinds)
        :bind (([remap execute-extended-command] . counsel-M-x)
               ("C-x C-f" . counsel-find-file)
               ("C-c g" . counsel-git)
               ("C-c j" . counsel-git-grep)
               ("C-c k" . counsel-ag)
               ("C-x l" . counsel-locate)
               ("M-y" . counsel-yank-pop)))

      (use-package flycheck
        :defer 2
        :config (global-flycheck-mode))

      (use-package ivy
        :defer 1
        :bind (("C-c C-r" . ivy-resume)
               ("C-x C-b" . ivy-switch-buffer)
               :map ivy-minibuffer-map
               ("C-j" . ivy-call))
        :diminish ivy-mode
        :commands ivy-mode
        :config
        (ivy-mode 1))

      (use-package magit
        :defer
        :if (executable-find "git")
        :bind (("C-x g" . magit-status)
               ("C-x G" . magit-dispatch-popup))
        :init
        (setq magit-completing-read-function 'ivy-completing-read))

      (use-package projectile
        :commands projectile-mode
        :bind-keymap ("C-c p" . projectile-command-map)
        :defer 5
        :config
        (projectile-global-mode))
    '';

    myEmacs = emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
      (runCommand "default.el" {} ''
         mkdir -p $out/share/emacs/site-lisp
         cp ${myEmacsConfig} $out/share/emacs/site-lisp/default.el
       '')
      company
      counsel
      flycheck
      ivy
      magit
      projectile
      use-package
    ]));
  };
}
```

This provides a fairly full Emacs start file. It will load in addition to the user's personal config. You can always disable it by passing `-q` to the Emacs command.

Sometimes `emacs.pkgs.withPackages` is not enough, as this package set has some priorities imposed on packages (with the lowest priority assigned to Melpa Unstable, and the highest for packages manually defined in `pkgs/top-level/emacs-packages.nix`). But you can't control these priorities when some package is installed as a dependency. You can override it on a per-package-basis, providing all the required dependencies manually, but it's tedious and there is always a possibility that an unwanted dependency will sneak in through some other package. To completely override such a package, you can use `overrideScope'`.

```nix
overrides = self: super: rec {
  haskell-mode = self.melpaPackages.haskell-mode;
  ...
};
((emacsPackagesFor emacs).overrideScope' overrides).withPackages
  (p: with p; [
    # here both these package will use haskell-mode of our own choice
    ghc-mod
    dante
  ])
```
