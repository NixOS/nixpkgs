# ninja {#ninja}

Overrides the build, install, and check phase to run ninja instead of make. You can disable this behavior with `dontUseNinjaBuild`, `dontUseNinjaInstall`, and `dontUseNinjaCheck`, respectively. Parallel building is enabled by default in Ninja.

Note that if the [Meson setup hook](#meson) is also active, Ninja's install and check phases will be disabled in favor of Meson's.
