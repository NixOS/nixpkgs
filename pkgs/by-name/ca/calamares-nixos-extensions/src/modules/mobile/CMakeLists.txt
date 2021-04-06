# SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
# SPDX-License-Identifier: GPL-3.0-or-later

calamares_add_plugin( mobile
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        Config.cpp
        MobileQmlViewStep.cpp
        PartitionJob.cpp
        UsersJob.cpp
    RESOURCES
        mobile.qrc
    SHARED_LIB
)
