{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  rustPlatform,
  makeWrapper,
  llvmPackages,
  buildNpmPackage,
  cmake,
  nodejs,
  unzip,
  python3,
  pkg-config,
  libsecret,
  darwin,
}:
assert lib.versionAtLeast python3.version "3.5";
let
  publisher = "vadimcn";
  pname = "vscode-lldb";
  version = "1.10.0";

  vscodeExtUniqueId = "${publisher}.${pname}";
  vscodeExtPublisher = publisher;
  vscodeExtName = pname;

  src = fetchFromGitHub {
    owner = "vadimcn";
    repo = "vscode-lldb";
    rev = "v${version}";
    hash = "sha256-ExSS5HxDmJJtYypRYJNz7nY0D50gjoDBc4CnJMfgVw8=";
  };

  # need to build a custom version of lldb and llvm for enhanced rust support
  lldb = (import ./lldb.nix { inherit fetchFromGitHub runCommand llvmPackages; });

  adapter = rustPlatform.buildRustPackage {
    pname = "${pname}-adapter";
    inherit version src;

    cargoHash = "sha256-e/Jki/4pCs0qzaBVR4iiUhdBFmWlTZYREQkuFSoWYFo=";

    buildInputs = lib.optionals stdenv.isDarwin [ lldb ];

    nativeBuildInputs = [ makeWrapper ];

    env = lib.optionalAttrs stdenv.isDarwin { NIX_LDFLAGS = "-llldb -lc++abi"; };

    buildAndTestSubdir = "adapter";

    buildFeatures = [ "weak-linkage" ];

    cargoBuildFlags = [
      "--lib"
      "--bin=codelldb"
    ];

    postFixup = ''
      mkdir -p $out/share/{adapter,formatters}
      # codelldb expects libcodelldb.so to be in the same
      # directory as the executable, and can't find it in $out/lib.
      # To make codelldb executable as a standalone,
      # we put all files in $out/share, and then wrap the binary in $out/bin.
      mv $out/bin/* $out/share/adapter
      cp $out/lib/* $out/share/adapter
      cp -r adapter/scripts $out/share/adapter
      cp -t $out/share/formatters formatters/*.py
      ln -s ${lib.getLib lldb} $out/share/lldb
      makeWrapper $out/share/adapter/codelldb $out/bin/codelldb \
        --set-default LLDB_DEBUGSERVER_PATH "${lldb.out}/bin/lldb-server"
    '';

    patches = [ ./adapter-output-shared_object.patch ];

    # Tests are linked to liblldb but it is not available here.
    doCheck = false;
  };

  nodeDeps = buildNpmPackage {
    pname = "${pname}-node-deps";
    inherit version src;

    npmDepsHash = "sha256-fMKGi+AJTMlWl7SQtZ21hUwOLgqlFYDhwLvEergQLfI=";

    nativeBuildInputs = [
      python3
      pkg-config
    ];

    buildInputs =
      [ libsecret ]
      ++ lib.optionals stdenv.isDarwin (
        with darwin.apple_sdk.frameworks;
        [
          Security
          AppKit
        ]
      );

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r node_modules $out/lib

      runHook postInstall
    '';
  };

  # debugservers on macOS require the 'com.apple.security.cs.debugger'
  # entitlement which nixpkgs' lldb-server does not yet provide; see
  # <https://github.com/NixOS/nixpkgs/pull/38624> for details
  lldbServer =
    if stdenv.isDarwin then
      "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver"
    else
      "${lldb.out}/bin/lldb-server";
in
stdenv.mkDerivation {
  pname = "vscode-extension-${publisher}-${pname}";
  inherit
    src
    version
    vscodeExtUniqueId
    vscodeExtPublisher
    vscodeExtName
    ;

  installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

  nativeBuildInputs = [
    cmake
    nodejs
    unzip
    makeWrapper
  ];

  patches = [ ./cmake-build-extension-only.patch ];

  postPatch = ''
    # temporary patch for forgotten version updates
    substituteInPlace CMakeLists.txt \
      --replace "1.9.2" ${version}
  '';

  postConfigure =
    ''
      cp -r ${nodeDeps}/lib/node_modules .
    ''
    + lib.optionalString stdenv.isDarwin ''
      export HOME="$TMPDIR/home"
      mkdir $HOME
    '';

  cmakeFlags = [
    # Do not append timestamp to version.
    "-DVERSION_SUFFIX="
  ];
  makeFlags = [ "vsix_bootstrap" ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    ext=$out/$installPrefix
    runHook preInstall

    unzip ./codelldb-bootstrap.vsix 'extension/*' -d ./vsix-extracted

    mkdir -p $ext/{adapter,formatters}
    mv -t $ext vsix-extracted/extension/*
    cp -t $ext/ -r ${adapter}/share/*
    wrapProgram $ext/adapter/codelldb \
      --prefix LD_LIBRARY_PATH : "$ext/lldb/lib" \
      --set-default LLDB_DEBUGSERVER_PATH "${lldbServer}"
    # Mark that all components are installed.
    touch $ext/platform.ok

    runHook postInstall
  '';

  # `adapter` will find python binary and libraries at runtime.
  postFixup = ''
    wrapProgram $out/$installPrefix/adapter/codelldb \
      --prefix PATH : "${python3}/bin" \
      --prefix LD_LIBRARY_PATH : "${python3}/lib"
  '';

  passthru = {
    inherit lldb adapter;
    updateScript = ./update.sh;
  };

  meta = {
    description = "A native debugger extension for VSCode based on LLDB";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.nigelgbanks ];
    platforms = lib.platforms.all;
  };
}
