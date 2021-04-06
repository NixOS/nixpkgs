# SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
# SPDX-License-Identifier: GPL-3.0-or-later

calamares_add_plugin( unpackfsc
    TYPE job
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        Config.cpp
        UnpackFSCJob.cpp
    SHARED_LIB
)
