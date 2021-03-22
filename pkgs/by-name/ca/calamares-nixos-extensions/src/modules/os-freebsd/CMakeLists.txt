# The OS-FreeBSD module does "all the things" in a FreeBSD installation.
# Since the other modules -- users, fstab, grub, pretty much all of them
# -- are Linux-specific, it doesn't make much sense to fork each of them
# or provide alternatives, so instead we have one module that completes
# a FreeBSD installation based on the GlobalStorage values set by
# Calamares viewmodules.
#
#   SPDX-FileCopyrightText: 2019 Adriaan de Groot <groot@kde.org>
#   SPDX-License-Identifier: GPL-3.0-or-later
#   License-Filename: LICENSE
#

calamares_add_plugin( os-freebsd
    TYPE job
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        FreeBSDJob.cpp
    LINK_PRIVATE_LIBRARIES
        calamares
    SHARED_LIB
    NO_CONFIG
)
