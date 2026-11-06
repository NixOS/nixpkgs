# CPM.cmake defaults to fetching every CPMAddPackage dependency from the
# network, which never works in the Nix sandbox. Any package that already
# provides the dependency (via a normal nixpkgs package on CMAKE_PREFIX_PATH,
# wired up automatically for buildInputs) should be found instead of
# downloaded; anything CPM can't resolve that way should fail the configure
# step loudly rather than attempt a network fetch.
export CPM_LOCAL_PACKAGES_ONLY=1
