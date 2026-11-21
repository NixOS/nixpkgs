/*
 * Stub of the obsolete ISDN CAPI 2.0 library (libcapi20.so.3), which
 * CrossOver's capi2032.so links against but nixpkgs does not package.
 * Every call reports "CAPI not installed", the same as when the real
 * library is absent.
 */

#define CAPIERR_NOTINSTALLED 1001

unsigned capi20_register(
    unsigned maxLogicalConnection,
    unsigned maxBDataBlocks,
    unsigned maxBDataLen,
    unsigned maxB3Connection,
    unsigned maxB3Blocks,
    unsigned maxB3Len,
    unsigned maxNCCI,
    unsigned maxController)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_release(unsigned appl)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_put_message(unsigned appl, void *message)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_get_message(unsigned appl, void *message)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_release_message(unsigned appl, unsigned message)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_waitformessage(unsigned appl, void *message)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_get_manufacturer(unsigned controller, char *buf)
{
    if (buf)
        buf[0] = '\0';
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_get_version(unsigned controller, unsigned *version)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_get_serial_number(unsigned controller, char *buf)
{
    if (buf)
        buf[0] = '\0';
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_isinstalled(void)
{
    return CAPIERR_NOTINSTALLED;
}

unsigned capi20_get_profile(unsigned controller, void *profile)
{
    return CAPIERR_NOTINSTALLED;
}
