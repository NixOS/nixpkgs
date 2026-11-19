{ lib
, stdenv
, libmatti
, cmake
, ninja
, pkg-config
, rustc
, cargo
, zlib
, sdl3
, vulkan-loader
, vulkan-headers
, glfw
, libGL
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matticraft";
  version = "0.1.0";

  # libmatti carries the pinned source; the client is built from the same tree.
  src = libmatti.src;

  nativeBuildInputs = [ cmake ninja pkg-config rustc cargo makeWrapper ];
  buildInputs = [ zlib sdl3 vulkan-loader vulkan-headers glfw libGL ];


  cmakeFlags = [
    "-DMATTI_BUILD_LAUNCHER=OFF"
    "-DMATTI_CLIENTS_SHARED=ON"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  buildPhase = ''
    runHook preBuild
    cmake --build . --target matti_shared runClient vulkanClient -j "$NIX_BUILD_CORES"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib" "$out/share/matticraft"
    install -Dm755 runClient "$out/bin/matticraft"
    install -Dm755 vulkanClient "$out/bin/vulkanClient"
    cp -a library/libmatti.so* "$out/lib/"
    if [ -d ../library/src/libmatti/matti/ui/assets ]; then
      cp -a ../library/src/libmatti/matti/ui/assets "$out/share/matticraft/"
    fi
    install -Dm644 ../library/src/libmatti/matti/ui/Monocraft.ttf \
      "$out/share/matticraft/Monocraft.ttf"
    install -Dm644 ../README.md "$out/share/doc/matticraft/README.md"
    install -Dm644 ../planported.MD "$out/share/doc/matticraft/planported.MD"

    for entry in matticraft vulkanClient; do
      mv "$out/bin/$entry" "$out/bin/.$entry"
      makeWrapper "$out/bin/.$entry" "$out/bin/$entry" \
        --set MATTI_UI_ASSETS "$out/share/matticraft/assets" \
        --set MATTI_THEME_FONT "$out/share/matticraft/Monocraft.ttf" \
        --prefix LD_LIBRARY_PATH : "$out/lib"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Matticraft client and libmatti shared library";
    homepage = "https://github.com/mattiasploesch-cpu/LibMatti";
    license = with licenses; [ mit lgpl3Plus ];
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "matticraft";
  };
})
