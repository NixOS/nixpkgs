{
  stdenv,
  lib,
  php,
  autoreconfHook,
  fetchurl,
  re2c,
  nix-update-script,
}:

{
  pname,
  version,
  internalDeps ? [ ],
  peclDeps ? [ ],
  buildInputs ? [ ],
  nativeBuildInputs ? [ ],
  postPhpize ? "",
  makeFlags ? [ ],
  src ? fetchurl (
    {
      url = "https://pecl.php.net/get/${pname}-${version}.tgz";
    }
    // lib.filterAttrs (
      attrName: _:
      lib.elem attrName [
        "sha256"
        "hash"
      ]
    ) args
  ),
  passthru ? { },
  ...
}@args:

stdenv.mkDerivation (
  args
  // {
    name = "php-${pname}-${version}";
    extensionName = pname;

    inherit src;

    strictDeps = true;
    nativeBuildInputs = [
      php
      autoreconfHook
      re2c
    ]
    ++ nativeBuildInputs;
    buildInputs = [ php ] ++ peclDeps ++ buildInputs;

    makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ] ++ makeFlags;

    autoreconfPhase = ''
      phpize
      ${postPhpize}
      ${lib.concatMapStringsSep "\n" (
        dep: "mkdir -p ext; ln -s ${dep.dev}/include ext/${dep.extensionName}"
      ) internalDeps}
    '';
    checkPhase = "NO_INTERACTON=yes make test";

    passthru = passthru // {
      # Thes flags were introduced for `nix-update` so that it can update
      # PHP extensions correctly.
      # See the corresponding PR: https://github.com/Mic92/nix-update/pull/123
      isPhpExtension = true;
      updateScript = passthru.updateScript or (nix-update-script { });
    };
  }
)
