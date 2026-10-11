import sys

def patch_file(path, replacements):
    with open(path, 'rb') as f:
        data = bytearray(f.read())

    for old, new in replacements.items():
        assert len(old) == len(new), f"Lengths must match: {old} vs {new}"
        old_bytes = b'\x00' + old.encode('ascii') + b'\x00'
        new_bytes = b'\x00' + new.encode('ascii') + b'\x00'

        # We only want to replace unique null-terminated strings
        # by matching the preceding and succeeding null bytes.
        offset = 0
        count = 0
        while True:
            offset = data.find(old_bytes, offset)
            if offset == -1:
                break
            data[offset:offset+len(new_bytes)] = new_bytes
            offset += len(new_bytes) - 1 # Back off by 1 so we don't skip the next string's prefix null byte
            count += 1
        print(f"Patched {old} to {new}: {count} occurrences in {path}")

    with open(path, 'wb') as f:
        f.write(data)

if __name__ == '__main__':
    path = sys.argv[1]
    replacements = {
        'access': 'ac_ess',
        'fopen': 'fop_n',
        'fopen64': 'fop_n64',
        '__xstat': '__xp_at',
        'execve': 'ex_cve',
        'execvp': 'ex_cvp',
        '_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode': '_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmodx',
        '_ZNSt10filesystem6statusERKNS_7__cxx114pathE': '_ZNSt10filesystem6statusERKNS_7__cxx114pathX',
        '_ZNSt10filesystem18create_directoriesERKNS_7__cxx114pathE': '_ZNSt10filesystem18create_directoriesERKNS_7__cxx114pathX',
        '_ZNSt10filesystem7__cxx1128recursive_directory_iteratorC1ERKNS0_4pathENS_17directory_optionsEPSt10error_code': '_ZNSt10filesystem7__cxx1128recursive_directory_iteratorC1ERKNS0_4pathENS_17directory_optionsEPSt10error_codx',
        '_ZNSt10filesystem9copy_fileERKNS_7__cxx114pathES3_NS_12copy_optionsE': '_ZNSt10filesystem9copy_fileERKNS_7__cxx114pathES3_NS_12copy_optionsX',
    }
    patch_file(path, replacements)
