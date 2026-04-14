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

  throwSystem = "unsupported";

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
      x86_64-linux = "23.26.3.0.0";
      aarch64-linux = "23.26.3.0.0";
      aarch64-darwin = "23.26.2.0.0";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  directory =
    {
      x86_64-linux = "2326300";
      aarch64-linux = "2326300";
      aarch64-darwin = "2326200";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  # hashes per component and architecture
  hashes =
    {
      x86_64-linux = {
        basic = "sha256-/OSFNhMykn+DKOpLaNmJaMaw6hJOYkcN6MnQzviAEw4=";
        sdk = "sha256-esE1h7qKc0rnzAbPQnU7v9vmmDna+HvVk1pJyD3szP0=";
        sqlplus = "sha256-ZXDXk5hWdnzbtUm1HhQj1qX1MUPFfDDAFWaXBvZaYyo=";
        tools = "sha256-aAtubzt64Tly1MOVmz3E870HWgvtUeXVshkV1VNfNQs=";
        odbc = "sha256-Jjz8d7uruWSEcg7fF+g6+5bJF9lvBTrnYhhvCrzm9Aw=";
      };
      aarch64-linux = {
        basic = "sha256-dLB0TXvxvij2DD2QoTXl2arKGUa6sK3MDI21+8LMl1g=";
        sdk = "sha256-X7A7RhXYbKemRTpBozT8J9ysbYOd1+VBF3MiqvOe4xg=";
        sqlplus = "sha256-w8Dvwac0ZV5ITHHzFkYEGKBrpapa8AxV0e2h2racbak=";
        tools = "sha256-0lzr6PX96IYT7PKcvI99OpMB8SxHPAseFvzTFlLLrME=";
        odbc = "sha256-YlsMBi3tSjyGdjb5QRsny58aGJmWvxDKCxbw4UIEbEQ=";
      };
      aarch64-darwin = {
        basic = "sha256-w8T843pVcZIyJxfBqEIv4Jj8gppB84L1eiiLJK1roR4=";
        sdk = "sha256-XuDf/n/wrFXuoZjvaWgcxyn8f98XzJCJ+L/V2TxRQT4=";
        sqlplus = "sha256-w7EFNxlKUmej7RjQn92uH4ZBkeDeJa14BClAu4JJYpQ=";
        tools = "sha256-cEHZFl/jcMxM51mF2xzxT+0heotePiz+nM4GljUns40=";
        odbc = "sha256-N3IFU346SndwqjhdSLpOZ7BJUMV7I76IdYdfd+qiyYQ=";
      };
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  # convert platform to oracle architecture names
  arch =
    {
      x86_64-linux = "linux.x64";
      aarch64-linux = "linux.arm64";
      aarch64-darwin = "macos.arm64";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

  shortArch =
    {
      x86_64-linux = "linux";
      aarch64-linux = "linux";
      aarch64-darwin = "mac";
    }
    .${stdenv.hostPlatform.system} or throwSystem;

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
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    hydraPlatforms = [ ];
  };
}
