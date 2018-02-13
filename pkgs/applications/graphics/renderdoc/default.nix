{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtx11extras, qtsvg, makeWrapper
, vulkan-loader, xorg
, python36, bison, pcre, automake, autoconf
}:

stdenv.mkDerivation rec {
  version = "1.0rc1";
  name = "renderdoc-${version}";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "2300a94252384c63c93f58a264235b3cff59146b";
    sha256 = "1406w2cxk96jj05lvcrr75n1msn7abrcfvz7sgz9byp209vv3p1m";
  };

  custom_swig = fetchFromGitHub {
    owner = "baldurk";
    repo = "swig";
    rev = "renderdoc-modified-4";
    sha256 = "02hhhkvlqzpx5qfjzpq5wjzpxi9k999jczxm92y2nxf0m05dbyl4";
  };

  buildInputs = [
    qtbase qtsvg xorg.libpthreadstubs xorg.libXdmcp qtx11extras vulkan-loader python36
  ];

  nativeBuildInputs = [ cmake makeWrapper pkgconfig bison pcre automake autoconf ];

  cmakeFlags = [
    "-DBUILD_VERSION_HASH=${src.rev}"
    "-DBUILD_VERSION_DIST_NAME=NixOS"
    "-DBUILD_VERSION_DIST_VER=${version}"
    "-DBUILD_VERSION_DIST_CONTACT=https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/graphics/renderdoc"
    "-DBUILD_VERSION_DIST_STABLE=ON"
    # TODO: add once pyside2 is in nixpkgs
    #"-DPYSIDE2_PACKAGE_DIR=${python36Packages.pyside2}"
    # TODO: use this instead of preConfigure once placeholders land
    #"-DVULKAN_LAYER_FOLDER=${placeholder out}/share/vulkan/implicit_layer.d/"
  ];

  postUnpack = ''
    cp -r ${custom_swig} custom_swig
    chmod -R +w custom_swig
    patchShebangs custom_swig/autogen.sh
  '';

  preConfigure = ''
    cmakeFlags+=" -DRENDERDOC_SWIG_PACKAGE=$PWD/../custom_swig"
    cmakeFlags+=" -DVULKAN_LAYER_FOLDER=$out/share/vulkan/implicit_layer.d/"
  '';

  preFixup = ''
    wrapProgram $out/bin/qrenderdoc --suffix LD_LIBRARY_PATH : $out/lib --suffix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    wrapProgram $out/bin/renderdoccmd --suffix LD_LIBRARY_PATH : $out/lib --suffix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A single-frame graphics debugger";
    homepage = https://renderdoc.org/;
    license = licenses.mit;
    longDescription = ''
      RenderDoc is a free MIT licensed stand-alone graphics debugger that
      allows quick and easy single-frame capture and detailed introspection
      of any application using Vulkan, D3D11, OpenGL or D3D12 across
      Windows 7 - 10, Linux or Android.
    '';
    maintainers = [maintainers.jansol];
    platforms = ["i686-linux" "x86_64-linux"];
  };
}
