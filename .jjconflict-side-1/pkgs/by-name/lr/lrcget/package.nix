{
  lib,
  stdenv,
  rustPlatform,

  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,

  cargo-tauri,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  alsa-lib,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lrcget";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "tranxuanthang";
    repo = "lrcget";
    tag = version;
    hash = "sha256-sp31o62rwWONd7ajo8prvkEVbU3lPPLFkXsxAT9oRzY=";
  };

  patches = [
    # needed to not attempt codesigning on darwin
    ./remove-signing-identity.patch

    # Make npm ci pass by adding missing packages to package-lock.json
    # Upstream PR: https://github.com/tranxuanthang/lrcget/pull/408
    ./sync-package-lock.patch
  ];

  cargoPatches = [
    # Update charabia crate to v0.10.0 to allow caching of Lindera dictionaries
    # Upstream PR: https://github.com/tranxuanthang/lrcget/pull/407
    ./update-to-charabia-0.10.0.patch
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-qyIvUbEBImJfVaxILtLN88KREgUk45zRdxbdZ1A6vc0=";

  # FIXME: This is a workaround, because we have a git dependency node_modules/lrc-kit contains install scripts
  # but has no lockfile, which is something that will probably break.
  forceGitDeps = true;

  npmDeps = fetchNpmDeps {
    name = "lrcget-${version}-npm-deps";
    inherit src forceGitDeps patches;
    hash = "sha256-PyKnh2AjdhWurTQmoCuOnLDdDIcZT51xwpPImkc3nBc=";
  };

  preConfigure =
    let
      # Adapted from pg_search's Nix package: https://github.com/NixOS/nixpkgs/blob/b1b875982b17dabde9b4a37f3e229e74913e6db3/pkgs/servers/sql/postgresql/ext/pg_search.nix#L27
      # Lindera dictionaries are copied to a temporary directory and Lindera's
      # cache environment variable prevents the build.rs files in
      # the Lindera crates from downloading their dictionary from an
      # external URL, which doesn't work in the Nix sandbox.

      # Lindera uses subdirectory in the main cache directory to separate cached
      # dictionaries for different versions of Lindera.
      # The name of those subdirectories is made up of the Lindera version
      # and the "format" version (currently only for format version 2).
      # LRCGET's Lindera version is in their Cargo.lock file: https://github.com/tranxuanthang/lrcget/tree/${version}/src-tauri/Cargo.lock
      # And the current format version is 2, represented by the -fmt2 suffix in the subdirectory name.
      cacheSubdir = "5.3.0-fmt2";

      # The env var Lindera uses for the cache has changed over time.
      # Currently, the correct variable name is LINDERA_BUILD_DICTIONARY_CACHE_DIR.
      dictCacheVarName = "LINDERA_BUILD_DICTIONARY_CACHE_DIR";

      # The Lindera uses several language dictionaries that can be enabled by consuming apps and libraries.
      # Check the relevant build.rs files to get the proper URLs:
      # https://github.com/lindera/lindera/blob/${linderaVersion}/${dictionaryKey}/build.rs
      # Here's an example build.rs URL:
      # https://github.com/lindera/lindera/blob/v1.5.1/lindera-cc-cedict/build.rs

      dict =
        {
          language,
          filename,
          hash,
        }:
        {
          inherit filename language;
          source = fetchurl {
            url = "https://lindera.dev/${filename}";
            inherit hash;
          };
        };

      # LRCGET via charabia requires the Korean and Japanese (unidic) dictionaries.
      dictionaries = {
        lindera-ko-dic = dict {
          language = "Korean";
          filename = "mecab-ko-dic-2.1.1-20180720.tar.gz";
          hash = "sha256-cCztIcYWfp2a68Z0q17lSvWNREOXXylA030FZ8AgWRo=";
        };
        lindera-unidic = dict {
          language = "Japanese";
          filename = "unidic-mecab-2.1.2.tar.gz";
          hash = "sha256-JKx1/k5E2XO1XmWEfDX6Suwtt6QaB7ScoSUUbbn8EYk=";
        };
      };
    in
    ''
      export ${dictCacheVarName}=$TMPDIR/lindera-cache
      mkdir -p ''$${dictCacheVarName}/${cacheSubdir}
      ${lib.concatMapStringsSep "\n" (dict: ''
        echo "Copying ${dict.language} dictionary to Lindera cache"
        cp -r ${dict.source} ''$${dictCacheVarName}/${cacheSubdir}/${dict.filename}
      '') (lib.attrValues dictionaries)}
      echo "Lindera cache prepared at ''$${dictCacheVarName}"
    '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    alsa-lib
    openssl
    webkitgtk_4_1
  ];

  # To fix `npm ERR! Your cache folder contains root-owned files`
  makeCacheWritable = true;

  # Disable checkPhase, since the project doesn't contain tests
  doCheck = false;

  # make the binary also runnable from the shell
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out/Applications/LRCGET.app/Contents/MacOS/LRCGET" "$out/bin/LRCGET"
  '';

  preFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    gappsWrapperArgs+=(
      # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for mass-downloading LRC synced lyrics for your offline music library";
    homepage = "https://github.com/tranxuanthang/lrcget";
    changelog = "https://github.com/tranxuanthang/lrcget/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anas
      Scrumplex
    ];
    mainProgram = "LRCGET";
    platforms = with lib.platforms; unix ++ windows;
  };
}
