{
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
})
