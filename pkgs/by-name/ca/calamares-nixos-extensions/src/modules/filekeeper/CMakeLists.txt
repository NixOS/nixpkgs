# The FileKeeper plugin preserves files from the live system
# to the target system. It is particularly suited for copying
# the log file(s) for post-installation or post-mortem examination.

calamares_add_plugin( filekeeper
    TYPE job
    EXPORT_MACRO PLUGINDLLEXPORT_PRO
    SOURCES
        FileKeeper.cpp
    SHARED_LIB
)
