# ld.lld has two incompatible command-line drivers: One for the gnu-compatible COFF linker and one for
# the ELF linker. If no emulation is set (with -m), it will default to the ELF linker;
# unfortunately, some configure scripts use `ld --help` to check for certain Windows-specific flags,
# which don't show up in the help for the ELF linker. So we set a default -m here.

extraBefore+=("-m" "@mtype@")
