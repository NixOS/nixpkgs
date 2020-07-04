{ stdenv, fetchFromGitHub, fetchurl, makeWrapper, cmake
, curl, boost, gdal, glew, soil
, libX11, libXi, libXxf86vm, libXcursor, libXrandr, libXinerama }:

stdenv.mkDerivation rec {
  version = "0.11.1";
  pname = "openspace";

  src = fetchFromGitHub {
    owner  = "OpenSpace";
    repo   = "OpenSpace";
    rev    = "a65eea61a1b8807ce3d69e9925e75f8e3dfb085d";
    sha256 = "0msqixf30r0d41xmfmzkdfw6w9jkx2ph5clq8xiwrg1jc3z9q7nv";
    fetchSubmodules = true;
  };

  buildInputs = [
    makeWrapper cmake
    curl boost gdal glew soil
    libX11 libXi libXxf86vm libXcursor libXrandr libXinerama
  ];

  glmPlatformH = fetchurl {
    url    = "https://raw.githubusercontent.com/g-truc/glm/dd48b56e44d699a022c69155c8672caacafd9e8a/glm/simd/platform.h";
    sha256 = "0y91hlbgn5va7ijg5mz823gqkq9hqxl00lwmdwnf8q2g086rplzw";
  };

  # See <https://github.com/g-truc/glm/issues/726>
  prePatch = ''
    cp ${glmPlatformH} ext/sgct/include/glm/simd/platform.h
    cp ${glmPlatformH} ext/ghoul/ext/glm/glm/simd/platform.h
  '';

  patches = [
    # See <https://github.com/opensgct/sgct/issues/13>
    ./vrpn.patch

    ./constexpr.patch
    ./config.patch

    # WARNING: This patch disables some slow torrents in a very dirty way.
    ./assets.patch
  ];

  bundle = "$out/usr/share/openspace";

  preConfigure = ''
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DCMAKE_BUILD_TYPE="
      "-DCMAKE_INSTALL_PREFIX=${bundle}"
    )
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p ${bundle}
  '';

  postInstall = ''
    cp ext/spice/libSpice.so       ${bundle}/lib
    cp ext/ghoul/ext/lua/libLua.so ${bundle}/lib
  '';

  postFixup = ''
    for bin in ${bundle}/bin/*
    do
      rpath=$(patchelf --print-rpath $bin)
      patchelf --set-rpath $rpath:${bundle}/lib $bin

      name=$(basename $bin)
      makeWrapper $bin $out/bin/$name --run "cd ${bundle}"
    done
  '';

  meta = {
    description     = "Open-source astrovisualization project";
    longDescription = ''
      OpenSpace is open source interactive data visualization software
      designed to visualize the entire known universe and portray our
      ongoing efforts to investigate the cosmos.

      WARNING: This build is not very usable for now.
    '';
    homepage  = "https://www.openspaceproject.com/";
    license   = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    broken = true; # fails to build
  };
}
