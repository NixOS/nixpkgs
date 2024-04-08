# Nginx {#sec-nginx}

[Nginx](https://nginx.org) is a reverse proxy and lightweight webserver.

## ETags on static files served from the Nix store {#sec-nginx-etag}

HTTP has a couple of different mechanisms for caching to prevent clients from having to download the same content repeatedly if a resource has not changed since the last time it was requested. When nginx is used as a server for static files, it implements the caching mechanism based on the [`Last-Modified`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Last-Modified) response header automatically; unfortunately, it works by using filesystem timestamps to determine the value of the `Last-Modified` header. This doesn't give the desired behavior when the file is in the Nix store because all file timestamps are set to 0 (for reasons related to build reproducibility).

Fortunately, HTTP supports an alternative (and more effective) caching mechanism: the [`ETag`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag) response header. The value of the `ETag` header specifies some identifier for the particular content that the server is sending (e.g., a hash). When a client makes a second request for the same resource, it sends that value back in an `If-None-Match` header. If the ETag value is unchanged, then the server does not need to resend the content.

As of NixOS 19.09, the nginx package in Nixpkgs is patched such that when nginx serves a file out of `/nix/store`, the hash in the store path is used as the `ETag` header in the HTTP response, thus providing proper caching functionality. With NixOS 24.05 and later, the `ETag` additionally includes the response content length, to ensure files served with static compression do not share `ETag`s with their uncompressed version. This `ETag` functionality is enabled automatically; you do not need to do modify any configuration to get this behavior.
