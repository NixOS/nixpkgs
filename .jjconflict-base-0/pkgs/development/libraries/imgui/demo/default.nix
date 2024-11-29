{
  lib,
  stdenv,
  cmake,
  imgui,
}:

stdenv.mkDerivation {
  pname = "${imgui.pname}-demo";
  inherit (imgui) version;

  src = "${imgui.src}/examples/example_glfw_opengl3";
  postPatch = ''
    rm Makefile*
    cp ${./CMakeLists.txt} CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ (imgui.override { IMGUI_BUILD_GLFW_BINDING = true; }) ];

  meta = with lib; {
    description = "Standalone ImPlot Demos";
    homepage = "https://github.com/ocornut/imgui/tree/master/examples/example_glfw_opengl3";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
    mainProgram = "demo";
    platforms = lib.platforms.linux;
  };
}
