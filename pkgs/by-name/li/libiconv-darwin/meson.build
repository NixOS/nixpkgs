# Build settings based on the upstream Xcode project.
# See: https://github.com/apple-oss-distributions/libiconv/blob/main/libiconv.xcodeproj/project.pbxproj

# Project settings
project('libiconv', 'c', version : '@version@')

fs = import('fs')


# Dependencies
cc = meson.get_compiler('c')


# Definitions
prefix_libdir = get_option('prefix') / get_option('libdir')
prefix_datadir = get_option('prefix') / get_option('datadir')

i18nmoduledir = prefix_libdir / 'i18n'
esdbdir = prefix_datadir / 'i18n/esdb'
csmapperdir = prefix_datadir / 'i18n/csmapper'


# Libraries
libcharset = library(
    'charset',
    darwin_versions : '1',
    install : true,
    include_directories : ['libcharset'],
    sources : [
        'libcharset/libcharset.c'
    ],
    soversion : '1'
)
install_headers(
    'libcharset/libcharset.h',
    'libcharset/localcharset.h'
)

libiconv = library(
    'iconv',
    build_rpath : fs.parent(libcharset.full_path()),
    c_args : [
        f'-D_PATH_I18NMODULE="@i18nmoduledir@"',
        f'-D_PATH_ESDB="@esdbdir@"',
        f'-D_PATH_CSMAPPER="@csmapperdir@"'
    ],
    darwin_versions : '7',
    install : true,
    include_directories : ['citrus', 'libcharset'],
    link_args : ['-Wl,-reexport_library', fs.name(libcharset.full_path())],
    link_depends : [libcharset],
    override_options : {'b_asneeded' : false}, # Make sure the libcharset reexport is not stripped
    sources : [
        'citrus/__iconv_get_list.c',
        'citrus/__iconv_free_list.c',
        'citrus/__iconv.c',
        'citrus/bsd_iconv.c',
        'citrus/citrus_bcs_strtol.c',
        'citrus/citrus_bcs_strtoul.c',
        'citrus/citrus_bcs.c',
        'citrus/citrus_csmapper.c',
        'citrus/citrus_db.c',
        'citrus/citrus_db_factory.c',
        'citrus/citrus_db_hash.c',
        'citrus/citrus_esdb.c',
        'citrus/citrus_hash.c',
        'citrus/citrus_iconv.c',
        'citrus/citrus_lookup_factory.c',
        'citrus/citrus_lookup.c',
        'citrus/citrus_mapper.c',
        'citrus/citrus_memstream.c',
        'citrus/citrus_mmap.c',
        'citrus/citrus_module.c',
        'citrus/citrus_none.c',
        'citrus/citrus_pivot_factory.c',
        'citrus/citrus_prop.c',
        'citrus/citrus_stdenc.c',
        'citrus/iconv_canonicalize.c',
        'citrus/iconv_close.c',
        'citrus/iconv_compat.c',
        'citrus/iconv_open_into.c',
        'citrus/iconv_open.c',
        'citrus/iconv_set_relocation_prefix.c',
        'citrus/iconvctl.c',
        'citrus/iconvlist.c',
        'citrus/iconv.c',
    ],
    soversion : '2'
)
install_headers(
    'citrus/iconv.h'
)
install_man(
    'citrus/__iconv_get_list.3',
    'citrus/iconv_canonicalize.3',
    'citrus/iconv.3',
    'citrus/iconvctl.3',
    'citrus/iconvlist.3',
)


# Binaries
executable(
    'iconv',
    install : true,
    include_directories : ['citrus', 'libcharset'],
    link_with : [libiconv],
    sources : [
        'iconv/iconv.c'
    ]
)
install_man('iconv/iconv.1')


# Data
## csmapper
csmapper_modules = [
    'APPLE',
    'AST',
    'BIG5',
    'CNS',
    'CP',
    'EBCDIC',
    'GB',
    'GEORGIAN',
    'ISO-8859',
    'ISO646',
    'JIS',
    'KAZAKH',
    'KOI',
    'KS',
    'MISC',
    'TCVN'
]

foreach module : csmapper_modules
    mps_files = run_command(
        'find', 'i18n/csmapper' / module, '-regex', '.*\\.\\(mps\\|646\\)',
        check : true
    ).stdout().strip().split('\n')
    install_data(mps_files, install_dir : csmapperdir / module)
endforeach

install_data(
    'i18n/csmapper/charset.pivot',
    'i18n/csmapper/charset.pivot.pvdb',
    'i18n/csmapper/mapper.dir',
    'i18n/csmapper/mapper.dir.db',
    install_dir : csmapperdir
)

## esdb
esdb_modules = [
    'APPLE',
    'AST',
    'BIG5',
    'CP',
    'DEC',
    'EBCDIC',
    'EUC',
    'GB',
    'GEORGIAN',
    'ISO-2022',
    'ISO-8859',
    'ISO646',
    'KAZAKH',
    'KOI',
    'MISC',
    'TCVN',
    'UTF'
]

foreach module : esdb_modules
    esdb_files = run_command(
        'find', 'i18n/esdb' / module, '-name', '*.esdb',
        check : true
    ).stdout().strip().split('\n')
    install_data(esdb_files, install_dir : esdbdir / module)
endforeach

install_data(
    'i18n/esdb/esdb.alias',
    'i18n/esdb/esdb.alias.db',
    'i18n/esdb/esdb.dir',
    'i18n/esdb/esdb.dir.db',
    install_dir : esdbdir
)


# Modules
libiconv_modules = [
    'BIG5',
    'DECHanyu',
    'DECKanji',
    'EUC',
    'EUCTW',
    'GBK2K',
    'HZ',
    'ISO2022',
    'JOHAB',
    'MSKanji',
    'UES',
    'UTF1632',
    'UTF7',
    'UTF8',
    'UTF8MAC',
    'VIQR',
    'ZW',
    'iconv_none',
    'iconv_std',
    'mapper_646',
    'mapper_none',
    'mapper_serial',
    'mapper_parallel',
    'mapper_std',
    'mapper_zone'
]

foreach module : libiconv_modules
    module_source = module.to_lower()
    module_path = 'libiconv_modules' / module

    if module == 'UTF8MAC'
        extra_headers = 'libiconv_modules/UTF8'
    else
        extra_headers = [ ]
    endif

    # Upstream builds this module under both names.
    # See: https://github.com/apple-oss-distributions/libiconv/blob/81be60a93521c931a01aab9c747dd2b078bc0679/libiconv.xcodeproj/project.pbxproj#L2549-L2556
    # See also: https://cgit.freebsd.org/src/tree/lib/libiconv_modules/mapper_parallel/Makefile?id=9241ebc796c11cf133c550f188f324bd2c12d89a
    if module == 'mapper_parallel'
        module_source = 'mapper_serial'
        module_path = 'libiconv_modules/mapper_serial'
    endif

    library(
        module,
        darwin_versions : '1',
        install : true,
        install_dir : i18nmoduledir,
        include_directories : [module_path, 'citrus', 'libcharset'] + extra_headers,
        link_with : [libiconv],
        override_options : {'b_asneeded' : false}, # Upstream always links libiconv
        sources : [
            module_path / f'citrus_@module_source@.c'
        ]
    )
endforeach


# Tests
if get_option('tests') == true
## Only required for running the tests
    atf = dependency('atf-c')
    foreach suite : ['libiconv_test', 'mbopt_test', 'nixpkgs_test']
        test_src = f'tests/libiconv/@suite@.c'
        test_exe = executable(
            suite,
            dependencies : [atf],
            include_directories : ['citrus', 'libcharset'],
            link_with : [libiconv],
            sources : [test_src]
        )

        # Extract the tests to run from the test source code.
        tests = run_command(
            'sed', '-n', '-E', 's|.*ATF_TP_ADD_TC\\([^,]*, ([^)]*).*$|\\1|p', test_src,
            check : true
        ).stdout().strip().split('\n')

        foreach test : tests
            test(test, test_exe, args : [test], suite : suite, timeout : 300)
        endforeach
    endforeach

# These tests depend on `os_variant_has_internal_content`, which is stubbed out.
#     atf_sh = find_program('atf-sh')
#     print_charset = executable(
#         'print_charset',
#         include_directories : ['citrus', 'libcharset'],
#         link_with : [libiconv],
#         sources : 'tests/libcharset/print_charset.c'
#     )
#
#     test_charset = custom_target(
#         'test_charset.sh',
#         command : ['cp', '@INPUT@', '@OUTPUT@'],
#         depends : print_charset,
#         input : 'tests/libcharset/test_charset.sh',
#         output : 'test_charset.sh'
#     )
#
#     # Extract the tests to run from the test source code.
#     tests = run_command(
#         'sed', '-n', '-E', 's|.*atf_add_test_case (.*$)|\\1|p', 'tests/libcharset/test_charset.sh',
#         check : true
#     ).stdout().strip().split('\n')
#
#     foreach test : tests
#         test(test, atf_sh, args : [test_charset, test], suite : 'libcharset', timeout : 300)
#     endforeach
endif
