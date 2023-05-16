{ pkgs, lib, stdenv, fetchFromGitHub, runCommand, rustPlatform, makeWrapper, llvmPackages
<<<<<<< HEAD
, buildNpmPackage, cmake, nodejs, unzip, python3, pkg-config, libsecret, darwin
=======
, nodePackages, cmake, nodejs, unzip, python3, pkg-config, libsecret
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:
assert lib.versionAtLeast python3.version "3.5";
let
  publisher = "vadimcn";
  pname = "vscode-lldb";
<<<<<<< HEAD
  version = "1.9.2";
=======
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  vscodeExtUniqueId = "${publisher}.${pname}";
  vscodeExtPublisher = publisher;
  vscodeExtName = pname;

  src = fetchFromGitHub {
    owner = "vadimcn";
    repo = "vscode-lldb";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6QmYRlSv8jY3OE3RcYuZt+c3z6GhFc8ESETVfCfF5RI=";
=======
    sha256 = "sha256-5wrw8LNH14WAyIKIRGFbvrISb5RUXeD5Uh/weja9p4Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # need to build a custom version of lldb and llvm for enhanced rust support
  lldb = (import ./lldb.nix { inherit fetchFromGitHub runCommand llvmPackages; });

  adapter = rustPlatform.buildRustPackage {
    pname = "${pname}-adapter";
    inherit version src;

<<<<<<< HEAD
    cargoHash = "sha256-Qq2igtH1XIB+NAEES6hdNZcMbEmaFN69qIJ+gTYupvQ=";
=======
    cargoSha256 = "sha256-Lpo2jaDMaZGwSrpQBvBCscVbWi2Db1Cx1Tv84v1H4Es=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    nativeBuildInputs = [ makeWrapper ];

    buildAndTestSubdir = "adapter";

    buildFeatures = [ "weak-linkage" ];

    cargoBuildFlags = [
      "--lib"
      "--bin=codelldb"
    ];

<<<<<<< HEAD
    patches = [ ./adapter-output-shared_object.patch ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # Tests are linked to liblldb but it is not available here.
    doCheck = false;
  };

<<<<<<< HEAD
  nodeDeps = buildNpmPackage {
    pname = "${pname}-node-deps";
    inherit version src;

    npmDepsHash = "sha256-fMKGi+AJTMlWl7SQtZ21hUwOLgqlFYDhwLvEergQLfI=";

    nativeBuildInputs = [
      python3
      pkg-config
    ];

    buildInputs = [
      libsecret
    ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      Security
      AppKit
    ]);

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r node_modules $out/lib

      runHook postInstall
    '';
  };
=======
  nodeDeps = ((import ./build-deps/default.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  }).nodeDependencies.override (old: {
    inherit src version;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [libsecret];
    dontNpmInstall = true;
  }));
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

in stdenv.mkDerivation {
  pname = "vscode-extension-${publisher}-${pname}";
  inherit src version vscodeExtUniqueId vscodeExtPublisher vscodeExtName;

  installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

  nativeBuildInputs = [ cmake nodejs unzip makeWrapper ];

  patches = [ ./cmake-build-extension-only.patch ];

  postConfigure = ''
<<<<<<< HEAD
    cp -r ${nodeDeps}/lib/node_modules .
=======
    cp -r ${nodeDeps}/lib/{node_modules,package-lock.json} .
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  cmakeFlags = [
    # Do not append timestamp to version.
    "-DVERSION_SUFFIX="
  ];
  makeFlags = [ "vsix_bootstrap" ];

<<<<<<< HEAD
  preBuild = lib.optionalString stdenv.isDarwin ''
    export HOME=$TMPDIR
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installPhase = ''
    ext=$out/$installPrefix
    runHook preInstall

    unzip ./codelldb-bootstrap.vsix 'extension/*' -d ./vsix-extracted

    mkdir -p $ext/{adapter,formatters}
    mv -t $ext vsix-extracted/extension/*
<<<<<<< HEAD
    cp -t $ext/adapter ${adapter}/{bin,lib}/*
    cp -r ../adapter/scripts $ext/adapter
=======
    cp -t $ext/adapter ${adapter}/{bin,lib}/* ../adapter/*.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram $ext/adapter/codelldb \
      --set-default LLDB_DEBUGSERVER_PATH "${lldb.out}/bin/lldb-server"
    cp -t $ext/formatters ../formatters/*.py
    ln -s ${lldb.lib} $ext/lldb
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
