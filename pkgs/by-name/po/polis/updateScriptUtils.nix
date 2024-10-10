{
  writeShellScript,
  srcOnly,
  fetchpatch,
  clojure,
  jq,
  pkgs,

  source,
}:
let
  clojure-nix-locker = fetchTarball {
    url = "https://github.com/bevuta/clojure-nix-locker/archive/f3b95050963a811344ce75831272948a7a299888.tar.gz";
    sha256 = "1f5lmk0a2dlsyz27w0brwxq06ig9xrm41y43g52lxx2cnclbv82b";
  };

  clojure-nix-locker-patched = srcOnly {
    name = "clojure-nix-locker-patched";
    src = clojure-nix-locker;
    patches = [
      (fetchpatch {
        url = "https://github.com/infinisil/clojure-nix-locker/commit/5db18ff991388d6a1b25b7694fb12ca49813311c.patch";
        hash = "sha256-CANw3TTIg05DDCI0/+iMX471A1XjvE+IHMB97XddvMg=";
      })
    ];
  };

  locker = (import clojure-nix-locker-patched {
    inherit pkgs;
  }).lockfile {
    src = source + "/math";
    lockfile = ./generated/deps.lock.json;
  };
in
{
  inherit clojure-nix-locker-patched;
  commandLocker = locker.commandLocker ''
    ${clojure}/bin/clojure -M:run --help
  '';
}
