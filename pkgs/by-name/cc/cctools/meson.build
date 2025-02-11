# Build settings based on the upstream Xcode project.
# See: https://github.com/apple-oss-distributions/cctools/blob/main/cctools.xcodeproj/project.pbxproj

# Project settings
project(
    'cctools',
    'c',
    version : '@version@',
    default_options : {
        'c_args': [
            '-DCCTB_MACOS=YES',
            '-DCCTB_PROJECT=cctools',
            '-DCCTB_PROJVERS=cctools-@version@',
            '-DCCTB_VERSION=@version@',
            '-DCURRENT_PROJECT_VERSION="@version@"',
            '-DCODEDIRECTORY_SUPPORT',
            '-DLTO_SUPPORT',
        ],
    },
)

fs = import('fs')

# Options
target_prefix = get_option('target_prefix')


# Dependencies
cc = meson.get_compiler('c')

libcxx = cc.find_library('c++')
libcodedirectory = cc.find_library('codedirectory')
libprunetrie = cc.find_library('prunetrie')


incdirs = include_directories('include')

# Static libraries
libstuff = static_library(
    'stuff',
    c_args : [
        '-DCPU_TYPE_RISCV32=24', # Per src/abstraction/MachOFileAbstraction.hpp from ld64
    ],
    include_directories : [incdirs, 'include/stuff'],
    sources : [
        'libstuff/SymLoc.c',
        'libstuff/align.c',
        'libstuff/allocate.c',
        'libstuff/apple_version.c',
        'libstuff/arch.c',
        'libstuff/arch_usage.c',
        'libstuff/args.c',
        'libstuff/best_arch.c',
        'libstuff/breakout.c',
        'libstuff/bytesex.c',
        'libstuff/checkout.c',
        'libstuff/code_directory.c',
        'libstuff/coff_bytesex.c',
        'libstuff/crc32.c',
        'libstuff/depinfo.c',
        'libstuff/diagnostics.c',
        'libstuff/dylib_roots.c',
        'libstuff/dylib_table.c',
        'libstuff/errors.c',
        'libstuff/execute.c',
        'libstuff/fatal_arch.c',
        'libstuff/fatals.c',
        'libstuff/get_arch_from_host.c',
        'libstuff/get_toc_byte_sex.c',
        'libstuff/guess_short_name.c',
        'libstuff/hash_string.c',
        'libstuff/hppa.c',
        'libstuff/llvm.c',
        'libstuff/lto.c',
        'libstuff/macosx_deployment_target.c',
        'libstuff/ofile.c',
        'libstuff/ofile_error.c',
        'libstuff/ofile_get_word.c',
        'libstuff/print.c',
        'libstuff/reloc.c',
        'libstuff/rnd.c',
        'libstuff/seg_addr_table.c',
        'libstuff/set_arch_flag_name.c',
        'libstuff/swap_headers.c',
        'libstuff/symbol_list.c',
        'libstuff/unix_standard_mode.c',
        'libstuff/version_number.c',
        'libstuff/vm_flush_cache.c',
        'libstuff/write64.c',
        'libstuff/writeout.c',
        'libstuff/xcode.c',
    ],
)

libstuff_otool = static_library(
    'stuff_otool',
    c_args : [
        '-DCPU_TYPE_RISCV32=24', # Per src/abstraction/MachOFileAbstraction.hpp from ld64
    ],
    include_directories : [incdirs, 'include/stuff', 'otool'],
    sources : [
        'libstuff/SymLoc.c',
        'libstuff/align.c',
        'libstuff/allocate.c',
        'libstuff/apple_version.c',
        'libstuff/arch.c',
        'libstuff/arch_usage.c',
        'libstuff/args.c',
        'libstuff/best_arch.c',
        'libstuff/breakout.c',
        'libstuff/bytesex.c',
        'libstuff/checkout.c',
        'libstuff/code_directory.c',
        'libstuff/coff_bytesex.c',
        'libstuff/crc32.c',
        'libstuff/depinfo.c',
        'libstuff/diagnostics.c',
        'libstuff/dylib_roots.c',
        'libstuff/dylib_table.c',
        'libstuff/errors.c',
        'libstuff/execute.c',
        'libstuff/fatal_arch.c',
        'libstuff/fatals.c',
        'libstuff/get_arch_from_host.c',
        'libstuff/get_toc_byte_sex.c',
        'libstuff/guess_short_name.c',
        'libstuff/hash_string.c',
        'libstuff/hppa.c',
        'libstuff/llvm.c',
        'libstuff/lto.c',
        'libstuff/macosx_deployment_target.c',
        'libstuff/ofile.c',
        'libstuff/ofile_error.c',
        'libstuff/ofile_get_word.c',
        'libstuff/print.c',
        'libstuff/reloc.c',
        'libstuff/rnd.c',
        'libstuff/seg_addr_table.c',
        'libstuff/set_arch_flag_name.c',
        'libstuff/swap_headers.c',
        'libstuff/symbol_list.c',
        'libstuff/unix_standard_mode.c',
        'libstuff/version_number.c',
        'libstuff/vm_flush_cache.c',
        'libstuff/write64.c',
        'libstuff/writeout.c',
        'libstuff/xcode.c',
    ],
)


# Binaries
ar = executable(
    f'@target_prefix@ar',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : [
        'ar/append.c',
        'ar/ar.c',
        'ar/archive.c',
        'ar/contents.c',
        'ar/delete.c',
        'ar/extract.c',
        'ar/misc.c',
        'ar/move.c',
        'ar/print.c',
        'ar/replace.c',
    ],
)
install_man(
    'ar/ar.1',
    'ar/ar.5',
)

as = executable(
    f'@target_prefix@gas',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['as/driver.c'],
)

as_common = files(
    'as/app.c',
    'as/as.c',
    'as/atof-generic.c',
    'as/atof-ieee.c',
    'as/dwarf2dbg.c',
    'as/expr.c',
    'as/fixes.c',
    'as/flonum-const.c',
    'as/flonum-copy.c',
    'as/flonum-mult.c',
    'as/frags.c',
    'as/hash.c',
    'as/hex-value.c',
    'as/input-file.c',
    'as/input-scrub.c',
    'as/layout.c',
    'as/messages.c',
    'as/obstack.c',
    'as/read.c',
    'as/sections.c',
    'as/symbols.c',
    'as/write_object.c',
    'as/xmalloc.c',
)

as_arm = executable(
    'as-arm',
    c_args : [
        '-DARM',
        '-DNeXT_MOD',
    ],
    include_directories : [
        incdirs,
        'as',
        'include/gnu',
    ],
    install : true,
    install_dir : 'libexec/as/arm',
    link_with : [libstuff],
    sources : [as_common, 'as/arm.c'],
)

as_i386 = executable(
    'as-i386',
    c_args : [
        '-DI386',
        '-Di486',
        '-Di586',
        '-Di686',
        '-DNeXT_MOD',
    ],
    include_directories : [
        incdirs,
        'as',
        'include/gnu',
    ],
    install : true,
    install_dir : 'libexec/as/i386',
    link_with : [libstuff],
    sources : [as_common, 'as/i386.c'],
)

as_x86_64 = executable(
    'as-x86_64',
    c_args : [
        '-DI386',
        '-Di486',
        '-Di586',
        '-Di686',
        '-DARCH64',
        '-DNeXT_MOD',
    ],
    include_directories : [
        incdirs,
        'as',
        'include/gnu'
    ],
    install : true,
    install_dir : 'libexec/as/x86_64',
    link_with : [libstuff],
    sources : [as_common, 'as/i386.c'],
)

# # ld # excluded because ld64 is built separately

bitcode_strip = executable(
    f'@target_prefix@bitcode_strip',
    dependencies : [libcodedirectory],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/bitcode_strip.c'],
)
install_man('man/bitcode_strip.1')

check_dylib = executable(
    f'@target_prefix@check_dylib',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/check_dylib.c'],
)
install_man('man/check_dylib.1')

checksyms = executable(
    f'@target_prefix@checksyms',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/checksyms.c'],
)
install_man('man/checksyms.1')

cmpdylib = executable(
    f'@target_prefix@cmpdylib',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/cmpdylib.c'],
)
install_man('man/cmpdylib.1')

codesign_allocate = executable(
    f'@target_prefix@codesign_allocate',
    dependencies : [libcodedirectory],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/codesign_allocate.c'],
)
install_man('man/codesign_allocate.1')

ctf_insert = executable(
    f'@target_prefix@ctf_insert',
    dependencies : [libcodedirectory],
    include_directories : [incdirs, 'include/stuff'],
    install : true,
    link_with : [libstuff],
    sources : ['misc/ctf_insert.c'],
)
install_man('man/ctf_insert.1')

depinfo = executable(
    f'@target_prefix@depinfo',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/depinfo.c'],
)
install_man('man/depinfo.1')

diagtest = executable(
    f'@target_prefix@diagtest',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/diagtest.c'],
)
install_man('man/diagtest.1')

gprof = executable(
    f'@target_prefix@gprof',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : [
        'gprof/arcs.c',
        'gprof/calls.c',
        'gprof/dfn.c',
        'gprof/getnfile.c',
        'gprof/gprof.c',
        'gprof/hertz.c',
        'gprof/lookup.c',
        'gprof/printgprof.c',
        'gprof/printlist.c',
        'gprof/scatter.c',
    ],
)
install_man('man/gprof.1')

# Not supported on 64-bit architectures
# indr = executable(
#     f'@target_prefix@indr',
#     include_directories : incdirs,
#     sources : ['misc/indr.c'],
# )
# install_man('man/indr.1')

install_name_tool = executable(
    f'@target_prefix@install_name_tool',
    dependencies : [libcodedirectory],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/install_name_tool.c'],
)
install_man('man/install_name_tool.1')

libtool = executable(
    f'@target_prefix@libtool',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/libtool.c'],
)
install_man('man/libtool.1')

lipo = executable(
    f'@target_prefix@lipo',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/lipo.c'],
)
install_man('man/lipo.1')

mtoc = executable(
    f'@target_prefix@mtoc',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['efitools/mtoc.c'],
)
install_man('man/mtoc.1')

mtor = executable(
    f'@target_prefix@mtor',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['efitools/mtor.c'],
)
install_man('man/mtor.1')

nm = executable(
    f'@target_prefix@nm',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/nm.c'],
)
install_man('man/nm-classic.1')

nmedit = executable(
    f'@target_prefix@nmedit',
    c_args : ['-DNMEDIT'],
    dependencies : [libcodedirectory],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/strip.c'],
)
install_man('man/nmedit.1')

otool = executable(
    f'@target_prefix@otool',
    c_args : ['-DEFI_SUPPORT'],
    dependencies : [libcxx],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : [
        'otool/arm64_disasm.c',
        'otool/arm_disasm.c',
        'otool/coff_print.c',
        'otool/dyld_bind_info.c',
        'otool/hppa_disasm.c',
        'otool/i386_disasm.c',
        'otool/i860_disasm.c',
        'otool/m68k_disasm.c',
        'otool/m88k_disasm.c',
        'otool/main.c',
        'otool/ofile_print.c',
        'otool/ppc_disasm.c',
        'otool/print_bitcode.c',
        'otool/print_objc.c',
        'otool/print_objc2_32bit.c',
        'otool/print_objc2_64bit.c',
        'otool/print_objc2_util.c',
        'otool/sparc_disasm.c',
    ],
)
install_man('man/otool-classic.1')

pagestuff = executable(
    f'@target_prefix@pagestuff',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/pagestuff.c'],
)
install_man('man/pagestuff.1')

# ranlib is a symlink to libtool
install_man(
    'man/ranlib.1',
    'man/ranlib.5',
)

redo_prebinding = executable(
    f'@target_prefix@redo_prebinding',
    dependencies : [libcodedirectory],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/redo_prebinding.c'],
)
install_man('man/redo_prebinding.1')

seg_addr_table = executable(
    f'@target_prefix@seg_addr_table',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/seg_addr_table.c'],
)
install_man('man/seg_addr_table.1')

seg_hack = executable(
    f'@target_prefix@seg_hack',
    dependencies : [libcodedirectory],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/seg_hack.c'],
)

segedit = executable(
    f'@target_prefix@segedit',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/segedit.c'],
)
install_man('man/segedit.1',)

size = executable(
    f'@target_prefix@size',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/size.c'],
)
install_man('man/size-classic.1')

strings = executable(
    f'@target_prefix@strings',
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/strings.c'],
)
install_man('man/strings.1')

strip = executable(
    f'@target_prefix@strip',
    c_args : ['-DTRIE_SUPPORT'],
    dependencies : [libcxx, libcodedirectory, libprunetrie],
    include_directories : incdirs,
    install : true,
    link_with : [libstuff],
    sources : ['misc/strip.c'],
)
install_man('man/strip.1')

vtool = executable(
    f'@target_prefix@vtool',
    dependencies : [libcodedirectory],
    include_directories : [incdirs, 'include/stuff'],
    install : true,
    link_with : [libstuff],
    sources : ['misc/vtool.c'],
)
install_man('man/vtool.1')


# Development files
# Static libraries
libmacho = static_library(
    'macho',
    include_directories : incdirs,
    sources : [
        'libmacho/arch.c',
        'libmacho/get_end.c',
        'libmacho/getsecbyname.c',
        'libmacho/getsegbyname.c',
        'libmacho/hppa_swap.c',
        'libmacho/i386_swap.c',
        'libmacho/i860_swap.c',
        'libmacho/m68k_swap.c',
        'libmacho/m88k_swap.c',
        'libmacho/ppc_swap.c',
        'libmacho/slot_name.c',
        'libmacho/sparc_swap.c',
        'libmacho/swap.c',
    ],
)

libredo_prebinding = static_library(
    'redo_prebinding',
    c_args : ['-DLIBRARY_API'],
    include_directories : incdirs,
    sources : ['misc/redo_prebinding.c'],
)
install_man('man/redo_prebinding.3')


# Development files
# Based on the contents of the upstream SDK.
install_headers(
    'include/mach-o/arch.h',
    'include/mach-o/fat.h',
    'include/mach-o/getsect.h',
    'include/mach-o/ldsyms.h',
    'include/mach-o/loader.h',
    'include/mach-o/nlist.h',
    'include/mach-o/ranlib.h',
    'include/mach-o/reloc.h',
    'include/mach-o/stab.h',
    'include/mach-o/swap.h',
    subdir : 'mach-o',
)

# Some of these architectures are irrelevant, but the Libsystem derivation expects their headers to be present.
# Not every arch has both headers, so tailor the lists for each that does.
foreach arch : ['arm', 'arm64', 'hppa', 'i860', 'm88k', 'ppc', 'sparc', 'x86_64']
    install_headers(
        f'include/mach-o/@arch@/reloc.h',
        subdir : f'mach-o/@arch@',
    )
endforeach
foreach arch : ['hppa', 'i386', 'i860', 'm68k', 'm88k', 'ppc', 'sparc']
    install_headers(
        f'include/mach-o/@arch@/swap.h',
        subdir : f'mach-o/@arch@',
    )
endforeach

install_data(
    'include/modules/mach-o.modulemap',
    install_dir : get_option('includedir'),
    rename : 'mach-o/module.map',
)
install_man(
    'man/Mach-O.5',
    'man/NSModule.3',
    'man/NSObjectFileImage.3',
    'man/NSObjectFileImage_priv.3',
    'man/arch.3',
    'man/dyld.3',
    'man/end.3',
    'man/get_end.3',
    'man/getsectbyname.3',
    'man/getsectbynamefromheader.3',
    'man/getsectdata.3',
    'man/getsectdatafromheader.3',
    'man/getsegbyname.3',
    'man/stab.5',
)
