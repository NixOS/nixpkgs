{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtx11extras, qtsvg, makeWrapper
, vulkan-loader, xorg
, python36, bison, pcre, automake, autoconf
}:
let
  custom_swig = stdenv.mkDerivation {
    name = "patched-custom-swig";
    src = fetchFromGitHub {
      owner = "baldurk";
      repo = "swig";
      rev = "renderdoc-modified-5";
      sha256 = "0ihrxbx56p5wn589fbbsns93fp91sypqdzfxdy7l7v9sf69a41mw";
    };
    phases = ["unpackPhase" "patchAndMove"];
    patchAndMove = ''
      patchShebangs autogen.sh
      root=$(pwd)
      cd ..
      mv "$root" $out
    '';
  };
in
stdenv.mkDerivation rec {
  version = "1.0";
  name = "renderdoc-${version}";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "v1.0";
    sha256 = "0l7pjxfrly4llryjnwk42dzx65n78wc98h56qm4yh04ja8fdbx2y";
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
    "-DRENDERDOC_SWIG_PACKAGE=${custom_swig}"
    # TODO: add once pyside2 is in nixpkgs
    #"-DPYSIDE2_PACKAGE_DIR=${python36Packages.pyside2}"
    "-DVULKAN_LAYER_FOLDER=${placeholder "out"}/share/vulkan/implicit_layer.d/"
  ];

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
