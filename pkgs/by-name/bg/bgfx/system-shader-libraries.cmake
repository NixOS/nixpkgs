# Preserve the target names expected by shaderc while using installed libraries.
find_package(glslang CONFIG REQUIRED)
add_library(glslang INTERFACE)
target_link_libraries(glslang INTERFACE
    glslang::glslang
    glslang::SPIRV
    glslang::glslang-default-resource-limits
)
get_target_property(glslang_includes glslang::glslang INTERFACE_INCLUDE_DIRECTORIES)
foreach(include_dir IN LISTS glslang_includes)
    target_include_directories(glslang INTERFACE
        "${include_dir}/glslang"
        "${include_dir}/glslang/Public"
        "${include_dir}/glslang/Include"
    )
endforeach()

find_package(SPIRV-Tools-opt CONFIG REQUIRED)
add_library(spirv-opt INTERFACE)
target_link_libraries(spirv-opt INTERFACE SPIRV-Tools-opt)

# Load glsl before cpp: the exported cpp target references spirv-cross-glsl.
foreach(component core glsl hlsl msl cpp reflect util)
    find_package(spirv_cross_${component} CONFIG REQUIRED)
endforeach()
add_library(spirv-cross INTERFACE)
target_link_libraries(spirv-cross INTERFACE
    spirv-cross-core
    spirv-cross-cpp
    spirv-cross-glsl
    spirv-cross-hlsl
    spirv-cross-msl
    spirv-cross-reflect
    spirv-cross-util
)
