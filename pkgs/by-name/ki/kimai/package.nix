{pkgs,
system ? builtins.currentSystem,
config,
consoleCmd ? "kimai-console",
databaseUrl ? "",
mailerFrom ? "",
mailerUrl ? "",
appSecret ? "",
corsAllowOrigin ? "",
...
}:

let
  phpPackage = import ./composer2nix/default.nix {
    inherit pkgs system;
  };
in
phpPackage.override {
  postInstall = ''
    # ensure the dirs exist, just in case,
    # move any initialized data to "sample" to make space for symlinks.
    # Finally, symlink to a directory outside of the nix store so that kimai
    # may write to them without issue.
    # These symlinks are created in the nix store but their targets need to be created later on,
    # when the service starts.

    mkdir -p ./var/cache
    mkdir -p ./var/log
    mkdir -p ./var/data
    mv ./var/cache ./var/cache.sample
    mv ./var/log ./var/log.sample
    mv ./var/data ./var/data.sample
    ln -s /var/lib/kimai/var/cache ./var/cache
    ln -s /var/lib/kimai/var/log ./var/log
    ln -s /var/lib/kimai/var/data ./var/data
    ln -s /var/lib/kimai/var/plugins ./var/plugins

    # Create the .env file
    # https://github.com/kimai/kimai/blob/main/.env.dist
    rm -rf ./.env
    touch ./.env
    echo -e 'DATABASE_URL=${databaseUrl}\n' >> ./.env
    echo -e 'MAILER_FROM=${mailerFrom}\n' >> ./.env
    echo -e 'MAILER_URL=${mailerUrl}\n' >> ./.env
    echo -e 'APP_SECRET=${appSecret}\n' >> ./.env
    echo -e 'CORS_ALLOW_ORIGIN=${corsAllowOrigin}\n' >> ./.env

    # give a more unique name to the binary
    # you would use this binary for the commands:
    # https://www.kimai.org/documentation/commands.html
    mv ./bin/console ./bin/${consoleCmd}
  '';
  buildInputs = [ pkgs.cacert pkgs.curl pkgs.git ];
}
