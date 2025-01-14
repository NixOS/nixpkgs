CapnProtoCMakeFlags() {
  cmakeFlagsArray+=(
    -DCAPNP_EXECUTABLE="@build_capnp@/bin/capnp"
    -DCAPNPC_CXX_EXECUTABLE="@build_capnp@/bin/capnpc-c++"
  )
}

preConfigureHooks+=(CapnProtoCMakeFlags)
