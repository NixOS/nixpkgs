# SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
# SPDX-License-Identifier: GPL-3.0-or-later

calamares_add_plugin( unpackfsc
    TYPE job
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        UnpackFSCJob.cpp
        # The workers for differently-packed filesystems
        Runners.cpp
        FSArchiverRunner.cpp
        UnsquashRunner.cpp
    SHARED_LIB
)
