if( NOT Calamares_WITH_QML )
    calamares_skip_module( "freebsddisk (QML is not supported in this build)" )
    return()
endif()

calamares_add_plugin( freebsddisk
    TYPE viewmodule
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        FreeBSDDiskViewStep.cpp
    RESOURCES
        freebsddisk.qrc
    SHARED_LIB
)
