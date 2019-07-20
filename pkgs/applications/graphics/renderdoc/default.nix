{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtx11extras, qtsvg, makeWrapper
, vulkan-loader, xorg
, python3, bison, pcre, automake, autoconf
}:
let
  custom_swig = fetchFromGitHub {
    owner = "baldurk";
    repo = "swig";
    rev = "renderdoc-modified-6";
    sha256 = "00ykqlzx1k9iwqjlc54kfch7cnzsj53hxn7ql70dj3rxqzrnadc0";
  };
in
stdenv.mkDerivation rec {
  version = "1.4";
  name = "renderdoc-${version}";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "v${version}";
    sha256 = "1iann73r4yzkwnm13h4zqipqrp5i5cnkv27yyap0axz6h3npw94r";
  };

  buildInputs = [
    qtbase qtsvg xorg.libpthreadstubs xorg.libXdmcp qtx11extras vulkan-loader python3
  ];

  nativeBuildInputs = [ cmake makeWrapper pkgconfig bison pcre automake autoconf ];

  postUnpack = ''
    cp -r ${custom_swig} swig
    chmod -R +w swig
    patchShebangs swig/autogen.sh
  '';

  cmakeFlags = [
    "-DBUILD_VERSION_HASH=${src.rev}"
    "-DBUILD_VERSION_DIST_NAME=NixOS"
    "-DBUILD_VERSION_DIST_VER=${version}"
    "-DBUILD_VERSION_DIST_CONTACT=https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/graphics/renderdoc"
    "-DBUILD_VERSION_STABLE=ON"
    # TODO: add once pyside2 is in nixpkgs
    #"-DPYSIDE2_PACKAGE_DIR=${python36Packages.pyside2}"
  ];

  # Future work: define these in the above array via placeholders
  preConfigure = ''
    cmakeFlags+=" -DVULKAN_LAYER_FOLDER=$out/share/vulkan/implicit_layer.d/"
    cmakeFlags+=" -DRENDERDOC_SWIG_PACKAGE=$PWD/../swig"
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
