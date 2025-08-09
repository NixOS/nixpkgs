{
  callPackage,
  cargo,
  cmake,
  fetchFromGitHub,
  lib,
  llvmPackages_19,
  makeRustPlatform,
  makeWrapper,
  nodejs,
  python3,
  rustc,
  stdenv,
  unzip,
}:
assert lib.versionAtLeast python3.version "3.5";
let
  publisher = "vadimcn";
  pname = "vscode-lldb";
  version = "1.11.4";

  vscodeExtUniqueId = "${publisher}.${pname}";
  vscodeExtPublisher = publisher;
  vscodeExtName = pname;

  src = fetchFromGitHub {
    owner = "vadimcn";
    repo = "codelldb";
    rev = "v${version}";
    hash = "sha256-+Pe7ij5ukF5pLgwvr+HOHjIv1TQDiPOEeJtkpIW9XWI=";
  };

  lldb = llvmPackages_19.lldb;

  adapter = (
    callPackage ./adapter.nix {
      # The adapter is meant to be compiled with clang++,
      # based on the provided CMake toolchain files.
      # <https://github.com/vadimcn/codelldb/tree/master/cmake>
      rustPlatform = makeRustPlatform {
        stdenv = llvmPackages_19.libcxxStdenv;
        inherit cargo rustc;
      };
      stdenv = llvmPackages_19.libcxxStdenv;

      inherit
        pname
        src
        version
        ;
    }
  );

  nodeDeps = (
    callPackage ./node_deps.nix {
      inherit
        pname
        src
        version
        ;
    }
  );

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
    makeWrapper
    nodejs
    unzip
  ];

  patches = [ ./patches/cmake-build-extension-only.patch ];

  # Make devDependencies available to tools/prep-package.js
  preConfigure = ''
    cp -r ${nodeDeps}/lib/node_modules .
  '';

  postConfigure = ''
    cp -r ${nodeDeps}/lib/node_modules .
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export HOME="$TMPDIR/home"
    mkdir $HOME
  '';

  cmakeFlags = [
    # Do not append timestamp to version.
    "-DVERSION_SUFFIX="
  ];
  makeFlags = [ "vsix_bootstrap" ];

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    ext=$out/$installPrefix
    runHook preInstall

    unzip ./codelldb-bootstrap.vsix 'extension/*' -d ./vsix-extracted

    mkdir -p $ext/adapter
    mv -t $ext vsix-extracted/extension/*
    cp -t $ext/ -r ${adapter}/share/*
    wrapProgram $ext/adapter/codelldb \
      --prefix LD_LIBRARY_PATH : "$ext/lldb/lib" \
      --set-default LLDB_DEBUGSERVER_PATH "${adapter.lldbServer}"
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
    description = "Native debugger extension for VSCode based on LLDB";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.r4v3n6101 ];
    platforms = lib.platforms.all;
  };
}
