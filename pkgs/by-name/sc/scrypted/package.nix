{
  stdenv,
  lib,
  callPackage,
  symlinkJoin,
  makeWrapper,

  ffmpeg,
  python3,
  pythonManylinuxPackages,

  scrypted-unwrapped ? callPackage ./unwrapped.nix { },

  extraPythons ? [ ],
  extraPython3Packages ? (_: [ ]),
  extraDependencies ? [ ],

  plugins ? [ ],
}:
let
  getPythonVersion = package: lib.replaceStrings [ "." ] [ "" ] package.passthru.pythonVersion;
  addPython = package: "--set SCRYPTED_PYTHON${getPythonVersion package}_PATH ${package.interpreter}";

  python3Env = python3.withPackages (
    p:
    (extraPython3Packages p)
    ++ (with p; [
      pip
      debugpy
    ])
  );
in
symlinkJoin rec {
  name = "scrypted";
  inherit (scrypted-unwrapped) version meta;

  paths = [
    scrypted-unwrapped
  ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.concatMap (plugin: plugin.buildInputs) plugins ++ extraDependencies;

  postBuild = ''
    wrapProgram $out/bin/scrypted-serve \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          python3
        ]
      } \
      --set SCRYPTED_FFMPEG_PATH ${lib.getExe ffmpeg} \
      --set SCRYPTED_PYTHON_PATH ${python3Env.interpreter} \
      ${lib.concatMapStringsSep " " addPython extraPythons} \
      --set NODE_ENV production \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          (lib.optionals stdenv.hostPlatform.isLinux pythonManylinuxPackages.manylinux1) ++ buildInputs
        )
      }
  '';

  passthru = {
    inherit scrypted-unwrapped;
  };
}
