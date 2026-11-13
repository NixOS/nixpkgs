project(
  'ldacbt',
  'c',
  meson_version: '>=1.10.0',
  version: files('VERSION'),
)

pkg = import('pkgconfig')

cc = meson.get_compiler('c')
dep_m = cc.find_library('m')

lib = library(
  'ldacBT',
  'abr/src/ldacBT_abr.c',
  'src/ldacBT.c',
  'src/ldaclib.c',
  include_directories: [
    'abr/inc',
    'inc',
  ],
  dependencies: [dep_m],
  version: meson.project_version(),
  install: true,
)

install_headers(
  'abr/inc/ldacBT_abr.h',
  'inc/ldacBT.h',
  subdir: 'ldac',
)

pkg.generate(
  lib,
  name: 'ldacBT-enc',
  description: 'LDAC Bluetooth encoder',
  subdirs: 'ldac',
)

pkg.generate(
  lib,
  name: 'ldacBT-abr',
  description: 'LDAC Bluetooth ABR library',
  subdirs: 'ldac',
)

pkg.generate(
  lib,
  name: 'ldacBT-dec',
  description: 'LDAC Bluetooth decoder',
  subdirs: 'ldac',
)
