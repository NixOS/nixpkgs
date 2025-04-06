{
  'includes': ['common.gypi'],
  'targets': [
    {
      'target_name': 'locate_sqlite3',
      'type': 'none',
      'copies': [{
        'files': [
          '@extension@/src/sqlite3.c',
        ],
        'destination': '<(SHARED_INTERMEDIATE_DIR)/sqlite3',
      }],
    },
    {
      'target_name': 'sqlite3',
      'type': 'static_library',
      'dependencies': ['locate_sqlite3'],
      'sources': ['<(SHARED_INTERMEDIATE_DIR)/sqlite3/sqlite3.c'],
      'include_dirs': [
        '<(SHARED_INTERMEDIATE_DIR)/sqlite3/',
      ],
      'direct_dependent_settings': {
        'include_dirs': [
          '@extension@/include',
        ],
      },
      'cflags': ['-std=c99', '-w'],
      'xcode_settings': {
        'OTHER_CFLAGS': ['-std=c99'],
        'WARNING_CFLAGS': ['-w'],
      },
      'includes': ['defines.gypi'],
      'link_settings': {
        'libraries': [
          '@extension@/lib/libsignal_sqlcipher_extension@static_lib_ext@',
        ]
      }
    },
  ],
}
