{ stdenvNoCC
, lib
, fetchurl
, p7zip
, version
, sha256
, useMklink ? false
, customSymlinkCommand ? null
}:
let
  pname = "losslesscut";
  nameRepo = "lossless-cut";
  nameCamel = "LosslessCut";
  nameSourceBase = "${nameCamel}-win-x64";
  nameSource = "${nameSourceBase}.7z";
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

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    7z x $src -o${nameSourceBase}
  '';

  sourceRoot = nameSourceBase;

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cd ..
    mv ${nameSourceBase} $out/libexec

  '' + (getSymlinkCommand "${nameSourceBase}/${nameExecutable}" "$out/bin/${nameExecutable}");

  meta.platforms = lib.platforms.windows;
}
