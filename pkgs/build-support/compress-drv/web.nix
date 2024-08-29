{
  brotli,
  compressDrv,
  lib,
  zopfli,
  zstd,
}:
/**
  compressDrvWeb compresses a derivation for common web server use.

  Useful when one wants to pre-compress certain static assets and pass them to
  the web server.

  # Inputs

  `formats` ([String])

  : List of file extensions to compress.

    Defaults to common formats that compress well.

  `extraFindOperands` (String)

  : See compressDrv for details.

  `extraFormats` ([ String ])

  : Extra extensions to compress in addition to `formats`.

  `compressors` ( { ${fileExtension} :: String })

  : Map a desired extension (e.g. `gz`) to a compress program.

  # Type

  ```
  compressDrvWeb :: Derivation -> { formats :: [ String ]; extraFormats :: [ String ]; compressors :: { ${fileExtension} :: String; } } -> Derivation
  ```

  # Examples
  :::{.example}
  ## `pkgs.compressDrvWeb` full usage example with `pkgs.gamja` and a webserver
  ```nix

  For example, building `pkgs.gamja` produces the following output:

    /nix/store/2wn1qbk8gp4y2m8xvafxv1b2dcdqj8fz-gamja-1.0.0-beta.9/
    ├── index.2fd01148.js
    ├── index.2fd01148.js.map
    ├── index.37aa9a8a.css
    ├── index.37aa9a8a.css.map
    ├── index.html
    └── manifest.webmanifest

  With `pkgs.compressDrvWeb`, one can compress these files:

  ```nix
  pkgs.compressDrvWeb pkgs.gamja {}
  =>
  «derivation /nix/store/...-gamja-compressed.drv»
  ```

  ```bash
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
  ```

  When the `-compressed` derivation is passed to a properly configured web server,
  it enables direct serving of the pre-compressed files.

  ```shell-session
  $ curl -I -H 'Accept-Encoding: br' https://irc.example.org/
  <...>
  content-encoding: br
  <...>
  ```

  For example, a caddy configuration snippet for gamja to serve
  the static assets (JS, CSS files) pre-compressed:

  ```nix
  {
    virtualHosts."irc.example.org".extraConfig = ''
      root * ${pkgs.compressDrvWeb pkgs.gamja {}}
      file_server browse {
          precompressed br gzip
      }
    '';
  }
  ```

  This feature is also available in nginx via `ngx_brotli` and
  `ngx_http_gzip_static_module`.
  :::
*/
drv:
{
  formats ? [
    "css"
    "eot"
    "htm"
    "html"
    "js"
    "json"
    "map"
    "otf"
    "svg"
    "ttf"
    "txt"
    "webmanifest"
    "xml"
  ],
  extraFormats ? [ ],
  compressors ? {
    br = "${lib.getExe brotli} --keep --no-copy-stat {}";
    gz = "${lib.getExe zopfli} --keep {}";
    # --force is required to not fail on symlinks
    # for details on the compression level see
    # https://github.com/NixOS/nixpkgs/pull/332752#issuecomment-2275110390
    zstd = "${lib.getExe zstd} --force --keep --quiet -19 {}";
  },
  extraFindOperands ? "",
}:
compressDrv drv {
  formats = formats ++ extraFormats;
  compressors = compressors;
  inherit extraFindOperands;
}
