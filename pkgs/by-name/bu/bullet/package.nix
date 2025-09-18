{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGLU,
  libGL,
  libglut,
}:

stdenv.mkDerivation rec {
  pname = "bullet";
  version = "3.25";

  src = fetchFromGitHub {
    owner = "bulletphysics";
    repo = "bullet3";
    rev = version;
    sha256 = "sha256-AGP05GoxLjHqlnW63/KkZe+TjO3IKcgBi+Qb/osQuCM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libGLU
    libGL
    libglut
  ];

  postPatch = ''
    substituteInPlace examples/ThirdPartyLibs/Gwen/CMakeLists.txt \
      --replace "-DGLEW_STATIC" "-DGLEW_STATIC -Wno-narrowing"
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_CPU_DEMOS=OFF"
    "-DINSTALL_EXTRA_LIBS=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DBUILD_BULLET2_DEMOS=OFF"
    "-DBUILD_UNIT_TESTS=OFF"
    "-DBUILD_BULLET_ROBOTICS_GUI_EXTRA=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=argument-outside-range -Wno-error=c++11-narrowing";

  meta = with lib; {
    description = "Professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics.
    '';
    homepage = "http://bulletphysics.org";
    license = licenses.zlib;
    maintainers = with maintainers; [ aforemny ];
    platforms = platforms.unix;
  };
}
