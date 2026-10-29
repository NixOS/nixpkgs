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
  unzip,
}:
assert lib.versionAtLeast python3.version "3.5";
let
  publisher = "vadimcn";
  pname = "vscode-lldb";
  version = "1.12.1";

  vscodeExtUniqueId = "${publisher}.${pname}";
  vscodeExtPublisher = publisher;
  vscodeExtName = pname;

  src = fetchFromGitHub {
    owner = "vadimcn";
    repo = "codelldb";
    rev = "v${version}";
    hash = "sha256-B8iCy4NXG7IzJVncbYm5VoAMfhMfxGF+HW7M5sVn5b0=";
  };

  lldb = llvmPackages_19.lldb;
  stdenv = llvmPackages_19.libcxxStdenv;

  cargoHash = "sha256-fuUTLdavMiYfpyxctXes2GJCsNZd5g1d4B/v+W/Rnu8=";

  adapter = (
    callPackage ./adapter.nix {
      # The adapter is meant to be compiled with clang++,
      # based on the provided CMake toolchain files.
      # <https://github.com/vadimcn/codelldb/tree/master/cmake>
      rustPlatform = makeRustPlatform {
        inherit stdenv cargo rustc;
      };

      inherit
        pname
        src
        version
        stdenv
        cargoHash
        codelldb-launch
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

  codelldb-types = (
    callPackage ./codelldb-types.nix {
      rustPlatform = makeRustPlatform {
        inherit stdenv cargo rustc;
      };

      inherit
        pname
        src
        version
        cargoHash
        ;
    }
  );

  codelldb-launch = (
    callPackage ./codelldb-launch.nix {
      rustPlatform = makeRustPlatform {
        inherit stdenv cargo rustc;
      };

      inherit
        pname
        src
        version
        cargoHash
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
    codelldb-types
    codelldb-launch
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

    # Used by VSCode
    mkdir -p $ext/bin
    cp ${codelldb-launch}/bin/codelldb-launch $ext/bin/codelldb-launch

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
    inherit lldb;
    adapter = adapter.override { standalone = true; };
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
