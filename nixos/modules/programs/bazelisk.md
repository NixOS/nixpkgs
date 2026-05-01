# Bazelisk {#module-programs-bazelisk}

The `programs.bazelisk` module installs Bazelisk as both `bazelisk` and
`bazel`, enables envfs so unpatched Bazel binaries can resolve `/bin/bash`,
and writes `/etc/bazel.bazelrc` with Nix store paths for common action tools.

Set `programs.bazelisk.cc` and `programs.bazelisk.cxx` when a project needs C
or C++ toolchain detection through `rules_cc`.
