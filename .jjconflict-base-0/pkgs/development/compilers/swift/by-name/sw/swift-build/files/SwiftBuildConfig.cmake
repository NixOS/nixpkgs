add_library(SwiftBuild::SwiftBuild @buildType@ IMPORTED)
set_target_properties(SwiftBuild::SwiftBuild PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}SwiftBuild${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@include@/include;@include@/lib/swift/@swiftPlatform@"
)

add_library(SwiftBuild::SWBBuildService @buildType@ IMPORTED)
set_target_properties(SwiftBuild::SWBBuildService PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}SWBBuildService${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@include@/include;@include@/lib/swift/@swiftPlatform@"
)
