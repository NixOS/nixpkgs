{
  lib,
  stdenv,
  fetchFromGitHub,
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
  lldb = (import ./lldb.nix { inherit fetchFromGitHub llvmPackages; });

  adapter = (
    import ./adapter.nix {
      inherit
        lib
        lldb
        makeWrapper
        rustPlatform
        stdenv

        pname
        src
        version
        ;
    }
  );

  nodeDeps = (
    import ./node_deps.nix {
      inherit
        buildNpmPackage
        libsecret
        pkg-config
        python3

        pname
        src
        version
        ;
    }
  );

  # debugservers on macOS require the 'com.apple.security.cs.debugger'
  # entitlement which nixpkgs' lldb-server does not yet provide; see
  # <https://github.com/NixOS/nixpkgs/pull/38624> for details
  lldbServer =
    if stdenv.hostPlatform.isDarwin then
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
    makeWrapper
    nodejs
    unzip
  ];

  patches = [ ./patches/cmake-build-extension-only.patch ];

  postPatch = ''
    # temporary patch for forgotten version updates
    substituteInPlace CMakeLists.txt \
      --replace-fail "1.9.2" ${version}
  '';

  postConfigure =
    ''
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
    description = "Native debugger extension for VSCode based on LLDB";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = [ lib.licenses.mit ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
