{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtx11extras, qtsvg, makeWrapper, python3, bison
, autoconf, automake, pcre, vulkan-loader, xorg
}:

stdenv.mkDerivation rec {
  name = "renderdoc-${version}";
  version = "0.91";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "2d8b2cf818746b6a2add54e2fef449398816a40c";
    sha256 = "07yc3fk7j2nqmrhc4dm3v2pgbc37scd7d28nlzk6v0hw99zck8k0";
  };

  buildInputs = [
    qtbase qtsvg xorg.libpthreadstubs xorg.libXdmcp qtx11extras vulkan-loader
  ];
  nativeBuildInputs = [ cmake makeWrapper pkgconfig python3 bison autoconf automake pcre ];

  cmakeFlags = [
    "-DBUILD_VERSION_HASH=${src.rev}"
    "-DBUILD_VERSION_DIST_NAME=NixOS"
    "-DBUILD_VERSION_DIST_VER=0.91"
    "-DBUILD_VERSION_DIST_CONTACT=https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/graphics/renderdoc"
    "-DBUILD_VERSION_DIST_STABLE=ON"
    # TODO: use this instead of preConfigure once placeholders land
    #"-DVULKAN_LAYER_FOLDER=${placeholder out}/share/vulkan/implicit_layer.d/"
  ];
  preConfigure = ''
    cmakeFlags+=" -DVULKAN_LAYER_FOLDER=$out/share/vulkan/implicit_layer.d/"
  '';

  preFixup = ''
    mkdir $out/bin/.bin
    mv $out/bin/qrenderdoc $out/bin/.bin/qrenderdoc
    ln -s $out/bin/.bin/qrenderdoc $out/bin/qrenderdoc
    wrapProgram $out/bin/qrenderdoc --suffix LD_LIBRARY_PATH : $out/lib --suffix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    mv $out/bin/renderdoccmd $out/bin/.bin/renderdoccmd
    ln -s $out/bin/.bin/renderdoccmd $out/bin/renderdoccmd
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
