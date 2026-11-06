{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  fixDarwinDylibNames,
  unzip,
  _7zz,
  libaio,
  makeWrapper,
  odbcSupport ? true,
  unixodbc,
}:

assert odbcSupport -> unixodbc != null;

let
  inherit (lib) optional optionalString;

  # assemble list of components
  components = [
    "basic"
    "sdk"
    "sqlplus"
    "tools"
  ]
  ++ optional odbcSupport "odbc";

  sources =
    (lib.importJSON ./sources.json).${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  inherit (sources) version directory hashes;

  # convert platform to oracle architecture names
  arch =
    {
      x86_64-linux = "linux.x64";
      aarch64-linux = "linux.arm64";
      aarch64-darwin = "macos.arm64";
    }
    .${stdenv.hostPlatform.system};

  shortArch =
    {
      x86_64-linux = "linux";
      aarch64-linux = "linux";
      aarch64-darwin = "mac";
    }
    .${stdenv.hostPlatform.system};

  suffix =
    {
      aarch64-darwin = ".dmg";
    }
    .${stdenv.hostPlatform.system} or ".zip";

  # calculate the filename of a single zip file
  srcFilename = component: "instantclient-${component}-${arch}-${version}${suffix}";

  # fetcher for the non clickthrough artifacts
  fetcher =
    srcFilename: hash:
    fetchurl {
      url = "https://download.oracle.com/otn_software/${shortArch}/instantclient/${directory}/${srcFilename}";
      inherit hash;
    };

  # assemble srcs
  srcs = map (component: fetcher (srcFilename component) hashes.${component}) components;

  inherit (stdenv.hostPlatform) isDarwin;

  pname = "oracle-instantclient";
  extLib = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation {
  inherit pname version srcs;

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ]
  ++ optional stdenv.hostPlatform.isLinux libaio
  ++ optional odbcSupport unixodbc;

  nativeBuildInputs = [
    makeWrapper
    (if isDarwin then _7zz else unzip)
  ]
  ++ optional stdenv.hostPlatform.isLinux autoPatchelfHook
  ++ optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  unpackCmd =
    if isDarwin then
      "7zz x $curSrc -aoa -oinstantclient -x!META-INF"
    else
      "unzip $curSrc -x 'META-INF/*'";

  installPhase = ''
    mkdir -p "$out/"{bin,include,lib,"share/java","share/${pname}-${version}/demo/"} $lib/lib
    install -Dm755 {adrci,genezi,uidrvci,sqlplus,exp,expdp,imp,impdp,sqlldr,wrc} $out/bin

    # cp to preserve symlinks
    cp -P *${extLib}* $lib/lib

    install -Dm644 *.jar $out/share/java
    install -Dm644 sdk/include/* $out/include
    install -Dm644 sdk/demo/* $out/share/${pname}-${version}/demo

    # provide alias
    ln -sfn $out/bin/sqlplus $out/bin/sqlplus64
  '';

  passthru.updateScript = ./update.sh;

  postFixup = optionalString stdenv.hostPlatform.isDarwin ''
    for exe in "$out/bin/"* ; do
      if [ ! -L "$exe" ]; then
        install_name_tool -add_rpath "$lib/lib" "$exe"
      fi
    done
  '';

  meta = {
    description = "Oracle instant client libraries and sqlplus CLI";
    longDescription = ''
      Oracle instant client provides access to Oracle databases (OCI,
      OCCI, Pro*C, ODBC or JDBC). This package includes the sqlplus
      command line SQL client.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    hydraPlatforms = [ ];
  };
}
