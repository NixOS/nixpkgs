{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ament_cmake";
  version = "2.7.3";
  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_cmake";
    rev = finalAttrs.version;
    hash = "sha256-KLSyQpO7JCxIsi7wzKxv0XYO762/wIez80LRYMfKT8Y=";
  };

  # Skip unnecessary build steps
  dontConfigure = true;
  dontBuild = true;

  # Install all files to $out
  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';

  meta = {
    description = "CMake build system infrastructure for ROS 2 packages";
    homepage = "https://github.com/ament/ament_cmake";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
  };
})
