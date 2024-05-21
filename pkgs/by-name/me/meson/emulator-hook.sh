add_meson_exe_wrapper_cross_flag() {
  mesonFlagsArray+=(--cross-file=@crossFile@)
}

preConfigureHooks+=(add_meson_exe_wrapper_cross_flag)
