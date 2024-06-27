{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  open3d,
}:

stdenv.mkDerivation rec {
  pname = "directxmath";
  version = "2024-02";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXMath";
    rev = "feb2024";
    hash = "sha256-BXiI6h3rGRwDjOXMm6OLSgxXVZJnmAZ4wTFZL2RrwRA=";
  };

  nativeBuildInputs = [ cmake ];

  # WSL stubs taken from
  # https://github.com/isl-org/Open3D/blob/ad17a26332d93c0de4bd67218d0134c9deab7b93/3rdparty/uvatlas/uvatlas.cmake#L44-L46
  postInstall = ''
    cp ${open3d.src}/3rdparty/uvatlas/sal.h "''${!outputDev}/include/directxmath/"
  '';

  meta = {
    description = "DirectXMath is an all inline SIMD C++ linear algebra library for use in games and graphics apps";
    homepage = "https://github.com/microsoft/DirectXMath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "directxmath";
    platforms = lib.platforms.all;
  };
}
