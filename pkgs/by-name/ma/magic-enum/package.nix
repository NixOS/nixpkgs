{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "magic-enum";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "Neargye";
    repo = "magic_enum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P6fl/dcGOSE1lTJwZlimbvsTPelHwdQdZr18H4Zji20=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Static reflection for enums (to string, from string, iteration) for modern C++";
    homepage = "https://github.com/Neargye/magic_enum";
    changelog = "https://github.com/Neargye/magic_enum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Alper-Celik ];
  };
})
