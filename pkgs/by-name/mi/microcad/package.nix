{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  cmake,
  glm,
  ninja,
  clipper2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microcad";
  version = "0.3.0";

  src = fetchFromCodeberg {
    owner = "microcad";
    repo = "microcad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OpXx3iXM0NHrdAwS6eCdAcY83TyHAtLv5ul76d5zT94=";
  };

  cargoHash = "sha256-mIDckwToKcMx4gcqcd/F0J+xUHVZKE6812nxRSB+3d4=";

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
  ];

  buildInputs = [
    clipper2
    glm
  ];

  # Pass system paths to CMake
  CMAKE_PREFIX_PATH = "${clipper2};${glm}";
  CLIPPER2_DIR = clipper2;
  GLM_DIR = glm;

  # Tell the build to use system libraries
  MANIFOLD_SYSTEM_CLIPPER2 = "1";
  MANIFOLD_SYSTEM_GLM = "1";

  # Provide the library path for the Rust linker patch
  CLIPPER2_LIB_DIR = "${clipper2}/lib";

  #cmake and ninja needs to be disabled, because this is a cargo project
  dontUseCmake = true;
  dontUseNinja = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  postPatch = ''
      ls -la ${clipper2}/lib/cmake/ || true
      ls -la ${clipper2}/lib/ || true
      ls -la ${glm}/lib/cmake/ || true

      VENDOR_DIR="../${finalAttrs.pname}-${finalAttrs.version}-vendor"
      DEPS_FILE=$(find "$VENDOR_DIR" -name manifoldDeps.cmake | head -n1)
      BUILD_RS=$(find "$VENDOR_DIR" -name build.rs -path "*/manifold-rs-*" | head -n1)

      # ---- Patch manifoldDeps.cmake (unchanged) ----
      if [ -n "$DEPS_FILE" ]; then
        chmod +w "$DEPS_FILE"
        cp "$DEPS_FILE" "$DEPS_FILE.bak"

        sed -i '/FetchContent_Declare(clipper2/,/)/c\find_package(clipper2 CONFIG REQUIRED)' "$DEPS_FILE"
        sed -i '/FetchContent_Declare(glm/,/)/c\find_package(glm CONFIG REQUIRED)' "$DEPS_FILE"
        sed -i 's/FetchContent_MakeAvailable/# FetchContent_MakeAvailable/g' "$DEPS_FILE"
        sed -i '/add_library(Clipper2::Clipper2 ALIAS Clipper2)/d' "$DEPS_FILE"
        sed -i '/add_library(glm::glm ALIAS glm)/d' "$DEPS_FILE"

        cat <<'EOF' >> "$DEPS_FILE"

          # === DEBUG: find_package results ===
          message(STATUS "clipper2: find_package result: ''\${clipper2_FOUND}")
          message(STATUS "glm: find_package result: ''\${glm_FOUND}")
          message(STATUS "CMAKE_PREFIX_PATH: ''\$ENV{CMAKE_PREFIX_PATH}")
          message(STATUS "CMAKE_FIND_ROOT_PATH: ''\$ENV{CMAKE_FIND_ROOT_PATH}")

          get_cmake_property(_vars VARIABLES)
          list(FILTER _vars INCLUDE REGEX ".*clipper2.*")
          foreach(_var ''\${_vars})
              message(STATUS "''\${_var} = ''\${''\${_var}}")
          endforeach()

          if(clipper2_FOUND)
              if(TARGET clipper2::clipper2)
                  message(STATUS "Found target clipper2::clipper2")
                  get_target_property(clipper2_type clipper2::clipper2 TYPE)
                  message(STATUS "clipper2::clipper2 type: ''\${clipper2_type}")
                  get_target_property(clipper2_location clipper2::clipper2 IMPORTED_LOCATION)
                  message(STATUS "clipper2::clipper2 IMPORTED_LOCATION: ''\${clipper2_location}")
                  if(NOT TARGET Clipper2::Clipper2)
                      add_library(Clipper2::Clipper2 ALIAS clipper2::clipper2)
                      message(STATUS "Aliased clipper2::clipper2 to Clipper2::Clipper2")
                  endif()
              elseif(TARGET clipper2)
                  message(STATUS "Found target clipper2")
                  get_target_property(clipper2_type clipper2 TYPE)
                  message(STATUS "clipper2 type: ''\${clipper2_type}")
                  get_target_property(clipper2_location clipper2 IMPORTED_LOCATION)
                  message(STATUS "clipper2 IMPORTED_LOCATION: ''\${clipper2_location}")
                  if(NOT TARGET Clipper2::Clipper2)
                      add_library(Clipper2::Clipper2 ALIAS clipper2)
                      message(STATUS "Aliased clipper2 to Clipper2::Clipper2")
                  endif()
              elseif(TARGET Clipper2)
                  message(STATUS "Found target Clipper2")
                  get_target_property(clipper2_type Clipper2 TYPE)
                  message(STATUS "Clipper2 type: ''\${clipper2_type}")
                  get_target_property(clipper2_location Clipper2 IMPORTED_LOCATION)
                  message(STATUS "Clipper2 IMPORTED_LOCATION: ''\${clipper2_location}")
                  if(NOT TARGET Clipper2::Clipper2)
                      add_library(Clipper2::Clipper2 ALIAS Clipper2)
                      message(STATUS "Aliased Clipper2 to Clipper2::Clipper2")
                  endif()
              else()
                  message(WARNING "No clipper2 target found after find_package; falling back to manual search")
              endif()
          endif()

          if(NOT TARGET Clipper2::Clipper2)
              message(STATUS "Manually searching for clipper2 library")
              find_library(CLIPPER2_LIBRARY
                  NAMES clipper2 Clipper2 libclipper2 libClipper2
                  PATHS ${clipper2}/lib
                  NO_DEFAULT_PATH
                  REQUIRED
              )
              find_path(CLIPPER2_INCLUDE_DIR
                  NAMES clipper2/clipper.h clipper2.h
                  PATHS ${clipper2}/include
                  NO_DEFAULT_PATH
                  REQUIRED
              )
              message(STATUS "Found clipper2 library: ''\${CLIPPER2_LIBRARY}")
              message(STATUS "Found clipper2 include dir: ''\${CLIPPER2_INCLUDE_DIR}")

              get_filename_component(CLIPPER2_EXT "''\${CLIPPER2_LIBRARY}" EXT)
              if("''\${CLIPPER2_EXT}" STREQUAL ".a")
                  set(CLIPPER2_TYPE STATIC)
              else()
                  set(CLIPPER2_TYPE UNKNOWN)
              endif()

              add_library(Clipper2::Clipper2 ''\${CLIPPER2_TYPE} IMPORTED)
              set_target_properties(Clipper2::Clipper2 PROPERTIES
                  IMPORTED_LOCATION "''\${CLIPPER2_LIBRARY}"
                  INTERFACE_INCLUDE_DIRECTORIES "''\${CLIPPER2_INCLUDE_DIR}"
              )
              message(STATUS "Created manual Clipper2::Clipper2 target of type ''\${CLIPPER2_TYPE}")
          endif()
    EOF
        echo "Patched $DEPS_FILE"
      fi

      # ---- Detect the actual clipper2 library name (case-insensitive) ----
      LIB_PATH=$(find ${clipper2}/lib -maxdepth 1 \( -name 'lib*clipper2*' -o -name 'lib*Clipper2*' \) 2>/dev/null | head -n1)
      if [ -z "$LIB_PATH" ]; then
        echo "ERROR: No clipper2 library found in ${clipper2}/lib"
        exit 1
      fi
      ACTUAL_LIB=$(basename "$LIB_PATH" | sed -e 's/^lib//' -e 's/\.so.*$//' -e 's/\.a.*$//' -e 's/\.dylib.*$//')

      # ---- Patch manifold-rs build.rs to use system libraries and correct linking ----
      if [ -n "$BUILD_RS" ]; then
        head -n30 "$BUILD_RS"
        chmod +w "$BUILD_RS"
        cp "$BUILD_RS" "$BUILD_RS.bak"

        # Replace the built-in clipper2 flag
        sed -i 's/-DMANIFOLD_USE_BUILTIN_CLIPPER2=ON/-DMANIFOLD_USE_BUILTIN_CLIPPER2=OFF/g' "$BUILD_RS"
        sed -i 's/"MANIFOLD_USE_BUILTIN_CLIPPER2", "ON"/"MANIFOLD_USE_BUILTIN_CLIPPER2", "OFF"/g' "$BUILD_RS"

        # Comment out any existing link-lib directives for clipper2 (case-insensitive)
        sed -i '/cargo:rustc-link-lib=.*[cC]lipper2/s/^/\/\/ /' "$BUILD_RS"

        # Insert CMAKE_PREFIX_PATH before the cmake_cmd line (as before)
        awk -v syspath="${clipper2}:${glm}" '
          /let cmake_cmd = / {
            print "    // Inject system paths into CMAKE_PREFIX_PATH";
            print "    let mut prefix_path = std::env::var(\"CMAKE_PREFIX_PATH\").unwrap_or_default();";
            print "    if !prefix_path.is_empty() {";
            print "        prefix_path.push_str(\":\");";
            print "    }";
            print "    prefix_path.push_str(syspath);";
            print "    cmake_cmd.arg(format!(\"-DCMAKE_PREFIX_PATH={}\", prefix_path));";
            print "";
            print $0;
            next;
          }
          { print }
        ' "$BUILD_RS" > "$BUILD_RS.tmp" && mv "$BUILD_RS.tmp" "$BUILD_RS"

        # Append our own link-search and link-lib at the end of main (before the final })
        # using correct Rust format syntax.
        awk -v libdir="${clipper2}/lib" -v libname="$ACTUAL_LIB" '
          /^}$/ {
            print "    // Add system clipper2 library search path and link";
            print "    println!(\"cargo:rustc-link-search=native={}\", \"" libdir "\");";
            print "    println!(\"cargo:rustc-link-lib={}\", \"" libname "\");";
            print $0;
            next;
          }
          { print }
        ' "$BUILD_RS" > "$BUILD_RS.tmp2" && mv "$BUILD_RS.tmp2" "$BUILD_RS"

        grep -E "cargo:rustc-link" "$BUILD_RS" || echo "No link flags found"
      fi
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern programming language for CAD";
    homepage = "https://microcad.xyz/";
    downloadPage = "https://codeberg.org/microcad/microcad";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
