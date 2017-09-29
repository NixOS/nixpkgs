{ stdenv, fetchFromGitHub, cmake, makeWrapper, pkgconfig
, qtbase, qtx11extras, vulkan-loader, xorg
}:

stdenv.mkDerivation rec {
  name = "renderdoc-${version}";
  version = "0.34pre";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "5e2717daec53e5b51517d3231fb6120bebbe6b7a";
    sha256 = "1zpvjvsj5c441kyjpmd2d2r0ykb190rbq474nkmp1jk72cggnpq0";
  };

  buildInputs = [
    qtbase xorg.libpthreadstubs xorg.libXdmcp qtx11extras vulkan-loader
  ];
  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];

  cmakeFlags = [
    "-DBUILD_VERSION_HASH=${src.rev}-distro-nix"
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
    platforms = platforms.linux;
  };
}
