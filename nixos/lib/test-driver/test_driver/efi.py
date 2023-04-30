from enum import IntEnum

class EfiVariableAttributes(IntEnum):
    NonVolatile = 0x01
    BootServiceAccess = 0x02
    RuntimeAccess = 0x04
    HardwareErrorRecord = 0x08
    AuthenticatedWriteAccess = 0x10
    TimeBasedAuthenticatedWriteAccess = 0x20
    AppendWrite = 0x40
    EnhancedAuthenticatedAccess = 0x80

class EfiVariable:
    """
        An EFI variable represented by its attributes and raw value in bytes.
        Generally, the value is not encoded in UTF-8, but UCS-2 or UTF-16-LE.
    """
    attributes: EfiVariableAttributes
    value: bytes

    def __init__(self, value: bytes, attributes: bytes):
        self.value = value
        self.attributes = EfiVariableAttributes(attributes)

    def value_as_null_terminated_string(self, encoding: str = 'utf-16-le'):
        """
            Most often, variables are encoded with a null-terminated \x00.
            This function gives you the string in a default encoding of UTF-16-LE
            stripped of the null terminator.
        """
        return self.value.decode(encoding).rstrip('\x00')
