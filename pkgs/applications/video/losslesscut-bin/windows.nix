{ stdenvNoCC
, lib
, fetchurl
, unzip
, version
, sha256
, useMklink ? false
, customSymlinkCommand ? null
}:
let
  pname = "losslesscut";
  nameRepo = "lossless-cut";
  nameCamel = "LosslessCut";
  nameSourceBase = "${nameCamel}-win";
  nameSource = "${nameSourceBase}.zip";
  nameExecutable = "${nameCamel}.exe";
  owner = "mifi";
  getSymlinkCommand = if (customSymlinkCommand != null) then customSymlinkCommand
    else if useMklink then (targetPath: linkPath: "mklink ${targetPath} ${linkPath}")
    else (targetPath: linkPath: "ln -s ${targetPath} ${linkPath}");
in stdenvNoCC.mkDerivation {
  inherit pname version sha256;

  src = fetchurl {
    name = nameSource;
    url = "https://github.com/${owner}/${nameRepo}/releases/download/v${version}/${nameSource}";
    inherit sha256;
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d ${nameSourceBase}
  '';

  sourceRoot = nameSourceBase;

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cd ..
    mv ${nameSourceBase} $out/libexec

  '' + (getSymlinkCommand "${nameSourceBase}/${nameExecutable}" "$out/bin/${nameExecutable}");

  meta.platforms = lib.platforms.windows;
}
