cmake_minimum_required(VERSION 3.16)
project(ouster-consumer LANGUAGES CXX)

enable_testing()

if(NOT SHARED_ONLY AND STATIC_FIRST)
  find_package(OusterSDK ${OUSTER_SDK_VERSION} EXACT CONFIG REQUIRED COMPONENTS Static)
endif()
find_package(OusterSDK ${OUSTER_SDK_VERSION} EXACT CONFIG REQUIRED COMPONENTS Shared)
find_package(OusterSDK ${OUSTER_SDK_VERSION} EXACT CONFIG REQUIRED COMPONENTS Shared)

if(SHARED_ONLY)
  if(TARGET OusterSDK::ouster_core)
    message(FATAL_ERROR "Shared component imported static SDK targets")
  endif()
else()
  find_package(OusterSDK ${OUSTER_SDK_VERSION} EXACT CONFIG REQUIRED COMPONENTS Static)
  find_package(OusterSDK ${OUSTER_SDK_VERSION} EXACT CONFIG REQUIRED)
  find_package(OusterSDK ${OUSTER_SDK_VERSION} EXACT CONFIG REQUIRED)

  if(NOT STATIC_FIRST)
    add_test(NAME static-first-configure COMMAND ${CMAKE_COMMAND}
      -S ${CMAKE_CURRENT_SOURCE_DIR} -B ${CMAKE_CURRENT_BINARY_DIR}/static-first
      -DSTATIC_FIRST=ON -DOUSTER_SDK_VERSION=${OUSTER_SDK_VERSION}
      -DOusterSDK_DIR=${OusterSDK_DIR})
  endif()

  add_executable(static-sdk main.cpp)
  target_link_libraries(static-sdk PRIVATE
    OusterSDK::ouster_core OusterSDK::ouster_sensor OusterSDK::ouster_pcap
    OusterSDK::ouster_osf OusterSDK::ouster_viz OusterSDK::ouster_mapping)
  add_test(NAME static-sdk COMMAND static-sdk static.osf)
endif()

add_executable(shared-sdk main.cpp)
target_link_libraries(shared-sdk PRIVATE OusterSDK::shared_library)
add_test(NAME shared-sdk COMMAND shared-sdk shared.osf)
