{ lib
, stdenv
, fetchFromGitHub
, cmake
, libbpf
, nlohmann_json
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgproxy";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "springzfx";
    repo = "cgproxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mI57YGB0wG2ePHb8HXFth6g7QXrz8x5gGv2or0oBrEA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    nlohmann_json
    libbpf
  ];

  configureFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DCMAKE_BUILD_TYPE=Release"
    "-Dbuild_execsnoop_dl=ON"
    "-Dbuild_static=OFF"
  ];

  meta = with lib; {
    description = "Transparent Proxy with cgroup v2";
    homepage = "https://github.com/springzfx/cgproxy";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oluceps ];
  };
})
