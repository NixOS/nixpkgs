project(
    'frozen',
    'c',
    default_options: [
        'c_args=-Wextra -fno-builtin -pedantic',
        'c_std=c99',
        'werror=true'
    ],
    license: 'Apache-2.0',
    version: '20210223'
)

library(
    'frozen',
    'frozen.c',
    install: true
)

install_headers('frozen.h')
