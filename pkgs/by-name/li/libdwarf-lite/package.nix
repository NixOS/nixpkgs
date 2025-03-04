{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libdwarf-lite";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "libdwarf-lite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qHikjAG5xuuHquqqKGuiDHXVZSlg/MbNp9JNSAKM/Hs=";
  };

  outputs = [
    "dev"
    "lib"
    "out"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DWARFDUMP" false)
    (lib.cmakeBool "PIC_ALWAYS" true)
  ];

  meta = {
    description = "Minimal libdwarf mirror for faster cloning and configuration";
    homepage = "https://github.com/jeremy-rifkin/libdwarf-lite";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
    mainProgram = "libdwarf-lite";
    platforms = lib.platforms.all;
  };
})
