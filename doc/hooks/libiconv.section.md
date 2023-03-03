
### libiconv, libintl {#libiconv-libintl}

A few libraries automatically add to `NIX_LDFLAGS` their library, making their symbols automatically available to the linker. This includes libiconv and libintl (gettext). This is done to provide compatibility between GNU Linux, where libiconv and libintl are bundled in, and other systems where that might not be the case. Sometimes, this behavior is not desired. To disable this behavior, set `dontAddExtraLibs`.
