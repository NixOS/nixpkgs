# Some packages, such as or-tools, strictly require a specific LTS
# branch of abseil-cpp, and will be broken by arbitrary upgrades.  See
# also https://abseil.io/about/compatibility, which confirms “Each LTS
# release should be considered to be a new major version of the
# library.”  Therefore, we keep packages `abseil-cpp_YYYYMM` for each
# required LTS branch, leaving `abseil-cpp` as an alias.

{ abseil-cpp_202508 }: abseil-cpp_202508
