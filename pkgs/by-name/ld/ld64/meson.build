# Build settings based on the upstream Xcode project.
# See: https://github.com/apple-oss-distributions/ld64/blob/main/ld64.xcodeproj/project.pbxproj

# Project settings
project(
    'ld64',
    'c', 'cpp',
    version : '@version@',
    default_options : {'cpp_std': 'c++20'},
)

fs = import('fs')

# Options
target_prefix = get_option('target_prefix')


# Dependencies
cc = meson.get_compiler('c')
cxx = meson.get_compiler('cpp')
python = find_program('python3')

libtapi = cxx.find_library('tapi')
openssl = dependency('openssl', version : '>=3.0')
xar = cc.find_library('xar')


# Generated files

compile_stubs_h = custom_target(
    'compile_stubs.h',
    capture : true,
    command : [python, '@INPUT0@', '@INPUT1@'],
    input : ['gen_compile_stubs.py', 'compile_stubs'],
    output : ['compile_stubs.h'],
)

configure_h = custom_target(
    'configure_h',
    command : ['bash', '@INPUT@'],
    env : {
        'DERIVED_FILE_DIR' : meson.current_build_dir(),
        'RC_ProjectSourceVersion': '@version@'
    },
    input : ['src/create_configure'],
    output : ['configure.h'],
)

incdirs = include_directories(
    'compat',
    'src/abstraction',
    'src/ld',
    'src/ld/code-sign-blobs',
    'src/ld/parsers',
    'src/ld/passes',
    'src/mach_o',
)

# Dynamic libraries
libcodedirectory = library(
    'codedirectory',
    dependencies : [openssl],
    include_directories : incdirs,
    install : true,
    sources : [
        'compat/corecrypto/ccdigest.c',
        'compat/corecrypto/ccsha1.c',
        'compat/corecrypto/ccsha2.c',
        'compat/libcodedirectory.c',
        'src/ld/libcodedirectory.c'
    ],
    soversion : 1,
)
install_headers(
    'src/ld/cs_blobs.h',
    'src/ld/libcodedirectory.h',
)


# Static libraries
libprunetrie = static_library(
    'prunetrie',
    include_directories : incdirs,
    install : true,
    override_options : {'b_lto': false},
    sources : [
        'src/mach_o/Error.cpp',
        'src/mach_o/ExportsTrie.cpp',
        'src/other/PruneTrie.cpp',
    ],
)
install_headers(
    'src/other/prune_trie.h',
    subdir : 'mach-o',
)


# Binaries
ld64 = executable(
    f'@target_prefix@ld',
    dependencies : [libtapi, openssl, xar],
    include_directories : incdirs,
    install : true,
    cpp_args : [
        # Required for `_COMM_PAGE_CPU_CAPABILITIES64` in
        # <System/machine/cpu_capabilities.h> on `x86_64-darwin`
        '-DPRIVATE',
    ],
    # These linker flags mirror those used in a release build of the Xcode project.
    # See: https://github.com/apple-oss-distributions/ld64/blob/47f477cb721755419018f7530038b272e9d0cdea/ld64.xcodeproj/project.pbxproj#L1292-L1299.
    link_args : [
        '-Wl,-exported_symbol,__mh_execute_header',
        '-Wl,-stack_size,0x02000000',
        '-Wl,-client_name,ld',
    ],
    link_with : [libcodedirectory],
    sources : [
        compile_stubs_h,
        configure_h,
        'compat/CommonCrypto/CommonDigestSPI.c',
        'compat/corecrypto/ccdigest.c',
        'compat/corecrypto/ccsha1.c',
        'compat/corecrypto/ccsha2.c',
        'src/ld/FatFile.cpp',
        'src/ld/InputFiles.cpp',
        'src/ld/Mangling.cpp',
        'src/ld/Options.cpp',
        'src/ld/OutputFile.cpp',
        'src/ld/PlatformSupport.cpp',
        'src/ld/Resolver.cpp',
        'src/ld/ResponseFiles.cpp',
        'src/ld/Snapshot.cpp',
        'src/ld/SymbolTable.cpp',
        'src/ld/code-sign-blobs/blob.cpp',
        'src/ld/code-sign-blobs/blob.h',
        'src/ld/debugline.c',
        'src/ld/ld.cpp',
        'src/ld/parsers/archive_file.cpp',
        'src/ld/parsers/generic_dylib_file.cpp',
        'src/ld/parsers/lto_file.cpp',
        'src/ld/parsers/macho_dylib_file.cpp',
        'src/ld/parsers/macho_relocatable_file.cpp',
        'src/ld/parsers/opaque_section_file.cpp',
        'src/ld/parsers/textstub_dylib_file.cpp',
        'src/ld/passes/bitcode_bundle.cpp',
        'src/ld/passes/branch_island.cpp',
        'src/ld/passes/branch_shim.cpp',
        'src/ld/passes/code_dedup.cpp',
        'src/ld/passes/compact_unwind.cpp',
        'src/ld/passes/dtrace_dof.cpp',
        'src/ld/passes/dylibs.cpp',
        'src/ld/passes/got.cpp',
        'src/ld/passes/huge.cpp',
        'src/ld/passes/inits.cpp',
        'src/ld/passes/objc.cpp',
        'src/ld/passes/objc_constants.cpp',
        'src/ld/passes/objc_stubs.cpp',
        'src/ld/passes/order.cpp',
        'src/ld/passes/stubs/stubs.cpp',
        'src/ld/passes/thread_starts.cpp',
        'src/ld/passes/tlvp.cpp',
        'src/mach_o/Error.cpp',
        'src/mach_o/ExportsTrie.cpp',
    ],
)
install_man('doc/man/man1/ld-classic.1')

# Extra tools
unwinddump = executable(
    f'@target_prefix@unwinddump',
    include_directories : incdirs,
    install : true,
    sources : [
        configure_h,
        'src/other/UnwindDump.cpp',
    ],
)
install_man('doc/man/man1/unwinddump.1')

machocheck = executable(
    f'@target_prefix@machocheck',
    include_directories : incdirs,
    install : true,
    sources : [
        configure_h,
        'src/other/machochecker.cpp',
    ],
)

objectdump = executable(
    f'@target_prefix@ObjectDump',
    include_directories : incdirs,
    install : true,
    sources : [
        configure_h,
        'src/ld/PlatformSupport.cpp',
        'src/ld/debugline.c',
        'src/ld/parsers/macho_relocatable_file.cpp',
        'src/other/ObjectDump.cpp',
    ],
)

objcimageinfo = executable(
    f'@target_prefix@objcimageinfo',
    include_directories : incdirs,
    install : true,
    sources : [
        configure_h,
        'src/other/objcimageinfo.cpp',
    ],
)
