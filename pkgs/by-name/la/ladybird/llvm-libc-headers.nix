{
  lib,
  stdenvNoCC,
  fetchurl,
}:

# Match Ladybird's llvm-libc overlay port. The header-only math API includes
# functions that are not available in a released LLVM version yet.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ladybird-llvm-libc-headers";
  version = "e54169423e7ee5d8b41c2f1b6f7a59000c901ee0";

  src = fetchurl {
    url = "https://github.com/llvm/llvm-project/archive/${finalAttrs.version}.tar.gz";
    sha512 = "4ab7f1f2c49a661148b38414c16d3600467f43a295ab0383358098eb2434dd0c21ea202da25bcd466d3b8f1b397527dd7793f4a7025f79388492fee291947bed";
  };

  # Extract only libc from the LLVM monorepo archive.
  unpackPhase = ''
    runHook preUnpack
    tar -xf "$src" --strip-components=2 "llvm-project-${finalAttrs.version}/libc"
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    find hdr include shared src/__support src/string/memory_utils -type f -name '*.h' \
      -exec install -Dm644 '{}' "$out/include/llvm-libc/{}" \;
    install -Dm644 LICENSE.TXT "$out/share/licenses/llvm-libc-headers/LICENSE.TXT"
    runHook postInstall
  '';

  meta = {
    description = "LLVM libc headers for Ladybird's math functions";
    homepage = "https://libc.llvm.org/";
    license = lib.licenses.WITH lib.licenses.asl20 lib.licenses.llvm-exception;
    platforms = lib.platforms.all;
  };
})
