{
  lib,
  idris2,
  makeBinaryWrapper,
  symlinkJoin,
  idris2-unwrapped,
  libidris2_support,
  extraPackages ? [ ],
}:
let
  supportLibrariesPath = lib.makeLibraryPath [ idris2.libidris2_support ];
  supportSharePath = lib.makeSearchPath "share" [ libidris2_support ];
in
symlinkJoin {
  inherit (idris2) version;
  pname = "idris2-wrapped";

  paths = [ idris2-unwrapped ] ++ extraPackages;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/idris2" \
      --set CHEZ "${lib.getExe idris2.chez}" \
      --suffix IDRIS2_LIBS ':' "${supportLibrariesPath}" \
      --suffix IDRIS2_DATA ':' "${supportSharePath}" \
      --suffix IDRIS2_PACKAGE_PATH ':' "$out/idris2-${idris2.version}" \
      --suffix LD_LIBRARY_PATH ':' "${supportLibrariesPath}" \
      --suffix DYLD_LIBRARY_PATH ':' "${supportLibrariesPath}"
  '';

  passthru = {
    unwrapped = idris2-unwrapped;
  }
  // idris2-unwrapped.passthru;

  meta = {
    # Manually inherit so that pos works
    inherit (idris2.meta)
      description
      homepage
      changelog
      license
      maintainers
      platforms
      ;
  };
}
