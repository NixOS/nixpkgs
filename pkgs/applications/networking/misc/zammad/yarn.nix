{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "ansi_cyan___ansi_cyan_0.1.1.tgz";
      path = fetchurl {
        name = "ansi_cyan___ansi_cyan_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/ansi-cyan/-/ansi-cyan-0.1.1.tgz";
        sha1 = "538ae528af8982f28ae30d86f2f17456d2609873";
      };
    }
    {
      name = "ansi_gray___ansi_gray_0.1.1.tgz";
      path = fetchurl {
        name = "ansi_gray___ansi_gray_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/ansi-gray/-/ansi-gray-0.1.1.tgz";
        sha1 = "2962cf54ec9792c48510a3deb524436861ef7251";
      };
    }
    {
      name = "ansi_red___ansi_red_0.1.1.tgz";
      path = fetchurl {
        name = "ansi_red___ansi_red_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/ansi-red/-/ansi-red-0.1.1.tgz";
        sha1 = "8c638f9d1080800a353c9c28c8a81ca4705d946c";
      };
    }
    {
      name = "ansi_regex___ansi_regex_2.1.1.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_2.1.1.tgz";
        url = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz";
        sha1 = "c3b33ab5ee360d86e0e628f0468ae7ef27d654df";
      };
    }
    {
      name = "ansi_styles___ansi_styles_2.2.1.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_2.2.1.tgz";
        url = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz";
        sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
      };
    }
    {
      name = "ansi_wrap___ansi_wrap_0.1.0.tgz";
      path = fetchurl {
        name = "ansi_wrap___ansi_wrap_0.1.0.tgz";
        url = "https://registry.yarnpkg.com/ansi-wrap/-/ansi-wrap-0.1.0.tgz";
        sha1 = "a82250ddb0015e9a27ca82e82ea603bbfa45efaf";
      };
    }
    {
      name = "anymatch___anymatch_1.3.2.tgz";
      path = fetchurl {
        name = "anymatch___anymatch_1.3.2.tgz";
        url = "https://registry.yarnpkg.com/anymatch/-/anymatch-1.3.2.tgz";
        sha1 = "553dcb8f91e3c889845dfdba34c77721b90b9d7a";
      };
    }
    {
      name = "archy___archy_1.0.0.tgz";
      path = fetchurl {
        name = "archy___archy_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/archy/-/archy-1.0.0.tgz";
        sha1 = "f9c8c13757cc1dd7bc379ac77b2c62a5c2868c40";
      };
    }
    {
      name = "argparse___argparse_1.0.10.tgz";
      path = fetchurl {
        name = "argparse___argparse_1.0.10.tgz";
        url = "https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz";
        sha1 = "bcd6791ea5ae09725e17e5ad988134cd40b3d911";
      };
    }
    {
      name = "arr_diff___arr_diff_1.1.0.tgz";
      path = fetchurl {
        name = "arr_diff___arr_diff_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/arr-diff/-/arr-diff-1.1.0.tgz";
        sha1 = "687c32758163588fef7de7b36fabe495eb1a399a";
      };
    }
    {
      name = "arr_diff___arr_diff_2.0.0.tgz";
      path = fetchurl {
        name = "arr_diff___arr_diff_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/arr-diff/-/arr-diff-2.0.0.tgz";
        sha1 = "8f3b827f955a8bd669697e4a4256ac3ceae356cf";
      };
    }
    {
      name = "arr_diff___arr_diff_4.0.0.tgz";
      path = fetchurl {
        name = "arr_diff___arr_diff_4.0.0.tgz";
        url = "https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz";
        sha1 = "d6461074febfec71e7e15235761a329a5dc7c520";
      };
    }
    {
      name = "arr_flatten___arr_flatten_1.1.0.tgz";
      path = fetchurl {
        name = "arr_flatten___arr_flatten_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz";
        sha1 = "36048bbff4e7b47e136644316c99669ea5ae91f1";
      };
    }
    {
      name = "arr_union___arr_union_2.1.0.tgz";
      path = fetchurl {
        name = "arr_union___arr_union_2.1.0.tgz";
        url = "https://registry.yarnpkg.com/arr-union/-/arr-union-2.1.0.tgz";
        sha1 = "20f9eab5ec70f5c7d215b1077b1c39161d292c7d";
      };
    }
    {
      name = "arr_union___arr_union_3.1.0.tgz";
      path = fetchurl {
        name = "arr_union___arr_union_3.1.0.tgz";
        url = "https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz";
        sha1 = "e39b09aea9def866a8f206e288af63919bae39c4";
      };
    }
    {
      name = "array_differ___array_differ_1.0.0.tgz";
      path = fetchurl {
        name = "array_differ___array_differ_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/array-differ/-/array-differ-1.0.0.tgz";
        sha1 = "eff52e3758249d33be402b8bb8e564bb2b5d4031";
      };
    }
    {
      name = "array_each___array_each_1.0.1.tgz";
      path = fetchurl {
        name = "array_each___array_each_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/array-each/-/array-each-1.0.1.tgz";
        sha1 = "a794af0c05ab1752846ee753a1f211a05ba0c44f";
      };
    }
    {
      name = "array_slice___array_slice_0.2.3.tgz";
      path = fetchurl {
        name = "array_slice___array_slice_0.2.3.tgz";
        url = "https://registry.yarnpkg.com/array-slice/-/array-slice-0.2.3.tgz";
        sha1 = "dd3cfb80ed7973a75117cdac69b0b99ec86186f5";
      };
    }
    {
      name = "array_slice___array_slice_1.1.0.tgz";
      path = fetchurl {
        name = "array_slice___array_slice_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/array-slice/-/array-slice-1.1.0.tgz";
        sha1 = "e368ea15f89bc7069f7ffb89aec3a6c7d4ac22d4";
      };
    }
    {
      name = "array_uniq___array_uniq_1.0.3.tgz";
      path = fetchurl {
        name = "array_uniq___array_uniq_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz";
        sha1 = "af6ac877a25cc7f74e058894753858dfdb24fdb6";
      };
    }
    {
      name = "array_unique___array_unique_0.2.1.tgz";
      path = fetchurl {
        name = "array_unique___array_unique_0.2.1.tgz";
        url = "https://registry.yarnpkg.com/array-unique/-/array-unique-0.2.1.tgz";
        sha1 = "a1d97ccafcbc2625cc70fadceb36a50c58b01a53";
      };
    }
    {
      name = "array_unique___array_unique_0.3.2.tgz";
      path = fetchurl {
        name = "array_unique___array_unique_0.3.2.tgz";
        url = "https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz";
        sha1 = "a894b75d4bc4f6cd679ef3244a9fd8f46ae2d428";
      };
    }
    {
      name = "assign_symbols___assign_symbols_1.0.0.tgz";
      path = fetchurl {
        name = "assign_symbols___assign_symbols_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz";
        sha1 = "59667f41fadd4f20ccbc2bb96b8d4f7f78ec0367";
      };
    }
    {
      name = "async_each___async_each_1.0.3.tgz";
      path = fetchurl {
        name = "async_each___async_each_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/async-each/-/async-each-1.0.3.tgz";
        sha1 = "b727dbf87d7651602f06f4d4ac387f47d91b0cbf";
      };
    }
    {
      name = "atob___atob_2.1.2.tgz";
      path = fetchurl {
        name = "atob___atob_2.1.2.tgz";
        url = "https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz";
        sha1 = "6d9517eb9e030d2436666651e86bd9f6f13533c9";
      };
    }
    {
      name = "balanced_match___balanced_match_1.0.2.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz";
        sha1 = "e83e3a7e3f300b34cb9d87f615fa0cbf357690ee";
      };
    }
    {
      name = "base___base_0.11.2.tgz";
      path = fetchurl {
        name = "base___base_0.11.2.tgz";
        url = "https://registry.yarnpkg.com/base/-/base-0.11.2.tgz";
        sha1 = "7bde5ced145b6d551a90db87f83c558b4eb48a8f";
      };
    }
    {
      name = "beeper___beeper_1.1.1.tgz";
      path = fetchurl {
        name = "beeper___beeper_1.1.1.tgz";
        url = "https://registry.yarnpkg.com/beeper/-/beeper-1.1.1.tgz";
        sha1 = "e6d5ea8c5dad001304a70b22638447f69cb2f809";
      };
    }
    {
      name = "binary_extensions___binary_extensions_1.13.1.tgz";
      path = fetchurl {
        name = "binary_extensions___binary_extensions_1.13.1.tgz";
        url = "https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.13.1.tgz";
        sha1 = "598afe54755b2868a5330d2aff9d4ebb53209b65";
      };
    }
    {
      name = "bindings___bindings_1.5.0.tgz";
      path = fetchurl {
        name = "bindings___bindings_1.5.0.tgz";
        url = "https://registry.yarnpkg.com/bindings/-/bindings-1.5.0.tgz";
        sha1 = "10353c9e945334bc0511a6d90b38fbc7c9c504df";
      };
    }
    {
      name = "boolbase___boolbase_1.0.0.tgz";
      path = fetchurl {
        name = "boolbase___boolbase_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/boolbase/-/boolbase-1.0.0.tgz";
        sha1 = "68dff5fbe60c51eb37725ea9e3ed310dcc1e776e";
      };
    }
    {
      name = "brace_expansion___brace_expansion_1.1.11.tgz";
      path = fetchurl {
        name = "brace_expansion___brace_expansion_1.1.11.tgz";
        url = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha1 = "3c7fcbf529d87226f3d2f52b966ff5271eb441dd";
      };
    }
    {
      name = "braces___braces_1.8.5.tgz";
      path = fetchurl {
        name = "braces___braces_1.8.5.tgz";
        url = "https://registry.yarnpkg.com/braces/-/braces-1.8.5.tgz";
        sha1 = "ba77962e12dff969d6b76711e914b737857bf6a7";
      };
    }
    {
      name = "braces___braces_2.3.2.tgz";
      path = fetchurl {
        name = "braces___braces_2.3.2.tgz";
        url = "https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz";
        sha1 = "5979fd3f14cd531565e5fa2df1abfff1dfaee729";
      };
    }
    {
      name = "cache_base___cache_base_1.0.1.tgz";
      path = fetchurl {
        name = "cache_base___cache_base_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz";
        sha1 = "0a7f46416831c8b662ee36fe4e7c59d76f666ab2";
      };
    }
    {
      name = "chalk___chalk_1.1.3.tgz";
      path = fetchurl {
        name = "chalk___chalk_1.1.3.tgz";
        url = "https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz";
        sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
      };
    }
    {
      name = "cheerio___cheerio_0.22.0.tgz";
      path = fetchurl {
        name = "cheerio___cheerio_0.22.0.tgz";
        url = "https://registry.yarnpkg.com/cheerio/-/cheerio-0.22.0.tgz";
        sha1 = "a9baa860a3f9b595a6b81b1a86873121ed3a269e";
      };
    }
    {
      name = "chokidar___chokidar_1.7.0.tgz";
      path = fetchurl {
        name = "chokidar___chokidar_1.7.0.tgz";
        url = "https://registry.yarnpkg.com/chokidar/-/chokidar-1.7.0.tgz";
        sha1 = "798e689778151c8076b4b360e5edd28cda2bb468";
      };
    }
    {
      name = "clap___clap_1.2.3.tgz";
      path = fetchurl {
        name = "clap___clap_1.2.3.tgz";
        url = "https://registry.yarnpkg.com/clap/-/clap-1.2.3.tgz";
        sha1 = "4f36745b32008492557f46412d66d50cb99bce51";
      };
    }
    {
      name = "class_utils___class_utils_0.3.6.tgz";
      path = fetchurl {
        name = "class_utils___class_utils_0.3.6.tgz";
        url = "https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz";
        sha1 = "f93369ae8b9a7ce02fd41faad0ca83033190c463";
      };
    }
    {
      name = "clone_stats___clone_stats_0.0.1.tgz";
      path = fetchurl {
        name = "clone_stats___clone_stats_0.0.1.tgz";
        url = "https://registry.yarnpkg.com/clone-stats/-/clone-stats-0.0.1.tgz";
        sha1 = "b88f94a82cf38b8791d58046ea4029ad88ca99d1";
      };
    }
    {
      name = "clone___clone_0.2.0.tgz";
      path = fetchurl {
        name = "clone___clone_0.2.0.tgz";
        url = "https://registry.yarnpkg.com/clone/-/clone-0.2.0.tgz";
        sha1 = "c6126a90ad4f72dbf5acdb243cc37724fe93fc1f";
      };
    }
    {
      name = "clone___clone_1.0.4.tgz";
      path = fetchurl {
        name = "clone___clone_1.0.4.tgz";
        url = "https://registry.yarnpkg.com/clone/-/clone-1.0.4.tgz";
        sha1 = "da309cc263df15994c688ca902179ca3c7cd7c7e";
      };
    }
    {
      name = "coa___coa_1.0.4.tgz";
      path = fetchurl {
        name = "coa___coa_1.0.4.tgz";
        url = "https://registry.yarnpkg.com/coa/-/coa-1.0.4.tgz";
        sha1 = "a9ef153660d6a86a8bdec0289a5c684d217432fd";
      };
    }
    {
      name = "collection_visit___collection_visit_1.0.0.tgz";
      path = fetchurl {
        name = "collection_visit___collection_visit_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz";
        sha1 = "4bc0373c164bc3291b4d368c829cf1a80a59dca0";
      };
    }
    {
      name = "color_support___color_support_1.1.3.tgz";
      path = fetchurl {
        name = "color_support___color_support_1.1.3.tgz";
        url = "https://registry.yarnpkg.com/color-support/-/color-support-1.1.3.tgz";
        sha1 = "93834379a1cc9a0c61f82f52f0d04322251bd5a2";
      };
    }
    {
      name = "colors___colors_1.1.2.tgz";
      path = fetchurl {
        name = "colors___colors_1.1.2.tgz";
        url = "https://registry.yarnpkg.com/colors/-/colors-1.1.2.tgz";
        sha1 = "168a4701756b6a7f51a12ce0c97bfa28c084ed63";
      };
    }
    {
      name = "component_emitter___component_emitter_1.3.0.tgz";
      path = fetchurl {
        name = "component_emitter___component_emitter_1.3.0.tgz";
        url = "https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz";
        sha1 = "16e4070fba8ae29b679f2215853ee181ab2eabc0";
      };
    }
    {
      name = "concat_map___concat_map_0.0.1.tgz";
      path = fetchurl {
        name = "concat_map___concat_map_0.0.1.tgz";
        url = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    }
    {
      name = "copy_descriptor___copy_descriptor_0.1.1.tgz";
      path = fetchurl {
        name = "copy_descriptor___copy_descriptor_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz";
        sha1 = "676f6eb3c39997c2ee1ac3a924fd6124748f578d";
      };
    }
    {
      name = "core_util_is___core_util_is_1.0.3.tgz";
      path = fetchurl {
        name = "core_util_is___core_util_is_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz";
        sha1 = "a6042d3634c2b27e9328f837b965fac83808db85";
      };
    }
    {
      name = "css_select___css_select_1.2.0.tgz";
      path = fetchurl {
        name = "css_select___css_select_1.2.0.tgz";
        url = "https://registry.yarnpkg.com/css-select/-/css-select-1.2.0.tgz";
        sha1 = "2b3a110539c5355f1cd8d314623e870b121ec858";
      };
    }
    {
      name = "css_what___css_what_2.1.3.tgz";
      path = fetchurl {
        name = "css_what___css_what_2.1.3.tgz";
        url = "https://registry.yarnpkg.com/css-what/-/css-what-2.1.3.tgz";
        sha1 = "a6d7604573365fe74686c3f311c56513d88285f2";
      };
    }
    {
      name = "csso___csso_2.3.2.tgz";
      path = fetchurl {
        name = "csso___csso_2.3.2.tgz";
        url = "https://registry.yarnpkg.com/csso/-/csso-2.3.2.tgz";
        sha1 = "ddd52c587033f49e94b71fc55569f252e8ff5f85";
      };
    }
    {
      name = "dateformat___dateformat_2.2.0.tgz";
      path = fetchurl {
        name = "dateformat___dateformat_2.2.0.tgz";
        url = "https://registry.yarnpkg.com/dateformat/-/dateformat-2.2.0.tgz";
        sha1 = "4065e2013cf9fb916ddfd82efb506ad4c6769062";
      };
    }
    {
      name = "debug___debug_2.6.9.tgz";
      path = fetchurl {
        name = "debug___debug_2.6.9.tgz";
        url = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha1 = "5d128515df134ff327e90a4c93f4e077a536341f";
      };
    }
    {
      name = "decode_uri_component___decode_uri_component_0.2.0.tgz";
      path = fetchurl {
        name = "decode_uri_component___decode_uri_component_0.2.0.tgz";
        url = "https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.0.tgz";
        sha1 = "eb3913333458775cb84cd1a1fae062106bb87545";
      };
    }
    {
      name = "defaults___defaults_1.0.3.tgz";
      path = fetchurl {
        name = "defaults___defaults_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/defaults/-/defaults-1.0.3.tgz";
        sha1 = "c656051e9817d9ff08ed881477f3fe4019f3ef7d";
      };
    }
    {
      name = "define_property___define_property_0.2.5.tgz";
      path = fetchurl {
        name = "define_property___define_property_0.2.5.tgz";
        url = "https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz";
        sha1 = "c35b1ef918ec3c990f9a5bc57be04aacec5c8116";
      };
    }
    {
      name = "define_property___define_property_1.0.0.tgz";
      path = fetchurl {
        name = "define_property___define_property_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz";
        sha1 = "769ebaaf3f4a63aad3af9e8d304c9bbe79bfb0e6";
      };
    }
    {
      name = "define_property___define_property_2.0.2.tgz";
      path = fetchurl {
        name = "define_property___define_property_2.0.2.tgz";
        url = "https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz";
        sha1 = "d459689e8d654ba77e02a817f8710d702cb16e9d";
      };
    }
    {
      name = "deprecated___deprecated_0.0.1.tgz";
      path = fetchurl {
        name = "deprecated___deprecated_0.0.1.tgz";
        url = "https://registry.yarnpkg.com/deprecated/-/deprecated-0.0.1.tgz";
        sha1 = "f9c9af5464afa1e7a971458a8bdef2aa94d5bb19";
      };
    }
    {
      name = "detect_file___detect_file_1.0.0.tgz";
      path = fetchurl {
        name = "detect_file___detect_file_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/detect-file/-/detect-file-1.0.0.tgz";
        sha1 = "f0d66d03672a825cb1b73bdb3fe62310c8e552b7";
      };
    }
    {
      name = "dom_serializer___dom_serializer_0.2.2.tgz";
      path = fetchurl {
        name = "dom_serializer___dom_serializer_0.2.2.tgz";
        url = "https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-0.2.2.tgz";
        sha1 = "1afb81f533717175d478655debc5e332d9f9bb51";
      };
    }
    {
      name = "dom_serializer___dom_serializer_0.1.1.tgz";
      path = fetchurl {
        name = "dom_serializer___dom_serializer_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-0.1.1.tgz";
        sha1 = "1ec4059e284babed36eec2941d4a970a189ce7c0";
      };
    }
    {
      name = "domelementtype___domelementtype_1.3.1.tgz";
      path = fetchurl {
        name = "domelementtype___domelementtype_1.3.1.tgz";
        url = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-1.3.1.tgz";
        sha1 = "d048c44b37b0d10a7f2a3d5fee3f4333d790481f";
      };
    }
    {
      name = "domelementtype___domelementtype_2.2.0.tgz";
      path = fetchurl {
        name = "domelementtype___domelementtype_2.2.0.tgz";
        url = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-2.2.0.tgz";
        sha1 = "9a0b6c2782ed6a1c7323d42267183df9bd8b1d57";
      };
    }
    {
      name = "domhandler___domhandler_2.4.2.tgz";
      path = fetchurl {
        name = "domhandler___domhandler_2.4.2.tgz";
        url = "https://registry.yarnpkg.com/domhandler/-/domhandler-2.4.2.tgz";
        sha1 = "8805097e933d65e85546f726d60f5eb88b44f803";
      };
    }
    {
      name = "domutils___domutils_1.5.1.tgz";
      path = fetchurl {
        name = "domutils___domutils_1.5.1.tgz";
        url = "https://registry.yarnpkg.com/domutils/-/domutils-1.5.1.tgz";
        sha1 = "dcd8488a26f563d61079e48c9f7b7e32373682cf";
      };
    }
    {
      name = "domutils___domutils_1.7.0.tgz";
      path = fetchurl {
        name = "domutils___domutils_1.7.0.tgz";
        url = "https://registry.yarnpkg.com/domutils/-/domutils-1.7.0.tgz";
        sha1 = "56ea341e834e06e6748af7a1cb25da67ea9f8c2a";
      };
    }
    {
      name = "duplexer2___duplexer2_0.0.2.tgz";
      path = fetchurl {
        name = "duplexer2___duplexer2_0.0.2.tgz";
        url = "https://registry.yarnpkg.com/duplexer2/-/duplexer2-0.0.2.tgz";
        sha1 = "c614dcf67e2fb14995a91711e5a617e8a60a31db";
      };
    }
    {
      name = "end_of_stream___end_of_stream_0.1.5.tgz";
      path = fetchurl {
        name = "end_of_stream___end_of_stream_0.1.5.tgz";
        url = "https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-0.1.5.tgz";
        sha1 = "8e177206c3c80837d85632e8b9359dfe8b2f6eaf";
      };
    }
    {
      name = "entities___entities_1.1.2.tgz";
      path = fetchurl {
        name = "entities___entities_1.1.2.tgz";
        url = "https://registry.yarnpkg.com/entities/-/entities-1.1.2.tgz";
        sha1 = "bdfa735299664dfafd34529ed4f8522a275fea56";
      };
    }
    {
      name = "entities___entities_2.2.0.tgz";
      path = fetchurl {
        name = "entities___entities_2.2.0.tgz";
        url = "https://registry.yarnpkg.com/entities/-/entities-2.2.0.tgz";
        sha1 = "098dc90ebb83d8dffa089d55256b351d34c4da55";
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
        url = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    }
    {
      name = "esprima___esprima_2.7.3.tgz";
      path = fetchurl {
        name = "esprima___esprima_2.7.3.tgz";
        url = "https://registry.yarnpkg.com/esprima/-/esprima-2.7.3.tgz";
        sha1 = "96e3b70d5779f6ad49cd032673d1c312767ba581";
      };
    }
    {
      name = "expand_brackets___expand_brackets_0.1.5.tgz";
      path = fetchurl {
        name = "expand_brackets___expand_brackets_0.1.5.tgz";
        url = "https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-0.1.5.tgz";
        sha1 = "df07284e342a807cd733ac5af72411e581d1177b";
      };
    }
    {
      name = "expand_brackets___expand_brackets_2.1.4.tgz";
      path = fetchurl {
        name = "expand_brackets___expand_brackets_2.1.4.tgz";
        url = "https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz";
        sha1 = "b77735e315ce30f6b6eff0f83b04151a22449622";
      };
    }
    {
      name = "expand_range___expand_range_1.8.2.tgz";
      path = fetchurl {
        name = "expand_range___expand_range_1.8.2.tgz";
        url = "https://registry.yarnpkg.com/expand-range/-/expand-range-1.8.2.tgz";
        sha1 = "a299effd335fe2721ebae8e257ec79644fc85337";
      };
    }
    {
      name = "expand_tilde___expand_tilde_2.0.2.tgz";
      path = fetchurl {
        name = "expand_tilde___expand_tilde_2.0.2.tgz";
        url = "https://registry.yarnpkg.com/expand-tilde/-/expand-tilde-2.0.2.tgz";
        sha1 = "97e801aa052df02454de46b02bf621642cdc8502";
      };
    }
    {
      name = "extend_shallow___extend_shallow_1.1.4.tgz";
      path = fetchurl {
        name = "extend_shallow___extend_shallow_1.1.4.tgz";
        url = "https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-1.1.4.tgz";
        sha1 = "19d6bf94dfc09d76ba711f39b872d21ff4dd9071";
      };
    }
    {
      name = "extend_shallow___extend_shallow_2.0.1.tgz";
      path = fetchurl {
        name = "extend_shallow___extend_shallow_2.0.1.tgz";
        url = "https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz";
        sha1 = "51af7d614ad9a9f610ea1bafbb989d6b1c56890f";
      };
    }
    {
      name = "extend_shallow___extend_shallow_3.0.2.tgz";
      path = fetchurl {
        name = "extend_shallow___extend_shallow_3.0.2.tgz";
        url = "https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz";
        sha1 = "26a71aaf073b39fb2127172746131c2704028db8";
      };
    }
    {
      name = "extend___extend_3.0.2.tgz";
      path = fetchurl {
        name = "extend___extend_3.0.2.tgz";
        url = "https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz";
        sha1 = "f8b1136b4071fbd8eb140aff858b1019ec2915fa";
      };
    }
    {
      name = "extglob___extglob_0.3.2.tgz";
      path = fetchurl {
        name = "extglob___extglob_0.3.2.tgz";
        url = "https://registry.yarnpkg.com/extglob/-/extglob-0.3.2.tgz";
        sha1 = "2e18ff3d2f49ab2765cec9023f011daa8d8349a1";
      };
    }
    {
      name = "extglob___extglob_2.0.4.tgz";
      path = fetchurl {
        name = "extglob___extglob_2.0.4.tgz";
        url = "https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz";
        sha1 = "ad00fe4dc612a9232e8718711dc5cb5ab0285543";
      };
    }
    {
      name = "fancy_log___fancy_log_1.3.3.tgz";
      path = fetchurl {
        name = "fancy_log___fancy_log_1.3.3.tgz";
        url = "https://registry.yarnpkg.com/fancy-log/-/fancy-log-1.3.3.tgz";
        sha1 = "dbc19154f558690150a23953a0adbd035be45fc7";
      };
    }
    {
      name = "file_uri_to_path___file_uri_to_path_1.0.0.tgz";
      path = fetchurl {
        name = "file_uri_to_path___file_uri_to_path_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz";
        sha1 = "553a7b8446ff6f684359c445f1e37a05dacc33dd";
      };
    }
    {
      name = "filename_regex___filename_regex_2.0.1.tgz";
      path = fetchurl {
        name = "filename_regex___filename_regex_2.0.1.tgz";
        url = "https://registry.yarnpkg.com/filename-regex/-/filename-regex-2.0.1.tgz";
        sha1 = "c1c4b9bee3e09725ddb106b75c1e301fe2f18b26";
      };
    }
    {
      name = "fill_range___fill_range_2.2.4.tgz";
      path = fetchurl {
        name = "fill_range___fill_range_2.2.4.tgz";
        url = "https://registry.yarnpkg.com/fill-range/-/fill-range-2.2.4.tgz";
        sha1 = "eb1e773abb056dcd8df2bfdf6af59b8b3a936565";
      };
    }
    {
      name = "fill_range___fill_range_4.0.0.tgz";
      path = fetchurl {
        name = "fill_range___fill_range_4.0.0.tgz";
        url = "https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz";
        sha1 = "d544811d428f98eb06a63dc402d2403c328c38f7";
      };
    }
    {
      name = "find_index___find_index_0.1.1.tgz";
      path = fetchurl {
        name = "find_index___find_index_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/find-index/-/find-index-0.1.1.tgz";
        sha1 = "675d358b2ca3892d795a1ab47232f8b6e2e0dde4";
      };
    }
    {
      name = "findup_sync___findup_sync_2.0.0.tgz";
      path = fetchurl {
        name = "findup_sync___findup_sync_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/findup-sync/-/findup-sync-2.0.0.tgz";
        sha1 = "9326b1488c22d1a6088650a86901b2d9a90a2cbc";
      };
    }
    {
      name = "fined___fined_1.2.0.tgz";
      path = fetchurl {
        name = "fined___fined_1.2.0.tgz";
        url = "https://registry.yarnpkg.com/fined/-/fined-1.2.0.tgz";
        sha1 = "d00beccf1aa2b475d16d423b0238b713a2c4a37b";
      };
    }
    {
      name = "first_chunk_stream___first_chunk_stream_1.0.0.tgz";
      path = fetchurl {
        name = "first_chunk_stream___first_chunk_stream_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/first-chunk-stream/-/first-chunk-stream-1.0.0.tgz";
        sha1 = "59bfb50cd905f60d7c394cd3d9acaab4e6ad934e";
      };
    }
    {
      name = "first_chunk_stream___first_chunk_stream_2.0.0.tgz";
      path = fetchurl {
        name = "first_chunk_stream___first_chunk_stream_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/first-chunk-stream/-/first-chunk-stream-2.0.0.tgz";
        sha1 = "1bdecdb8e083c0664b91945581577a43a9f31d70";
      };
    }
    {
      name = "flagged_respawn___flagged_respawn_1.0.1.tgz";
      path = fetchurl {
        name = "flagged_respawn___flagged_respawn_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/flagged-respawn/-/flagged-respawn-1.0.1.tgz";
        sha1 = "e7de6f1279ddd9ca9aac8a5971d618606b3aab41";
      };
    }
    {
      name = "for_in___for_in_1.0.2.tgz";
      path = fetchurl {
        name = "for_in___for_in_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz";
        sha1 = "81068d295a8142ec0ac726c6e2200c30fb6d5e80";
      };
    }
    {
      name = "for_own___for_own_0.1.5.tgz";
      path = fetchurl {
        name = "for_own___for_own_0.1.5.tgz";
        url = "https://registry.yarnpkg.com/for-own/-/for-own-0.1.5.tgz";
        sha1 = "5265c681a4f294dabbf17c9509b6763aa84510ce";
      };
    }
    {
      name = "for_own___for_own_1.0.0.tgz";
      path = fetchurl {
        name = "for_own___for_own_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/for-own/-/for-own-1.0.0.tgz";
        sha1 = "c63332f415cedc4b04dbfe70cf836494c53cb44b";
      };
    }
    {
      name = "fragment_cache___fragment_cache_0.2.1.tgz";
      path = fetchurl {
        name = "fragment_cache___fragment_cache_0.2.1.tgz";
        url = "https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz";
        sha1 = "4290fad27f13e89be7f33799c6bc5a0abfff0d19";
      };
    }
    {
      name = "fsevents___fsevents_1.2.13.tgz";
      path = fetchurl {
        name = "fsevents___fsevents_1.2.13.tgz";
        url = "https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.13.tgz";
        sha1 = "f325cb0455592428bcf11b383370ef70e3bfcc38";
      };
    }
    {
      name = "function_bind___function_bind_1.1.1.tgz";
      path = fetchurl {
        name = "function_bind___function_bind_1.1.1.tgz";
        url = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
        sha1 = "a56899d3ea3c9bab874bb9773b7c5ede92f4895d";
      };
    }
    {
      name = "gaze___gaze_0.5.2.tgz";
      path = fetchurl {
        name = "gaze___gaze_0.5.2.tgz";
        url = "https://registry.yarnpkg.com/gaze/-/gaze-0.5.2.tgz";
        sha1 = "40b709537d24d1d45767db5a908689dfe69ac44f";
      };
    }
    {
      name = "get_value___get_value_2.0.6.tgz";
      path = fetchurl {
        name = "get_value___get_value_2.0.6.tgz";
        url = "https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz";
        sha1 = "dc15ca1c672387ca76bd37ac0a395ba2042a2c28";
      };
    }
    {
      name = "glob_base___glob_base_0.3.0.tgz";
      path = fetchurl {
        name = "glob_base___glob_base_0.3.0.tgz";
        url = "https://registry.yarnpkg.com/glob-base/-/glob-base-0.3.0.tgz";
        sha1 = "dbb164f6221b1c0b1ccf82aea328b497df0ea3c4";
      };
    }
    {
      name = "glob_parent___glob_parent_2.0.0.tgz";
      path = fetchurl {
        name = "glob_parent___glob_parent_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-2.0.0.tgz";
        sha1 = "81383d72db054fcccf5336daa902f182f6edbb28";
      };
    }
    {
      name = "glob_parent___glob_parent_3.1.0.tgz";
      path = fetchurl {
        name = "glob_parent___glob_parent_3.1.0.tgz";
        url = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz";
        sha1 = "9e6af6299d8d3bd2bd40430832bd113df906c5ae";
      };
    }
    {
      name = "glob_stream___glob_stream_3.1.18.tgz";
      path = fetchurl {
        name = "glob_stream___glob_stream_3.1.18.tgz";
        url = "https://registry.yarnpkg.com/glob-stream/-/glob-stream-3.1.18.tgz";
        sha1 = "9170a5f12b790306fdfe598f313f8f7954fd143b";
      };
    }
    {
      name = "glob_watcher___glob_watcher_0.0.6.tgz";
      path = fetchurl {
        name = "glob_watcher___glob_watcher_0.0.6.tgz";
        url = "https://registry.yarnpkg.com/glob-watcher/-/glob-watcher-0.0.6.tgz";
        sha1 = "b95b4a8df74b39c83298b0c05c978b4d9a3b710b";
      };
    }
    {
      name = "glob2base___glob2base_0.0.12.tgz";
      path = fetchurl {
        name = "glob2base___glob2base_0.0.12.tgz";
        url = "https://registry.yarnpkg.com/glob2base/-/glob2base-0.0.12.tgz";
        sha1 = "9d419b3e28f12e83a362164a277055922c9c0d56";
      };
    }
    {
      name = "glob___glob_4.5.3.tgz";
      path = fetchurl {
        name = "glob___glob_4.5.3.tgz";
        url = "https://registry.yarnpkg.com/glob/-/glob-4.5.3.tgz";
        sha1 = "c6cb73d3226c1efef04de3c56d012f03377ee15f";
      };
    }
    {
      name = "glob___glob_3.1.21.tgz";
      path = fetchurl {
        name = "glob___glob_3.1.21.tgz";
        url = "https://registry.yarnpkg.com/glob/-/glob-3.1.21.tgz";
        sha1 = "d29e0a055dea5138f4d07ed40e8982e83c2066cd";
      };
    }
    {
      name = "global_modules___global_modules_1.0.0.tgz";
      path = fetchurl {
        name = "global_modules___global_modules_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/global-modules/-/global-modules-1.0.0.tgz";
        sha1 = "6d770f0eb523ac78164d72b5e71a8877265cc3ea";
      };
    }
    {
      name = "global_prefix___global_prefix_1.0.2.tgz";
      path = fetchurl {
        name = "global_prefix___global_prefix_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/global-prefix/-/global-prefix-1.0.2.tgz";
        sha1 = "dbf743c6c14992593c655568cb66ed32c0122ebe";
      };
    }
    {
      name = "globule___globule_0.1.0.tgz";
      path = fetchurl {
        name = "globule___globule_0.1.0.tgz";
        url = "https://registry.yarnpkg.com/globule/-/globule-0.1.0.tgz";
        sha1 = "d9c8edde1da79d125a151b79533b978676346ae5";
      };
    }
    {
      name = "glogg___glogg_1.0.2.tgz";
      path = fetchurl {
        name = "glogg___glogg_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/glogg/-/glogg-1.0.2.tgz";
        sha1 = "2d7dd702beda22eb3bffadf880696da6d846313f";
      };
    }
    {
      name = "graceful_fs___graceful_fs_3.0.12.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_3.0.12.tgz";
        url = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-3.0.12.tgz";
        sha1 = "0034947ce9ed695ec8ab0b854bc919e82b1ffaef";
      };
    }
    {
      name = "graceful_fs___graceful_fs_4.2.8.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.8.tgz";
        url = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.8.tgz";
        sha1 = "e412b8d33f5e006593cbd3cee6df9f2cebbe802a";
      };
    }
    {
      name = "graceful_fs___graceful_fs_1.2.3.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_1.2.3.tgz";
        url = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      };
    }
    {
      name = "gulp_cheerio___gulp_cheerio_0.6.3.tgz";
      path = fetchurl {
        name = "gulp_cheerio___gulp_cheerio_0.6.3.tgz";
        url = "https://registry.yarnpkg.com/gulp-cheerio/-/gulp-cheerio-0.6.3.tgz";
        sha1 = "40271c1703368c88408ab8750ba9bf3e1aea9c68";
      };
    }
    {
      name = "gulp_rename___gulp_rename_1.4.0.tgz";
      path = fetchurl {
        name = "gulp_rename___gulp_rename_1.4.0.tgz";
        url = "https://registry.yarnpkg.com/gulp-rename/-/gulp-rename-1.4.0.tgz";
        sha1 = "de1c718e7c4095ae861f7296ef4f3248648240bd";
      };
    }
    {
      name = "gulp_svgmin___gulp_svgmin_1.2.4.tgz";
      path = fetchurl {
        name = "gulp_svgmin___gulp_svgmin_1.2.4.tgz";
        url = "https://registry.yarnpkg.com/gulp-svgmin/-/gulp-svgmin-1.2.4.tgz";
        sha1 = "a4aa9e2615cf1105ef555aea86e86296cc20e273";
      };
    }
    {
      name = "gulp_svgstore___gulp_svgstore_5.0.5.tgz";
      path = fetchurl {
        name = "gulp_svgstore___gulp_svgstore_5.0.5.tgz";
        url = "https://registry.yarnpkg.com/gulp-svgstore/-/gulp-svgstore-5.0.5.tgz";
        sha1 = "4ad5cec5d753a1624a00e49cef5fc86a45d97327";
      };
    }
    {
      name = "gulp_util___gulp_util_3.0.8.tgz";
      path = fetchurl {
        name = "gulp_util___gulp_util_3.0.8.tgz";
        url = "https://registry.yarnpkg.com/gulp-util/-/gulp-util-3.0.8.tgz";
        sha1 = "0054e1e744502e27c04c187c3ecc505dd54bbb4f";
      };
    }
    {
      name = "gulp_watch___gulp_watch_4.3.11.tgz";
      path = fetchurl {
        name = "gulp_watch___gulp_watch_4.3.11.tgz";
        url = "https://registry.yarnpkg.com/gulp-watch/-/gulp-watch-4.3.11.tgz";
        sha1 = "162fc563de9fc770e91f9a7ce3955513a9a118c0";
      };
    }
    {
      name = "gulp___gulp_3.9.1.tgz";
      path = fetchurl {
        name = "gulp___gulp_3.9.1.tgz";
        url = "https://registry.yarnpkg.com/gulp/-/gulp-3.9.1.tgz";
        sha1 = "571ce45928dd40af6514fc4011866016c13845b4";
      };
    }
    {
      name = "gulplog___gulplog_1.0.0.tgz";
      path = fetchurl {
        name = "gulplog___gulplog_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/gulplog/-/gulplog-1.0.0.tgz";
        sha1 = "e28c4d45d05ecbbed818363ce8f9c5926229ffe5";
      };
    }
    {
      name = "has_ansi___has_ansi_2.0.0.tgz";
      path = fetchurl {
        name = "has_ansi___has_ansi_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
    }
    {
      name = "has_gulplog___has_gulplog_0.1.0.tgz";
      path = fetchurl {
        name = "has_gulplog___has_gulplog_0.1.0.tgz";
        url = "https://registry.yarnpkg.com/has-gulplog/-/has-gulplog-0.1.0.tgz";
        sha1 = "6414c82913697da51590397dafb12f22967811ce";
      };
    }
    {
      name = "has_value___has_value_0.3.1.tgz";
      path = fetchurl {
        name = "has_value___has_value_0.3.1.tgz";
        url = "https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz";
        sha1 = "7b1f58bada62ca827ec0a2078025654845995e1f";
      };
    }
    {
      name = "has_value___has_value_1.0.0.tgz";
      path = fetchurl {
        name = "has_value___has_value_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz";
        sha1 = "18b281da585b1c5c51def24c930ed29a0be6b177";
      };
    }
    {
      name = "has_values___has_values_0.1.4.tgz";
      path = fetchurl {
        name = "has_values___has_values_0.1.4.tgz";
        url = "https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz";
        sha1 = "6d61de95d91dfca9b9a02089ad384bff8f62b771";
      };
    }
    {
      name = "has_values___has_values_1.0.0.tgz";
      path = fetchurl {
        name = "has_values___has_values_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz";
        sha1 = "95b0b63fec2146619a6fe57fe75628d5a39efe4f";
      };
    }
    {
      name = "has___has_1.0.3.tgz";
      path = fetchurl {
        name = "has___has_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/has/-/has-1.0.3.tgz";
        sha1 = "722d7cbfc1f6aa8241f16dd814e011e1f41e8796";
      };
    }
    {
      name = "homedir_polyfill___homedir_polyfill_1.0.3.tgz";
      path = fetchurl {
        name = "homedir_polyfill___homedir_polyfill_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz";
        sha1 = "743298cef4e5af3e194161fbadcc2151d3a058e8";
      };
    }
    {
      name = "htmlparser2___htmlparser2_3.10.1.tgz";
      path = fetchurl {
        name = "htmlparser2___htmlparser2_3.10.1.tgz";
        url = "https://registry.yarnpkg.com/htmlparser2/-/htmlparser2-3.10.1.tgz";
        sha1 = "bd679dc3f59897b6a34bb10749c855bb53a9392f";
      };
    }
    {
      name = "inflight___inflight_1.0.6.tgz";
      path = fetchurl {
        name = "inflight___inflight_1.0.6.tgz";
        url = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    }
    {
      name = "inherits___inherits_1.0.2.tgz";
      path = fetchurl {
        name = "inherits___inherits_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/inherits/-/inherits-1.0.2.tgz";
        sha1 = "ca4309dadee6b54cc0b8d247e8d7c7a0975bdc9b";
      };
    }
    {
      name = "inherits___inherits_2.0.4.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.4.tgz";
        url = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz";
        sha1 = "0fa2c64f932917c3433a0ded55363aae37416b7c";
      };
    }
    {
      name = "ini___ini_1.3.8.tgz";
      path = fetchurl {
        name = "ini___ini_1.3.8.tgz";
        url = "https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz";
        sha1 = "a29da425b48806f34767a4efce397269af28432c";
      };
    }
    {
      name = "interpret___interpret_1.4.0.tgz";
      path = fetchurl {
        name = "interpret___interpret_1.4.0.tgz";
        url = "https://registry.yarnpkg.com/interpret/-/interpret-1.4.0.tgz";
        sha1 = "665ab8bc4da27a774a40584e812e3e0fa45b1a1e";
      };
    }
    {
      name = "is_absolute___is_absolute_1.0.0.tgz";
      path = fetchurl {
        name = "is_absolute___is_absolute_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-absolute/-/is-absolute-1.0.0.tgz";
        sha1 = "395e1ae84b11f26ad1795e73c17378e48a301576";
      };
    }
    {
      name = "is_accessor_descriptor___is_accessor_descriptor_0.1.6.tgz";
      path = fetchurl {
        name = "is_accessor_descriptor___is_accessor_descriptor_0.1.6.tgz";
        url = "https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz";
        sha1 = "a9e12cb3ae8d876727eeef3843f8a0897b5c98d6";
      };
    }
    {
      name = "is_accessor_descriptor___is_accessor_descriptor_1.0.0.tgz";
      path = fetchurl {
        name = "is_accessor_descriptor___is_accessor_descriptor_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz";
        sha1 = "169c2f6d3df1f992618072365c9b0ea1f6878656";
      };
    }
    {
      name = "is_binary_path___is_binary_path_1.0.1.tgz";
      path = fetchurl {
        name = "is_binary_path___is_binary_path_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz";
        sha1 = "75f16642b480f187a711c814161fd3a4a7655898";
      };
    }
    {
      name = "is_buffer___is_buffer_1.1.6.tgz";
      path = fetchurl {
        name = "is_buffer___is_buffer_1.1.6.tgz";
        url = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz";
        sha1 = "efaa2ea9daa0d7ab2ea13a97b2b8ad51fefbe8be";
      };
    }
    {
      name = "is_core_module___is_core_module_2.8.0.tgz";
      path = fetchurl {
        name = "is_core_module___is_core_module_2.8.0.tgz";
        url = "https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.8.0.tgz";
        sha1 = "0321336c3d0925e497fd97f5d95cb114a5ccd548";
      };
    }
    {
      name = "is_data_descriptor___is_data_descriptor_0.1.4.tgz";
      path = fetchurl {
        name = "is_data_descriptor___is_data_descriptor_0.1.4.tgz";
        url = "https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz";
        sha1 = "0b5ee648388e2c860282e793f1856fec3f301b56";
      };
    }
    {
      name = "is_data_descriptor___is_data_descriptor_1.0.0.tgz";
      path = fetchurl {
        name = "is_data_descriptor___is_data_descriptor_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz";
        sha1 = "d84876321d0e7add03990406abbbbd36ba9268c7";
      };
    }
    {
      name = "is_descriptor___is_descriptor_0.1.6.tgz";
      path = fetchurl {
        name = "is_descriptor___is_descriptor_0.1.6.tgz";
        url = "https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz";
        sha1 = "366d8240dde487ca51823b1ab9f07a10a78251ca";
      };
    }
    {
      name = "is_descriptor___is_descriptor_1.0.2.tgz";
      path = fetchurl {
        name = "is_descriptor___is_descriptor_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz";
        sha1 = "3b159746a66604b04f8c81524ba365c5f14d86ec";
      };
    }
    {
      name = "is_dotfile___is_dotfile_1.0.3.tgz";
      path = fetchurl {
        name = "is_dotfile___is_dotfile_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/is-dotfile/-/is-dotfile-1.0.3.tgz";
        sha1 = "a6a2f32ffd2dfb04f5ca25ecd0f6b83cf798a1e1";
      };
    }
    {
      name = "is_equal_shallow___is_equal_shallow_0.1.3.tgz";
      path = fetchurl {
        name = "is_equal_shallow___is_equal_shallow_0.1.3.tgz";
        url = "https://registry.yarnpkg.com/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz";
        sha1 = "2238098fc221de0bcfa5d9eac4c45d638aa1c534";
      };
    }
    {
      name = "is_extendable___is_extendable_0.1.1.tgz";
      path = fetchurl {
        name = "is_extendable___is_extendable_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz";
        sha1 = "62b110e289a471418e3ec36a617d472e301dfc89";
      };
    }
    {
      name = "is_extendable___is_extendable_1.0.1.tgz";
      path = fetchurl {
        name = "is_extendable___is_extendable_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz";
        sha1 = "a7470f9e426733d81bd81e1155264e3a3507cab4";
      };
    }
    {
      name = "is_extglob___is_extglob_1.0.0.tgz";
      path = fetchurl {
        name = "is_extglob___is_extglob_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-1.0.0.tgz";
        sha1 = "ac468177c4943405a092fc8f29760c6ffc6206c0";
      };
    }
    {
      name = "is_extglob___is_extglob_2.1.1.tgz";
      path = fetchurl {
        name = "is_extglob___is_extglob_2.1.1.tgz";
        url = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz";
        sha1 = "a88c02535791f02ed37c76a1b9ea9773c833f8c2";
      };
    }
    {
      name = "is_glob___is_glob_2.0.1.tgz";
      path = fetchurl {
        name = "is_glob___is_glob_2.0.1.tgz";
        url = "https://registry.yarnpkg.com/is-glob/-/is-glob-2.0.1.tgz";
        sha1 = "d096f926a3ded5600f3fdfd91198cb0888c2d863";
      };
    }
    {
      name = "is_glob___is_glob_3.1.0.tgz";
      path = fetchurl {
        name = "is_glob___is_glob_3.1.0.tgz";
        url = "https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz";
        sha1 = "7ba5ae24217804ac70707b96922567486cc3e84a";
      };
    }
    {
      name = "is_number___is_number_2.1.0.tgz";
      path = fetchurl {
        name = "is_number___is_number_2.1.0.tgz";
        url = "https://registry.yarnpkg.com/is-number/-/is-number-2.1.0.tgz";
        sha1 = "01fcbbb393463a548f2f466cce16dece49db908f";
      };
    }
    {
      name = "is_number___is_number_3.0.0.tgz";
      path = fetchurl {
        name = "is_number___is_number_3.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz";
        sha1 = "24fd6201a4782cf50561c810276afc7d12d71195";
      };
    }
    {
      name = "is_number___is_number_4.0.0.tgz";
      path = fetchurl {
        name = "is_number___is_number_4.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-number/-/is-number-4.0.0.tgz";
        sha1 = "0026e37f5454d73e356dfe6564699867c6a7f0ff";
      };
    }
    {
      name = "is_plain_object___is_plain_object_2.0.4.tgz";
      path = fetchurl {
        name = "is_plain_object___is_plain_object_2.0.4.tgz";
        url = "https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz";
        sha1 = "2c163b3fafb1b606d9d17928f05c2a1c38e07677";
      };
    }
    {
      name = "is_posix_bracket___is_posix_bracket_0.1.1.tgz";
      path = fetchurl {
        name = "is_posix_bracket___is_posix_bracket_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz";
        sha1 = "3334dc79774368e92f016e6fbc0a88f5cd6e6bc4";
      };
    }
    {
      name = "is_primitive___is_primitive_2.0.0.tgz";
      path = fetchurl {
        name = "is_primitive___is_primitive_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-primitive/-/is-primitive-2.0.0.tgz";
        sha1 = "207bab91638499c07b2adf240a41a87210034575";
      };
    }
    {
      name = "is_relative___is_relative_1.0.0.tgz";
      path = fetchurl {
        name = "is_relative___is_relative_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-relative/-/is-relative-1.0.0.tgz";
        sha1 = "a1bb6935ce8c5dba1e8b9754b9b2dcc020e2260d";
      };
    }
    {
      name = "is_unc_path___is_unc_path_1.0.0.tgz";
      path = fetchurl {
        name = "is_unc_path___is_unc_path_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/is-unc-path/-/is-unc-path-1.0.0.tgz";
        sha1 = "d731e8898ed090a12c352ad2eaed5095ad322c9d";
      };
    }
    {
      name = "is_utf8___is_utf8_0.2.1.tgz";
      path = fetchurl {
        name = "is_utf8___is_utf8_0.2.1.tgz";
        url = "https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz";
        sha1 = "4b0da1442104d1b336340e80797e865cf39f7d72";
      };
    }
    {
      name = "is_windows___is_windows_1.0.2.tgz";
      path = fetchurl {
        name = "is_windows___is_windows_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz";
        sha1 = "d1850eb9791ecd18e6182ce12a30f396634bb19d";
      };
    }
    {
      name = "isarray___isarray_0.0.1.tgz";
      path = fetchurl {
        name = "isarray___isarray_0.0.1.tgz";
        url = "https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      };
    }
    {
      name = "isarray___isarray_1.0.0.tgz";
      path = fetchurl {
        name = "isarray___isarray_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    }
    {
      name = "isexe___isexe_2.0.0.tgz";
      path = fetchurl {
        name = "isexe___isexe_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
      };
    }
    {
      name = "isobject___isobject_2.1.0.tgz";
      path = fetchurl {
        name = "isobject___isobject_2.1.0.tgz";
        url = "https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz";
        sha1 = "f065561096a3f1da2ef46272f815c840d87e0c89";
      };
    }
    {
      name = "isobject___isobject_3.0.1.tgz";
      path = fetchurl {
        name = "isobject___isobject_3.0.1.tgz";
        url = "https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz";
        sha1 = "4e431e92b11a9731636aa1f9c8d1ccbcfdab78df";
      };
    }
    {
      name = "js_yaml___js_yaml_3.7.0.tgz";
      path = fetchurl {
        name = "js_yaml___js_yaml_3.7.0.tgz";
        url = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.7.0.tgz";
        sha1 = "5c967ddd837a9bfdca5f2de84253abe8a1c03b80";
      };
    }
    {
      name = "kind_of___kind_of_1.1.0.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/kind-of/-/kind-of-1.1.0.tgz";
        sha1 = "140a3d2d41a36d2efcfa9377b62c24f8495a5c44";
      };
    }
    {
      name = "kind_of___kind_of_3.2.2.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_3.2.2.tgz";
        url = "https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz";
        sha1 = "31ea21a734bab9bbb0f32466d893aea51e4a3c64";
      };
    }
    {
      name = "kind_of___kind_of_4.0.0.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_4.0.0.tgz";
        url = "https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz";
        sha1 = "20813df3d712928b207378691a45066fae72dd57";
      };
    }
    {
      name = "kind_of___kind_of_5.1.0.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_5.1.0.tgz";
        url = "https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz";
        sha1 = "729c91e2d857b7a419a1f9aa65685c4c33f5845d";
      };
    }
    {
      name = "kind_of___kind_of_6.0.3.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_6.0.3.tgz";
        url = "https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz";
        sha1 = "07c05034a6c349fa06e24fa35aa76db4580ce4dd";
      };
    }
    {
      name = "liftoff___liftoff_2.5.0.tgz";
      path = fetchurl {
        name = "liftoff___liftoff_2.5.0.tgz";
        url = "https://registry.yarnpkg.com/liftoff/-/liftoff-2.5.0.tgz";
        sha1 = "2009291bb31cea861bbf10a7c15a28caf75c31ec";
      };
    }
    {
      name = "lodash._basecopy___lodash._basecopy_3.0.1.tgz";
      path = fetchurl {
        name = "lodash._basecopy___lodash._basecopy_3.0.1.tgz";
        url = "https://registry.yarnpkg.com/lodash._basecopy/-/lodash._basecopy-3.0.1.tgz";
        sha1 = "8da0e6a876cf344c0ad8a54882111dd3c5c7ca36";
      };
    }
    {
      name = "lodash._basetostring___lodash._basetostring_3.0.1.tgz";
      path = fetchurl {
        name = "lodash._basetostring___lodash._basetostring_3.0.1.tgz";
        url = "https://registry.yarnpkg.com/lodash._basetostring/-/lodash._basetostring-3.0.1.tgz";
        sha1 = "d1861d877f824a52f669832dcaf3ee15566a07d5";
      };
    }
    {
      name = "lodash._basevalues___lodash._basevalues_3.0.0.tgz";
      path = fetchurl {
        name = "lodash._basevalues___lodash._basevalues_3.0.0.tgz";
        url = "https://registry.yarnpkg.com/lodash._basevalues/-/lodash._basevalues-3.0.0.tgz";
        sha1 = "5b775762802bde3d3297503e26300820fdf661b7";
      };
    }
    {
      name = "lodash._getnative___lodash._getnative_3.9.1.tgz";
      path = fetchurl {
        name = "lodash._getnative___lodash._getnative_3.9.1.tgz";
        url = "https://registry.yarnpkg.com/lodash._getnative/-/lodash._getnative-3.9.1.tgz";
        sha1 = "570bc7dede46d61cdcde687d65d3eecbaa3aaff5";
      };
    }
    {
      name = "lodash._isiterateecall___lodash._isiterateecall_3.0.9.tgz";
      path = fetchurl {
        name = "lodash._isiterateecall___lodash._isiterateecall_3.0.9.tgz";
        url = "https://registry.yarnpkg.com/lodash._isiterateecall/-/lodash._isiterateecall-3.0.9.tgz";
        sha1 = "5203ad7ba425fae842460e696db9cf3e6aac057c";
      };
    }
    {
      name = "lodash._reescape___lodash._reescape_3.0.0.tgz";
      path = fetchurl {
        name = "lodash._reescape___lodash._reescape_3.0.0.tgz";
        url = "https://registry.yarnpkg.com/lodash._reescape/-/lodash._reescape-3.0.0.tgz";
        sha1 = "2b1d6f5dfe07c8a355753e5f27fac7f1cde1616a";
      };
    }
    {
      name = "lodash._reevaluate___lodash._reevaluate_3.0.0.tgz";
      path = fetchurl {
        name = "lodash._reevaluate___lodash._reevaluate_3.0.0.tgz";
        url = "https://registry.yarnpkg.com/lodash._reevaluate/-/lodash._reevaluate-3.0.0.tgz";
        sha1 = "58bc74c40664953ae0b124d806996daca431e2ed";
      };
    }
    {
      name = "lodash._reinterpolate___lodash._reinterpolate_3.0.0.tgz";
      path = fetchurl {
        name = "lodash._reinterpolate___lodash._reinterpolate_3.0.0.tgz";
        url = "https://registry.yarnpkg.com/lodash._reinterpolate/-/lodash._reinterpolate-3.0.0.tgz";
        sha1 = "0ccf2d89166af03b3663c796538b75ac6e114d9d";
      };
    }
    {
      name = "lodash._root___lodash._root_3.0.1.tgz";
      path = fetchurl {
        name = "lodash._root___lodash._root_3.0.1.tgz";
        url = "https://registry.yarnpkg.com/lodash._root/-/lodash._root-3.0.1.tgz";
        sha1 = "fba1c4524c19ee9a5f8136b4609f017cf4ded692";
      };
    }
    {
      name = "lodash.assignin___lodash.assignin_4.2.0.tgz";
      path = fetchurl {
        name = "lodash.assignin___lodash.assignin_4.2.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.assignin/-/lodash.assignin-4.2.0.tgz";
        sha1 = "ba8df5fb841eb0a3e8044232b0e263a8dc6a28a2";
      };
    }
    {
      name = "lodash.bind___lodash.bind_4.2.1.tgz";
      path = fetchurl {
        name = "lodash.bind___lodash.bind_4.2.1.tgz";
        url = "https://registry.yarnpkg.com/lodash.bind/-/lodash.bind-4.2.1.tgz";
        sha1 = "7ae3017e939622ac31b7d7d7dcb1b34db1690d35";
      };
    }
    {
      name = "lodash.defaults___lodash.defaults_4.2.0.tgz";
      path = fetchurl {
        name = "lodash.defaults___lodash.defaults_4.2.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.defaults/-/lodash.defaults-4.2.0.tgz";
        sha1 = "d09178716ffea4dde9e5fb7b37f6f0802274580c";
      };
    }
    {
      name = "lodash.escape___lodash.escape_3.2.0.tgz";
      path = fetchurl {
        name = "lodash.escape___lodash.escape_3.2.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.escape/-/lodash.escape-3.2.0.tgz";
        sha1 = "995ee0dc18c1b48cc92effae71a10aab5b487698";
      };
    }
    {
      name = "lodash.filter___lodash.filter_4.6.0.tgz";
      path = fetchurl {
        name = "lodash.filter___lodash.filter_4.6.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.filter/-/lodash.filter-4.6.0.tgz";
        sha1 = "668b1d4981603ae1cc5a6fa760143e480b4c4ace";
      };
    }
    {
      name = "lodash.flatten___lodash.flatten_4.4.0.tgz";
      path = fetchurl {
        name = "lodash.flatten___lodash.flatten_4.4.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.flatten/-/lodash.flatten-4.4.0.tgz";
        sha1 = "f31c22225a9632d2bbf8e4addbef240aa765a61f";
      };
    }
    {
      name = "lodash.foreach___lodash.foreach_4.5.0.tgz";
      path = fetchurl {
        name = "lodash.foreach___lodash.foreach_4.5.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.foreach/-/lodash.foreach-4.5.0.tgz";
        sha1 = "1a6a35eace401280c7f06dddec35165ab27e3e53";
      };
    }
    {
      name = "lodash.isarguments___lodash.isarguments_3.1.0.tgz";
      path = fetchurl {
        name = "lodash.isarguments___lodash.isarguments_3.1.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.isarguments/-/lodash.isarguments-3.1.0.tgz";
        sha1 = "2f573d85c6a24289ff00663b491c1d338ff3458a";
      };
    }
    {
      name = "lodash.isarray___lodash.isarray_3.0.4.tgz";
      path = fetchurl {
        name = "lodash.isarray___lodash.isarray_3.0.4.tgz";
        url = "https://registry.yarnpkg.com/lodash.isarray/-/lodash.isarray-3.0.4.tgz";
        sha1 = "79e4eb88c36a8122af86f844aa9bcd851b5fbb55";
      };
    }
    {
      name = "lodash.keys___lodash.keys_3.1.2.tgz";
      path = fetchurl {
        name = "lodash.keys___lodash.keys_3.1.2.tgz";
        url = "https://registry.yarnpkg.com/lodash.keys/-/lodash.keys-3.1.2.tgz";
        sha1 = "4dbc0472b156be50a0b286855d1bd0b0c656098a";
      };
    }
    {
      name = "lodash.map___lodash.map_4.6.0.tgz";
      path = fetchurl {
        name = "lodash.map___lodash.map_4.6.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.map/-/lodash.map-4.6.0.tgz";
        sha1 = "771ec7839e3473d9c4cde28b19394c3562f4f6d3";
      };
    }
    {
      name = "lodash.merge___lodash.merge_4.6.2.tgz";
      path = fetchurl {
        name = "lodash.merge___lodash.merge_4.6.2.tgz";
        url = "https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz";
        sha1 = "558aa53b43b661e1925a0afdfa36a9a1085fe57a";
      };
    }
    {
      name = "lodash.pick___lodash.pick_4.4.0.tgz";
      path = fetchurl {
        name = "lodash.pick___lodash.pick_4.4.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.pick/-/lodash.pick-4.4.0.tgz";
        sha1 = "52f05610fff9ded422611441ed1fc123a03001b3";
      };
    }
    {
      name = "lodash.reduce___lodash.reduce_4.6.0.tgz";
      path = fetchurl {
        name = "lodash.reduce___lodash.reduce_4.6.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.reduce/-/lodash.reduce-4.6.0.tgz";
        sha1 = "f1ab6b839299ad48f784abbf476596f03b914d3b";
      };
    }
    {
      name = "lodash.reject___lodash.reject_4.6.0.tgz";
      path = fetchurl {
        name = "lodash.reject___lodash.reject_4.6.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.reject/-/lodash.reject-4.6.0.tgz";
        sha1 = "80d6492dc1470864bbf583533b651f42a9f52415";
      };
    }
    {
      name = "lodash.restparam___lodash.restparam_3.6.1.tgz";
      path = fetchurl {
        name = "lodash.restparam___lodash.restparam_3.6.1.tgz";
        url = "https://registry.yarnpkg.com/lodash.restparam/-/lodash.restparam-3.6.1.tgz";
        sha1 = "936a4e309ef330a7645ed4145986c85ae5b20805";
      };
    }
    {
      name = "lodash.some___lodash.some_4.6.0.tgz";
      path = fetchurl {
        name = "lodash.some___lodash.some_4.6.0.tgz";
        url = "https://registry.yarnpkg.com/lodash.some/-/lodash.some-4.6.0.tgz";
        sha1 = "1bb9f314ef6b8baded13b549169b2a945eb68e4d";
      };
    }
    {
      name = "lodash.template___lodash.template_3.6.2.tgz";
      path = fetchurl {
        name = "lodash.template___lodash.template_3.6.2.tgz";
        url = "https://registry.yarnpkg.com/lodash.template/-/lodash.template-3.6.2.tgz";
        sha1 = "f8cdecc6169a255be9098ae8b0c53d378931d14f";
      };
    }
    {
      name = "lodash.templatesettings___lodash.templatesettings_3.1.1.tgz";
      path = fetchurl {
        name = "lodash.templatesettings___lodash.templatesettings_3.1.1.tgz";
        url = "https://registry.yarnpkg.com/lodash.templatesettings/-/lodash.templatesettings-3.1.1.tgz";
        sha1 = "fb307844753b66b9f1afa54e262c745307dba8e5";
      };
    }
    {
      name = "lodash___lodash_1.0.2.tgz";
      path = fetchurl {
        name = "lodash___lodash_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/lodash/-/lodash-1.0.2.tgz";
        sha1 = "8f57560c83b59fc270bd3d561b690043430e2551";
      };
    }
    {
      name = "lru_cache___lru_cache_2.7.3.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_2.7.3.tgz";
        url = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-2.7.3.tgz";
        sha1 = "6d4524e8b955f95d4f5b58851ce21dd72fb4e952";
      };
    }
    {
      name = "make_iterator___make_iterator_1.0.1.tgz";
      path = fetchurl {
        name = "make_iterator___make_iterator_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/make-iterator/-/make-iterator-1.0.1.tgz";
        sha1 = "29b33f312aa8f547c4a5e490f56afcec99133ad6";
      };
    }
    {
      name = "map_cache___map_cache_0.2.2.tgz";
      path = fetchurl {
        name = "map_cache___map_cache_0.2.2.tgz";
        url = "https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz";
        sha1 = "c32abd0bd6525d9b051645bb4f26ac5dc98a0dbf";
      };
    }
    {
      name = "map_visit___map_visit_1.0.0.tgz";
      path = fetchurl {
        name = "map_visit___map_visit_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz";
        sha1 = "ecdca8f13144e660f1b5bd41f12f3479d98dfb8f";
      };
    }
    {
      name = "math_random___math_random_1.0.4.tgz";
      path = fetchurl {
        name = "math_random___math_random_1.0.4.tgz";
        url = "https://registry.yarnpkg.com/math-random/-/math-random-1.0.4.tgz";
        sha1 = "5dd6943c938548267016d4e34f057583080c514c";
      };
    }
    {
      name = "micromatch___micromatch_2.3.11.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_2.3.11.tgz";
        url = "https://registry.yarnpkg.com/micromatch/-/micromatch-2.3.11.tgz";
        sha1 = "86677c97d1720b363431d04d0d15293bd38c1565";
      };
    }
    {
      name = "micromatch___micromatch_3.1.10.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_3.1.10.tgz";
        url = "https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz";
        sha1 = "70859bc95c9840952f359a068a3fc49f9ecfac23";
      };
    }
    {
      name = "minimatch___minimatch_2.0.10.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_2.0.10.tgz";
        url = "https://registry.yarnpkg.com/minimatch/-/minimatch-2.0.10.tgz";
        sha1 = "8d087c39c6b38c001b97fca7ce6d0e1e80afbac7";
      };
    }
    {
      name = "minimatch___minimatch_0.2.14.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_0.2.14.tgz";
        url = "https://registry.yarnpkg.com/minimatch/-/minimatch-0.2.14.tgz";
        sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
      };
    }
    {
      name = "minimist___minimist_1.2.5.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.5.tgz";
        url = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.5.tgz";
        sha1 = "67d66014b66a6a8aaa0c083c5fd58df4e4e97602";
      };
    }
    {
      name = "mixin_deep___mixin_deep_1.3.2.tgz";
      path = fetchurl {
        name = "mixin_deep___mixin_deep_1.3.2.tgz";
        url = "https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.2.tgz";
        sha1 = "1120b43dc359a785dce65b55b82e257ccf479566";
      };
    }
    {
      name = "mkdirp___mkdirp_0.5.5.tgz";
      path = fetchurl {
        name = "mkdirp___mkdirp_0.5.5.tgz";
        url = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.5.tgz";
        sha1 = "d91cefd62d1436ca0f41620e251288d420099def";
      };
    }
    {
      name = "ms___ms_2.0.0.tgz";
      path = fetchurl {
        name = "ms___ms_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    }
    {
      name = "multipipe___multipipe_0.1.2.tgz";
      path = fetchurl {
        name = "multipipe___multipipe_0.1.2.tgz";
        url = "https://registry.yarnpkg.com/multipipe/-/multipipe-0.1.2.tgz";
        sha1 = "2a8f2ddf70eed564dff2d57f1e1a137d9f05078b";
      };
    }
    {
      name = "nan___nan_2.15.0.tgz";
      path = fetchurl {
        name = "nan___nan_2.15.0.tgz";
        url = "https://registry.yarnpkg.com/nan/-/nan-2.15.0.tgz";
        sha1 = "3f34a473ff18e15c1b5626b62903b5ad6e665fee";
      };
    }
    {
      name = "nanomatch___nanomatch_1.2.13.tgz";
      path = fetchurl {
        name = "nanomatch___nanomatch_1.2.13.tgz";
        url = "https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz";
        sha1 = "b87a8aa4fc0de8fe6be88895b38983ff265bd119";
      };
    }
    {
      name = "natives___natives_1.1.6.tgz";
      path = fetchurl {
        name = "natives___natives_1.1.6.tgz";
        url = "https://registry.yarnpkg.com/natives/-/natives-1.1.6.tgz";
        sha1 = "a603b4a498ab77173612b9ea1acdec4d980f00bb";
      };
    }
    {
      name = "normalize_path___normalize_path_2.1.1.tgz";
      path = fetchurl {
        name = "normalize_path___normalize_path_2.1.1.tgz";
        url = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz";
        sha1 = "1ab28b556e198363a8c1a6f7e6fa20137fe6aed9";
      };
    }
    {
      name = "nth_check___nth_check_1.0.2.tgz";
      path = fetchurl {
        name = "nth_check___nth_check_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/nth-check/-/nth-check-1.0.2.tgz";
        sha1 = "b2bd295c37e3dd58a3bf0700376663ba4d9cf05c";
      };
    }
    {
      name = "object_assign___object_assign_3.0.0.tgz";
      path = fetchurl {
        name = "object_assign___object_assign_3.0.0.tgz";
        url = "https://registry.yarnpkg.com/object-assign/-/object-assign-3.0.0.tgz";
        sha1 = "9bedd5ca0897949bca47e7ff408062d549f587f2";
      };
    }
    {
      name = "object_assign___object_assign_4.1.1.tgz";
      path = fetchurl {
        name = "object_assign___object_assign_4.1.1.tgz";
        url = "https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz";
        sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
      };
    }
    {
      name = "object_copy___object_copy_0.1.0.tgz";
      path = fetchurl {
        name = "object_copy___object_copy_0.1.0.tgz";
        url = "https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz";
        sha1 = "7e7d858b781bd7c991a41ba975ed3812754e998c";
      };
    }
    {
      name = "object_visit___object_visit_1.0.1.tgz";
      path = fetchurl {
        name = "object_visit___object_visit_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz";
        sha1 = "f79c4493af0c5377b59fe39d395e41042dd045bb";
      };
    }
    {
      name = "object.defaults___object.defaults_1.1.0.tgz";
      path = fetchurl {
        name = "object.defaults___object.defaults_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/object.defaults/-/object.defaults-1.1.0.tgz";
        sha1 = "3a7f868334b407dea06da16d88d5cd29e435fecf";
      };
    }
    {
      name = "object.map___object.map_1.0.1.tgz";
      path = fetchurl {
        name = "object.map___object.map_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/object.map/-/object.map-1.0.1.tgz";
        sha1 = "cf83e59dc8fcc0ad5f4250e1f78b3b81bd801d37";
      };
    }
    {
      name = "object.omit___object.omit_2.0.1.tgz";
      path = fetchurl {
        name = "object.omit___object.omit_2.0.1.tgz";
        url = "https://registry.yarnpkg.com/object.omit/-/object.omit-2.0.1.tgz";
        sha1 = "1a9c744829f39dbb858c76ca3579ae2a54ebd1fa";
      };
    }
    {
      name = "object.pick___object.pick_1.3.0.tgz";
      path = fetchurl {
        name = "object.pick___object.pick_1.3.0.tgz";
        url = "https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz";
        sha1 = "87a10ac4c1694bd2e1cbf53591a66141fb5dd747";
      };
    }
    {
      name = "once___once_1.4.0.tgz";
      path = fetchurl {
        name = "once___once_1.4.0.tgz";
        url = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    }
    {
      name = "once___once_1.3.3.tgz";
      path = fetchurl {
        name = "once___once_1.3.3.tgz";
        url = "https://registry.yarnpkg.com/once/-/once-1.3.3.tgz";
        sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
      };
    }
    {
      name = "orchestrator___orchestrator_0.3.8.tgz";
      path = fetchurl {
        name = "orchestrator___orchestrator_0.3.8.tgz";
        url = "https://registry.yarnpkg.com/orchestrator/-/orchestrator-0.3.8.tgz";
        sha1 = "14e7e9e2764f7315fbac184e506c7aa6df94ad7e";
      };
    }
    {
      name = "ordered_read_streams___ordered_read_streams_0.1.0.tgz";
      path = fetchurl {
        name = "ordered_read_streams___ordered_read_streams_0.1.0.tgz";
        url = "https://registry.yarnpkg.com/ordered-read-streams/-/ordered-read-streams-0.1.0.tgz";
        sha1 = "fd565a9af8eb4473ba69b6ed8a34352cb552f126";
      };
    }
    {
      name = "os_homedir___os_homedir_1.0.2.tgz";
      path = fetchurl {
        name = "os_homedir___os_homedir_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz";
        sha1 = "ffbc4988336e0e833de0c168c7ef152121aa7fb3";
      };
    }
    {
      name = "parse_filepath___parse_filepath_1.0.2.tgz";
      path = fetchurl {
        name = "parse_filepath___parse_filepath_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/parse-filepath/-/parse-filepath-1.0.2.tgz";
        sha1 = "a632127f53aaf3d15876f5872f3ffac763d6c891";
      };
    }
    {
      name = "parse_glob___parse_glob_3.0.4.tgz";
      path = fetchurl {
        name = "parse_glob___parse_glob_3.0.4.tgz";
        url = "https://registry.yarnpkg.com/parse-glob/-/parse-glob-3.0.4.tgz";
        sha1 = "b2c376cfb11f35513badd173ef0bb6e3a388391c";
      };
    }
    {
      name = "parse_node_version___parse_node_version_1.0.1.tgz";
      path = fetchurl {
        name = "parse_node_version___parse_node_version_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/parse-node-version/-/parse-node-version-1.0.1.tgz";
        sha1 = "e2b5dbede00e7fa9bc363607f53327e8b073189b";
      };
    }
    {
      name = "parse_passwd___parse_passwd_1.0.0.tgz";
      path = fetchurl {
        name = "parse_passwd___parse_passwd_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/parse-passwd/-/parse-passwd-1.0.0.tgz";
        sha1 = "6d5b934a456993b23d37f40a382d6f1666a8e5c6";
      };
    }
    {
      name = "pascalcase___pascalcase_0.1.1.tgz";
      path = fetchurl {
        name = "pascalcase___pascalcase_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz";
        sha1 = "b363e55e8006ca6fe21784d2db22bd15d7917f14";
      };
    }
    {
      name = "path_dirname___path_dirname_1.0.2.tgz";
      path = fetchurl {
        name = "path_dirname___path_dirname_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/path-dirname/-/path-dirname-1.0.2.tgz";
        sha1 = "cc33d24d525e099a5388c0336c6e32b9160609e0";
      };
    }
    {
      name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
      path = fetchurl {
        name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    }
    {
      name = "path_parse___path_parse_1.0.7.tgz";
      path = fetchurl {
        name = "path_parse___path_parse_1.0.7.tgz";
        url = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz";
        sha1 = "fbc114b60ca42b30d9daf5858e4bd68bbedb6735";
      };
    }
    {
      name = "path_root_regex___path_root_regex_0.1.2.tgz";
      path = fetchurl {
        name = "path_root_regex___path_root_regex_0.1.2.tgz";
        url = "https://registry.yarnpkg.com/path-root-regex/-/path-root-regex-0.1.2.tgz";
        sha1 = "bfccdc8df5b12dc52c8b43ec38d18d72c04ba96d";
      };
    }
    {
      name = "path_root___path_root_0.1.1.tgz";
      path = fetchurl {
        name = "path_root___path_root_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/path-root/-/path-root-0.1.1.tgz";
        sha1 = "9a4a6814cac1c0cd73360a95f32083c8ea4745b7";
      };
    }
    {
      name = "pify___pify_2.3.0.tgz";
      path = fetchurl {
        name = "pify___pify_2.3.0.tgz";
        url = "https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz";
        sha1 = "ed141a6ac043a849ea588498e7dca8b15330e90c";
      };
    }
    {
      name = "pinkie_promise___pinkie_promise_2.0.1.tgz";
      path = fetchurl {
        name = "pinkie_promise___pinkie_promise_2.0.1.tgz";
        url = "https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz";
        sha1 = "2135d6dfa7a358c069ac9b178776288228450ffa";
      };
    }
    {
      name = "pinkie___pinkie_2.0.4.tgz";
      path = fetchurl {
        name = "pinkie___pinkie_2.0.4.tgz";
        url = "https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz";
        sha1 = "72556b80cfa0d48a974e80e77248e80ed4f7f870";
      };
    }
    {
      name = "plugin_error___plugin_error_0.1.2.tgz";
      path = fetchurl {
        name = "plugin_error___plugin_error_0.1.2.tgz";
        url = "https://registry.yarnpkg.com/plugin-error/-/plugin-error-0.1.2.tgz";
        sha1 = "3b9bb3335ccf00f425e07437e19276967da47ace";
      };
    }
    {
      name = "posix_character_classes___posix_character_classes_0.1.1.tgz";
      path = fetchurl {
        name = "posix_character_classes___posix_character_classes_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz";
        sha1 = "01eac0fe3b5af71a2a6c02feabb8c1fef7e00eab";
      };
    }
    {
      name = "preserve___preserve_0.2.0.tgz";
      path = fetchurl {
        name = "preserve___preserve_0.2.0.tgz";
        url = "https://registry.yarnpkg.com/preserve/-/preserve-0.2.0.tgz";
        sha1 = "815ed1f6ebc65926f865b310c0713bcb3315ce4b";
      };
    }
    {
      name = "pretty_hrtime___pretty_hrtime_1.0.3.tgz";
      path = fetchurl {
        name = "pretty_hrtime___pretty_hrtime_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/pretty-hrtime/-/pretty-hrtime-1.0.3.tgz";
        sha1 = "b7e3ea42435a4c9b2759d99e0f201eb195802ee1";
      };
    }
    {
      name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
      path = fetchurl {
        name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
        url = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz";
        sha1 = "7820d9b16120cc55ca9ae7792680ae7dba6d7fe2";
      };
    }
    {
      name = "q___q_1.5.1.tgz";
      path = fetchurl {
        name = "q___q_1.5.1.tgz";
        url = "https://registry.yarnpkg.com/q/-/q-1.5.1.tgz";
        sha1 = "7e32f75b41381291d04611f1bf14109ac00651d7";
      };
    }
    {
      name = "randomatic___randomatic_3.1.1.tgz";
      path = fetchurl {
        name = "randomatic___randomatic_3.1.1.tgz";
        url = "https://registry.yarnpkg.com/randomatic/-/randomatic-3.1.1.tgz";
        sha1 = "b776efc59375984e36c537b2f51a1f0aff0da1ed";
      };
    }
    {
      name = "readable_stream___readable_stream_1.0.34.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_1.0.34.tgz";
        url = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.0.34.tgz";
        sha1 = "125820e34bc842d2f2aaafafe4c2916ee32c157c";
      };
    }
    {
      name = "readable_stream___readable_stream_2.3.7.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_2.3.7.tgz";
        url = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.7.tgz";
        sha1 = "1eca1cf711aef814c04f62252a36a62f6cb23b57";
      };
    }
    {
      name = "readable_stream___readable_stream_3.6.0.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_3.6.0.tgz";
        url = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz";
        sha1 = "337bbda3adc0706bd3e024426a286d4b4b2c9198";
      };
    }
    {
      name = "readable_stream___readable_stream_1.1.14.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_1.1.14.tgz";
        url = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz";
        sha1 = "7cf4c54ef648e3813084c636dd2079e166c081d9";
      };
    }
    {
      name = "readdirp___readdirp_2.2.1.tgz";
      path = fetchurl {
        name = "readdirp___readdirp_2.2.1.tgz";
        url = "https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz";
        sha1 = "0e87622a3325aa33e892285caf8b4e846529a525";
      };
    }
    {
      name = "rechoir___rechoir_0.6.2.tgz";
      path = fetchurl {
        name = "rechoir___rechoir_0.6.2.tgz";
        url = "https://registry.yarnpkg.com/rechoir/-/rechoir-0.6.2.tgz";
        sha1 = "85204b54dba82d5742e28c96756ef43af50e3384";
      };
    }
    {
      name = "regex_cache___regex_cache_0.4.4.tgz";
      path = fetchurl {
        name = "regex_cache___regex_cache_0.4.4.tgz";
        url = "https://registry.yarnpkg.com/regex-cache/-/regex-cache-0.4.4.tgz";
        sha1 = "75bdc58a2a1496cec48a12835bc54c8d562336dd";
      };
    }
    {
      name = "regex_not___regex_not_1.0.2.tgz";
      path = fetchurl {
        name = "regex_not___regex_not_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz";
        sha1 = "1f4ece27e00b0b65e0247a6810e6a85d83a5752c";
      };
    }
    {
      name = "remove_trailing_separator___remove_trailing_separator_1.1.0.tgz";
      path = fetchurl {
        name = "remove_trailing_separator___remove_trailing_separator_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz";
        sha1 = "c24bce2a283adad5bc3f58e0d48249b92379d8ef";
      };
    }
    {
      name = "repeat_element___repeat_element_1.1.4.tgz";
      path = fetchurl {
        name = "repeat_element___repeat_element_1.1.4.tgz";
        url = "https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.4.tgz";
        sha1 = "be681520847ab58c7568ac75fbfad28ed42d39e9";
      };
    }
    {
      name = "repeat_string___repeat_string_1.6.1.tgz";
      path = fetchurl {
        name = "repeat_string___repeat_string_1.6.1.tgz";
        url = "https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz";
        sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
      };
    }
    {
      name = "replace_ext___replace_ext_0.0.1.tgz";
      path = fetchurl {
        name = "replace_ext___replace_ext_0.0.1.tgz";
        url = "https://registry.yarnpkg.com/replace-ext/-/replace-ext-0.0.1.tgz";
        sha1 = "29bbd92078a739f0bcce2b4ee41e837953522924";
      };
    }
    {
      name = "resolve_dir___resolve_dir_1.0.1.tgz";
      path = fetchurl {
        name = "resolve_dir___resolve_dir_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/resolve-dir/-/resolve-dir-1.0.1.tgz";
        sha1 = "79a40644c362be82f26effe739c9bb5382046f43";
      };
    }
    {
      name = "resolve_url___resolve_url_0.2.1.tgz";
      path = fetchurl {
        name = "resolve_url___resolve_url_0.2.1.tgz";
        url = "https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz";
        sha1 = "2c637fe77c893afd2a663fe21aa9080068e2052a";
      };
    }
    {
      name = "resolve___resolve_1.20.0.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.20.0.tgz";
        url = "https://registry.yarnpkg.com/resolve/-/resolve-1.20.0.tgz";
        sha1 = "629a013fb3f70755d6f0b7935cc1c2c5378b1975";
      };
    }
    {
      name = "ret___ret_0.1.15.tgz";
      path = fetchurl {
        name = "ret___ret_0.1.15.tgz";
        url = "https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz";
        sha1 = "b8a4825d5bdb1fc3f6f53c2bc33f81388681c7bc";
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.1.2.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.1.2.tgz";
        url = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha1 = "991ec69d296e0313747d59bdfd2b745c35f8828d";
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.2.1.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.2.1.tgz";
        url = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz";
        sha1 = "1eaf9fa9bdb1fdd4ec75f58f9cdb4e6b7827eec6";
      };
    }
    {
      name = "safe_regex___safe_regex_1.1.0.tgz";
      path = fetchurl {
        name = "safe_regex___safe_regex_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz";
        sha1 = "40a3669f3b077d1e943d44629e157dd48023bf2e";
      };
    }
    {
      name = "sax___sax_1.2.4.tgz";
      path = fetchurl {
        name = "sax___sax_1.2.4.tgz";
        url = "https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz";
        sha1 = "2816234e2378bddc4e5354fab5caa895df7100d9";
      };
    }
    {
      name = "semver___semver_4.3.6.tgz";
      path = fetchurl {
        name = "semver___semver_4.3.6.tgz";
        url = "https://registry.yarnpkg.com/semver/-/semver-4.3.6.tgz";
        sha1 = "300bc6e0e86374f7ba61068b5b1ecd57fc6532da";
      };
    }
    {
      name = "sequencify___sequencify_0.0.7.tgz";
      path = fetchurl {
        name = "sequencify___sequencify_0.0.7.tgz";
        url = "https://registry.yarnpkg.com/sequencify/-/sequencify-0.0.7.tgz";
        sha1 = "90cff19d02e07027fd767f5ead3e7b95d1e7380c";
      };
    }
    {
      name = "set_value___set_value_2.0.1.tgz";
      path = fetchurl {
        name = "set_value___set_value_2.0.1.tgz";
        url = "https://registry.yarnpkg.com/set-value/-/set-value-2.0.1.tgz";
        sha1 = "a18d40530e6f07de4228c7defe4227af8cad005b";
      };
    }
    {
      name = "sigmund___sigmund_1.0.1.tgz";
      path = fetchurl {
        name = "sigmund___sigmund_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/sigmund/-/sigmund-1.0.1.tgz";
        sha1 = "3ff21f198cad2175f9f3b781853fd94d0d19b590";
      };
    }
    {
      name = "slash___slash_1.0.0.tgz";
      path = fetchurl {
        name = "slash___slash_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/slash/-/slash-1.0.0.tgz";
        sha1 = "c41f2f6c39fc16d1cd17ad4b5d896114ae470d55";
      };
    }
    {
      name = "snapdragon_node___snapdragon_node_2.1.1.tgz";
      path = fetchurl {
        name = "snapdragon_node___snapdragon_node_2.1.1.tgz";
        url = "https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz";
        sha1 = "6c175f86ff14bdb0724563e8f3c1b021a286853b";
      };
    }
    {
      name = "snapdragon_util___snapdragon_util_3.0.1.tgz";
      path = fetchurl {
        name = "snapdragon_util___snapdragon_util_3.0.1.tgz";
        url = "https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz";
        sha1 = "f956479486f2acd79700693f6f7b805e45ab56e2";
      };
    }
    {
      name = "snapdragon___snapdragon_0.8.2.tgz";
      path = fetchurl {
        name = "snapdragon___snapdragon_0.8.2.tgz";
        url = "https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz";
        sha1 = "64922e7c565b0e14204ba1aa7d6964278d25182d";
      };
    }
    {
      name = "source_map_resolve___source_map_resolve_0.5.3.tgz";
      path = fetchurl {
        name = "source_map_resolve___source_map_resolve_0.5.3.tgz";
        url = "https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.3.tgz";
        sha1 = "190866bece7553e1f8f267a2ee82c606b5509a1a";
      };
    }
    {
      name = "source_map_url___source_map_url_0.4.1.tgz";
      path = fetchurl {
        name = "source_map_url___source_map_url_0.4.1.tgz";
        url = "https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.1.tgz";
        sha1 = "0af66605a745a5a2f91cf1bbf8a7afbc283dec56";
      };
    }
    {
      name = "source_map___source_map_0.5.7.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.5.7.tgz";
        url = "https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz";
        sha1 = "8a039d2d1021d22d1ea14c80d8ea468ba2ef3fcc";
      };
    }
    {
      name = "sparkles___sparkles_1.0.1.tgz";
      path = fetchurl {
        name = "sparkles___sparkles_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/sparkles/-/sparkles-1.0.1.tgz";
        sha1 = "008db65edce6c50eec0c5e228e1945061dd0437c";
      };
    }
    {
      name = "split_string___split_string_3.1.0.tgz";
      path = fetchurl {
        name = "split_string___split_string_3.1.0.tgz";
        url = "https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz";
        sha1 = "7cb09dda3a86585705c64b39a6466038682e8fe2";
      };
    }
    {
      name = "sprintf_js___sprintf_js_1.0.3.tgz";
      path = fetchurl {
        name = "sprintf_js___sprintf_js_1.0.3.tgz";
        url = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz";
        sha1 = "04e6926f662895354f3dd015203633b857297e2c";
      };
    }
    {
      name = "static_extend___static_extend_0.1.2.tgz";
      path = fetchurl {
        name = "static_extend___static_extend_0.1.2.tgz";
        url = "https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz";
        sha1 = "60809c39cbff55337226fd5e0b520f341f1fb5c6";
      };
    }
    {
      name = "stream_consume___stream_consume_0.1.1.tgz";
      path = fetchurl {
        name = "stream_consume___stream_consume_0.1.1.tgz";
        url = "https://registry.yarnpkg.com/stream-consume/-/stream-consume-0.1.1.tgz";
        sha1 = "d3bdb598c2bd0ae82b8cac7ac50b1107a7996c48";
      };
    }
    {
      name = "string_decoder___string_decoder_1.3.0.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.3.0.tgz";
        url = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz";
        sha1 = "42f114594a46cf1a8e30b0a84f56c78c3edac21e";
      };
    }
    {
      name = "string_decoder___string_decoder_0.10.31.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_0.10.31.tgz";
        url = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      };
    }
    {
      name = "string_decoder___string_decoder_1.1.1.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.1.1.tgz";
        url = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz";
        sha1 = "9cf1611ba62685d7030ae9e4ba34149c3af03fc8";
      };
    }
    {
      name = "strip_ansi___strip_ansi_3.0.1.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_3.0.1.tgz";
        url = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz";
        sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
      };
    }
    {
      name = "strip_bom_stream___strip_bom_stream_2.0.0.tgz";
      path = fetchurl {
        name = "strip_bom_stream___strip_bom_stream_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/strip-bom-stream/-/strip-bom-stream-2.0.0.tgz";
        sha1 = "f87db5ef2613f6968aa545abfe1ec728b6a829ca";
      };
    }
    {
      name = "strip_bom___strip_bom_1.0.0.tgz";
      path = fetchurl {
        name = "strip_bom___strip_bom_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-1.0.0.tgz";
        sha1 = "85b8862f3844b5a6d5ec8467a93598173a36f794";
      };
    }
    {
      name = "strip_bom___strip_bom_2.0.0.tgz";
      path = fetchurl {
        name = "strip_bom___strip_bom_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz";
        sha1 = "6219a85616520491f35788bdbf1447a99c7e6b0e";
      };
    }
    {
      name = "supports_color___supports_color_2.0.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
    }
    {
      name = "svgo___svgo_0.7.2.tgz";
      path = fetchurl {
        name = "svgo___svgo_0.7.2.tgz";
        url = "https://registry.yarnpkg.com/svgo/-/svgo-0.7.2.tgz";
        sha1 = "9f5772413952135c6fefbf40afe6a4faa88b4bb5";
      };
    }
    {
      name = "through2___through2_0.6.5.tgz";
      path = fetchurl {
        name = "through2___through2_0.6.5.tgz";
        url = "https://registry.yarnpkg.com/through2/-/through2-0.6.5.tgz";
        sha1 = "41ab9c67b29d57209071410e1d7a7a968cd3ad48";
      };
    }
    {
      name = "through2___through2_2.0.5.tgz";
      path = fetchurl {
        name = "through2___through2_2.0.5.tgz";
        url = "https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz";
        sha1 = "01c1e39eb31d07cb7d03a96a70823260b23132cd";
      };
    }
    {
      name = "tildify___tildify_1.2.0.tgz";
      path = fetchurl {
        name = "tildify___tildify_1.2.0.tgz";
        url = "https://registry.yarnpkg.com/tildify/-/tildify-1.2.0.tgz";
        sha1 = "dcec03f55dca9b7aa3e5b04f21817eb56e63588a";
      };
    }
    {
      name = "time_stamp___time_stamp_1.1.0.tgz";
      path = fetchurl {
        name = "time_stamp___time_stamp_1.1.0.tgz";
        url = "https://registry.yarnpkg.com/time-stamp/-/time-stamp-1.1.0.tgz";
        sha1 = "764a5a11af50561921b133f3b44e618687e0f5c3";
      };
    }
    {
      name = "to_object_path___to_object_path_0.3.0.tgz";
      path = fetchurl {
        name = "to_object_path___to_object_path_0.3.0.tgz";
        url = "https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz";
        sha1 = "297588b7b0e7e0ac08e04e672f85c1f4999e17af";
      };
    }
    {
      name = "to_regex_range___to_regex_range_2.1.1.tgz";
      path = fetchurl {
        name = "to_regex_range___to_regex_range_2.1.1.tgz";
        url = "https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz";
        sha1 = "7c80c17b9dfebe599e27367e0d4dd5590141db38";
      };
    }
    {
      name = "to_regex___to_regex_3.0.2.tgz";
      path = fetchurl {
        name = "to_regex___to_regex_3.0.2.tgz";
        url = "https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz";
        sha1 = "13cfdd9b336552f30b51f33a8ae1b42a7a7599ce";
      };
    }
    {
      name = "unc_path_regex___unc_path_regex_0.1.2.tgz";
      path = fetchurl {
        name = "unc_path_regex___unc_path_regex_0.1.2.tgz";
        url = "https://registry.yarnpkg.com/unc-path-regex/-/unc-path-regex-0.1.2.tgz";
        sha1 = "e73dd3d7b0d7c5ed86fbac6b0ae7d8c6a69d50fa";
      };
    }
    {
      name = "union_value___union_value_1.0.1.tgz";
      path = fetchurl {
        name = "union_value___union_value_1.0.1.tgz";
        url = "https://registry.yarnpkg.com/union-value/-/union-value-1.0.1.tgz";
        sha1 = "0b6fe7b835aecda61c6ea4d4f02c14221e109847";
      };
    }
    {
      name = "unique_stream___unique_stream_1.0.0.tgz";
      path = fetchurl {
        name = "unique_stream___unique_stream_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/unique-stream/-/unique-stream-1.0.0.tgz";
        sha1 = "d59a4a75427447d9aa6c91e70263f8d26a4b104b";
      };
    }
    {
      name = "unset_value___unset_value_1.0.0.tgz";
      path = fetchurl {
        name = "unset_value___unset_value_1.0.0.tgz";
        url = "https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz";
        sha1 = "8376873f7d2335179ffb1e6fc3a8ed0dfc8ab559";
      };
    }
    {
      name = "urix___urix_0.1.0.tgz";
      path = fetchurl {
        name = "urix___urix_0.1.0.tgz";
        url = "https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz";
        sha1 = "da937f7a62e21fec1fd18d49b35c2935067a6c72";
      };
    }
    {
      name = "use___use_3.1.1.tgz";
      path = fetchurl {
        name = "use___use_3.1.1.tgz";
        url = "https://registry.yarnpkg.com/use/-/use-3.1.1.tgz";
        sha1 = "d50c8cac79a19fbc20f2911f56eb973f4e10070f";
      };
    }
    {
      name = "user_home___user_home_1.1.1.tgz";
      path = fetchurl {
        name = "user_home___user_home_1.1.1.tgz";
        url = "https://registry.yarnpkg.com/user-home/-/user-home-1.1.1.tgz";
        sha1 = "2b5be23a32b63a7c9deb8d0f28d485724a3df190";
      };
    }
    {
      name = "util_deprecate___util_deprecate_1.0.2.tgz";
      path = fetchurl {
        name = "util_deprecate___util_deprecate_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    }
    {
      name = "v8flags___v8flags_2.1.1.tgz";
      path = fetchurl {
        name = "v8flags___v8flags_2.1.1.tgz";
        url = "https://registry.yarnpkg.com/v8flags/-/v8flags-2.1.1.tgz";
        sha1 = "aab1a1fa30d45f88dd321148875ac02c0b55e5b4";
      };
    }
    {
      name = "vinyl_file___vinyl_file_2.0.0.tgz";
      path = fetchurl {
        name = "vinyl_file___vinyl_file_2.0.0.tgz";
        url = "https://registry.yarnpkg.com/vinyl-file/-/vinyl-file-2.0.0.tgz";
        sha1 = "a7ebf5ffbefda1b7d18d140fcb07b223efb6751a";
      };
    }
    {
      name = "vinyl_fs___vinyl_fs_0.3.14.tgz";
      path = fetchurl {
        name = "vinyl_fs___vinyl_fs_0.3.14.tgz";
        url = "https://registry.yarnpkg.com/vinyl-fs/-/vinyl-fs-0.3.14.tgz";
        sha1 = "9a6851ce1cac1c1cea5fe86c0931d620c2cfa9e6";
      };
    }
    {
      name = "vinyl___vinyl_0.4.6.tgz";
      path = fetchurl {
        name = "vinyl___vinyl_0.4.6.tgz";
        url = "https://registry.yarnpkg.com/vinyl/-/vinyl-0.4.6.tgz";
        sha1 = "2f356c87a550a255461f36bbeb2a5ba8bf784847";
      };
    }
    {
      name = "vinyl___vinyl_0.5.3.tgz";
      path = fetchurl {
        name = "vinyl___vinyl_0.5.3.tgz";
        url = "https://registry.yarnpkg.com/vinyl/-/vinyl-0.5.3.tgz";
        sha1 = "b0455b38fc5e0cf30d4325132e461970c2091cde";
      };
    }
    {
      name = "vinyl___vinyl_1.2.0.tgz";
      path = fetchurl {
        name = "vinyl___vinyl_1.2.0.tgz";
        url = "https://registry.yarnpkg.com/vinyl/-/vinyl-1.2.0.tgz";
        sha1 = "5c88036cf565e5df05558bfc911f8656df218884";
      };
    }
    {
      name = "whet.extend___whet.extend_0.9.9.tgz";
      path = fetchurl {
        name = "whet.extend___whet.extend_0.9.9.tgz";
        url = "https://registry.yarnpkg.com/whet.extend/-/whet.extend-0.9.9.tgz";
        sha1 = "f877d5bf648c97e5aa542fadc16d6a259b9c11a1";
      };
    }
    {
      name = "which___which_1.3.1.tgz";
      path = fetchurl {
        name = "which___which_1.3.1.tgz";
        url = "https://registry.yarnpkg.com/which/-/which-1.3.1.tgz";
        sha1 = "a45043d54f5805316da8d62f9f50918d3da70b0a";
      };
    }
    {
      name = "wrappy___wrappy_1.0.2.tgz";
      path = fetchurl {
        name = "wrappy___wrappy_1.0.2.tgz";
        url = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    }
    {
      name = "xtend___xtend_4.0.2.tgz";
      path = fetchurl {
        name = "xtend___xtend_4.0.2.tgz";
        url = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz";
        sha1 = "bb72779f5fa465186b1f438f674fa347fdb5db54";
      };
    }
  ];
}
