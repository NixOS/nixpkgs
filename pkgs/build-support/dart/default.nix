{ stdenv
, dart
, lib
, fetchzip
, callPackage
, tree
, git
, makeBinaryWrapper
}:

/*
  Build a Dart application.

  Users need to add dependencies listed in the upstream project's
  pubspec.yaml file to dartDependencies. Use `dart.fetchPackage` and 
  `dart.fetchGitPackage` for those, defined in ./fetchPackage.nix and ./fetchGitPackage.nix.

  This can **not** be used to build Flutter apps.

  Example:
  buildDartApp {
  name = "myapp";
  entryPoint = "bin/some-entry-point.dart"; # defaults to bin/${name}.dart
  executableName = "executable-name"; # defaults to ${name}
  src = ./.;
  dartDependencies = with dart; [
      (fetchPackage {
        name = "my-package";
        version = "123";
        sha256 = "sha256-...";
      })
  ];
  }
*/

args@
{
  # dependencies, from `dart.fetchPackage` and `dart.fetchGitPackage`
  dartDependencies ? [ ]
  # application entry point, if non-default
, entryPoint ? "bin/${builtins.replaceStrings ["-"] ["_"] args.name}.dart"
  # filename of the executable in $out/bin
, executableName ? args.name
, ...
}:

let
  dependencyLinkCommands = builtins.map
    (x:
      if x ? isPub
      then
        ''
          mkdir -p pub-cache/hosted/${x.shortUrl}
          ln -s ${x} pub-cache/hosted/${x.shortUrl}/${x.name}-${x.version}''
      else
        ''
          CACHE_DIR=pub-cache/git/cache/${x.name}-$(echo -n ${x.url} | sha1sum | cut -d' ' -f 1)
          mkdir -p $CACHE_DIR/..

          # dart executes git fetch and it would fail because it can't write FETCH_HEAD
          cp --no-preserve=mode,ownership -r ${x}/.git $CACHE_DIR
          ls -lah $CACHE_DIR
          ln -s ${x} pub-cache/git/${x.name}-${x.rev}
        '')
    dartDependencies;
  aotName = ".${executableName}-snapshot.aot";
in


stdenv.mkDerivation (args // {
  nativeBuildInputs = [ dart git makeBinaryWrapper ];
  buildInputs = [ dart ];
  dontStrip = true; # else the dart vm cannot run the exe

  buildPhase = ''
    # needed because pub will spawn git and that will complain about dubious ownership,
    # so we mark the paths needed at save, and it saves that to ~/.gitconfig
    export HOME=$(mktemp -d)
    mkdir -p pub-cache/git/cache pub-cache/hosted

    ${lib.concatLines dependencyLinkCommands}
    export PUB_CACHE=$(realpath pub-cache)

    # so pub doesn't complain that the upstream pubspec.lock doesn't match our hashes
    # (mostly because of git dependencies). The packages the user provides are deterministic anyway.
    rm pubspec.lock

    dart pub get --offline -v
    # we do this (compile an AOT, then run on the nixpkgs-provided vm) for other languages,
    # eg java, too
    dart compile aot-snapshot ${entryPoint} -o ${aotName}
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ${aotName} $out/bin
    makeBinaryWrapper "${dart}/bin/dartaotruntime" $out/bin/${executableName} \
      --add-flags "$out/bin/${aotName}"
  '';
})
