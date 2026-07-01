cmake_minimum_required(VERSION 3.0)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
add_executable(test test.cpp)
target_link_libraries(test "webgpu_dawn" "spdlog" "fmt")
