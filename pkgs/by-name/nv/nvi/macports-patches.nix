let
  url = "https://github.com/macports/macports-ports/raw/abae7e550897dc13b7a48763a7a022b709d8793f/editors/nvi/files";
  hashes = {
    "dynamic_lookup-11.patch" = "sha256-eXLSMUtslSXLYd1HZRD6pfqcYMIA3EtixWL1yvx4ook=";
    "patch-common_key.h.diff" = "sha256-AAO/2lHpmFJMYb9fyQrWnGPaJYLdwhrp87tbHu5hr/k=";
    "patch-dist_port.h.in.diff" = "sha256-GPKgIm9pDGtN6CNqbX3+hANkZbYFql5K5JyjCr5TIKI=";
    "patch-ex_script.c.diff" = "sha256-IUuJ7b6A5O3q6qQCwZsrc9Bt1LpjU3DgxHTwtMp16Qc=";
    "patch-includes.diff" = "sha256-j3V4LmcJEFqnTlTHFZFd8NtycEa+GKM+ZIUwZHjq15w=";
  };
in
builtins.attrValues (
  builtins.mapAttrs (n: v: {
    url = "${url}/${n}";
    hash = v;
    extraPrefix = "";
  }) hashes
)
