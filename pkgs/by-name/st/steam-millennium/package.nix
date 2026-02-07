{
  runCommand,
  steam,
  millennium,
  ...
}:
let
  millenniumLibraries = libPkgs: [
    millennium
    libPkgs.openssl
  ];

  millenniumEnv = {
    OPENSSL_CONF = "/dev/null";
    STEAM_RUNTIME_LOGGER = "0";
    MILLENNIUM_RUNTIME_PATH = "${millennium}/lib/libmillennium_x86.so";
  };
in
steam.override (prev: {
  extraEnv = millenniumEnv // (prev.extraEnv or { });
  extraLibraries =
    libPkgs:
    let
      prevLibs = if prev ? extraLibraries then prev.extraLibraries libPkgs else [ ];
      millenniumLibs = millenniumLibraries libPkgs;
    in
    prevLibs ++ millenniumLibs;
  extraPkgs = extraPkgs: [
    millennium.assets
    millennium.shims
    millennium.python
    (runCommand "millennium-libXtst-shim"
      {
        meta.priority = 10;
      }
      ''
        mkdir -p $out/lib
        ln -s ${millennium}/lib/libmillennium_bootstrap_86x.so $out/lib/libXtst.so.6
      ''
    )
  ];
})
