{
  zopfli,
  brotli,
  compressDrv,
}:
/**
  # compressDrvWeb compresses a derivation for common web server use.

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

  ## Inputs

  `formats` ([String])

  : List of file extensions to compress. Default is common formats that compress
  well. The list may be expanded.

  `extraFormats` ([String])

  : Extra extensions to compress in addition to `formats`.

  `compressors` (String -> String)

  : See parameter `compressors` of compressDrv.
*/
drv:
{
  formats ? [
    "css"
    "js"
    "svg"
    "ttf"
    "eot"
    "txt"
    "xml"
    "map"
    "html"
    "json"
    "webmanifest"
  ],
  extraFormats ? [ ],
  compressors ? {
    "gz" = "${zopfli}/bin/zopfli --keep {}";
    "br" = "${brotli}/bin/brotli --keep --no-copy-stat {}";
  },
  ...
}:
compressDrv drv {
  formats = formats ++ extraFormats;
  compressors = compressors;
}
