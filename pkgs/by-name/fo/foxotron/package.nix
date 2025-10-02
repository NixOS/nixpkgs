{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  cmake,
  pkg-config,
  makeWrapper,
  zlib,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libXext,
  libGLU,
  alsa-lib,
  fontconfig,
}:

stdenv.mkDerivation rec {
  pname = "foxotron";
  version = "2024-09-23";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = "Foxotron";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-OnZWoiQ5ASKQV73/W6nl17B2ANwqCy/PlybHbNwrOyQ=";
  };

  patches = [
    (fetchpatch {
      name = "0001-assimp-Include-cstdint-for-std-uint32_t.patch";
      url = "https://github.com/assimp/assimp/commit/108e3192a201635e49e99a91ff2044e1851a2953.patch";
      stripLen = 1;
      extraPrefix = "externals/assimp/";
      hash = "sha256-rk0EFmgeZVwvx3NJOOob5Jwj9/J+eOtuAzfwp88o+J4=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "set(CMAKE_OSX_ARCHITECTURES x86_64)" ""

    # Outdated vendored assimp, many warnings with newer compilers, too old for CMake option to control this
    # Note that this -Werror caused issues on darwin, so make sure to re-check builds there before removing this
    substituteInPlace externals/assimp/code/CMakeLists.txt \
      --replace 'TARGET_COMPILE_OPTIONS(assimp PRIVATE -Werror)' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    alsa-lib
    fontconfig
    libGLU
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ];

  # error: writing 1 byte into a region of size 0
  hardeningDisable = [ "fortify3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/foxotron}
    cp -R ${lib.optionalString stdenv.hostPlatform.isDarwin "Foxotron.app/Contents/MacOS/"}Foxotron \
      ../{config.json,Shaders,Skyboxes} $out/lib/foxotron/
    wrapProgram $out/lib/foxotron/Foxotron \
      --chdir "$out/lib/foxotron"
    ln -s $out/{lib/foxotron,bin}/Foxotron

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "General purpose model viewer";
    longDescription = ''
      ASSIMP based general purpose model viewer ("turntable") created for the
      Revision 2021 3D Graphics Competition.
    '';
    homepage = "https://github.com/Gargaj/Foxotron";
    license = licenses.unlicense;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    mainProgram = "Foxotron";
  };
}
