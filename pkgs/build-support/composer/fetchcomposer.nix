{ stdenv, cacert, composer, git, openssh, jq }:

{ name ? "composer-deps", hash, hashAlgo, ... } @ args:
stdenv.mkDerivation ({
  name = "${name}-vendor";
  buildInputs = [ jq ];
  nativeBuildInputs = [ composer git ];

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  installPhase = ''
    if [[ ! -f composer.lock ]]; then
        echo
        echo "ERROR: The composer.lock file doesn't exist"
        echo
        echo "composer.lock is needed to make sure that composerSha256 doesn't change"
        echo "when the registry is updated."
        echo

        exit 1
    fi

    # Various composer configuration options need to be set to ensure reproducibility.
    #
    # - `autoloader-suffix` is used in the generated Composer autoloader, if this isn't set then it
    #   will be randomly generated.
    # - `github-protocols` forces HTTPS to be used when downloading from GitHub - this avoids
    #   clones happening with SSH and trying to authenticate with a public key.
    # - `preferred-install` forces cloning over zip downloads, which can fail due to rate limiting.
    #   When zip downloads fail, cloning happens as a fallback, and that can cause
    #   irreproducibility.
    cat <<EOF >filter
      .config."autoloader-suffix" = "nixfetchcomposer" |
      .config."github-protocols" = ["https"] |
      .config."preferred-install" = "source"
    EOF

    # Apply filter to `composer.json`.
    jq -f filter composer.json > composer.json.tmp
    mv composer.json.tmp composer.json

    # Cannot use `COMPOSER_VENDOR_DIR` to install directly to `$out`, some packages use Composer
    # events (`post-update`, `post-autoload-dump`, etc.) to require files relative to `vendor-dir`
    # (which they request from `getComposer()->getConfig()->get(..)`) - unfortunately, this appears
    # to return the default vendor path, not `COMPOSER_VENDOR_DIR`, so the file that they are
    # looking for isn't found.
    composer install -o

    # Remove the `.git` folder in each dependency directory, these aren't reproducible or required.
    find vendor/ -name .git -type d -print0 | xargs -0 rm -r --

    mv vendor/ $out/
  '';

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  outputHashAlgo = hashAlgo;
  outputHashMode = "recursive";
  outputHash = hash;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
} // (builtins.removeAttrs args [ "name" "hash" "hashAlgo" ]))
