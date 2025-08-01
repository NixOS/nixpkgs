# `aws-c-common` {#aws-c-common}

This hook exposes its own [CMake](#cmake) modules by setting [`CMAKE_MODULE_PATH`](https://cmake.org/cmake/help/latest/variable/CMAKE_MODULE_PATH.html) through [the `cmakeFlags` variable](#cmake-flags)
to the nonstandard `$out/lib/cmake` directory, as a workaround for [an upstream bug](https://github.com/awslabs/aws-c-common/issues/844).
