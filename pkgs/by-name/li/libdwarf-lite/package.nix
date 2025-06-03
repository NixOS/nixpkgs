{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libdwarf-lite";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "libdwarf-lite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rP46SFw6mvwuX6aE64F86nF6fn+8CzZdCZIL8AmsZcI=";
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
