# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

calamares_add_plugin( mobile
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        Config.cpp
        Config.h
        MobileQmlViewStep.cpp
        MobileQmlViewStep.h
        PartitionJob.cpp
        PartitionJob.h
        UsersJob.cpp
        UsersJob.h
    RESOURCES
        mobile.qrc
    LINK_PRIVATE_LIBRARIES
        calamaresui
    SHARED_LIB
)
