project(
    'systre',
    'c',
    version: '1.0.2',
    license: 'BSD-2-Clause',
    meson_version: '>=0.50.0',
    default_options: ['warning_level=1', 'default_library=both'],
)

tre_dep = dependency('tre')

libsystre = library(
    'systre',
    'systre.c',
    soversion: 0,
    install: true,
    dependencies: tre_dep,
)

install_headers('regex.h')

pkg = import('pkgconfig')
pkg.generate(
    libsystre,
    name: 'regex',
    libraries: tre_dep,
    description: 'Regular Expressions library',
    filebase: 'regex',
)

meson.add_install_script('meson_post_install.py')


