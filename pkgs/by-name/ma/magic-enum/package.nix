{ fetchFromGitHub
, lib
, stdenv
, cmake
, nix-update-script
, testers
}:
stdenv.mkDerivation rec{
  pname = "magic-enum";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "Neargye";
    repo = "magic_enum";
    rev = "refs/tags/v${version}";
    hash = "sha256-1pO9FWd0InXqg8+lwRF3YNFTAeVLjqoI9v15LjWxnZY=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Static reflection for enums (to string, from string, iteration) for modern C++";
    homepage = "https://github.com/Neargye/magic_enum";
    changelog = "https://github.com/Neargye/magic_enum/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Alper-Celik ];
  };
}
