cmake_minimum_required(VERSION 3.21)
project(bgfx-consumer LANGUAGES CXX)

find_package(bgfx ${EXPECTED_BGFX_VERSION} EXACT CONFIG REQUIRED)
add_executable(consumer main.cpp)
target_link_libraries(consumer PRIVATE bgfx::bgfx)
