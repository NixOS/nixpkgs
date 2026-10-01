# SDL3 windowing/input library for Linux builds
# Nixpkgs adaptation: Use find_package with nixpkgs-provided SDL3 libraries
if(SAGE_USE_SDL3)
    message(STATUS "Configuring SDL3 with find_package (nixpkgs)...")
    find_package(SDL3 CONFIG REQUIRED)
    find_package(SDL3_image CONFIG REQUIRED)
    add_library(sdl3lib INTERFACE)
    target_link_libraries(sdl3lib INTERFACE SDL3::SDL3 SDL3_image::SDL3_image)
    message(STATUS "✓ SDL3 + SDL3_image configured (nixpkgs)")
endif()
