cmake_minimum_required(VERSION 3.16)
project(pdfium-integration-test LANGUAGES C)

find_package(PDFium REQUIRED)

add_executable(pdfium-integration-test integration.c)
target_link_libraries(pdfium-integration-test PRIVATE pdfium)
