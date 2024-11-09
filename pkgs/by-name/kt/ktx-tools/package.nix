{
  cmake,
  doxygen,
  fetchFromGitHub,
  getopt,
  ninja,
  lib,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "ktx-tools";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "KTX-Software";
    rev = "v${version}";
    hash = "sha256-zjiJ8B8FEZUJ3iFTYXRmuIEtcaCWtBIbYwz0DwjTDFo";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    getopt
    ninja
    pkg-config
  ];

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [ "-DKTX_FEATURE_DOC=ON" ];

  postPatch = ''
    patchShebangs .
  '';

  meta = with lib; {
    description = "KTX (Khronos Texture) Library and Tools";
    longDescription = ''
      KTX (Khronos Texture) is a lightweight container for textures for OpenGL®,
      Vulkan® and other GPU APIs. KTX files contain all the parameters needed
      for texture loading. A single file can contain anything from a simple
      base-level 2D texture through to a cubemap array texture with mipmaps.

      This software package contains:
        - libktx: a small library of functions for writing and reading KTX
          files, and instantiating OpenGL®, OpenGL ES™️ and Vulkan® textures
          from them.
        - ktx2check: a tool for validating KTX Version 2 format files.
        - ktx2ktx2: a tool for converting a KTX Version 1 file to a KTX Version
          2 file.
        - ktxinfo: a tool to display information about a KTX file in human
          readable form.
        - ktxsc: a tool to supercompress a KTX Version 2 file that contains
          uncompressed images.
        - toktx: a tool to create KTX files from PNG, Netpbm or JPEG format
          images. It supports mipmap generation, encoding to Basis Universal
          formats and Zstd supercompression.
    '';
    homepage = "https://github.com/KhronosGroup/KTX-Software";
    license = licenses.asl20;
    maintainers = with maintainers; [ bonsairobo ];
    platforms = platforms.linux;
  };
}
