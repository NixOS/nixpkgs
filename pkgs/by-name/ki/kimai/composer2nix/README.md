These files were created with `composer2nix` by using the `composer.json` from the kimai repo.

After creating the files with `composer2nix`:
- The `composerEnv.buildPackage` in `php-packages.nix` is to be adjusted and the repo files can be removed. The `src` needs be replaced with `fetchFromGitHub`, and the `meta` attributes adjusted.
- The `default.nix` should stay mostly the same, although `composer2nix` will generate its own default file.

- composer2nix:
    - https://github.com/svanderburg/composer2nix
- kimai:
    - https://github.com/kimai/kimai/tree/main

Additionally the `filterSrc` in `composer-env.nix` needs to be removed to satisfy ofBorg CI.
