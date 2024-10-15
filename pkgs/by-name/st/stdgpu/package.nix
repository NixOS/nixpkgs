{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "stdgpu";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "stotko";
    repo = "stdgpu";
    rev = version;
    hash = "sha256-avjNeo5E/ENIVqpe+VxvH6QmbA3OVJ7TPjLUSt1qWkY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Stdgpu: Efficient STL-like Data Structures on the GPU";
    homepage = "https://github.com/stotko/stdgpu";
    changelog = "https://github.com/stotko/stdgpu/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "stdgpu";
    platforms = lib.platforms.all;
  };
}
