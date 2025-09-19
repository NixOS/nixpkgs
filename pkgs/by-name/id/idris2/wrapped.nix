{
  lib,
  makeBinaryWrapper,
  symlinkJoin,
  idris2-unwrapped,
  extraPackages ? [ ],
}:
let
  supportLibrariesPath = lib.makeLibraryPath [ idris2-unwrapped.libidris2_support ];
  supportSharePath = lib.makeSearchPath "share" [ idris2-unwrapped.libidris2_support ];
in
symlinkJoin {
  inherit (idris2-unwrapped) version;
  pname = "idris2-wrapped";

  paths = [ idris2-unwrapped ] ++ extraPackages;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/idris2" \
      --set CHEZ "${lib.getExe idris2-unwrapped.chez}" \
      --suffix IDRIS2_LIBS ':' "${supportLibrariesPath}" \
      --suffix IDRIS2_DATA ':' "${supportSharePath}" \
      --suffix IDRIS2_PACKAGE_PATH ':' "$out/idris2-${idris2-unwrapped.version}" \
      --suffix LD_LIBRARY_PATH ':' "${supportLibrariesPath}" \
      --suffix DYLD_LIBRARY_PATH ':' "${supportLibrariesPath}"
  '';

  passthru = {
    unwrapped = idris2-unwrapped;
    src = idris2-unwrapped.src;
  }
  // idris2-unwrapped.passthru;

  meta = {
    # Manually inherit so that pos works
    inherit (idris2-unwrapped.meta)
      description
      mainProgram
      homepage
      changelog
      license
      maintainers
      platforms
      ;
  };
}
