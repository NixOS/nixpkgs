{ lib
, stdenv
, fetchurl
, cmake
, ninja
, pkg-config
, rustc
, cargo
, zlib
, sdl3
, vulkan-loader
, vulkan-headers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmatti";
  version = "0.1.0";

  # The normal GitHub archive URL currently returns 404 for this commit.
  # codeload's legacy tarball is the same tree and stays fetchable.
  src = fetchurl {
    name = "libmatti-source.tar.gz";
    url = "https://codeload.github.com/mattiasploesch-cpu/LibMatti/legacy.tar.gz/74a383170f50d81b159a78d3cc91533348dc4362";
    hash = "sha256-f9H7g0/jzKROcHnd9XuL2sVJZHXhsBv2YyBrfQVYCys=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ninja pkg-config rustc cargo ];
  buildInputs = [ zlib sdl3 vulkan-loader vulkan-headers ];


  cmakeFlags = [
    "-DMATTI_MOBILE_ONLY=ON"
    "-DMATTI_BUILD_LAUNCHER=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  buildPhase = ''
    runHook preBuild
    cmake --build . --target matti_shared -j "$NIX_BUILD_CORES"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$dev/include/libmatti" "$out/share/doc/matticraft"
    cp library/libmatti.so.0.1.0 "$out/lib/"
    ln -s libmatti.so.0.1.0 "$out/lib/libmatti.so.0"
    ln -s libmatti.so.0 "$out/lib/libmatti.so"

    (cd ../library/src/libmatti
     find . -name '*.h' -print0 |
       while IFS= read -r -d "" header; do
         install -Dm644 "$header" "$dev/include/libmatti/''${header#./}"
       done)

    if [ -d ../library/src/libmatti/matti/ui/assets ]; then
      mkdir -p "$out/share/matticraft"
      cp -a ../library/src/libmatti/matti/ui/assets "$out/share/matticraft/"
    fi
    install -Dm644 ../library/src/libmatti/matti/ui/Monocraft.ttf \
      "$out/share/matticraft/Monocraft.ttf"
    install -Dm644 ../README.md "$out/share/doc/matticraft/README.md"
    install -Dm644 ../planported.MD "$out/share/doc/matticraft/planported.MD"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Matticraft's C11 game library (shared library and public headers)";
    homepage = "https://github.com/mattiasploesch-cpu/LibMatti";
    license = with licenses; [ mit lgpl3Plus ];
    platforms = platforms.linux;
    maintainers = [ ];
  };
})
