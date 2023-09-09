# FreeBSD requires using --allow-shlib-undefined most of the time in order to link with libc,
# due to some exports (notably environ) not actually being provided by libc but instead being
# transitive dependencies to ld-elf.so (?)
# rust packages seem to sometimes use symbol linkage visibility that gcc rejects under
# --allow-shlib-undefined, so we must turn it off. We pray that nobody uses environ from rust code.
echo "HELLO HACKERS @suffixSalt@"  # TODO remove
export NIX_LDFLAGS_@suffixSalt@="$NIX_LDFLAGS_@suffixSalt@ --no-allow-shlib-undefined"
