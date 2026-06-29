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

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  # assemble list of components
  components = [
    "basic"
    "sdk"
    "sqlplus"
    "tools"
  ]
  ++ optional odbcSupport "odbc";

  # determine the version number, there might be different ones per architecture
  version =
    {
      x86_64-linux = "23.26.1.0.0";
      aarch64-linux = "23.26.1.0.0";
      x86_64-darwin = "19.16.0.0.0";
      aarch64-darwin = "23.3.0.23.09";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  directory =
    {
      x86_64-linux = "2326100";
      aarch64-linux = "2326100";
      x86_64-darwin = "1916000";
      aarch64-darwin = "233023";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  # hashes per component and architecture
  hashes =
    {
      x86_64-linux = {
        basic = "sha256-1nFeQEo1s6U4KAt4329+5Z2oOp02tZYhj9JkBR25d/M=";
        sdk = "sha256-LX747BTD4CQCIWIMEs6U0EcJLJBlFx2xd3jM57H91ds=";
        sqlplus = "sha256-Oi9t4B0iTkPcN4YJR7piNPAgBdryn8zUe4vBCGYZjkk=";
        tools = "sha256-34pyUxx7ubgTrTCqtHOIPMGg7baS1lCUuCgnBRbYR30=";
        odbc = "sha256-e8RaAWSNvI0QQABV7t7rO58Vn26jnwe6IsaxSpPAZtM=";
      };
      aarch64-linux = {
        basic = "sha256-Gsvr+LfnCBcf78ZhKmpmhFXn6J7HVloqcjps91QGCvI=";
        sdk = "sha256-LEziVUysVWPwSwc2iiEMcN1GtLM8r1R0rns4tXvroaA=";
        sqlplus = "sha256-LxgsfrLy93hY9dzvne6IE3XGM4d03UFkos/EFv9664o=";
        tools = "sha256-RU4J4zDZ9nAg8Q0zt2u37Mw02/rXaMjG5cg5r4lMqck=";
        odbc = "sha256-fRo46haK5IVT+Y/kCzvP0hGCI9m//RTKHcF5/Gfz2Eo=";
      };
      x86_64-darwin = {
        basic = "sha256-cl7rfAAEHpJrV8PbUI6nQ5oZNaN/SAwKxtRu3cQgUzE=";
        sdk = "sha256-DO4/x8xCfZUDcHRZua3QzBRrgMNIeUCrYjG9yrcCoOs=";
        sqlplus = "sha256-1KIZviC2YNq21TBigKJDbpfH6W5578/T/BR6MkQaaX0=";
        tools = "sha256-s7j6FGWzLM1f6O1zVuCxaDvOiolZHNJxVzSPu8G4/Bo=";
        odbc = "sha256-9+eMK3RFZUehUKSY+lkAUE10EgQgev9E5/z6ASVbO6A=";
      };
      aarch64-darwin = {
        basic = "sha256-G83bWDhw9wwjLVee24oy/VhJcCik7/GtKOzgOXuo1/4=";
        sdk = "sha256-PerfzgietrnAkbH9IT7XpmaFuyJkPHx0vl4FCtjPzLs=";
        sqlplus = "sha256-khOjmaExAb3rzWEwJ/o4XvRMQruiMw+UgLFtsOGn1nY=";
        tools = "sha256-gA+SbgXXpY12TidpnjBzt0oWQ5zLJg6wUpzpSd/N5W4=";
        odbc = "sha256-JzoSdH7mJB709cdXELxWzpgaNTjOZhYH/wLkdzKA2N0=";
      };
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  # rels per component and architecture, optional
  rels =
    {
      aarch64-darwin = {
        basic = "1";
        tools = "1";
      };
    }
    .${stdenv.hostPlatform.system} or { };

  # convert platform to oracle architecture names
  arch =
    {
      x86_64-linux = "linux.x64";
      aarch64-linux = "linux.arm64";
      x86_64-darwin = "macos.x64";
      aarch64-darwin = "macos.arm64";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  shortArch =
    {
      x86_64-linux = "linux";
      aarch64-linux = "linux";
      x86_64-darwin = "mac";
      aarch64-darwin = "mac";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  suffix =
    {
      x86_64-darwin = "dbru.dmg";
      aarch64-darwin = ".dmg";
    }
    .${stdenv.hostPlatform.system} or ".zip";

  # calculate the filename of a single zip file
  srcFilename =
    component: arch: version: rel:
    "instantclient-${component}-${arch}-${version}" + (optionalString (rel != "") "-${rel}") + suffix;

  # fetcher for the non clickthrough artifacts
  fetcher =
    srcFilename: hash:
    fetchurl {
      url = "https://download.oracle.com/otn_software/${shortArch}/instantclient/${directory}/${srcFilename}";
      sha256 = hash;
    };

  # assemble srcs
  srcs = map (
    component:
    (fetcher (srcFilename component arch version rels.${component} or "") hashes.${component} or "")
  ) components;

  isDarwinAarch64 = stdenv.hostPlatform.system == "aarch64-darwin";

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
    (if isDarwinAarch64 then _7zz else unzip)
  ]
  ++ optional stdenv.hostPlatform.isLinux autoPatchelfHook
  ++ optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  unpackCmd =
    if isDarwinAarch64 then
      "7zz x $curSrc -aoa -oinstantclient -x!META-INF"
    else
      "unzip $curSrc -x 'META-INF/*'";

  installPhase = ''
    mkdir -p "$out/"{bin,include,lib,"share/java","share/${pname}-${version}/demo/"} $lib/lib
    install -Dm755 {adrci,genezi,uidrvci,sqlplus,exp,expdp,imp,impdp} $out/bin

    # cp to preserve symlinks
    cp -P *${extLib}* $lib/lib

    install -Dm644 *.jar $out/share/java
    install -Dm644 sdk/include/* $out/include
    install -Dm644 sdk/demo/* $out/share/${pname}-${version}/demo

    # provide alias
    ln -sfn $out/bin/sqlplus $out/bin/sqlplus64
  '';

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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    hydraPlatforms = [ ];
  };
}
