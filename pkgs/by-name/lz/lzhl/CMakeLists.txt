cmake_minimum_required(VERSION 3.14)
project(lzhl LANGUAGES CXX)
add_library(lzhl STATIC
  Huff.cpp Lz.cpp Lzhl.cpp
)
target_include_directories(lzhl PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include/CompLibHeader>
)
install(TARGETS lzhl
  ARCHIVE DESTINATION lib
)
install(FILES _huff.h _lz.h _lzhl.h lzhl.h
  DESTINATION include/CompLibHeader
)
