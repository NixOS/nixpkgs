{
  lib,
  runCommand,
  xorg,
  zopfli,
  brotli,
}: let
  compressDrv = drv: {
    formats,
    compressors,
    ...
  } @ args: let
    compressorMap = lib.filterAttrs (k: _: (lib.hasPrefix "compressor-" k)) args;
    compressCommands =
      map
      (ext: let
        prog = builtins.getAttr "compressor-${ext}" compressorMap;
      in "tee >(xargs -I{} -n1 -P$NIX_BUILD_CORES ${prog})")
      compressors;
    formatsbar = builtins.concatStringsSep "|" formats;
  in
    runCommand "${drv.name}-compressed" {} ''
      mkdir $out
      ${xorg.lndir}/bin/lndir ${drv}/ $out/

      find -L $out -type f -regextype posix-extended \
        -iregex '.*\.(${formatsbar})' | \
          ${builtins.concatStringsSep " | \\\n    " compressCommands}
      find $out/
    '';
in {
  /*
  compressDrv compresses files in a given derivation.

  Inputs:

  - formats :: [String]

      List of file extensions to compress.

      Example: ["txt" "svg" "xml"]

  - compressors :: [String]

      A list of compressor names to use. Each element will need to have
      an associated compressor in the same arguments (see below).

      Example: ["gz" "zstd"]

  - compressor-<EXTENSION> :: String

      Map a desired extension (e.g. `gz`) to a compress program.

      The compressor program that will be executed to get the `COMPRESSOR`
      extension. The program is passed to xargs like this:

        xargs -I{} -n1 ${prog}

      Compressor must:
      - read symlinks (thus --force is needed to gzip, zstd, xz).
      - keep the original file in place (--keep).

      Example compressor:

        compressor-xz = "${xz}/bin/xz --force --keep {}";

   See compressDrvWeb, which is a wrapper on top of compressDrv, for broader
   use examples.
  */

  compressDrv = compressDrv;

  /*
  compressDrvWeb compresses a derivation for "web server" usage.

  Useful when one wants to pre-compress certain static assets and pass them to
  the web server. For example, `pkgs.gamja` creates this derivation:

      /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/
      ├── index.2fd01148.js
      ├── index.2fd01148.js.map
      ├── index.37aa9a8a.css
      ├── index.37aa9a8a.css.map
      ├── index.html
      └── manifest.webmanifest

  `pkgs.compressDrvWeb pkgs.gamja`:

      /nix/store/f5ryid7zrw2hid7h9kil5g5j29q5r2f7-gamja-1.0.0-beta.9-compressed
      ├── index.2fd01148.js -> /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/index.2fd01148.js
      ├── index.2fd01148.js.br
      ├── index.2fd01148.js.gz
      ├── index.2fd01148.js.map -> /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/index.2fd01148.js.map
      ├── index.2fd01148.js.map.br
      ├── index.2fd01148.js.map.gz
      ├── index.37aa9a8a.css -> /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/index.37aa9a8a.css
      ├── index.37aa9a8a.css.br
      ├── index.37aa9a8a.css.gz
      ├── index.37aa9a8a.css.map -> /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/index.37aa9a8a.css.map
      ├── index.37aa9a8a.css.map.br
      ├── index.37aa9a8a.css.map.gz
      ├── index.html -> /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/index.html
      ├── index.html.br
      ├── index.html.gz
      ├── manifest.webmanifest -> /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/manifest.webmanifest
      ├── manifest.webmanifest.br
      └── manifest.webmanifest.gz


  When this `-compressed` directory is passed to a properly configured web
  server, it will serve those pre-compressed files:

      $ curl -I -H 'Accept-Encoding: br' https://irc.example.org/
      <...>
      content-encoding: br
      <...>

  For example, a caddy configuration snippet for gamja to serve
  the static assets (JS, CSS files) pre-compressed:

      virtualHosts."irc.example.org".extraConfig = ''
        root * ${pkgs.compressDrvWeb pkgs.gamja {}}
        file_server browse {
            precompressed br gzip
        }
      '';

  This feature is also available in nginx via `ngx_brotli` and
  `ngx_http_gzip_static_module`.

  Inputs:
  - formats :: [String]

      List of file extensions to compress.

      Default: common formats that compress well. The list may be appended
      expanded.

  - extraFormats :: [String]

      Extra extensions to compress in addition to `formats`.

  - compressors :: [String]

      A list of compressor names to use. Each element will need to have
      an associated compressor in the same arguments (see below).

      Default: ["gz" "br"]

    - extraCompressors :: [String]

      Extra compressors in addition to `compressors`.

  - compressor-<COMPRESSOR> :: String

      Map a desired extension (e.g. `gz`) to a compress program.

      The compressor program that will be executed to get the `COMPRESSOR`
      extension. The program is passed to xargs like this:

        xargs -I{} -n1 ${prog}

      Default:

        compressor-gz = "${zopfli}/bin/zopfli --keep {}";
        compressor-br = "${brotli}/bin/brotli --keep --no-copy-stat {}";

  */

  compressDrvWeb = drv: {
    formats ? ["css" "js" "svg" "ttf" "eot" "txt" "xml" "map" "html" "json" "webmanifest"],
    extraFormats ? [],
    compressors ? ["gz" "br"],
    extraCompressors ? [],
    ...
  } @ args:
    compressDrv drv ({
        formats = formats ++ extraFormats;
        compressors = compressors ++ extraCompressors;
        compressor-gz = "${zopfli}/bin/zopfli --keep {}";
        compressor-br = "${brotli}/bin/brotli --keep --no-copy-stat {}";
      }
      // lib.filterAttrs (k: _: (lib.hasPrefix "compressor-" k)) args);
}
