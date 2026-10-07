! SPDX-License-Identifier: 0BSD
USING: io namespaces sequences ;

IN: hello

: greet ( name -- )
    "Hello, " prepend print ;
