{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "libldac-dec";
  version = "0.0.2-unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "O2C14";
    repo = "libldac-dec";
    rev = "8c15f53b97c8322c18cff3fddf6d7129dbd3d349";
    hash = "sha256-pdeEtQXxL2pd9qTfLOEmPDn3POgo5qxRqbK807WN98s=";
  };

  nativeBuildInputs = [ cmake ];

  # Upstream CMakeLists.txt doesn't have install rules
  postPatch = ''
    cat >> CMakeLists.txt <<'EOF'
    install(TARGETS ldacBT_dec LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR})
    EOF
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "LDAC decoding library implemented in another way";
    homepage = "https://github.com/O2C14/libldac-dec";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qweered ];
  };
}
