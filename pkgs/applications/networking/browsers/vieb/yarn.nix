{ fetchurl, fetchgit, linkFarm, runCommandNoCC, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "7zip_bin___7zip_bin_5.0.3.tgz";
      path = fetchurl {
        name = "7zip_bin___7zip_bin_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/7zip-bin/-/7zip-bin-5.0.3.tgz";
        sha1 = "bc5b5532ecafd923a61f2fb097e3b108c0106a3f";
      };
    }
    {
      name = "_babel_code_frame___code_frame_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_code_frame___code_frame_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.10.4.tgz";
        sha1 = "168da1a36e90da68ae8d49c0f1b48c7c6249213a";
      };
    }
    {
      name = "_babel_core___core_7.12.10.tgz";
      path = fetchurl {
        name = "_babel_core___core_7.12.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/core/-/core-7.12.10.tgz";
        sha1 = "b79a2e1b9f70ed3d84bbfb6d8c4ef825f606bccd";
      };
    }
    {
      name = "_babel_generator___generator_7.12.10.tgz";
      path = fetchurl {
        name = "_babel_generator___generator_7.12.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/generator/-/generator-7.12.10.tgz";
        sha1 = "2b188fc329fb8e4f762181703beffc0fe6df3460";
      };
    }
    {
      name = "_babel_helper_function_name___helper_function_name_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_helper_function_name___helper_function_name_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.10.4.tgz";
        sha1 = "d2d3b20c59ad8c47112fa7d2a94bc09d5ef82f1a";
      };
    }
    {
      name = "_babel_helper_get_function_arity___helper_get_function_arity_7.12.10.tgz";
      path = fetchurl {
        name = "_babel_helper_get_function_arity___helper_get_function_arity_7.12.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-get-function-arity/-/helper-get-function-arity-7.12.10.tgz";
        sha1 = "b158817a3165b5faa2047825dfa61970ddcc16cf";
      };
    }
    {
      name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.12.7.tgz";
      path = fetchurl {
        name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.12.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.12.7.tgz";
        sha1 = "aa77bd0396ec8114e5e30787efa78599d874a855";
      };
    }
    {
      name = "_babel_helper_module_imports___helper_module_imports_7.12.5.tgz";
      path = fetchurl {
        name = "_babel_helper_module_imports___helper_module_imports_7.12.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.12.5.tgz";
        sha1 = "1bfc0229f794988f76ed0a4d4e90860850b54dfb";
      };
    }
    {
      name = "_babel_helper_module_transforms___helper_module_transforms_7.12.1.tgz";
      path = fetchurl {
        name = "_babel_helper_module_transforms___helper_module_transforms_7.12.1.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.12.1.tgz";
        sha1 = "7954fec71f5b32c48e4b303b437c34453fd7247c";
      };
    }
    {
      name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.12.10.tgz";
      path = fetchurl {
        name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.12.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.12.10.tgz";
        sha1 = "94ca4e306ee11a7dd6e9f42823e2ac6b49881e2d";
      };
    }
    {
      name = "_babel_helper_plugin_utils___helper_plugin_utils_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_helper_plugin_utils___helper_plugin_utils_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.10.4.tgz";
        sha1 = "2f75a831269d4f677de49986dff59927533cf375";
      };
    }
    {
      name = "_babel_helper_replace_supers___helper_replace_supers_7.12.5.tgz";
      path = fetchurl {
        name = "_babel_helper_replace_supers___helper_replace_supers_7.12.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.12.5.tgz";
        sha1 = "f009a17543bbbbce16b06206ae73b63d3fca68d9";
      };
    }
    {
      name = "_babel_helper_simple_access___helper_simple_access_7.12.1.tgz";
      path = fetchurl {
        name = "_babel_helper_simple_access___helper_simple_access_7.12.1.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.12.1.tgz";
        sha1 = "32427e5aa61547d38eb1e6eaf5fd1426fdad9136";
      };
    }
    {
      name = "_babel_helper_skip_transparent_expression_wrappers___helper_skip_transparent_expression_wrappers_7.12.1.tgz";
      path = fetchurl {
        name = "_babel_helper_skip_transparent_expression_wrappers___helper_skip_transparent_expression_wrappers_7.12.1.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.12.1.tgz";
        sha1 = "462dc63a7e435ade8468385c63d2b84cce4b3cbf";
      };
    }
    {
      name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.11.0.tgz";
      path = fetchurl {
        name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.11.0.tgz";
        sha1 = "f8a491244acf6a676158ac42072911ba83ad099f";
      };
    }
    {
      name = "_babel_helper_validator_identifier___helper_validator_identifier_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_helper_validator_identifier___helper_validator_identifier_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.10.4.tgz";
        sha1 = "a78c7a7251e01f616512d31b10adcf52ada5e0d2";
      };
    }
    {
      name = "_babel_helpers___helpers_7.12.5.tgz";
      path = fetchurl {
        name = "_babel_helpers___helpers_7.12.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.12.5.tgz";
        sha1 = "1a1ba4a768d9b58310eda516c449913fe647116e";
      };
    }
    {
      name = "_babel_highlight___highlight_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_highlight___highlight_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.10.4.tgz";
        sha1 = "7d1bdfd65753538fabe6c38596cdb76d9ac60143";
      };
    }
    {
      name = "_babel_parser___parser_7.12.10.tgz";
      path = fetchurl {
        name = "_babel_parser___parser_7.12.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/parser/-/parser-7.12.10.tgz";
        sha1 = "824600d59e96aea26a5a2af5a9d812af05c3ae81";
      };
    }
    {
      name = "_babel_plugin_proposal_optional_chaining___plugin_proposal_optional_chaining_7.12.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_optional_chaining___plugin_proposal_optional_chaining_7.12.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-optional-chaining/-/plugin-proposal-optional-chaining-7.12.7.tgz";
        sha1 = "e02f0ea1b5dc59d401ec16fb824679f683d3303c";
      };
    }
    {
      name = "_babel_plugin_syntax_async_generators___plugin_syntax_async_generators_7.8.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_async_generators___plugin_syntax_async_generators_7.8.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz";
        sha1 = "a983fb1aeb2ec3f6ed042a210f640e90e786fe0d";
      };
    }
    {
      name = "_babel_plugin_syntax_bigint___plugin_syntax_bigint_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_bigint___plugin_syntax_bigint_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz";
        sha1 = "4c9a6f669f5d0cdf1b90a1671e9a146be5300cea";
      };
    }
    {
      name = "_babel_plugin_syntax_class_properties___plugin_syntax_class_properties_7.12.1.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_class_properties___plugin_syntax_class_properties_7.12.1.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.1.tgz";
        sha1 = "bcb297c5366e79bebadef509549cd93b04f19978";
      };
    }
    {
      name = "_babel_plugin_syntax_import_meta___plugin_syntax_import_meta_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_import_meta___plugin_syntax_import_meta_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz";
        sha1 = "ee601348c370fa334d2207be158777496521fd51";
      };
    }
    {
      name = "_babel_plugin_syntax_json_strings___plugin_syntax_json_strings_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_json_strings___plugin_syntax_json_strings_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz";
        sha1 = "01ca21b668cd8218c9e640cb6dd88c5412b2c96a";
      };
    }
    {
      name = "_babel_plugin_syntax_logical_assignment_operators___plugin_syntax_logical_assignment_operators_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_logical_assignment_operators___plugin_syntax_logical_assignment_operators_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz";
        sha1 = "ca91ef46303530448b906652bac2e9fe9941f699";
      };
    }
    {
      name = "_babel_plugin_syntax_nullish_coalescing_operator___plugin_syntax_nullish_coalescing_operator_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_nullish_coalescing_operator___plugin_syntax_nullish_coalescing_operator_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz";
        sha1 = "167ed70368886081f74b5c36c65a88c03b66d1a9";
      };
    }
    {
      name = "_babel_plugin_syntax_numeric_separator___plugin_syntax_numeric_separator_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_numeric_separator___plugin_syntax_numeric_separator_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz";
        sha1 = "b9b070b3e33570cd9fd07ba7fa91c0dd37b9af97";
      };
    }
    {
      name = "_babel_plugin_syntax_object_rest_spread___plugin_syntax_object_rest_spread_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_object_rest_spread___plugin_syntax_object_rest_spread_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz";
        sha1 = "60e225edcbd98a640332a2e72dd3e66f1af55871";
      };
    }
    {
      name = "_babel_plugin_syntax_optional_catch_binding___plugin_syntax_optional_catch_binding_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_optional_catch_binding___plugin_syntax_optional_catch_binding_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz";
        sha1 = "6111a265bcfb020eb9efd0fdfd7d26402b9ed6c1";
      };
    }
    {
      name = "_babel_plugin_syntax_optional_chaining___plugin_syntax_optional_chaining_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_optional_chaining___plugin_syntax_optional_chaining_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz";
        sha1 = "4f69c2ab95167e0180cd5336613f8c5788f7d48a";
      };
    }
    {
      name = "_babel_plugin_syntax_top_level_await___plugin_syntax_top_level_await_7.12.1.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_top_level_await___plugin_syntax_top_level_await_7.12.1.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.12.1.tgz";
        sha1 = "dd6c0b357ac1bb142d98537450a319625d13d2a0";
      };
    }
    {
      name = "_babel_template___template_7.12.7.tgz";
      path = fetchurl {
        name = "_babel_template___template_7.12.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/template/-/template-7.12.7.tgz";
        sha1 = "c817233696018e39fbb6c491d2fb684e05ed43bc";
      };
    }
    {
      name = "_babel_traverse___traverse_7.12.10.tgz";
      path = fetchurl {
        name = "_babel_traverse___traverse_7.12.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.12.10.tgz";
        sha1 = "2d1f4041e8bf42ea099e5b2dc48d6a594c00017a";
      };
    }
    {
      name = "_babel_types___types_7.12.10.tgz";
      path = fetchurl {
        name = "_babel_types___types_7.12.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/types/-/types-7.12.10.tgz";
        sha1 = "7965e4a7260b26f09c56bcfcb0498af1f6d9b260";
      };
    }
    {
      name = "_bcoe_v8_coverage___v8_coverage_0.2.3.tgz";
      path = fetchurl {
        name = "_bcoe_v8_coverage___v8_coverage_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz";
        sha1 = "75a2e8b51cb758a7553d6804a5932d7aace75c39";
      };
    }
    {
      name = "_cliqz_adblocker_content___adblocker_content_1.18.8.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker_content___adblocker_content_1.18.8.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker-content/-/adblocker-content-1.18.8.tgz";
        sha1 = "96473f14c098a20091298d34a6addcd430aceebd";
      };
    }
    {
      name = "_cliqz_adblocker_electron_preload___adblocker_electron_preload_1.18.8.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker_electron_preload___adblocker_electron_preload_1.18.8.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker-electron-preload/-/adblocker-electron-preload-1.18.8.tgz";
        sha1 = "c2058647e015b6f61c222e7d58040347324c63b0";
      };
    }
    {
      name = "_cliqz_adblocker_electron___adblocker_electron_1.18.8.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker_electron___adblocker_electron_1.18.8.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker-electron/-/adblocker-electron-1.18.8.tgz";
        sha1 = "5f697c5dc65cd936b3908078a6e4516ec995567a";
      };
    }
    {
      name = "_cliqz_adblocker___adblocker_1.18.8.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker___adblocker_1.18.8.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker/-/adblocker-1.18.8.tgz";
        sha1 = "f6e5724fe6573c2e68f2545d90bcce3e1ecfbae9";
      };
    }
    {
      name = "_cnakazawa_watch___watch_1.0.4.tgz";
      path = fetchurl {
        name = "_cnakazawa_watch___watch_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/@cnakazawa/watch/-/watch-1.0.4.tgz";
        sha1 = "f864ae85004d0fcab6f50be9141c4da368d1656a";
      };
    }
    {
      name = "_develar_schema_utils___schema_utils_2.6.5.tgz";
      path = fetchurl {
        name = "_develar_schema_utils___schema_utils_2.6.5.tgz";
        url  = "https://registry.yarnpkg.com/@develar/schema-utils/-/schema-utils-2.6.5.tgz";
        sha1 = "3ece22c5838402419a6e0425f85742b961d9b6c6";
      };
    }
    {
      name = "_electron_get___get_1.12.2.tgz";
      path = fetchurl {
        name = "_electron_get___get_1.12.2.tgz";
        url  = "https://registry.yarnpkg.com/@electron/get/-/get-1.12.2.tgz";
        sha1 = "6442066afb99be08cefb9a281e4b4692b33764f3";
      };
    }
    {
      name = "_eslint_eslintrc___eslintrc_0.2.2.tgz";
      path = fetchurl {
        name = "_eslint_eslintrc___eslintrc_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-0.2.2.tgz";
        sha1 = "d01fc791e2fc33e88a29d6f3dc7e93d0cd784b76";
      };
    }
    {
      name = "_istanbuljs_load_nyc_config___load_nyc_config_1.1.0.tgz";
      path = fetchurl {
        name = "_istanbuljs_load_nyc_config___load_nyc_config_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz";
        sha1 = "fd3db1d59ecf7cf121e80650bb86712f9b55eced";
      };
    }
    {
      name = "_istanbuljs_schema___schema_0.1.2.tgz";
      path = fetchurl {
        name = "_istanbuljs_schema___schema_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@istanbuljs/schema/-/schema-0.1.2.tgz";
        sha1 = "26520bf09abe4a5644cd5414e37125a8954241dd";
      };
    }
    {
      name = "_jest_console___console_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_console___console_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/console/-/console-26.6.2.tgz";
        sha1 = "4e04bc464014358b03ab4937805ee36a0aeb98f2";
      };
    }
    {
      name = "_jest_core___core_26.6.3.tgz";
      path = fetchurl {
        name = "_jest_core___core_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/@jest/core/-/core-26.6.3.tgz";
        sha1 = "7639fcb3833d748a4656ada54bde193051e45fad";
      };
    }
    {
      name = "_jest_environment___environment_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_environment___environment_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/environment/-/environment-26.6.2.tgz";
        sha1 = "ba364cc72e221e79cc8f0a99555bf5d7577cf92c";
      };
    }
    {
      name = "_jest_fake_timers___fake_timers_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_fake_timers___fake_timers_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/fake-timers/-/fake-timers-26.6.2.tgz";
        sha1 = "459c329bcf70cee4af4d7e3f3e67848123535aad";
      };
    }
    {
      name = "_jest_globals___globals_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_globals___globals_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/globals/-/globals-26.6.2.tgz";
        sha1 = "5b613b78a1aa2655ae908eba638cc96a20df720a";
      };
    }
    {
      name = "_jest_reporters___reporters_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_reporters___reporters_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/reporters/-/reporters-26.6.2.tgz";
        sha1 = "1f518b99637a5f18307bd3ecf9275f6882a667f6";
      };
    }
    {
      name = "_jest_source_map___source_map_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_source_map___source_map_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/source-map/-/source-map-26.6.2.tgz";
        sha1 = "29af5e1e2e324cafccc936f218309f54ab69d535";
      };
    }
    {
      name = "_jest_test_result___test_result_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_test_result___test_result_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/test-result/-/test-result-26.6.2.tgz";
        sha1 = "55da58b62df134576cc95476efa5f7949e3f5f18";
      };
    }
    {
      name = "_jest_test_sequencer___test_sequencer_26.6.3.tgz";
      path = fetchurl {
        name = "_jest_test_sequencer___test_sequencer_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/@jest/test-sequencer/-/test-sequencer-26.6.3.tgz";
        sha1 = "98e8a45100863886d074205e8ffdc5a7eb582b17";
      };
    }
    {
      name = "_jest_transform___transform_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_transform___transform_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/transform/-/transform-26.6.2.tgz";
        sha1 = "5ac57c5fa1ad17b2aae83e73e45813894dcf2e4b";
      };
    }
    {
      name = "_jest_types___types_26.6.2.tgz";
      path = fetchurl {
        name = "_jest_types___types_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@jest/types/-/types-26.6.2.tgz";
        sha1 = "bef5a532030e1d88a2f5a6d933f84e97226ed48e";
      };
    }
    {
      name = "_remusao_guess_url_type___guess_url_type_1.2.0.tgz";
      path = fetchurl {
        name = "_remusao_guess_url_type___guess_url_type_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/guess-url-type/-/guess-url-type-1.2.0.tgz";
        sha1 = "fb1402b4c47266161501704d74427b8d49e4b3e4";
      };
    }
    {
      name = "_remusao_small___small_1.2.0.tgz";
      path = fetchurl {
        name = "_remusao_small___small_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/small/-/small-1.2.0.tgz";
        sha1 = "1f56d59418d4c121cd8814e4bea5ed95dcf4b7a9";
      };
    }
    {
      name = "_remusao_smaz_compress___smaz_compress_1.9.0.tgz";
      path = fetchurl {
        name = "_remusao_smaz_compress___smaz_compress_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/smaz-compress/-/smaz-compress-1.9.0.tgz";
        sha1 = "ec79c87f5780865da616cd214b3b8978807d1e9a";
      };
    }
    {
      name = "_remusao_smaz_decompress___smaz_decompress_1.9.0.tgz";
      path = fetchurl {
        name = "_remusao_smaz_decompress___smaz_decompress_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/smaz-decompress/-/smaz-decompress-1.9.0.tgz";
        sha1 = "9b3fba7c8e0c2045de63fd0ad0e5b37b447bb7cf";
      };
    }
    {
      name = "_remusao_smaz___smaz_1.9.0.tgz";
      path = fetchurl {
        name = "_remusao_smaz___smaz_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/smaz/-/smaz-1.9.0.tgz";
        sha1 = "d02c2fb007483d4b4d050fb2fdaf523fcef08d40";
      };
    }
    {
      name = "_remusao_trie___trie_1.4.0.tgz";
      path = fetchurl {
        name = "_remusao_trie___trie_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/trie/-/trie-1.4.0.tgz";
        sha1 = "b439210445339f0ca95ff200d98b898d431a4ce1";
      };
    }
    {
      name = "_sindresorhus_is___is_0.14.0.tgz";
      path = fetchurl {
        name = "_sindresorhus_is___is_0.14.0.tgz";
        url  = "https://registry.yarnpkg.com/@sindresorhus/is/-/is-0.14.0.tgz";
        sha1 = "9fb3a3cf3132328151f353de4632e01e52102bea";
      };
    }
    {
      name = "_sinonjs_commons___commons_1.8.1.tgz";
      path = fetchurl {
        name = "_sinonjs_commons___commons_1.8.1.tgz";
        url  = "https://registry.yarnpkg.com/@sinonjs/commons/-/commons-1.8.1.tgz";
        sha1 = "e7df00f98a203324f6dc7cc606cad9d4a8ab2217";
      };
    }
    {
      name = "_sinonjs_fake_timers___fake_timers_6.0.1.tgz";
      path = fetchurl {
        name = "_sinonjs_fake_timers___fake_timers_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@sinonjs/fake-timers/-/fake-timers-6.0.1.tgz";
        sha1 = "293674fccb3262ac782c7aadfdeca86b10c75c40";
      };
    }
    {
      name = "_szmarczak_http_timer___http_timer_1.1.2.tgz";
      path = fetchurl {
        name = "_szmarczak_http_timer___http_timer_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-1.1.2.tgz";
        sha1 = "b1665e2c461a2cd92f4c1bbf50d5454de0d4b421";
      };
    }
    {
      name = "_types_babel__core___babel__core_7.1.12.tgz";
      path = fetchurl {
        name = "_types_babel__core___babel__core_7.1.12.tgz";
        url  = "https://registry.yarnpkg.com/@types/babel__core/-/babel__core-7.1.12.tgz";
        sha1 = "4d8e9e51eb265552a7e4f1ff2219ab6133bdfb2d";
      };
    }
    {
      name = "_types_babel__generator___babel__generator_7.6.2.tgz";
      path = fetchurl {
        name = "_types_babel__generator___babel__generator_7.6.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/babel__generator/-/babel__generator-7.6.2.tgz";
        sha1 = "f3d71178e187858f7c45e30380f8f1b7415a12d8";
      };
    }
    {
      name = "_types_babel__template___babel__template_7.4.0.tgz";
      path = fetchurl {
        name = "_types_babel__template___babel__template_7.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/babel__template/-/babel__template-7.4.0.tgz";
        sha1 = "0c888dd70b3ee9eebb6e4f200e809da0076262be";
      };
    }
    {
      name = "_types_babel__traverse___babel__traverse_7.11.0.tgz";
      path = fetchurl {
        name = "_types_babel__traverse___babel__traverse_7.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/babel__traverse/-/babel__traverse-7.11.0.tgz";
        sha1 = "b9a1efa635201ba9bc850323a8793ee2d36c04a0";
      };
    }
    {
      name = "_types_chrome___chrome_0.0.126.tgz";
      path = fetchurl {
        name = "_types_chrome___chrome_0.0.126.tgz";
        url  = "https://registry.yarnpkg.com/@types/chrome/-/chrome-0.0.126.tgz";
        sha1 = "f9f3436712f0c7c12ea9798abc9b95575ad7b23a";
      };
    }
    {
      name = "_types_debug___debug_4.1.5.tgz";
      path = fetchurl {
        name = "_types_debug___debug_4.1.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/debug/-/debug-4.1.5.tgz";
        sha1 = "b14efa8852b7768d898906613c23f688713e02cd";
      };
    }
    {
      name = "_types_filesystem___filesystem_0.0.29.tgz";
      path = fetchurl {
        name = "_types_filesystem___filesystem_0.0.29.tgz";
        url  = "https://registry.yarnpkg.com/@types/filesystem/-/filesystem-0.0.29.tgz";
        sha1 = "ee3748eb5be140dcf980c3bd35f11aec5f7a3748";
      };
    }
    {
      name = "_types_filewriter___filewriter_0.0.28.tgz";
      path = fetchurl {
        name = "_types_filewriter___filewriter_0.0.28.tgz";
        url  = "https://registry.yarnpkg.com/@types/filewriter/-/filewriter-0.0.28.tgz";
        sha1 = "c054e8af4d9dd75db4e63abc76f885168714d4b3";
      };
    }
    {
      name = "_types_firefox_webext_browser___firefox_webext_browser_82.0.0.tgz";
      path = fetchurl {
        name = "_types_firefox_webext_browser___firefox_webext_browser_82.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/firefox-webext-browser/-/firefox-webext-browser-82.0.0.tgz";
        sha1 = "4d0f5cfebd7321d2cbf0ccfb6032570f0138b958";
      };
    }
    {
      name = "_types_fs_extra___fs_extra_9.0.5.tgz";
      path = fetchurl {
        name = "_types_fs_extra___fs_extra_9.0.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.5.tgz";
        sha1 = "2afb76a43a4bef80a363b94b314d0ca1694fc4f8";
      };
    }
    {
      name = "_types_graceful_fs___graceful_fs_4.1.4.tgz";
      path = fetchurl {
        name = "_types_graceful_fs___graceful_fs_4.1.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/graceful-fs/-/graceful-fs-4.1.4.tgz";
        sha1 = "4ff9f641a7c6d1a3508ff88bc3141b152772e753";
      };
    }
    {
      name = "_types_har_format___har_format_1.2.5.tgz";
      path = fetchurl {
        name = "_types_har_format___har_format_1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/har-format/-/har-format-1.2.5.tgz";
        sha1 = "4f6648814d0fdcb6a510e3364a9db439a753c4b1";
      };
    }
    {
      name = "_types_istanbul_lib_coverage___istanbul_lib_coverage_2.0.3.tgz";
      path = fetchurl {
        name = "_types_istanbul_lib_coverage___istanbul_lib_coverage_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.3.tgz";
        sha1 = "4ba8ddb720221f432e443bd5f9117fd22cfd4762";
      };
    }
    {
      name = "_types_istanbul_lib_report___istanbul_lib_report_3.0.0.tgz";
      path = fetchurl {
        name = "_types_istanbul_lib_report___istanbul_lib_report_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz";
        sha1 = "c14c24f18ea8190c118ee7562b7ff99a36552686";
      };
    }
    {
      name = "_types_istanbul_reports___istanbul_reports_3.0.0.tgz";
      path = fetchurl {
        name = "_types_istanbul_reports___istanbul_reports_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/istanbul-reports/-/istanbul-reports-3.0.0.tgz";
        sha1 = "508b13aa344fa4976234e75dddcc34925737d821";
      };
    }
    {
      name = "_types_node___node_14.14.13.tgz";
      path = fetchurl {
        name = "_types_node___node_14.14.13.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-14.14.13.tgz";
        sha1 = "9e425079799322113ae8477297ae6ef51b8e0cdf";
      };
    }
    {
      name = "_types_node___node_12.19.9.tgz";
      path = fetchurl {
        name = "_types_node___node_12.19.9.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-12.19.9.tgz";
        sha1 = "990ad687ad8b26ef6dcc34a4f69c33d40c95b679";
      };
    }
    {
      name = "_types_normalize_package_data___normalize_package_data_2.4.0.tgz";
      path = fetchurl {
        name = "_types_normalize_package_data___normalize_package_data_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/normalize-package-data/-/normalize-package-data-2.4.0.tgz";
        sha1 = "e486d0d97396d79beedd0a6e33f4534ff6b4973e";
      };
    }
    {
      name = "_types_prettier___prettier_2.1.5.tgz";
      path = fetchurl {
        name = "_types_prettier___prettier_2.1.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/prettier/-/prettier-2.1.5.tgz";
        sha1 = "b6ab3bba29e16b821d84e09ecfaded462b816b00";
      };
    }
    {
      name = "_types_stack_utils___stack_utils_2.0.0.tgz";
      path = fetchurl {
        name = "_types_stack_utils___stack_utils_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/stack-utils/-/stack-utils-2.0.0.tgz";
        sha1 = "7036640b4e21cc2f259ae826ce843d277dad8cff";
      };
    }
    {
      name = "_types_yargs_parser___yargs_parser_15.0.0.tgz";
      path = fetchurl {
        name = "_types_yargs_parser___yargs_parser_15.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-15.0.0.tgz";
        sha1 = "cb3f9f741869e20cce330ffbeb9271590483882d";
      };
    }
    {
      name = "_types_yargs___yargs_15.0.11.tgz";
      path = fetchurl {
        name = "_types_yargs___yargs_15.0.11.tgz";
        url  = "https://registry.yarnpkg.com/@types/yargs/-/yargs-15.0.11.tgz";
        sha1 = "361d7579ecdac1527687bcebf9946621c12ab78c";
      };
    }
    {
      name = "abab___abab_2.0.5.tgz";
      path = fetchurl {
        name = "abab___abab_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/abab/-/abab-2.0.5.tgz";
        sha1 = "c0b678fb32d60fc1219c784d6a826fe385aeb79a";
      };
    }
    {
      name = "acorn_globals___acorn_globals_6.0.0.tgz";
      path = fetchurl {
        name = "acorn_globals___acorn_globals_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-globals/-/acorn-globals-6.0.0.tgz";
        sha1 = "46cdd39f0f8ff08a876619b55f5ac8a6dc770b45";
      };
    }
    {
      name = "acorn_jsx___acorn_jsx_5.3.1.tgz";
      path = fetchurl {
        name = "acorn_jsx___acorn_jsx_5.3.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.1.tgz";
        sha1 = "fc8661e11b7ac1539c47dbfea2e72b3af34d267b";
      };
    }
    {
      name = "acorn_walk___acorn_walk_7.2.0.tgz";
      path = fetchurl {
        name = "acorn_walk___acorn_walk_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-7.2.0.tgz";
        sha1 = "0de889a601203909b0fbe07b8938dc21d2e967bc";
      };
    }
    {
      name = "acorn___acorn_7.4.1.tgz";
      path = fetchurl {
        name = "acorn___acorn_7.4.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz";
        sha1 = "feaed255973d2e77555b83dbc08851a6c63520fa";
      };
    }
    {
      name = "ajv_keywords___ajv_keywords_3.5.2.tgz";
      path = fetchurl {
        name = "ajv_keywords___ajv_keywords_3.5.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz";
        sha1 = "31f29da5ab6e00d1c2d329acf7b5929614d5014d";
      };
    }
    {
      name = "ajv___ajv_6.12.6.tgz";
      path = fetchurl {
        name = "ajv___ajv_6.12.6.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz";
        sha1 = "baf5a62e802b07d977034586f8c3baf5adf26df4";
      };
    }
    {
      name = "ansi_align___ansi_align_3.0.0.tgz";
      path = fetchurl {
        name = "ansi_align___ansi_align_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-align/-/ansi-align-3.0.0.tgz";
        sha1 = "b536b371cf687caaef236c18d3e21fe3797467cb";
      };
    }
    {
      name = "ansi_colors___ansi_colors_4.1.1.tgz";
      path = fetchurl {
        name = "ansi_colors___ansi_colors_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz";
        sha1 = "cbb9ae256bf750af1eab344f229aa27fe94ba348";
      };
    }
    {
      name = "ansi_escapes___ansi_escapes_4.3.1.tgz";
      path = fetchurl {
        name = "ansi_escapes___ansi_escapes_4.3.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-4.3.1.tgz";
        sha1 = "a5c47cc43181f1f38ffd7076837700d395522a61";
      };
    }
    {
      name = "ansi_regex___ansi_regex_4.1.0.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.0.tgz";
        sha1 = "8b9f8f08cf1acb843756a839ca8c7e3168c51997";
      };
    }
    {
      name = "ansi_regex___ansi_regex_5.0.0.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.0.tgz";
        sha1 = "388539f55179bf39339c81af30a654d69f87cb75";
      };
    }
    {
      name = "ansi_styles___ansi_styles_3.2.1.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz";
        sha1 = "41fbb20243e50b12be0f04b8dedbf07520ce841d";
      };
    }
    {
      name = "ansi_styles___ansi_styles_4.3.0.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz";
        sha1 = "edd803628ae71c04c85ae7a0906edad34b648937";
      };
    }
    {
      name = "anymatch___anymatch_2.0.0.tgz";
      path = fetchurl {
        name = "anymatch___anymatch_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz";
        sha1 = "bcb24b4f37934d9aa7ac17b4adaf89e7c76ef2eb";
      };
    }
    {
      name = "anymatch___anymatch_3.1.1.tgz";
      path = fetchurl {
        name = "anymatch___anymatch_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.1.tgz";
        sha1 = "c55ecf02185e2469259399310c173ce31233b142";
      };
    }
    {
      name = "app_builder_bin___app_builder_bin_3.5.10.tgz";
      path = fetchurl {
        name = "app_builder_bin___app_builder_bin_3.5.10.tgz";
        url  = "https://registry.yarnpkg.com/app-builder-bin/-/app-builder-bin-3.5.10.tgz";
        sha1 = "4a7f9999fccc0c435b6284ae1366bc76a17c4a7d";
      };
    }
    {
      name = "app_builder_lib___app_builder_lib_22.9.1.tgz";
      path = fetchurl {
        name = "app_builder_lib___app_builder_lib_22.9.1.tgz";
        url  = "https://registry.yarnpkg.com/app-builder-lib/-/app-builder-lib-22.9.1.tgz";
        sha1 = "ccb8f1a02b628514a5dfab9401fa2a976689415c";
      };
    }
    {
      name = "archiver_utils___archiver_utils_2.1.0.tgz";
      path = fetchurl {
        name = "archiver_utils___archiver_utils_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/archiver-utils/-/archiver-utils-2.1.0.tgz";
        sha1 = "e8a460e94b693c3e3da182a098ca6285ba9249e2";
      };
    }
    {
      name = "archiver___archiver_5.1.0.tgz";
      path = fetchurl {
        name = "archiver___archiver_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/archiver/-/archiver-5.1.0.tgz";
        sha1 = "05b0f6f7836f3e6356a0532763d2bb91017a7e37";
      };
    }
    {
      name = "argparse___argparse_1.0.10.tgz";
      path = fetchurl {
        name = "argparse___argparse_1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz";
        sha1 = "bcd6791ea5ae09725e17e5ad988134cd40b3d911";
      };
    }
    {
      name = "arr_diff___arr_diff_4.0.0.tgz";
      path = fetchurl {
        name = "arr_diff___arr_diff_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz";
        sha1 = "d6461074febfec71e7e15235761a329a5dc7c520";
      };
    }
    {
      name = "arr_flatten___arr_flatten_1.1.0.tgz";
      path = fetchurl {
        name = "arr_flatten___arr_flatten_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz";
        sha1 = "36048bbff4e7b47e136644316c99669ea5ae91f1";
      };
    }
    {
      name = "arr_union___arr_union_3.1.0.tgz";
      path = fetchurl {
        name = "arr_union___arr_union_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz";
        sha1 = "e39b09aea9def866a8f206e288af63919bae39c4";
      };
    }
    {
      name = "array_unique___array_unique_0.3.2.tgz";
      path = fetchurl {
        name = "array_unique___array_unique_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz";
        sha1 = "a894b75d4bc4f6cd679ef3244a9fd8f46ae2d428";
      };
    }
    {
      name = "asn1___asn1_0.2.4.tgz";
      path = fetchurl {
        name = "asn1___asn1_0.2.4.tgz";
        url  = "https://registry.yarnpkg.com/asn1/-/asn1-0.2.4.tgz";
        sha1 = "8d2475dfab553bb33e77b54e59e880bb8ce23136";
      };
    }
    {
      name = "assert_plus___assert_plus_1.0.0.tgz";
      path = fetchurl {
        name = "assert_plus___assert_plus_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz";
        sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
      };
    }
    {
      name = "assign_symbols___assign_symbols_1.0.0.tgz";
      path = fetchurl {
        name = "assign_symbols___assign_symbols_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz";
        sha1 = "59667f41fadd4f20ccbc2bb96b8d4f7f78ec0367";
      };
    }
    {
      name = "astral_regex___astral_regex_1.0.0.tgz";
      path = fetchurl {
        name = "astral_regex___astral_regex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/astral-regex/-/astral-regex-1.0.0.tgz";
        sha1 = "6c8c3fb827dd43ee3918f27b82782ab7658a6fd9";
      };
    }
    {
      name = "async_exit_hook___async_exit_hook_2.0.1.tgz";
      path = fetchurl {
        name = "async_exit_hook___async_exit_hook_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/async-exit-hook/-/async-exit-hook-2.0.1.tgz";
        sha1 = "8bd8b024b0ec9b1c01cccb9af9db29bd717dfaf3";
      };
    }
    {
      name = "async___async_0.9.2.tgz";
      path = fetchurl {
        name = "async___async_0.9.2.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-0.9.2.tgz";
        sha1 = "aea74d5e61c1f899613bf64bda66d4c78f2fd17d";
      };
    }
    {
      name = "async___async_3.2.0.tgz";
      path = fetchurl {
        name = "async___async_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-3.2.0.tgz";
        sha1 = "b3a2685c5ebb641d3de02d161002c60fc9f85720";
      };
    }
    {
      name = "asynckit___asynckit_0.4.0.tgz";
      path = fetchurl {
        name = "asynckit___asynckit_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz";
        sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
      };
    }
    {
      name = "at_least_node___at_least_node_1.0.0.tgz";
      path = fetchurl {
        name = "at_least_node___at_least_node_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz";
        sha1 = "602cd4b46e844ad4effc92a8011a3c46e0238dc2";
      };
    }
    {
      name = "atob___atob_2.1.2.tgz";
      path = fetchurl {
        name = "atob___atob_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz";
        sha1 = "6d9517eb9e030d2436666651e86bd9f6f13533c9";
      };
    }
    {
      name = "aws_sign2___aws_sign2_0.7.0.tgz";
      path = fetchurl {
        name = "aws_sign2___aws_sign2_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.7.0.tgz";
        sha1 = "b46e890934a9591f2d2f6f86d7e6a9f1b3fe76a8";
      };
    }
    {
      name = "aws4___aws4_1.11.0.tgz";
      path = fetchurl {
        name = "aws4___aws4_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/aws4/-/aws4-1.11.0.tgz";
        sha1 = "d61f46d83b2519250e2784daf5b09479a8b41c59";
      };
    }
    {
      name = "babel_jest___babel_jest_26.6.3.tgz";
      path = fetchurl {
        name = "babel_jest___babel_jest_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/babel-jest/-/babel-jest-26.6.3.tgz";
        sha1 = "d87d25cb0037577a0c89f82e5755c5d293c01056";
      };
    }
    {
      name = "babel_plugin_istanbul___babel_plugin_istanbul_6.0.0.tgz";
      path = fetchurl {
        name = "babel_plugin_istanbul___babel_plugin_istanbul_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-istanbul/-/babel-plugin-istanbul-6.0.0.tgz";
        sha1 = "e159ccdc9af95e0b570c75b4573b7c34d671d765";
      };
    }
    {
      name = "babel_plugin_jest_hoist___babel_plugin_jest_hoist_26.6.2.tgz";
      path = fetchurl {
        name = "babel_plugin_jest_hoist___babel_plugin_jest_hoist_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-26.6.2.tgz";
        sha1 = "8185bd030348d254c6d7dd974355e6a28b21e62d";
      };
    }
    {
      name = "babel_preset_current_node_syntax___babel_preset_current_node_syntax_1.0.0.tgz";
      path = fetchurl {
        name = "babel_preset_current_node_syntax___babel_preset_current_node_syntax_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.0.tgz";
        sha1 = "cf5feef29551253471cfa82fc8e0f5063df07a77";
      };
    }
    {
      name = "babel_preset_jest___babel_preset_jest_26.6.2.tgz";
      path = fetchurl {
        name = "babel_preset_jest___babel_preset_jest_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-jest/-/babel-preset-jest-26.6.2.tgz";
        sha1 = "747872b1171df032252426586881d62d31798fee";
      };
    }
    {
      name = "balanced_match___balanced_match_1.0.0.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
      };
    }
    {
      name = "base64_js___base64_js_1.5.1.tgz";
      path = fetchurl {
        name = "base64_js___base64_js_1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz";
        sha1 = "1b1b440160a5bf7ad40b650f095963481903930a";
      };
    }
    {
      name = "base___base_0.11.2.tgz";
      path = fetchurl {
        name = "base___base_0.11.2.tgz";
        url  = "https://registry.yarnpkg.com/base/-/base-0.11.2.tgz";
        sha1 = "7bde5ced145b6d551a90db87f83c558b4eb48a8f";
      };
    }
    {
      name = "bcrypt_pbkdf___bcrypt_pbkdf_1.0.2.tgz";
      path = fetchurl {
        name = "bcrypt_pbkdf___bcrypt_pbkdf_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz";
        sha1 = "a4301d389b6a43f9b67ff3ca11a3f6637e360e9e";
      };
    }
    {
      name = "bl___bl_4.0.3.tgz";
      path = fetchurl {
        name = "bl___bl_4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/bl/-/bl-4.0.3.tgz";
        sha1 = "12d6287adc29080e22a705e5764b2a9522cdc489";
      };
    }
    {
      name = "bluebird_lst___bluebird_lst_1.0.9.tgz";
      path = fetchurl {
        name = "bluebird_lst___bluebird_lst_1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/bluebird-lst/-/bluebird-lst-1.0.9.tgz";
        sha1 = "a64a0e4365658b9ab5fe875eb9dfb694189bb41c";
      };
    }
    {
      name = "bluebird___bluebird_3.7.2.tgz";
      path = fetchurl {
        name = "bluebird___bluebird_3.7.2.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz";
        sha1 = "9f229c15be272454ffa973ace0dbee79a1b0c36f";
      };
    }
    {
      name = "boolean___boolean_3.0.2.tgz";
      path = fetchurl {
        name = "boolean___boolean_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/boolean/-/boolean-3.0.2.tgz";
        sha1 = "df1baa18b6a2b0e70840475e1d93ec8fe75b2570";
      };
    }
    {
      name = "boxen___boxen_4.2.0.tgz";
      path = fetchurl {
        name = "boxen___boxen_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/boxen/-/boxen-4.2.0.tgz";
        sha1 = "e411b62357d6d6d36587c8ac3d5d974daa070e64";
      };
    }
    {
      name = "brace_expansion___brace_expansion_1.1.11.tgz";
      path = fetchurl {
        name = "brace_expansion___brace_expansion_1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha1 = "3c7fcbf529d87226f3d2f52b966ff5271eb441dd";
      };
    }
    {
      name = "braces___braces_2.3.2.tgz";
      path = fetchurl {
        name = "braces___braces_2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz";
        sha1 = "5979fd3f14cd531565e5fa2df1abfff1dfaee729";
      };
    }
    {
      name = "braces___braces_3.0.2.tgz";
      path = fetchurl {
        name = "braces___braces_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz";
        sha1 = "3454e1a462ee8d599e236df336cd9ea4f8afe107";
      };
    }
    {
      name = "browser_process_hrtime___browser_process_hrtime_1.0.0.tgz";
      path = fetchurl {
        name = "browser_process_hrtime___browser_process_hrtime_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz";
        sha1 = "3c9b4b7d782c8121e56f10106d84c0d0ffc94626";
      };
    }
    {
      name = "bser___bser_2.1.1.tgz";
      path = fetchurl {
        name = "bser___bser_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/bser/-/bser-2.1.1.tgz";
        sha1 = "e6787da20ece9d07998533cfd9de6f5c38f4bc05";
      };
    }
    {
      name = "buffer_crc32___buffer_crc32_0.2.13.tgz";
      path = fetchurl {
        name = "buffer_crc32___buffer_crc32_0.2.13.tgz";
        url  = "https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz";
        sha1 = "0d333e3f00eac50aa1454abd30ef8c2a5d9a7242";
      };
    }
    {
      name = "buffer_from___buffer_from_1.1.1.tgz";
      path = fetchurl {
        name = "buffer_from___buffer_from_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz";
        sha1 = "32713bc028f75c02fdb710d7c7bcec1f2c6070ef";
      };
    }
    {
      name = "buffer___buffer_5.7.1.tgz";
      path = fetchurl {
        name = "buffer___buffer_5.7.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer/-/buffer-5.7.1.tgz";
        sha1 = "ba62e7c13133053582197160851a8f648e99eed0";
      };
    }
    {
      name = "builder_util_runtime___builder_util_runtime_8.7.2.tgz";
      path = fetchurl {
        name = "builder_util_runtime___builder_util_runtime_8.7.2.tgz";
        url  = "https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-8.7.2.tgz";
        sha1 = "d93afc71428a12789b437e13850e1fa7da956d72";
      };
    }
    {
      name = "builder_util___builder_util_22.9.1.tgz";
      path = fetchurl {
        name = "builder_util___builder_util_22.9.1.tgz";
        url  = "https://registry.yarnpkg.com/builder-util/-/builder-util-22.9.1.tgz";
        sha1 = "b7087a5cde477f90d718ca5d7fafb6ae261b16af";
      };
    }
    {
      name = "cache_base___cache_base_1.0.1.tgz";
      path = fetchurl {
        name = "cache_base___cache_base_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz";
        sha1 = "0a7f46416831c8b662ee36fe4e7c59d76f666ab2";
      };
    }
    {
      name = "cacheable_request___cacheable_request_6.1.0.tgz";
      path = fetchurl {
        name = "cacheable_request___cacheable_request_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-6.1.0.tgz";
        sha1 = "20ffb8bd162ba4be11e9567d823db651052ca912";
      };
    }
    {
      name = "callsites___callsites_3.1.0.tgz";
      path = fetchurl {
        name = "callsites___callsites_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz";
        sha1 = "b3630abd8943432f54b3f0519238e33cd7df2f73";
      };
    }
    {
      name = "camelcase___camelcase_5.3.1.tgz";
      path = fetchurl {
        name = "camelcase___camelcase_5.3.1.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz";
        sha1 = "e3c9b31569e106811df242f715725a1f4c494320";
      };
    }
    {
      name = "camelcase___camelcase_6.2.0.tgz";
      path = fetchurl {
        name = "camelcase___camelcase_6.2.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-6.2.0.tgz";
        sha1 = "924af881c9d525ac9d87f40d964e5cea982a1809";
      };
    }
    {
      name = "capture_exit___capture_exit_2.0.0.tgz";
      path = fetchurl {
        name = "capture_exit___capture_exit_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/capture-exit/-/capture-exit-2.0.0.tgz";
        sha1 = "fb953bfaebeb781f62898239dabb426d08a509a4";
      };
    }
    {
      name = "caseless___caseless_0.12.0.tgz";
      path = fetchurl {
        name = "caseless___caseless_0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz";
        sha1 = "1b681c21ff84033c826543090689420d187151dc";
      };
    }
    {
      name = "chalk___chalk_2.4.2.tgz";
      path = fetchurl {
        name = "chalk___chalk_2.4.2.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz";
        sha1 = "cd42541677a54333cf541a49108c1432b44c9424";
      };
    }
    {
      name = "chalk___chalk_3.0.0.tgz";
      path = fetchurl {
        name = "chalk___chalk_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-3.0.0.tgz";
        sha1 = "3f73c2bf526591f574cc492c51e2456349f844e4";
      };
    }
    {
      name = "chalk___chalk_4.1.0.tgz";
      path = fetchurl {
        name = "chalk___chalk_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-4.1.0.tgz";
        sha1 = "4e14870a618d9e2edd97dd8345fd9d9dc315646a";
      };
    }
    {
      name = "char_regex___char_regex_1.0.2.tgz";
      path = fetchurl {
        name = "char_regex___char_regex_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/char-regex/-/char-regex-1.0.2.tgz";
        sha1 = "d744358226217f981ed58f479b1d6bcc29545dcf";
      };
    }
    {
      name = "chromium_pickle_js___chromium_pickle_js_0.2.0.tgz";
      path = fetchurl {
        name = "chromium_pickle_js___chromium_pickle_js_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz";
        sha1 = "04a106672c18b085ab774d983dfa3ea138f22205";
      };
    }
    {
      name = "ci_info___ci_info_2.0.0.tgz";
      path = fetchurl {
        name = "ci_info___ci_info_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ci-info/-/ci-info-2.0.0.tgz";
        sha1 = "67a9e964be31a51e15e5010d58e6f12834002f46";
      };
    }
    {
      name = "cjs_module_lexer___cjs_module_lexer_0.6.0.tgz";
      path = fetchurl {
        name = "cjs_module_lexer___cjs_module_lexer_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/cjs-module-lexer/-/cjs-module-lexer-0.6.0.tgz";
        sha1 = "4186fcca0eae175970aee870b9fe2d6cf8d5655f";
      };
    }
    {
      name = "class_utils___class_utils_0.3.6.tgz";
      path = fetchurl {
        name = "class_utils___class_utils_0.3.6.tgz";
        url  = "https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz";
        sha1 = "f93369ae8b9a7ce02fd41faad0ca83033190c463";
      };
    }
    {
      name = "cli_boxes___cli_boxes_2.2.1.tgz";
      path = fetchurl {
        name = "cli_boxes___cli_boxes_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-2.2.1.tgz";
        sha1 = "ddd5035d25094fce220e9cab40a45840a440318f";
      };
    }
    {
      name = "cliui___cliui_6.0.0.tgz";
      path = fetchurl {
        name = "cliui___cliui_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-6.0.0.tgz";
        sha1 = "511d702c0c4e41ca156d7d0e96021f23e13225b1";
      };
    }
    {
      name = "cliui___cliui_7.0.4.tgz";
      path = fetchurl {
        name = "cliui___cliui_7.0.4.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz";
        sha1 = "a0265ee655476fc807aea9df3df8df7783808b4f";
      };
    }
    {
      name = "clone_response___clone_response_1.0.2.tgz";
      path = fetchurl {
        name = "clone_response___clone_response_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.2.tgz";
        sha1 = "d1dc973920314df67fbeb94223b4ee350239e96b";
      };
    }
    {
      name = "co___co_4.6.0.tgz";
      path = fetchurl {
        name = "co___co_4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/co/-/co-4.6.0.tgz";
        sha1 = "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184";
      };
    }
    {
      name = "collect_v8_coverage___collect_v8_coverage_1.0.1.tgz";
      path = fetchurl {
        name = "collect_v8_coverage___collect_v8_coverage_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/collect-v8-coverage/-/collect-v8-coverage-1.0.1.tgz";
        sha1 = "cc2c8e94fc18bbdffe64d6534570c8a673b27f59";
      };
    }
    {
      name = "collection_visit___collection_visit_1.0.0.tgz";
      path = fetchurl {
        name = "collection_visit___collection_visit_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz";
        sha1 = "4bc0373c164bc3291b4d368c829cf1a80a59dca0";
      };
    }
    {
      name = "color_convert___color_convert_1.9.3.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz";
        sha1 = "bb71850690e1f136567de629d2d5471deda4c1e8";
      };
    }
    {
      name = "color_convert___color_convert_2.0.1.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz";
        sha1 = "72d3a68d598c9bdb3af2ad1e84f21d896abd4de3";
      };
    }
    {
      name = "color_name___color_name_1.1.3.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz";
        sha1 = "a7d0558bd89c42f795dd42328f740831ca53bc25";
      };
    }
    {
      name = "color_name___color_name_1.1.4.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz";
        sha1 = "c2a09a87acbde69543de6f63fa3995c826c536a2";
      };
    }
    {
      name = "combined_stream___combined_stream_1.0.8.tgz";
      path = fetchurl {
        name = "combined_stream___combined_stream_1.0.8.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz";
        sha1 = "c3d45a8b34fd730631a110a8a2520682b31d5a7f";
      };
    }
    {
      name = "component_emitter___component_emitter_1.3.0.tgz";
      path = fetchurl {
        name = "component_emitter___component_emitter_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz";
        sha1 = "16e4070fba8ae29b679f2215853ee181ab2eabc0";
      };
    }
    {
      name = "compress_commons___compress_commons_4.0.2.tgz";
      path = fetchurl {
        name = "compress_commons___compress_commons_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/compress-commons/-/compress-commons-4.0.2.tgz";
        sha1 = "d6896be386e52f37610cef9e6fa5defc58c31bd7";
      };
    }
    {
      name = "concat_map___concat_map_0.0.1.tgz";
      path = fetchurl {
        name = "concat_map___concat_map_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    }
    {
      name = "concat_stream___concat_stream_1.6.2.tgz";
      path = fetchurl {
        name = "concat_stream___concat_stream_1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz";
        sha1 = "904bdf194cd3122fc675c77fc4ac3d4ff0fd1a34";
      };
    }
    {
      name = "config_chain___config_chain_1.1.12.tgz";
      path = fetchurl {
        name = "config_chain___config_chain_1.1.12.tgz";
        url  = "https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.12.tgz";
        sha1 = "0fde8d091200eb5e808caf25fe618c02f48e4efa";
      };
    }
    {
      name = "configstore___configstore_5.0.1.tgz";
      path = fetchurl {
        name = "configstore___configstore_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/configstore/-/configstore-5.0.1.tgz";
        sha1 = "d365021b5df4b98cdd187d6a3b0e3f6a7cc5ed96";
      };
    }
    {
      name = "convert_source_map___convert_source_map_1.7.0.tgz";
      path = fetchurl {
        name = "convert_source_map___convert_source_map_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.7.0.tgz";
        sha1 = "17a2cb882d7f77d3490585e2ce6c524424a3a442";
      };
    }
    {
      name = "copy_descriptor___copy_descriptor_0.1.1.tgz";
      path = fetchurl {
        name = "copy_descriptor___copy_descriptor_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz";
        sha1 = "676f6eb3c39997c2ee1ac3a924fd6124748f578d";
      };
    }
    {
      name = "core_js___core_js_3.8.1.tgz";
      path = fetchurl {
        name = "core_js___core_js_3.8.1.tgz";
        url  = "https://registry.yarnpkg.com/core-js/-/core-js-3.8.1.tgz";
        sha1 = "f51523668ac8a294d1285c3b9db44025fda66d47";
      };
    }
    {
      name = "core_util_is___core_util_is_1.0.2.tgz";
      path = fetchurl {
        name = "core_util_is___core_util_is_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    }
    {
      name = "crc_32___crc_32_1.2.0.tgz";
      path = fetchurl {
        name = "crc_32___crc_32_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/crc-32/-/crc-32-1.2.0.tgz";
        sha1 = "cb2db6e29b88508e32d9dd0ec1693e7b41a18208";
      };
    }
    {
      name = "crc32_stream___crc32_stream_4.0.1.tgz";
      path = fetchurl {
        name = "crc32_stream___crc32_stream_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/crc32-stream/-/crc32-stream-4.0.1.tgz";
        sha1 = "0f047d74041737f8a55e86837a1b826bd8ab0067";
      };
    }
    {
      name = "cross_spawn___cross_spawn_6.0.5.tgz";
      path = fetchurl {
        name = "cross_spawn___cross_spawn_6.0.5.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz";
        sha1 = "4a5ec7c64dfae22c3a14124dbacdee846d80cbc4";
      };
    }
    {
      name = "cross_spawn___cross_spawn_7.0.3.tgz";
      path = fetchurl {
        name = "cross_spawn___cross_spawn_7.0.3.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz";
        sha1 = "f73a85b9d5d41d045551c177e2882d4ac85728a6";
      };
    }
    {
      name = "crypto_random_string___crypto_random_string_2.0.0.tgz";
      path = fetchurl {
        name = "crypto_random_string___crypto_random_string_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-2.0.0.tgz";
        sha1 = "ef2a7a966ec11083388369baa02ebead229b30d5";
      };
    }
    {
      name = "cssom___cssom_0.4.4.tgz";
      path = fetchurl {
        name = "cssom___cssom_0.4.4.tgz";
        url  = "https://registry.yarnpkg.com/cssom/-/cssom-0.4.4.tgz";
        sha1 = "5a66cf93d2d0b661d80bf6a44fb65f5c2e4e0a10";
      };
    }
    {
      name = "cssom___cssom_0.3.8.tgz";
      path = fetchurl {
        name = "cssom___cssom_0.3.8.tgz";
        url  = "https://registry.yarnpkg.com/cssom/-/cssom-0.3.8.tgz";
        sha1 = "9f1276f5b2b463f2114d3f2c75250af8c1a36f4a";
      };
    }
    {
      name = "cssstyle___cssstyle_2.3.0.tgz";
      path = fetchurl {
        name = "cssstyle___cssstyle_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/cssstyle/-/cssstyle-2.3.0.tgz";
        sha1 = "ff665a0ddbdc31864b09647f34163443d90b0852";
      };
    }
    {
      name = "darkreader___darkreader_4.9.26.tgz";
      path = fetchurl {
        name = "darkreader___darkreader_4.9.26.tgz";
        url  = "https://registry.yarnpkg.com/darkreader/-/darkreader-4.9.26.tgz";
        sha1 = "ad92139742f22fc406ae14d12ec6e5672a7eedde";
      };
    }
    {
      name = "dashdash___dashdash_1.14.1.tgz";
      path = fetchurl {
        name = "dashdash___dashdash_1.14.1.tgz";
        url  = "https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz";
        sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
      };
    }
    {
      name = "data_urls___data_urls_2.0.0.tgz";
      path = fetchurl {
        name = "data_urls___data_urls_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/data-urls/-/data-urls-2.0.0.tgz";
        sha1 = "156485a72963a970f5d5821aaf642bef2bf2db9b";
      };
    }
    {
      name = "debug___debug_2.6.9.tgz";
      path = fetchurl {
        name = "debug___debug_2.6.9.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha1 = "5d128515df134ff327e90a4c93f4e077a536341f";
      };
    }
    {
      name = "debug___debug_4.3.1.tgz";
      path = fetchurl {
        name = "debug___debug_4.3.1.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-4.3.1.tgz";
        sha1 = "f0d229c505e0c6d8c49ac553d1b13dc183f6b2ee";
      };
    }
    {
      name = "decamelize___decamelize_1.2.0.tgz";
      path = fetchurl {
        name = "decamelize___decamelize_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz";
        sha1 = "f6534d15148269b20352e7bee26f501f9a191290";
      };
    }
    {
      name = "decimal.js___decimal.js_10.2.1.tgz";
      path = fetchurl {
        name = "decimal.js___decimal.js_10.2.1.tgz";
        url  = "https://registry.yarnpkg.com/decimal.js/-/decimal.js-10.2.1.tgz";
        sha1 = "238ae7b0f0c793d3e3cea410108b35a2c01426a3";
      };
    }
    {
      name = "decode_uri_component___decode_uri_component_0.2.0.tgz";
      path = fetchurl {
        name = "decode_uri_component___decode_uri_component_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.0.tgz";
        sha1 = "eb3913333458775cb84cd1a1fae062106bb87545";
      };
    }
    {
      name = "decompress_response___decompress_response_3.3.0.tgz";
      path = fetchurl {
        name = "decompress_response___decompress_response_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/decompress-response/-/decompress-response-3.3.0.tgz";
        sha1 = "80a4dd323748384bfa248083622aedec982adff3";
      };
    }
    {
      name = "deep_extend___deep_extend_0.6.0.tgz";
      path = fetchurl {
        name = "deep_extend___deep_extend_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz";
        sha1 = "c4fa7c95404a17a9c3e8ca7e1537312b736330ac";
      };
    }
    {
      name = "deep_is___deep_is_0.1.3.tgz";
      path = fetchurl {
        name = "deep_is___deep_is_0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.3.tgz";
        sha1 = "b369d6fb5dbc13eecf524f91b070feedc357cf34";
      };
    }
    {
      name = "deepmerge___deepmerge_4.2.2.tgz";
      path = fetchurl {
        name = "deepmerge___deepmerge_4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/deepmerge/-/deepmerge-4.2.2.tgz";
        sha1 = "44d2ea3679b8f4d4ffba33f03d865fc1e7bf4955";
      };
    }
    {
      name = "defer_to_connect___defer_to_connect_1.1.3.tgz";
      path = fetchurl {
        name = "defer_to_connect___defer_to_connect_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-1.1.3.tgz";
        sha1 = "331ae050c08dcf789f8c83a7b81f0ed94f4ac591";
      };
    }
    {
      name = "define_properties___define_properties_1.1.3.tgz";
      path = fetchurl {
        name = "define_properties___define_properties_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.3.tgz";
        sha1 = "cf88da6cbee26fe6db7094f61d870cbd84cee9f1";
      };
    }
    {
      name = "define_property___define_property_0.2.5.tgz";
      path = fetchurl {
        name = "define_property___define_property_0.2.5.tgz";
        url  = "https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz";
        sha1 = "c35b1ef918ec3c990f9a5bc57be04aacec5c8116";
      };
    }
    {
      name = "define_property___define_property_1.0.0.tgz";
      path = fetchurl {
        name = "define_property___define_property_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz";
        sha1 = "769ebaaf3f4a63aad3af9e8d304c9bbe79bfb0e6";
      };
    }
    {
      name = "define_property___define_property_2.0.2.tgz";
      path = fetchurl {
        name = "define_property___define_property_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz";
        sha1 = "d459689e8d654ba77e02a817f8710d702cb16e9d";
      };
    }
    {
      name = "delayed_stream___delayed_stream_1.0.0.tgz";
      path = fetchurl {
        name = "delayed_stream___delayed_stream_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
    }
    {
      name = "detect_newline___detect_newline_3.1.0.tgz";
      path = fetchurl {
        name = "detect_newline___detect_newline_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-newline/-/detect-newline-3.1.0.tgz";
        sha1 = "576f5dfc63ae1a192ff192d8ad3af6308991b651";
      };
    }
    {
      name = "detect_node___detect_node_2.0.4.tgz";
      path = fetchurl {
        name = "detect_node___detect_node_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/detect-node/-/detect-node-2.0.4.tgz";
        sha1 = "014ee8f8f669c5c58023da64b8179c083a28c46c";
      };
    }
    {
      name = "diff_sequences___diff_sequences_26.6.2.tgz";
      path = fetchurl {
        name = "diff_sequences___diff_sequences_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/diff-sequences/-/diff-sequences-26.6.2.tgz";
        sha1 = "48ba99157de1923412eed41db6b6d4aa9ca7c0b1";
      };
    }
    {
      name = "dmg_builder___dmg_builder_22.9.1.tgz";
      path = fetchurl {
        name = "dmg_builder___dmg_builder_22.9.1.tgz";
        url  = "https://registry.yarnpkg.com/dmg-builder/-/dmg-builder-22.9.1.tgz";
        sha1 = "64647224f37ee47fc9bd01947c21cc010a30511f";
      };
    }
    {
      name = "doctrine___doctrine_3.0.0.tgz";
      path = fetchurl {
        name = "doctrine___doctrine_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz";
        sha1 = "addebead72a6574db783639dc87a121773973961";
      };
    }
    {
      name = "domexception___domexception_2.0.1.tgz";
      path = fetchurl {
        name = "domexception___domexception_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/domexception/-/domexception-2.0.1.tgz";
        sha1 = "fb44aefba793e1574b0af6aed2801d057529f304";
      };
    }
    {
      name = "dot_prop___dot_prop_5.3.0.tgz";
      path = fetchurl {
        name = "dot_prop___dot_prop_5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/dot-prop/-/dot-prop-5.3.0.tgz";
        sha1 = "90ccce708cd9cd82cc4dc8c3ddd9abdd55b20e88";
      };
    }
    {
      name = "dotenv_expand___dotenv_expand_5.1.0.tgz";
      path = fetchurl {
        name = "dotenv_expand___dotenv_expand_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/dotenv-expand/-/dotenv-expand-5.1.0.tgz";
        sha1 = "3fbaf020bfd794884072ea26b1e9791d45a629f0";
      };
    }
    {
      name = "dotenv___dotenv_8.2.0.tgz";
      path = fetchurl {
        name = "dotenv___dotenv_8.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dotenv/-/dotenv-8.2.0.tgz";
        sha1 = "97e619259ada750eea3e4ea3e26bceea5424b16a";
      };
    }
    {
      name = "duplexer3___duplexer3_0.1.4.tgz";
      path = fetchurl {
        name = "duplexer3___duplexer3_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.4.tgz";
        sha1 = "ee01dd1cac0ed3cbc7fdbea37dc0a8f1ce002ce2";
      };
    }
    {
      name = "ecc_jsbn___ecc_jsbn_0.1.2.tgz";
      path = fetchurl {
        name = "ecc_jsbn___ecc_jsbn_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz";
        sha1 = "3a83a904e54353287874c564b7549386849a98c9";
      };
    }
    {
      name = "ejs___ejs_3.1.5.tgz";
      path = fetchurl {
        name = "ejs___ejs_3.1.5.tgz";
        url  = "https://registry.yarnpkg.com/ejs/-/ejs-3.1.5.tgz";
        sha1 = "aed723844dc20acb4b170cd9ab1017e476a0d93b";
      };
    }
    {
      name = "electron_builder___electron_builder_22.9.1.tgz";
      path = fetchurl {
        name = "electron_builder___electron_builder_22.9.1.tgz";
        url  = "https://registry.yarnpkg.com/electron-builder/-/electron-builder-22.9.1.tgz";
        sha1 = "a2962db6f2757bc01d02489f38fafe0809f68f60";
      };
    }
    {
      name = "electron_publish___electron_publish_22.9.1.tgz";
      path = fetchurl {
        name = "electron_publish___electron_publish_22.9.1.tgz";
        url  = "https://registry.yarnpkg.com/electron-publish/-/electron-publish-22.9.1.tgz";
        sha1 = "7cc76ac4cc53efd29ee31c1e5facb9724329068e";
      };
    }
    {
      name = "electron___electron_11.1.0.tgz";
      path = fetchurl {
        name = "electron___electron_11.1.0.tgz";
        url  = "https://registry.yarnpkg.com/electron/-/electron-11.1.0.tgz";
        sha1 = "8dfdf579d1eb79feef3e3d2937fc022e72129c90";
      };
    }
    {
      name = "emittery___emittery_0.7.2.tgz";
      path = fetchurl {
        name = "emittery___emittery_0.7.2.tgz";
        url  = "https://registry.yarnpkg.com/emittery/-/emittery-0.7.2.tgz";
        sha1 = "25595908e13af0f5674ab419396e2fb394cdfa82";
      };
    }
    {
      name = "emoji_regex___emoji_regex_7.0.3.tgz";
      path = fetchurl {
        name = "emoji_regex___emoji_regex_7.0.3.tgz";
        url  = "https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-7.0.3.tgz";
        sha1 = "933a04052860c85e83c122479c4748a8e4c72156";
      };
    }
    {
      name = "emoji_regex___emoji_regex_8.0.0.tgz";
      path = fetchurl {
        name = "emoji_regex___emoji_regex_8.0.0.tgz";
        url  = "https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz";
        sha1 = "e818fd69ce5ccfcb404594f842963bf53164cc37";
      };
    }
    {
      name = "encodeurl___encodeurl_1.0.2.tgz";
      path = fetchurl {
        name = "encodeurl___encodeurl_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz";
        sha1 = "ad3ff4c86ec2d029322f5a02c3a9a606c95b3f59";
      };
    }
    {
      name = "end_of_stream___end_of_stream_1.4.4.tgz";
      path = fetchurl {
        name = "end_of_stream___end_of_stream_1.4.4.tgz";
        url  = "https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz";
        sha1 = "5ae64a5f45057baf3626ec14da0ca5e4b2431eb0";
      };
    }
    {
      name = "enquirer___enquirer_2.3.6.tgz";
      path = fetchurl {
        name = "enquirer___enquirer_2.3.6.tgz";
        url  = "https://registry.yarnpkg.com/enquirer/-/enquirer-2.3.6.tgz";
        sha1 = "2a7fe5dd634a1e4125a975ec994ff5456dc3734d";
      };
    }
    {
      name = "env_paths___env_paths_2.2.0.tgz";
      path = fetchurl {
        name = "env_paths___env_paths_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.0.tgz";
        sha1 = "cdca557dc009152917d6166e2febe1f039685e43";
      };
    }
    {
      name = "error_ex___error_ex_1.3.2.tgz";
      path = fetchurl {
        name = "error_ex___error_ex_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz";
        sha1 = "b4ac40648107fdcdcfae242f428bea8a14d4f1bf";
      };
    }
    {
      name = "es6_error___es6_error_4.1.1.tgz";
      path = fetchurl {
        name = "es6_error___es6_error_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz";
        sha1 = "9e3af407459deed47e9a91f9b885a84eb05c561d";
      };
    }
    {
      name = "escalade___escalade_3.1.1.tgz";
      path = fetchurl {
        name = "escalade___escalade_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz";
        sha1 = "d8cfdc7000965c5a0174b4a82eaa5c0552742e40";
      };
    }
    {
      name = "escape_goat___escape_goat_2.1.1.tgz";
      path = fetchurl {
        name = "escape_goat___escape_goat_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/escape-goat/-/escape-goat-2.1.1.tgz";
        sha1 = "1b2dc77003676c457ec760b2dc68edb648188675";
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_2.0.0.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz";
        sha1 = "a30304e99daa32e23b2fd20f51babd07cffca344";
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_4.0.0.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz";
        sha1 = "14ba83a5d373e3d311e5afca29cf5bfad965bf34";
      };
    }
    {
      name = "escodegen___escodegen_1.14.3.tgz";
      path = fetchurl {
        name = "escodegen___escodegen_1.14.3.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.14.3.tgz";
        sha1 = "4e7b81fba61581dc97582ed78cab7f0e8d63f503";
      };
    }
    {
      name = "eslint_scope___eslint_scope_5.1.1.tgz";
      path = fetchurl {
        name = "eslint_scope___eslint_scope_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz";
        sha1 = "e786e59a66cb92b3f6c1fb0d508aab174848f48c";
      };
    }
    {
      name = "eslint_utils___eslint_utils_2.1.0.tgz";
      path = fetchurl {
        name = "eslint_utils___eslint_utils_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz";
        sha1 = "d2de5e03424e707dc10c74068ddedae708741b27";
      };
    }
    {
      name = "eslint_visitor_keys___eslint_visitor_keys_1.3.0.tgz";
      path = fetchurl {
        name = "eslint_visitor_keys___eslint_visitor_keys_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz";
        sha1 = "30ebd1ef7c2fdff01c3a4f151044af25fab0523e";
      };
    }
    {
      name = "eslint_visitor_keys___eslint_visitor_keys_2.0.0.tgz";
      path = fetchurl {
        name = "eslint_visitor_keys___eslint_visitor_keys_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.0.0.tgz";
        sha1 = "21fdc8fbcd9c795cc0321f0563702095751511a8";
      };
    }
    {
      name = "eslint___eslint_7.15.0.tgz";
      path = fetchurl {
        name = "eslint___eslint_7.15.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint/-/eslint-7.15.0.tgz";
        sha1 = "eb155fb8ed0865fcf5d903f76be2e5b6cd7e0bc7";
      };
    }
    {
      name = "espree___espree_7.3.1.tgz";
      path = fetchurl {
        name = "espree___espree_7.3.1.tgz";
        url  = "https://registry.yarnpkg.com/espree/-/espree-7.3.1.tgz";
        sha1 = "f2df330b752c6f55019f8bd89b7660039c1bbbb6";
      };
    }
    {
      name = "esprima___esprima_4.0.1.tgz";
      path = fetchurl {
        name = "esprima___esprima_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz";
        sha1 = "13b04cdb3e6c5d19df91ab6987a8695619b0aa71";
      };
    }
    {
      name = "esquery___esquery_1.3.1.tgz";
      path = fetchurl {
        name = "esquery___esquery_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/esquery/-/esquery-1.3.1.tgz";
        sha1 = "b78b5828aa8e214e29fb74c4d5b752e1c033da57";
      };
    }
    {
      name = "esrecurse___esrecurse_4.3.0.tgz";
      path = fetchurl {
        name = "esrecurse___esrecurse_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz";
        sha1 = "7ad7964d679abb28bee72cec63758b1c5d2c9921";
      };
    }
    {
      name = "estraverse___estraverse_4.3.0.tgz";
      path = fetchurl {
        name = "estraverse___estraverse_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz";
        sha1 = "398ad3f3c5a24948be7725e83d11a7de28cdbd1d";
      };
    }
    {
      name = "estraverse___estraverse_5.2.0.tgz";
      path = fetchurl {
        name = "estraverse___estraverse_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-5.2.0.tgz";
        sha1 = "307df42547e6cc7324d3cf03c155d5cdb8c53880";
      };
    }
    {
      name = "esutils___esutils_2.0.3.tgz";
      path = fetchurl {
        name = "esutils___esutils_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz";
        sha1 = "74d2eb4de0b8da1293711910d50775b9b710ef64";
      };
    }
    {
      name = "exec_sh___exec_sh_0.3.4.tgz";
      path = fetchurl {
        name = "exec_sh___exec_sh_0.3.4.tgz";
        url  = "https://registry.yarnpkg.com/exec-sh/-/exec-sh-0.3.4.tgz";
        sha1 = "3a018ceb526cc6f6df2bb504b2bfe8e3a4934ec5";
      };
    }
    {
      name = "execa___execa_1.0.0.tgz";
      path = fetchurl {
        name = "execa___execa_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-1.0.0.tgz";
        sha1 = "c6236a5bb4df6d6f15e88e7f017798216749ddd8";
      };
    }
    {
      name = "execa___execa_4.1.0.tgz";
      path = fetchurl {
        name = "execa___execa_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-4.1.0.tgz";
        sha1 = "4e5491ad1572f2f17a77d388c6c857135b22847a";
      };
    }
    {
      name = "exit_on_epipe___exit_on_epipe_1.0.1.tgz";
      path = fetchurl {
        name = "exit_on_epipe___exit_on_epipe_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/exit-on-epipe/-/exit-on-epipe-1.0.1.tgz";
        sha1 = "0bdd92e87d5285d267daa8171d0eb06159689692";
      };
    }
    {
      name = "exit___exit_0.1.2.tgz";
      path = fetchurl {
        name = "exit___exit_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/exit/-/exit-0.1.2.tgz";
        sha1 = "0632638f8d877cc82107d30a0fff1a17cba1cd0c";
      };
    }
    {
      name = "expand_brackets___expand_brackets_2.1.4.tgz";
      path = fetchurl {
        name = "expand_brackets___expand_brackets_2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz";
        sha1 = "b77735e315ce30f6b6eff0f83b04151a22449622";
      };
    }
    {
      name = "expect___expect_26.6.2.tgz";
      path = fetchurl {
        name = "expect___expect_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/expect/-/expect-26.6.2.tgz";
        sha1 = "c6b996bf26bf3fe18b67b2d0f51fc981ba934417";
      };
    }
    {
      name = "extend_shallow___extend_shallow_2.0.1.tgz";
      path = fetchurl {
        name = "extend_shallow___extend_shallow_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz";
        sha1 = "51af7d614ad9a9f610ea1bafbb989d6b1c56890f";
      };
    }
    {
      name = "extend_shallow___extend_shallow_3.0.2.tgz";
      path = fetchurl {
        name = "extend_shallow___extend_shallow_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz";
        sha1 = "26a71aaf073b39fb2127172746131c2704028db8";
      };
    }
    {
      name = "extend___extend_3.0.2.tgz";
      path = fetchurl {
        name = "extend___extend_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz";
        sha1 = "f8b1136b4071fbd8eb140aff858b1019ec2915fa";
      };
    }
    {
      name = "extglob___extglob_2.0.4.tgz";
      path = fetchurl {
        name = "extglob___extglob_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz";
        sha1 = "ad00fe4dc612a9232e8718711dc5cb5ab0285543";
      };
    }
    {
      name = "extract_zip___extract_zip_1.7.0.tgz";
      path = fetchurl {
        name = "extract_zip___extract_zip_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.7.0.tgz";
        sha1 = "556cc3ae9df7f452c493a0cfb51cc30277940927";
      };
    }
    {
      name = "extsprintf___extsprintf_1.3.0.tgz";
      path = fetchurl {
        name = "extsprintf___extsprintf_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.3.0.tgz";
        sha1 = "96918440e3041a7a414f8c52e3c574eb3c3e1e05";
      };
    }
    {
      name = "extsprintf___extsprintf_1.4.0.tgz";
      path = fetchurl {
        name = "extsprintf___extsprintf_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.0.tgz";
        sha1 = "e2689f8f356fad62cca65a3a91c5df5f9551692f";
      };
    }
    {
      name = "fast_deep_equal___fast_deep_equal_3.1.3.tgz";
      path = fetchurl {
        name = "fast_deep_equal___fast_deep_equal_3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz";
        sha1 = "3a7d56b559d6cbc3eb512325244e619a65c6c525";
      };
    }
    {
      name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
      path = fetchurl {
        name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz";
        sha1 = "874bf69c6f404c2b5d99c481341399fd55892633";
      };
    }
    {
      name = "fast_levenshtein___fast_levenshtein_2.0.6.tgz";
      path = fetchurl {
        name = "fast_levenshtein___fast_levenshtein_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz";
        sha1 = "3d8a5c66883a16a30ca8643e851f19baa7797917";
      };
    }
    {
      name = "fb_watchman___fb_watchman_2.0.1.tgz";
      path = fetchurl {
        name = "fb_watchman___fb_watchman_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fb-watchman/-/fb-watchman-2.0.1.tgz";
        sha1 = "fc84fb39d2709cf3ff6d743706157bb5708a8a85";
      };
    }
    {
      name = "fd_slicer___fd_slicer_1.1.0.tgz";
      path = fetchurl {
        name = "fd_slicer___fd_slicer_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz";
        sha1 = "25c7c89cb1f9077f8891bbe61d8f390eae256f1e";
      };
    }
    {
      name = "file_entry_cache___file_entry_cache_6.0.0.tgz";
      path = fetchurl {
        name = "file_entry_cache___file_entry_cache_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.0.tgz";
        sha1 = "7921a89c391c6d93efec2169ac6bf300c527ea0a";
      };
    }
    {
      name = "filelist___filelist_1.0.1.tgz";
      path = fetchurl {
        name = "filelist___filelist_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/filelist/-/filelist-1.0.1.tgz";
        sha1 = "f10d1a3ae86c1694808e8f20906f43d4c9132dbb";
      };
    }
    {
      name = "fill_range___fill_range_4.0.0.tgz";
      path = fetchurl {
        name = "fill_range___fill_range_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz";
        sha1 = "d544811d428f98eb06a63dc402d2403c328c38f7";
      };
    }
    {
      name = "fill_range___fill_range_7.0.1.tgz";
      path = fetchurl {
        name = "fill_range___fill_range_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz";
        sha1 = "1919a6a7c75fe38b2c7c77e5198535da9acdda40";
      };
    }
    {
      name = "find_up___find_up_4.1.0.tgz";
      path = fetchurl {
        name = "find_up___find_up_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz";
        sha1 = "97afe7d6cdc0bc5928584b7c8d7b16e8a9aa5d19";
      };
    }
    {
      name = "flat_cache___flat_cache_3.0.4.tgz";
      path = fetchurl {
        name = "flat_cache___flat_cache_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz";
        sha1 = "61b0338302b2fe9f957dcc32fc2a87f1c3048b11";
      };
    }
    {
      name = "flatted___flatted_3.1.0.tgz";
      path = fetchurl {
        name = "flatted___flatted_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/flatted/-/flatted-3.1.0.tgz";
        sha1 = "a5d06b4a8b01e3a63771daa5cb7a1903e2e57067";
      };
    }
    {
      name = "for_in___for_in_1.0.2.tgz";
      path = fetchurl {
        name = "for_in___for_in_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz";
        sha1 = "81068d295a8142ec0ac726c6e2200c30fb6d5e80";
      };
    }
    {
      name = "forever_agent___forever_agent_0.6.1.tgz";
      path = fetchurl {
        name = "forever_agent___forever_agent_0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
    }
    {
      name = "form_data___form_data_2.3.3.tgz";
      path = fetchurl {
        name = "form_data___form_data_2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.3.3.tgz";
        sha1 = "dcce52c05f644f298c6a7ab936bd724ceffbf3a6";
      };
    }
    {
      name = "fragment_cache___fragment_cache_0.2.1.tgz";
      path = fetchurl {
        name = "fragment_cache___fragment_cache_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz";
        sha1 = "4290fad27f13e89be7f33799c6bc5a0abfff0d19";
      };
    }
    {
      name = "fs_constants___fs_constants_1.0.0.tgz";
      path = fetchurl {
        name = "fs_constants___fs_constants_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-constants/-/fs-constants-1.0.0.tgz";
        sha1 = "6be0de9be998ce16af8afc24497b9ee9b7ccd9ad";
      };
    }
    {
      name = "fs_extra___fs_extra_8.1.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_8.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz";
        sha1 = "49d43c45a88cd9677668cb7be1b46efdb8d2e1c0";
      };
    }
    {
      name = "fs_extra___fs_extra_9.0.1.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_9.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.0.1.tgz";
        sha1 = "910da0062437ba4c39fedd863f1675ccfefcb9fc";
      };
    }
    {
      name = "fs.realpath___fs.realpath_1.0.0.tgz";
      path = fetchurl {
        name = "fs.realpath___fs.realpath_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
      };
    }
    {
      name = "fsevents___fsevents_2.2.1.tgz";
      path = fetchurl {
        name = "fsevents___fsevents_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-2.2.1.tgz";
        sha1 = "1fb02ded2036a8ac288d507a65962bd87b97628d";
      };
    }
    {
      name = "function_bind___function_bind_1.1.1.tgz";
      path = fetchurl {
        name = "function_bind___function_bind_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
        sha1 = "a56899d3ea3c9bab874bb9773b7c5ede92f4895d";
      };
    }
    {
      name = "functional_red_black_tree___functional_red_black_tree_1.0.1.tgz";
      path = fetchurl {
        name = "functional_red_black_tree___functional_red_black_tree_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz";
        sha1 = "1b0ab3bd553b2a0d6399d29c0e3ea0b252078327";
      };
    }
    {
      name = "gensync___gensync_1.0.0_beta.2.tgz";
      path = fetchurl {
        name = "gensync___gensync_1.0.0_beta.2.tgz";
        url  = "https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz";
        sha1 = "32a6ee76c3d7f52d46b2b1ae5d93fea8580a25e0";
      };
    }
    {
      name = "get_caller_file___get_caller_file_2.0.5.tgz";
      path = fetchurl {
        name = "get_caller_file___get_caller_file_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz";
        sha1 = "4f94412a82db32f36e3b0b9741f8a97feb031f7e";
      };
    }
    {
      name = "get_package_type___get_package_type_0.1.0.tgz";
      path = fetchurl {
        name = "get_package_type___get_package_type_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/get-package-type/-/get-package-type-0.1.0.tgz";
        sha1 = "8de2d803cff44df3bc6c456e6668b36c3926e11a";
      };
    }
    {
      name = "get_stream___get_stream_4.1.0.tgz";
      path = fetchurl {
        name = "get_stream___get_stream_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-4.1.0.tgz";
        sha1 = "c1b255575f3dc21d59bfc79cd3d2b46b1c3a54b5";
      };
    }
    {
      name = "get_stream___get_stream_5.2.0.tgz";
      path = fetchurl {
        name = "get_stream___get_stream_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz";
        sha1 = "4966a1795ee5ace65e706c4b7beb71257d6e22d3";
      };
    }
    {
      name = "get_value___get_value_2.0.6.tgz";
      path = fetchurl {
        name = "get_value___get_value_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz";
        sha1 = "dc15ca1c672387ca76bd37ac0a395ba2042a2c28";
      };
    }
    {
      name = "getpass___getpass_0.1.7.tgz";
      path = fetchurl {
        name = "getpass___getpass_0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/getpass/-/getpass-0.1.7.tgz";
        sha1 = "5eff8e3e684d569ae4cb2b1282604e8ba62149fa";
      };
    }
    {
      name = "glob_parent___glob_parent_5.1.1.tgz";
      path = fetchurl {
        name = "glob_parent___glob_parent_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.1.tgz";
        sha1 = "b6c1ef417c4e5663ea498f1c45afac6916bbc229";
      };
    }
    {
      name = "glob___glob_7.1.6.tgz";
      path = fetchurl {
        name = "glob___glob_7.1.6.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.6.tgz";
        sha1 = "141f33b81a7c2492e125594307480c46679278a6";
      };
    }
    {
      name = "global_agent___global_agent_2.1.12.tgz";
      path = fetchurl {
        name = "global_agent___global_agent_2.1.12.tgz";
        url  = "https://registry.yarnpkg.com/global-agent/-/global-agent-2.1.12.tgz";
        sha1 = "e4ae3812b731a9e81cbf825f9377ef450a8e4195";
      };
    }
    {
      name = "global_dirs___global_dirs_2.0.1.tgz";
      path = fetchurl {
        name = "global_dirs___global_dirs_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/global-dirs/-/global-dirs-2.0.1.tgz";
        sha1 = "acdf3bb6685bcd55cb35e8a052266569e9469201";
      };
    }
    {
      name = "global_tunnel_ng___global_tunnel_ng_2.7.1.tgz";
      path = fetchurl {
        name = "global_tunnel_ng___global_tunnel_ng_2.7.1.tgz";
        url  = "https://registry.yarnpkg.com/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz";
        sha1 = "d03b5102dfde3a69914f5ee7d86761ca35d57d8f";
      };
    }
    {
      name = "globals___globals_11.12.0.tgz";
      path = fetchurl {
        name = "globals___globals_11.12.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz";
        sha1 = "ab8795338868a0babd8525758018c2a7eb95c42e";
      };
    }
    {
      name = "globals___globals_12.4.0.tgz";
      path = fetchurl {
        name = "globals___globals_12.4.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-12.4.0.tgz";
        sha1 = "a18813576a41b00a24a97e7f815918c2e19925f8";
      };
    }
    {
      name = "globalthis___globalthis_1.0.1.tgz";
      path = fetchurl {
        name = "globalthis___globalthis_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.1.tgz";
        sha1 = "40116f5d9c071f9e8fb0037654df1ab3a83b7ef9";
      };
    }
    {
      name = "got___got_9.6.0.tgz";
      path = fetchurl {
        name = "got___got_9.6.0.tgz";
        url  = "https://registry.yarnpkg.com/got/-/got-9.6.0.tgz";
        sha1 = "edf45e7d67f99545705de1f7bbeeeb121765ed85";
      };
    }
    {
      name = "graceful_fs___graceful_fs_4.2.4.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.4.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.4.tgz";
        sha1 = "2256bde14d3632958c465ebc96dc467ca07a29fb";
      };
    }
    {
      name = "growly___growly_1.3.0.tgz";
      path = fetchurl {
        name = "growly___growly_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/growly/-/growly-1.3.0.tgz";
        sha1 = "f10748cbe76af964b7c96c93c6bcc28af120c081";
      };
    }
    {
      name = "har_schema___har_schema_2.0.0.tgz";
      path = fetchurl {
        name = "har_schema___har_schema_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/har-schema/-/har-schema-2.0.0.tgz";
        sha1 = "a94c2224ebcac04782a0d9035521f24735b7ec92";
      };
    }
    {
      name = "har_validator___har_validator_5.1.5.tgz";
      path = fetchurl {
        name = "har_validator___har_validator_5.1.5.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-5.1.5.tgz";
        sha1 = "1f0803b9f8cb20c0fa13822df1ecddb36bde1efd";
      };
    }
    {
      name = "has_flag___has_flag_3.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz";
        sha1 = "b5d454dc2199ae225699f3467e5a07f3b955bafd";
      };
    }
    {
      name = "has_flag___has_flag_4.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz";
        sha1 = "944771fd9c81c81265c4d6941860da06bb59479b";
      };
    }
    {
      name = "has_value___has_value_0.3.1.tgz";
      path = fetchurl {
        name = "has_value___has_value_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz";
        sha1 = "7b1f58bada62ca827ec0a2078025654845995e1f";
      };
    }
    {
      name = "has_value___has_value_1.0.0.tgz";
      path = fetchurl {
        name = "has_value___has_value_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz";
        sha1 = "18b281da585b1c5c51def24c930ed29a0be6b177";
      };
    }
    {
      name = "has_values___has_values_0.1.4.tgz";
      path = fetchurl {
        name = "has_values___has_values_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz";
        sha1 = "6d61de95d91dfca9b9a02089ad384bff8f62b771";
      };
    }
    {
      name = "has_values___has_values_1.0.0.tgz";
      path = fetchurl {
        name = "has_values___has_values_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz";
        sha1 = "95b0b63fec2146619a6fe57fe75628d5a39efe4f";
      };
    }
    {
      name = "has_yarn___has_yarn_2.1.0.tgz";
      path = fetchurl {
        name = "has_yarn___has_yarn_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/has-yarn/-/has-yarn-2.1.0.tgz";
        sha1 = "137e11354a7b5bf11aa5cb649cf0c6f3ff2b2e77";
      };
    }
    {
      name = "has___has_1.0.3.tgz";
      path = fetchurl {
        name = "has___has_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has/-/has-1.0.3.tgz";
        sha1 = "722d7cbfc1f6aa8241f16dd814e011e1f41e8796";
      };
    }
    {
      name = "hosted_git_info___hosted_git_info_2.8.8.tgz";
      path = fetchurl {
        name = "hosted_git_info___hosted_git_info_2.8.8.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.8.tgz";
        sha1 = "7539bd4bc1e0e0a895815a2e0262420b12858488";
      };
    }
    {
      name = "hosted_git_info___hosted_git_info_3.0.7.tgz";
      path = fetchurl {
        name = "hosted_git_info___hosted_git_info_3.0.7.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-3.0.7.tgz";
        sha1 = "a30727385ea85acfcee94e0aad9e368c792e036c";
      };
    }
    {
      name = "html_comment_regex___html_comment_regex_1.1.2.tgz";
      path = fetchurl {
        name = "html_comment_regex___html_comment_regex_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/html-comment-regex/-/html-comment-regex-1.1.2.tgz";
        sha1 = "97d4688aeb5c81886a364faa0cad1dda14d433a7";
      };
    }
    {
      name = "html_encoding_sniffer___html_encoding_sniffer_2.0.1.tgz";
      path = fetchurl {
        name = "html_encoding_sniffer___html_encoding_sniffer_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/html-encoding-sniffer/-/html-encoding-sniffer-2.0.1.tgz";
        sha1 = "42a6dc4fd33f00281176e8b23759ca4e4fa185f3";
      };
    }
    {
      name = "html_escaper___html_escaper_2.0.2.tgz";
      path = fetchurl {
        name = "html_escaper___html_escaper_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/html-escaper/-/html-escaper-2.0.2.tgz";
        sha1 = "dfd60027da36a36dfcbe236262c00a5822681453";
      };
    }
    {
      name = "http_cache_semantics___http_cache_semantics_4.1.0.tgz";
      path = fetchurl {
        name = "http_cache_semantics___http_cache_semantics_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.0.tgz";
        sha1 = "49e91c5cbf36c9b94bcfcd71c23d5249ec74e390";
      };
    }
    {
      name = "http_signature___http_signature_1.2.0.tgz";
      path = fetchurl {
        name = "http_signature___http_signature_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz";
        sha1 = "9aecd925114772f3d95b65a60abb8f7c18fbace1";
      };
    }
    {
      name = "human_signals___human_signals_1.1.1.tgz";
      path = fetchurl {
        name = "human_signals___human_signals_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/human-signals/-/human-signals-1.1.1.tgz";
        sha1 = "c5b1cd14f50aeae09ab6c59fe63ba3395fe4dfa3";
      };
    }
    {
      name = "iconv_lite___iconv_lite_0.4.24.tgz";
      path = fetchurl {
        name = "iconv_lite___iconv_lite_0.4.24.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz";
        sha1 = "2022b4b25fbddc21d2f524974a474aafe733908b";
      };
    }
    {
      name = "iconv_lite___iconv_lite_0.6.2.tgz";
      path = fetchurl {
        name = "iconv_lite___iconv_lite_0.6.2.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.2.tgz";
        sha1 = "ce13d1875b0c3a674bd6a04b7f76b01b1b6ded01";
      };
    }
    {
      name = "ieee754___ieee754_1.2.1.tgz";
      path = fetchurl {
        name = "ieee754___ieee754_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz";
        sha1 = "8eb7a10a63fff25d15a57b001586d177d1b0d352";
      };
    }
    {
      name = "ignore___ignore_4.0.6.tgz";
      path = fetchurl {
        name = "ignore___ignore_4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/ignore/-/ignore-4.0.6.tgz";
        sha1 = "750e3db5862087b4737ebac8207ffd1ef27b25fc";
      };
    }
    {
      name = "import_fresh___import_fresh_3.2.2.tgz";
      path = fetchurl {
        name = "import_fresh___import_fresh_3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.2.2.tgz";
        sha1 = "fc129c160c5d68235507f4331a6baad186bdbc3e";
      };
    }
    {
      name = "import_lazy___import_lazy_2.1.0.tgz";
      path = fetchurl {
        name = "import_lazy___import_lazy_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/import-lazy/-/import-lazy-2.1.0.tgz";
        sha1 = "05698e3d45c88e8d7e9d92cb0584e77f096f3e43";
      };
    }
    {
      name = "import_local___import_local_3.0.2.tgz";
      path = fetchurl {
        name = "import_local___import_local_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/import-local/-/import-local-3.0.2.tgz";
        sha1 = "a8cfd0431d1de4a2199703d003e3e62364fa6db6";
      };
    }
    {
      name = "imurmurhash___imurmurhash_0.1.4.tgz";
      path = fetchurl {
        name = "imurmurhash___imurmurhash_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz";
        sha1 = "9218b9b2b928a238b13dc4fb6b6d576f231453ea";
      };
    }
    {
      name = "inflight___inflight_1.0.6.tgz";
      path = fetchurl {
        name = "inflight___inflight_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    }
    {
      name = "inherits___inherits_2.0.4.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz";
        sha1 = "0fa2c64f932917c3433a0ded55363aae37416b7c";
      };
    }
    {
      name = "ini___ini_1.3.8.tgz";
      path = fetchurl {
        name = "ini___ini_1.3.8.tgz";
        url  = "https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz";
        sha1 = "a29da425b48806f34767a4efce397269af28432c";
      };
    }
    {
      name = "ip_regex___ip_regex_2.1.0.tgz";
      path = fetchurl {
        name = "ip_regex___ip_regex_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ip-regex/-/ip-regex-2.1.0.tgz";
        sha1 = "fa78bf5d2e6913c911ce9f819ee5146bb6d844e9";
      };
    }
    {
      name = "is_accessor_descriptor___is_accessor_descriptor_0.1.6.tgz";
      path = fetchurl {
        name = "is_accessor_descriptor___is_accessor_descriptor_0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz";
        sha1 = "a9e12cb3ae8d876727eeef3843f8a0897b5c98d6";
      };
    }
    {
      name = "is_accessor_descriptor___is_accessor_descriptor_1.0.0.tgz";
      path = fetchurl {
        name = "is_accessor_descriptor___is_accessor_descriptor_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz";
        sha1 = "169c2f6d3df1f992618072365c9b0ea1f6878656";
      };
    }
    {
      name = "is_arrayish___is_arrayish_0.2.1.tgz";
      path = fetchurl {
        name = "is_arrayish___is_arrayish_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz";
        sha1 = "77c99840527aa8ecb1a8ba697b80645a7a926a9d";
      };
    }
    {
      name = "is_buffer___is_buffer_1.1.6.tgz";
      path = fetchurl {
        name = "is_buffer___is_buffer_1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz";
        sha1 = "efaa2ea9daa0d7ab2ea13a97b2b8ad51fefbe8be";
      };
    }
    {
      name = "is_ci___is_ci_2.0.0.tgz";
      path = fetchurl {
        name = "is_ci___is_ci_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz";
        sha1 = "6bc6334181810e04b5c22b3d589fdca55026404c";
      };
    }
    {
      name = "is_core_module___is_core_module_2.2.0.tgz";
      path = fetchurl {
        name = "is_core_module___is_core_module_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.2.0.tgz";
        sha1 = "97037ef3d52224d85163f5597b2b63d9afed981a";
      };
    }
    {
      name = "is_data_descriptor___is_data_descriptor_0.1.4.tgz";
      path = fetchurl {
        name = "is_data_descriptor___is_data_descriptor_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz";
        sha1 = "0b5ee648388e2c860282e793f1856fec3f301b56";
      };
    }
    {
      name = "is_data_descriptor___is_data_descriptor_1.0.0.tgz";
      path = fetchurl {
        name = "is_data_descriptor___is_data_descriptor_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz";
        sha1 = "d84876321d0e7add03990406abbbbd36ba9268c7";
      };
    }
    {
      name = "is_descriptor___is_descriptor_0.1.6.tgz";
      path = fetchurl {
        name = "is_descriptor___is_descriptor_0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz";
        sha1 = "366d8240dde487ca51823b1ab9f07a10a78251ca";
      };
    }
    {
      name = "is_descriptor___is_descriptor_1.0.2.tgz";
      path = fetchurl {
        name = "is_descriptor___is_descriptor_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz";
        sha1 = "3b159746a66604b04f8c81524ba365c5f14d86ec";
      };
    }
    {
      name = "is_docker___is_docker_2.1.1.tgz";
      path = fetchurl {
        name = "is_docker___is_docker_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-docker/-/is-docker-2.1.1.tgz";
        sha1 = "4125a88e44e450d384e09047ede71adc2d144156";
      };
    }
    {
      name = "is_extendable___is_extendable_0.1.1.tgz";
      path = fetchurl {
        name = "is_extendable___is_extendable_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz";
        sha1 = "62b110e289a471418e3ec36a617d472e301dfc89";
      };
    }
    {
      name = "is_extendable___is_extendable_1.0.1.tgz";
      path = fetchurl {
        name = "is_extendable___is_extendable_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz";
        sha1 = "a7470f9e426733d81bd81e1155264e3a3507cab4";
      };
    }
    {
      name = "is_extglob___is_extglob_2.1.1.tgz";
      path = fetchurl {
        name = "is_extglob___is_extglob_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz";
        sha1 = "a88c02535791f02ed37c76a1b9ea9773c833f8c2";
      };
    }
    {
      name = "is_fullwidth_code_point___is_fullwidth_code_point_2.0.0.tgz";
      path = fetchurl {
        name = "is_fullwidth_code_point___is_fullwidth_code_point_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz";
        sha1 = "a3b30a5c4f199183167aaab93beefae3ddfb654f";
      };
    }
    {
      name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
      path = fetchurl {
        name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz";
        sha1 = "f116f8064fe90b3f7844a38997c0b75051269f1d";
      };
    }
    {
      name = "is_generator_fn___is_generator_fn_2.1.0.tgz";
      path = fetchurl {
        name = "is_generator_fn___is_generator_fn_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-generator-fn/-/is-generator-fn-2.1.0.tgz";
        sha1 = "7d140adc389aaf3011a8f2a2a4cfa6faadffb118";
      };
    }
    {
      name = "is_glob___is_glob_4.0.1.tgz";
      path = fetchurl {
        name = "is_glob___is_glob_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.1.tgz";
        sha1 = "7567dbe9f2f5e2467bc77ab83c4a29482407a5dc";
      };
    }
    {
      name = "is_installed_globally___is_installed_globally_0.3.2.tgz";
      path = fetchurl {
        name = "is_installed_globally___is_installed_globally_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.3.2.tgz";
        sha1 = "fd3efa79ee670d1187233182d5b0a1dd00313141";
      };
    }
    {
      name = "is_npm___is_npm_4.0.0.tgz";
      path = fetchurl {
        name = "is_npm___is_npm_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-npm/-/is-npm-4.0.0.tgz";
        sha1 = "c90dd8380696df87a7a6d823c20d0b12bbe3c84d";
      };
    }
    {
      name = "is_number___is_number_3.0.0.tgz";
      path = fetchurl {
        name = "is_number___is_number_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz";
        sha1 = "24fd6201a4782cf50561c810276afc7d12d71195";
      };
    }
    {
      name = "is_number___is_number_7.0.0.tgz";
      path = fetchurl {
        name = "is_number___is_number_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz";
        sha1 = "7535345b896734d5f80c4d06c50955527a14f12b";
      };
    }
    {
      name = "is_obj___is_obj_2.0.0.tgz";
      path = fetchurl {
        name = "is_obj___is_obj_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-obj/-/is-obj-2.0.0.tgz";
        sha1 = "473fb05d973705e3fd9620545018ca8e22ef4982";
      };
    }
    {
      name = "is_path_inside___is_path_inside_3.0.2.tgz";
      path = fetchurl {
        name = "is_path_inside___is_path_inside_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.2.tgz";
        sha1 = "f5220fc82a3e233757291dddc9c5877f2a1f3017";
      };
    }
    {
      name = "is_plain_object___is_plain_object_2.0.4.tgz";
      path = fetchurl {
        name = "is_plain_object___is_plain_object_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz";
        sha1 = "2c163b3fafb1b606d9d17928f05c2a1c38e07677";
      };
    }
    {
      name = "is_potential_custom_element_name___is_potential_custom_element_name_1.0.0.tgz";
      path = fetchurl {
        name = "is_potential_custom_element_name___is_potential_custom_element_name_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.0.tgz";
        sha1 = "0c52e54bcca391bb2c494b21e8626d7336c6e397";
      };
    }
    {
      name = "is_stream___is_stream_1.1.0.tgz";
      path = fetchurl {
        name = "is_stream___is_stream_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz";
        sha1 = "12d4a3dd4e68e0b79ceb8dbc84173ae80d91ca44";
      };
    }
    {
      name = "is_stream___is_stream_2.0.0.tgz";
      path = fetchurl {
        name = "is_stream___is_stream_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.0.tgz";
        sha1 = "bde9c32680d6fae04129d6ac9d921ce7815f78e3";
      };
    }
    {
      name = "is_svg___is_svg_4.2.1.tgz";
      path = fetchurl {
        name = "is_svg___is_svg_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-svg/-/is-svg-4.2.1.tgz";
        sha1 = "095b496e345fec9211c2a7d5d021003e040d6f81";
      };
    }
    {
      name = "is_typedarray___is_typedarray_1.0.0.tgz";
      path = fetchurl {
        name = "is_typedarray___is_typedarray_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz";
        sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
      };
    }
    {
      name = "is_windows___is_windows_1.0.2.tgz";
      path = fetchurl {
        name = "is_windows___is_windows_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz";
        sha1 = "d1850eb9791ecd18e6182ce12a30f396634bb19d";
      };
    }
    {
      name = "is_wsl___is_wsl_2.2.0.tgz";
      path = fetchurl {
        name = "is_wsl___is_wsl_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/is-wsl/-/is-wsl-2.2.0.tgz";
        sha1 = "74a4c76e77ca9fd3f932f290c17ea326cd157271";
      };
    }
    {
      name = "is_yarn_global___is_yarn_global_0.3.0.tgz";
      path = fetchurl {
        name = "is_yarn_global___is_yarn_global_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/is-yarn-global/-/is-yarn-global-0.3.0.tgz";
        sha1 = "d502d3382590ea3004893746754c89139973e232";
      };
    }
    {
      name = "isarray___isarray_1.0.0.tgz";
      path = fetchurl {
        name = "isarray___isarray_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    }
    {
      name = "isbinaryfile___isbinaryfile_4.0.6.tgz";
      path = fetchurl {
        name = "isbinaryfile___isbinaryfile_4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.6.tgz";
        sha1 = "edcb62b224e2b4710830b67498c8e4e5a4d2610b";
      };
    }
    {
      name = "isexe___isexe_2.0.0.tgz";
      path = fetchurl {
        name = "isexe___isexe_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
      };
    }
    {
      name = "isobject___isobject_2.1.0.tgz";
      path = fetchurl {
        name = "isobject___isobject_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz";
        sha1 = "f065561096a3f1da2ef46272f815c840d87e0c89";
      };
    }
    {
      name = "isobject___isobject_3.0.1.tgz";
      path = fetchurl {
        name = "isobject___isobject_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz";
        sha1 = "4e431e92b11a9731636aa1f9c8d1ccbcfdab78df";
      };
    }
    {
      name = "isstream___isstream_0.1.2.tgz";
      path = fetchurl {
        name = "isstream___isstream_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
    }
    {
      name = "istanbul_lib_coverage___istanbul_lib_coverage_3.0.0.tgz";
      path = fetchurl {
        name = "istanbul_lib_coverage___istanbul_lib_coverage_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-3.0.0.tgz";
        sha1 = "f5944a37c70b550b02a78a5c3b2055b280cec8ec";
      };
    }
    {
      name = "istanbul_lib_instrument___istanbul_lib_instrument_4.0.3.tgz";
      path = fetchurl {
        name = "istanbul_lib_instrument___istanbul_lib_instrument_4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-instrument/-/istanbul-lib-instrument-4.0.3.tgz";
        sha1 = "873c6fff897450118222774696a3f28902d77c1d";
      };
    }
    {
      name = "istanbul_lib_report___istanbul_lib_report_3.0.0.tgz";
      path = fetchurl {
        name = "istanbul_lib_report___istanbul_lib_report_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz";
        sha1 = "7518fe52ea44de372f460a76b5ecda9ffb73d8a6";
      };
    }
    {
      name = "istanbul_lib_source_maps___istanbul_lib_source_maps_4.0.0.tgz";
      path = fetchurl {
        name = "istanbul_lib_source_maps___istanbul_lib_source_maps_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.0.tgz";
        sha1 = "75743ce6d96bb86dc7ee4352cf6366a23f0b1ad9";
      };
    }
    {
      name = "istanbul_reports___istanbul_reports_3.0.2.tgz";
      path = fetchurl {
        name = "istanbul_reports___istanbul_reports_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-3.0.2.tgz";
        sha1 = "d593210e5000683750cb09fc0644e4b6e27fd53b";
      };
    }
    {
      name = "jake___jake_10.8.2.tgz";
      path = fetchurl {
        name = "jake___jake_10.8.2.tgz";
        url  = "https://registry.yarnpkg.com/jake/-/jake-10.8.2.tgz";
        sha1 = "ebc9de8558160a66d82d0eadc6a2e58fbc500a7b";
      };
    }
    {
      name = "jest_changed_files___jest_changed_files_26.6.2.tgz";
      path = fetchurl {
        name = "jest_changed_files___jest_changed_files_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-changed-files/-/jest-changed-files-26.6.2.tgz";
        sha1 = "f6198479e1cc66f22f9ae1e22acaa0b429c042d0";
      };
    }
    {
      name = "jest_cli___jest_cli_26.6.3.tgz";
      path = fetchurl {
        name = "jest_cli___jest_cli_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jest-cli/-/jest-cli-26.6.3.tgz";
        sha1 = "43117cfef24bc4cd691a174a8796a532e135e92a";
      };
    }
    {
      name = "jest_config___jest_config_26.6.3.tgz";
      path = fetchurl {
        name = "jest_config___jest_config_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jest-config/-/jest-config-26.6.3.tgz";
        sha1 = "64f41444eef9eb03dc51d5c53b75c8c71f645349";
      };
    }
    {
      name = "jest_diff___jest_diff_26.6.2.tgz";
      path = fetchurl {
        name = "jest_diff___jest_diff_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-diff/-/jest-diff-26.6.2.tgz";
        sha1 = "1aa7468b52c3a68d7d5c5fdcdfcd5e49bd164394";
      };
    }
    {
      name = "jest_docblock___jest_docblock_26.0.0.tgz";
      path = fetchurl {
        name = "jest_docblock___jest_docblock_26.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jest-docblock/-/jest-docblock-26.0.0.tgz";
        sha1 = "3e2fa20899fc928cb13bd0ff68bd3711a36889b5";
      };
    }
    {
      name = "jest_each___jest_each_26.6.2.tgz";
      path = fetchurl {
        name = "jest_each___jest_each_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-each/-/jest-each-26.6.2.tgz";
        sha1 = "02526438a77a67401c8a6382dfe5999952c167cb";
      };
    }
    {
      name = "jest_environment_jsdom___jest_environment_jsdom_26.6.2.tgz";
      path = fetchurl {
        name = "jest_environment_jsdom___jest_environment_jsdom_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-environment-jsdom/-/jest-environment-jsdom-26.6.2.tgz";
        sha1 = "78d09fe9cf019a357009b9b7e1f101d23bd1da3e";
      };
    }
    {
      name = "jest_environment_node___jest_environment_node_26.6.2.tgz";
      path = fetchurl {
        name = "jest_environment_node___jest_environment_node_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-environment-node/-/jest-environment-node-26.6.2.tgz";
        sha1 = "824e4c7fb4944646356f11ac75b229b0035f2b0c";
      };
    }
    {
      name = "jest_get_type___jest_get_type_26.3.0.tgz";
      path = fetchurl {
        name = "jest_get_type___jest_get_type_26.3.0.tgz";
        url  = "https://registry.yarnpkg.com/jest-get-type/-/jest-get-type-26.3.0.tgz";
        sha1 = "e97dc3c3f53c2b406ca7afaed4493b1d099199e0";
      };
    }
    {
      name = "jest_haste_map___jest_haste_map_26.6.2.tgz";
      path = fetchurl {
        name = "jest_haste_map___jest_haste_map_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-haste-map/-/jest-haste-map-26.6.2.tgz";
        sha1 = "dd7e60fe7dc0e9f911a23d79c5ff7fb5c2cafeaa";
      };
    }
    {
      name = "jest_jasmine2___jest_jasmine2_26.6.3.tgz";
      path = fetchurl {
        name = "jest_jasmine2___jest_jasmine2_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jest-jasmine2/-/jest-jasmine2-26.6.3.tgz";
        sha1 = "adc3cf915deacb5212c93b9f3547cd12958f2edd";
      };
    }
    {
      name = "jest_leak_detector___jest_leak_detector_26.6.2.tgz";
      path = fetchurl {
        name = "jest_leak_detector___jest_leak_detector_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-leak-detector/-/jest-leak-detector-26.6.2.tgz";
        sha1 = "7717cf118b92238f2eba65054c8a0c9c653a91af";
      };
    }
    {
      name = "jest_matcher_utils___jest_matcher_utils_26.6.2.tgz";
      path = fetchurl {
        name = "jest_matcher_utils___jest_matcher_utils_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-matcher-utils/-/jest-matcher-utils-26.6.2.tgz";
        sha1 = "8e6fd6e863c8b2d31ac6472eeb237bc595e53e7a";
      };
    }
    {
      name = "jest_message_util___jest_message_util_26.6.2.tgz";
      path = fetchurl {
        name = "jest_message_util___jest_message_util_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-message-util/-/jest-message-util-26.6.2.tgz";
        sha1 = "58173744ad6fc0506b5d21150b9be56ef001ca07";
      };
    }
    {
      name = "jest_mock___jest_mock_26.6.2.tgz";
      path = fetchurl {
        name = "jest_mock___jest_mock_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-mock/-/jest-mock-26.6.2.tgz";
        sha1 = "d6cb712b041ed47fe0d9b6fc3474bc6543feb302";
      };
    }
    {
      name = "jest_pnp_resolver___jest_pnp_resolver_1.2.2.tgz";
      path = fetchurl {
        name = "jest_pnp_resolver___jest_pnp_resolver_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-pnp-resolver/-/jest-pnp-resolver-1.2.2.tgz";
        sha1 = "b704ac0ae028a89108a4d040b3f919dfddc8e33c";
      };
    }
    {
      name = "jest_regex_util___jest_regex_util_26.0.0.tgz";
      path = fetchurl {
        name = "jest_regex_util___jest_regex_util_26.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jest-regex-util/-/jest-regex-util-26.0.0.tgz";
        sha1 = "d25e7184b36e39fd466c3bc41be0971e821fee28";
      };
    }
    {
      name = "jest_resolve_dependencies___jest_resolve_dependencies_26.6.3.tgz";
      path = fetchurl {
        name = "jest_resolve_dependencies___jest_resolve_dependencies_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jest-resolve-dependencies/-/jest-resolve-dependencies-26.6.3.tgz";
        sha1 = "6680859ee5d22ee5dcd961fe4871f59f4c784fb6";
      };
    }
    {
      name = "jest_resolve___jest_resolve_26.6.2.tgz";
      path = fetchurl {
        name = "jest_resolve___jest_resolve_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-resolve/-/jest-resolve-26.6.2.tgz";
        sha1 = "a3ab1517217f469b504f1b56603c5bb541fbb507";
      };
    }
    {
      name = "jest_runner___jest_runner_26.6.3.tgz";
      path = fetchurl {
        name = "jest_runner___jest_runner_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jest-runner/-/jest-runner-26.6.3.tgz";
        sha1 = "2d1fed3d46e10f233fd1dbd3bfaa3fe8924be159";
      };
    }
    {
      name = "jest_runtime___jest_runtime_26.6.3.tgz";
      path = fetchurl {
        name = "jest_runtime___jest_runtime_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jest-runtime/-/jest-runtime-26.6.3.tgz";
        sha1 = "4f64efbcfac398331b74b4b3c82d27d401b8fa2b";
      };
    }
    {
      name = "jest_serializer___jest_serializer_26.6.2.tgz";
      path = fetchurl {
        name = "jest_serializer___jest_serializer_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-serializer/-/jest-serializer-26.6.2.tgz";
        sha1 = "d139aafd46957d3a448f3a6cdabe2919ba0742d1";
      };
    }
    {
      name = "jest_snapshot___jest_snapshot_26.6.2.tgz";
      path = fetchurl {
        name = "jest_snapshot___jest_snapshot_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-snapshot/-/jest-snapshot-26.6.2.tgz";
        sha1 = "f3b0af1acb223316850bd14e1beea9837fb39c84";
      };
    }
    {
      name = "jest_util___jest_util_26.6.2.tgz";
      path = fetchurl {
        name = "jest_util___jest_util_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-util/-/jest-util-26.6.2.tgz";
        sha1 = "907535dbe4d5a6cb4c47ac9b926f6af29576cbc1";
      };
    }
    {
      name = "jest_validate___jest_validate_26.6.2.tgz";
      path = fetchurl {
        name = "jest_validate___jest_validate_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-validate/-/jest-validate-26.6.2.tgz";
        sha1 = "23d380971587150467342911c3d7b4ac57ab20ec";
      };
    }
    {
      name = "jest_watcher___jest_watcher_26.6.2.tgz";
      path = fetchurl {
        name = "jest_watcher___jest_watcher_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-watcher/-/jest-watcher-26.6.2.tgz";
        sha1 = "a5b683b8f9d68dbcb1d7dae32172d2cca0592975";
      };
    }
    {
      name = "jest_worker___jest_worker_26.6.2.tgz";
      path = fetchurl {
        name = "jest_worker___jest_worker_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/jest-worker/-/jest-worker-26.6.2.tgz";
        sha1 = "7f72cbc4d643c365e27b9fd775f9d0eaa9c7a8ed";
      };
    }
    {
      name = "jest___jest_26.6.3.tgz";
      path = fetchurl {
        name = "jest___jest_26.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jest/-/jest-26.6.3.tgz";
        sha1 = "40e8fdbe48f00dfa1f0ce8121ca74b88ac9148ef";
      };
    }
    {
      name = "js_tokens___js_tokens_4.0.0.tgz";
      path = fetchurl {
        name = "js_tokens___js_tokens_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz";
        sha1 = "19203fb59991df98e3a287050d4647cdeaf32499";
      };
    }
    {
      name = "js_yaml___js_yaml_3.14.1.tgz";
      path = fetchurl {
        name = "js_yaml___js_yaml_3.14.1.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.1.tgz";
        sha1 = "dae812fdb3825fa306609a8717383c50c36a0537";
      };
    }
    {
      name = "jsbn___jsbn_0.1.1.tgz";
      path = fetchurl {
        name = "jsbn___jsbn_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.1.tgz";
        sha1 = "a5e654c2e5a2deb5f201d96cefbca80c0ef2f513";
      };
    }
    {
      name = "jsdom___jsdom_16.4.0.tgz";
      path = fetchurl {
        name = "jsdom___jsdom_16.4.0.tgz";
        url  = "https://registry.yarnpkg.com/jsdom/-/jsdom-16.4.0.tgz";
        sha1 = "36005bde2d136f73eee1a830c6d45e55408edddb";
      };
    }
    {
      name = "jsesc___jsesc_2.5.2.tgz";
      path = fetchurl {
        name = "jsesc___jsesc_2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz";
        sha1 = "80564d2e483dacf6e8ef209650a67df3f0c283a4";
      };
    }
    {
      name = "json_buffer___json_buffer_3.0.0.tgz";
      path = fetchurl {
        name = "json_buffer___json_buffer_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.0.tgz";
        sha1 = "5b1f397afc75d677bde8bcfc0e47e1f9a3d9a898";
      };
    }
    {
      name = "json_parse_even_better_errors___json_parse_even_better_errors_2.3.1.tgz";
      path = fetchurl {
        name = "json_parse_even_better_errors___json_parse_even_better_errors_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz";
        sha1 = "7c47805a94319928e05777405dc12e1f7a4ee02d";
      };
    }
    {
      name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz";
        sha1 = "69f6a87d9513ab8bb8fe63bdb0979c448e684660";
      };
    }
    {
      name = "json_schema___json_schema_0.2.3.tgz";
      path = fetchurl {
        name = "json_schema___json_schema_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/json-schema/-/json-schema-0.2.3.tgz";
        sha1 = "b480c892e59a2f05954ce727bd3f2a4e882f9e13";
      };
    }
    {
      name = "json_stable_stringify_without_jsonify___json_stable_stringify_without_jsonify_1.0.1.tgz";
      path = fetchurl {
        name = "json_stable_stringify_without_jsonify___json_stable_stringify_without_jsonify_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz";
        sha1 = "9db7b59496ad3f3cfef30a75142d2d930ad72651";
      };
    }
    {
      name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
      path = fetchurl {
        name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    }
    {
      name = "json5___json5_2.1.3.tgz";
      path = fetchurl {
        name = "json5___json5_2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-2.1.3.tgz";
        sha1 = "c9b0f7fa9233bfe5807fe66fcf3a5617ed597d43";
      };
    }
    {
      name = "jsonfile___jsonfile_4.0.0.tgz";
      path = fetchurl {
        name = "jsonfile___jsonfile_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz";
        sha1 = "8771aae0799b64076b76640fca058f9c10e33ecb";
      };
    }
    {
      name = "jsonfile___jsonfile_6.1.0.tgz";
      path = fetchurl {
        name = "jsonfile___jsonfile_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz";
        sha1 = "bc55b2634793c679ec6403094eb13698a6ec0aae";
      };
    }
    {
      name = "jsprim___jsprim_1.4.1.tgz";
      path = fetchurl {
        name = "jsprim___jsprim_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/jsprim/-/jsprim-1.4.1.tgz";
        sha1 = "313e66bc1e5cc06e438bc1b7499c2e5c56acb6a2";
      };
    }
    {
      name = "keyv___keyv_3.1.0.tgz";
      path = fetchurl {
        name = "keyv___keyv_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/keyv/-/keyv-3.1.0.tgz";
        sha1 = "ecc228486f69991e49e9476485a5be1e8fc5c4d9";
      };
    }
    {
      name = "kind_of___kind_of_3.2.2.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz";
        sha1 = "31ea21a734bab9bbb0f32466d893aea51e4a3c64";
      };
    }
    {
      name = "kind_of___kind_of_4.0.0.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz";
        sha1 = "20813df3d712928b207378691a45066fae72dd57";
      };
    }
    {
      name = "kind_of___kind_of_5.1.0.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz";
        sha1 = "729c91e2d857b7a419a1f9aa65685c4c33f5845d";
      };
    }
    {
      name = "kind_of___kind_of_6.0.3.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_6.0.3.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz";
        sha1 = "07c05034a6c349fa06e24fa35aa76db4580ce4dd";
      };
    }
    {
      name = "kleur___kleur_3.0.3.tgz";
      path = fetchurl {
        name = "kleur___kleur_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/kleur/-/kleur-3.0.3.tgz";
        sha1 = "a79c9ecc86ee1ce3fa6206d1216c501f147fc07e";
      };
    }
    {
      name = "latest_version___latest_version_5.1.0.tgz";
      path = fetchurl {
        name = "latest_version___latest_version_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/latest-version/-/latest-version-5.1.0.tgz";
        sha1 = "119dfe908fe38d15dfa43ecd13fa12ec8832face";
      };
    }
    {
      name = "lazy_val___lazy_val_1.0.4.tgz";
      path = fetchurl {
        name = "lazy_val___lazy_val_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/lazy-val/-/lazy-val-1.0.4.tgz";
        sha1 = "882636a7245c2cfe6e0a4e3ba6c5d68a137e5c65";
      };
    }
    {
      name = "lazystream___lazystream_1.0.0.tgz";
      path = fetchurl {
        name = "lazystream___lazystream_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lazystream/-/lazystream-1.0.0.tgz";
        sha1 = "f6995fe0f820392f61396be89462407bb77168e4";
      };
    }
    {
      name = "leven___leven_3.1.0.tgz";
      path = fetchurl {
        name = "leven___leven_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/leven/-/leven-3.1.0.tgz";
        sha1 = "77891de834064cccba82ae7842bb6b14a13ed7f2";
      };
    }
    {
      name = "levn___levn_0.4.1.tgz";
      path = fetchurl {
        name = "levn___levn_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz";
        sha1 = "ae4562c007473b932a6200d403268dd2fffc6ade";
      };
    }
    {
      name = "levn___levn_0.3.0.tgz";
      path = fetchurl {
        name = "levn___levn_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz";
        sha1 = "3b09924edf9f083c0490fdd4c0bc4421e04764ee";
      };
    }
    {
      name = "lines_and_columns___lines_and_columns_1.1.6.tgz";
      path = fetchurl {
        name = "lines_and_columns___lines_and_columns_1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.1.6.tgz";
        sha1 = "1c00c743b433cd0a4e80758f7b64a57440d9ff00";
      };
    }
    {
      name = "locate_path___locate_path_5.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz";
        sha1 = "1afba396afd676a6d42504d0a67a3a7eb9f62aa0";
      };
    }
    {
      name = "lodash.defaults___lodash.defaults_4.2.0.tgz";
      path = fetchurl {
        name = "lodash.defaults___lodash.defaults_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.defaults/-/lodash.defaults-4.2.0.tgz";
        sha1 = "d09178716ffea4dde9e5fb7b37f6f0802274580c";
      };
    }
    {
      name = "lodash.difference___lodash.difference_4.5.0.tgz";
      path = fetchurl {
        name = "lodash.difference___lodash.difference_4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.difference/-/lodash.difference-4.5.0.tgz";
        sha1 = "9ccb4e505d486b91651345772885a2df27fd017c";
      };
    }
    {
      name = "lodash.flatten___lodash.flatten_4.4.0.tgz";
      path = fetchurl {
        name = "lodash.flatten___lodash.flatten_4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.flatten/-/lodash.flatten-4.4.0.tgz";
        sha1 = "f31c22225a9632d2bbf8e4addbef240aa765a61f";
      };
    }
    {
      name = "lodash.isplainobject___lodash.isplainobject_4.0.6.tgz";
      path = fetchurl {
        name = "lodash.isplainobject___lodash.isplainobject_4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz";
        sha1 = "7c526a52d89b45c45cc690b88163be0497f550cb";
      };
    }
    {
      name = "lodash.sortby___lodash.sortby_4.7.0.tgz";
      path = fetchurl {
        name = "lodash.sortby___lodash.sortby_4.7.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.sortby/-/lodash.sortby-4.7.0.tgz";
        sha1 = "edd14c824e2cc9c1e0b0a1b42bb5210516a42438";
      };
    }
    {
      name = "lodash.union___lodash.union_4.6.0.tgz";
      path = fetchurl {
        name = "lodash.union___lodash.union_4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.union/-/lodash.union-4.6.0.tgz";
        sha1 = "48bb5088409f16f1821666641c44dd1aaae3cd88";
      };
    }
    {
      name = "lodash___lodash_4.17.20.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.20.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.20.tgz";
        sha1 = "b44a9b6297bcb698f1c51a3545a2b3b368d59c52";
      };
    }
    {
      name = "lowercase_keys___lowercase_keys_1.0.1.tgz";
      path = fetchurl {
        name = "lowercase_keys___lowercase_keys_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz";
        sha1 = "6f9e30b47084d971a7c820ff15a6c5167b74c26f";
      };
    }
    {
      name = "lowercase_keys___lowercase_keys_2.0.0.tgz";
      path = fetchurl {
        name = "lowercase_keys___lowercase_keys_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz";
        sha1 = "2603e78b7b4b0006cbca2fbcc8a3202558ac9479";
      };
    }
    {
      name = "lru_cache___lru_cache_6.0.0.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz";
        sha1 = "6d6fe6570ebd96aaf90fcad1dafa3b2566db3a94";
      };
    }
    {
      name = "make_dir___make_dir_3.1.0.tgz";
      path = fetchurl {
        name = "make_dir___make_dir_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz";
        sha1 = "415e967046b3a7f1d185277d84aa58203726a13f";
      };
    }
    {
      name = "makeerror___makeerror_1.0.11.tgz";
      path = fetchurl {
        name = "makeerror___makeerror_1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/makeerror/-/makeerror-1.0.11.tgz";
        sha1 = "e01a5c9109f2af79660e4e8b9587790184f5a96c";
      };
    }
    {
      name = "map_cache___map_cache_0.2.2.tgz";
      path = fetchurl {
        name = "map_cache___map_cache_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz";
        sha1 = "c32abd0bd6525d9b051645bb4f26ac5dc98a0dbf";
      };
    }
    {
      name = "map_visit___map_visit_1.0.0.tgz";
      path = fetchurl {
        name = "map_visit___map_visit_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz";
        sha1 = "ecdca8f13144e660f1b5bd41f12f3479d98dfb8f";
      };
    }
    {
      name = "matcher___matcher_3.0.0.tgz";
      path = fetchurl {
        name = "matcher___matcher_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz";
        sha1 = "bd9060f4c5b70aa8041ccc6f80368760994f30ca";
      };
    }
    {
      name = "merge_stream___merge_stream_2.0.0.tgz";
      path = fetchurl {
        name = "merge_stream___merge_stream_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz";
        sha1 = "52823629a14dd00c9770fb6ad47dc6310f2c1f60";
      };
    }
    {
      name = "micromatch___micromatch_3.1.10.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_3.1.10.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz";
        sha1 = "70859bc95c9840952f359a068a3fc49f9ecfac23";
      };
    }
    {
      name = "micromatch___micromatch_4.0.2.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.2.tgz";
        sha1 = "4fcb0999bf9fbc2fcbdd212f6d629b9a56c39259";
      };
    }
    {
      name = "mime_db___mime_db_1.44.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.44.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.44.0.tgz";
        sha1 = "fa11c5eb0aca1334b4233cb4d52f10c5a6272f92";
      };
    }
    {
      name = "mime_types___mime_types_2.1.27.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.27.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.27.tgz";
        sha1 = "47949f98e279ea53119f5722e0f34e529bec009f";
      };
    }
    {
      name = "mime___mime_2.4.6.tgz";
      path = fetchurl {
        name = "mime___mime_2.4.6.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-2.4.6.tgz";
        sha1 = "e5b407c90db442f2beb5b162373d07b69affa4d1";
      };
    }
    {
      name = "mimic_fn___mimic_fn_2.1.0.tgz";
      path = fetchurl {
        name = "mimic_fn___mimic_fn_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz";
        sha1 = "7ed2c2ccccaf84d3ffcb7a69b57711fc2083401b";
      };
    }
    {
      name = "mimic_response___mimic_response_1.0.1.tgz";
      path = fetchurl {
        name = "mimic_response___mimic_response_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz";
        sha1 = "4923538878eef42063cb8a3e3b0798781487ab1b";
      };
    }
    {
      name = "minimatch___minimatch_3.0.4.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz";
        sha1 = "5166e286457f03306064be5497e8dbb0c3d32083";
      };
    }
    {
      name = "minimist___minimist_1.2.5.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.5.tgz";
        sha1 = "67d66014b66a6a8aaa0c083c5fd58df4e4e97602";
      };
    }
    {
      name = "mixin_deep___mixin_deep_1.3.2.tgz";
      path = fetchurl {
        name = "mixin_deep___mixin_deep_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.2.tgz";
        sha1 = "1120b43dc359a785dce65b55b82e257ccf479566";
      };
    }
    {
      name = "mkdirp___mkdirp_0.5.5.tgz";
      path = fetchurl {
        name = "mkdirp___mkdirp_0.5.5.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.5.tgz";
        sha1 = "d91cefd62d1436ca0f41620e251288d420099def";
      };
    }
    {
      name = "ms___ms_2.0.0.tgz";
      path = fetchurl {
        name = "ms___ms_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    }
    {
      name = "ms___ms_2.1.2.tgz";
      path = fetchurl {
        name = "ms___ms_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz";
        sha1 = "d09d1f357b443f493382a8eb3ccd183872ae6009";
      };
    }
    {
      name = "nanomatch___nanomatch_1.2.13.tgz";
      path = fetchurl {
        name = "nanomatch___nanomatch_1.2.13.tgz";
        url  = "https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz";
        sha1 = "b87a8aa4fc0de8fe6be88895b38983ff265bd119";
      };
    }
    {
      name = "natural_compare___natural_compare_1.4.0.tgz";
      path = fetchurl {
        name = "natural_compare___natural_compare_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz";
        sha1 = "4abebfeed7541f2c27acfb29bdbbd15c8d5ba4f7";
      };
    }
    {
      name = "nice_try___nice_try_1.0.5.tgz";
      path = fetchurl {
        name = "nice_try___nice_try_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz";
        sha1 = "a3378a7696ce7d223e88fc9b764bd7ef1089e366";
      };
    }
    {
      name = "node_int64___node_int64_0.4.0.tgz";
      path = fetchurl {
        name = "node_int64___node_int64_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/node-int64/-/node-int64-0.4.0.tgz";
        sha1 = "87a9065cdb355d3182d8f94ce11188b825c68a3b";
      };
    }
    {
      name = "node_modules_regexp___node_modules_regexp_1.0.0.tgz";
      path = fetchurl {
        name = "node_modules_regexp___node_modules_regexp_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/node-modules-regexp/-/node-modules-regexp-1.0.0.tgz";
        sha1 = "8d9dbe28964a4ac5712e9131642107c71e90ec40";
      };
    }
    {
      name = "node_notifier___node_notifier_8.0.0.tgz";
      path = fetchurl {
        name = "node_notifier___node_notifier_8.0.0.tgz";
        url  = "https://registry.yarnpkg.com/node-notifier/-/node-notifier-8.0.0.tgz";
        sha1 = "a7eee2d51da6d0f7ff5094bc7108c911240c1620";
      };
    }
    {
      name = "normalize_package_data___normalize_package_data_2.5.0.tgz";
      path = fetchurl {
        name = "normalize_package_data___normalize_package_data_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz";
        sha1 = "e66db1838b200c1dfc233225d12cb36520e234a8";
      };
    }
    {
      name = "normalize_path___normalize_path_2.1.1.tgz";
      path = fetchurl {
        name = "normalize_path___normalize_path_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz";
        sha1 = "1ab28b556e198363a8c1a6f7e6fa20137fe6aed9";
      };
    }
    {
      name = "normalize_path___normalize_path_3.0.0.tgz";
      path = fetchurl {
        name = "normalize_path___normalize_path_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz";
        sha1 = "0dcd69ff23a1c9b11fd0978316644a0388216a65";
      };
    }
    {
      name = "normalize_url___normalize_url_4.5.0.tgz";
      path = fetchurl {
        name = "normalize_url___normalize_url_4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-url/-/normalize-url-4.5.0.tgz";
        sha1 = "453354087e6ca96957bd8f5baf753f5982142129";
      };
    }
    {
      name = "npm_conf___npm_conf_1.1.3.tgz";
      path = fetchurl {
        name = "npm_conf___npm_conf_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/npm-conf/-/npm-conf-1.1.3.tgz";
        sha1 = "256cc47bd0e218c259c4e9550bf413bc2192aff9";
      };
    }
    {
      name = "npm_run_path___npm_run_path_2.0.2.tgz";
      path = fetchurl {
        name = "npm_run_path___npm_run_path_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz";
        sha1 = "35a9232dfa35d7067b4cb2ddf2357b1871536c5f";
      };
    }
    {
      name = "npm_run_path___npm_run_path_4.0.1.tgz";
      path = fetchurl {
        name = "npm_run_path___npm_run_path_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz";
        sha1 = "b7ecd1e5ed53da8e37a55e1c2269e0b97ed748ea";
      };
    }
    {
      name = "nwsapi___nwsapi_2.2.0.tgz";
      path = fetchurl {
        name = "nwsapi___nwsapi_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/nwsapi/-/nwsapi-2.2.0.tgz";
        sha1 = "204879a9e3d068ff2a55139c2c772780681a38b7";
      };
    }
    {
      name = "oauth_sign___oauth_sign_0.9.0.tgz";
      path = fetchurl {
        name = "oauth_sign___oauth_sign_0.9.0.tgz";
        url  = "https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.9.0.tgz";
        sha1 = "47a7b016baa68b5fa0ecf3dee08a85c679ac6455";
      };
    }
    {
      name = "object_copy___object_copy_0.1.0.tgz";
      path = fetchurl {
        name = "object_copy___object_copy_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz";
        sha1 = "7e7d858b781bd7c991a41ba975ed3812754e998c";
      };
    }
    {
      name = "object_keys___object_keys_1.1.1.tgz";
      path = fetchurl {
        name = "object_keys___object_keys_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz";
        sha1 = "1c47f272df277f3b1daf061677d9c82e2322c60e";
      };
    }
    {
      name = "object_visit___object_visit_1.0.1.tgz";
      path = fetchurl {
        name = "object_visit___object_visit_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz";
        sha1 = "f79c4493af0c5377b59fe39d395e41042dd045bb";
      };
    }
    {
      name = "object.pick___object.pick_1.3.0.tgz";
      path = fetchurl {
        name = "object.pick___object.pick_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz";
        sha1 = "87a10ac4c1694bd2e1cbf53591a66141fb5dd747";
      };
    }
    {
      name = "once___once_1.4.0.tgz";
      path = fetchurl {
        name = "once___once_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    }
    {
      name = "onetime___onetime_5.1.2.tgz";
      path = fetchurl {
        name = "onetime___onetime_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz";
        sha1 = "d0e96ebb56b07476df1dd9c4806e5237985ca45e";
      };
    }
    {
      name = "optionator___optionator_0.8.3.tgz";
      path = fetchurl {
        name = "optionator___optionator_0.8.3.tgz";
        url  = "https://registry.yarnpkg.com/optionator/-/optionator-0.8.3.tgz";
        sha1 = "84fa1d036fe9d3c7e21d99884b601167ec8fb495";
      };
    }
    {
      name = "optionator___optionator_0.9.1.tgz";
      path = fetchurl {
        name = "optionator___optionator_0.9.1.tgz";
        url  = "https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz";
        sha1 = "4f236a6373dae0566a6d43e1326674f50c291499";
      };
    }
    {
      name = "p_cancelable___p_cancelable_1.1.0.tgz";
      path = fetchurl {
        name = "p_cancelable___p_cancelable_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-1.1.0.tgz";
        sha1 = "d078d15a3af409220c886f1d9a0ca2e441ab26cc";
      };
    }
    {
      name = "p_each_series___p_each_series_2.2.0.tgz";
      path = fetchurl {
        name = "p_each_series___p_each_series_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/p-each-series/-/p-each-series-2.2.0.tgz";
        sha1 = "105ab0357ce72b202a8a8b94933672657b5e2a9a";
      };
    }
    {
      name = "p_finally___p_finally_1.0.0.tgz";
      path = fetchurl {
        name = "p_finally___p_finally_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz";
        sha1 = "3fbcfb15b899a44123b34b6dcc18b724336a2cae";
      };
    }
    {
      name = "p_limit___p_limit_2.3.0.tgz";
      path = fetchurl {
        name = "p_limit___p_limit_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz";
        sha1 = "3dd33c647a214fdfffd835933eb086da0dc21db1";
      };
    }
    {
      name = "p_locate___p_locate_4.1.0.tgz";
      path = fetchurl {
        name = "p_locate___p_locate_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz";
        sha1 = "a3428bb7088b3a60292f66919278b7c297ad4f07";
      };
    }
    {
      name = "p_try___p_try_2.2.0.tgz";
      path = fetchurl {
        name = "p_try___p_try_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz";
        sha1 = "cb2868540e313d61de58fafbe35ce9004d5540e6";
      };
    }
    {
      name = "package_json___package_json_6.5.0.tgz";
      path = fetchurl {
        name = "package_json___package_json_6.5.0.tgz";
        url  = "https://registry.yarnpkg.com/package-json/-/package-json-6.5.0.tgz";
        sha1 = "6feedaca35e75725876d0b0e64974697fed145b0";
      };
    }
    {
      name = "parent_module___parent_module_1.0.1.tgz";
      path = fetchurl {
        name = "parent_module___parent_module_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz";
        sha1 = "691d2709e78c79fae3a156622452d00762caaaa2";
      };
    }
    {
      name = "parse_json___parse_json_5.1.0.tgz";
      path = fetchurl {
        name = "parse_json___parse_json_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-json/-/parse-json-5.1.0.tgz";
        sha1 = "f96088cdf24a8faa9aea9a009f2d9d942c999646";
      };
    }
    {
      name = "parse5___parse5_5.1.1.tgz";
      path = fetchurl {
        name = "parse5___parse5_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/parse5/-/parse5-5.1.1.tgz";
        sha1 = "f68e4e5ba1852ac2cadc00f4555fff6c2abb6178";
      };
    }
    {
      name = "pascalcase___pascalcase_0.1.1.tgz";
      path = fetchurl {
        name = "pascalcase___pascalcase_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz";
        sha1 = "b363e55e8006ca6fe21784d2db22bd15d7917f14";
      };
    }
    {
      name = "path_exists___path_exists_4.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz";
        sha1 = "513bdbe2d3b95d7762e8c1137efa195c6c61b5b3";
      };
    }
    {
      name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
      path = fetchurl {
        name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    }
    {
      name = "path_key___path_key_2.0.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz";
        sha1 = "411cadb574c5a140d3a4b1910d40d80cc9f40b40";
      };
    }
    {
      name = "path_key___path_key_3.1.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz";
        sha1 = "581f6ade658cbba65a0d3380de7753295054f375";
      };
    }
    {
      name = "path_parse___path_parse_1.0.6.tgz";
      path = fetchurl {
        name = "path_parse___path_parse_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.6.tgz";
        sha1 = "d62dbb5679405d72c4737ec58600e9ddcf06d24c";
      };
    }
    {
      name = "pend___pend_1.2.0.tgz";
      path = fetchurl {
        name = "pend___pend_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz";
        sha1 = "7a57eb550a6783f9115331fcf4663d5c8e007a50";
      };
    }
    {
      name = "performance_now___performance_now_2.1.0.tgz";
      path = fetchurl {
        name = "performance_now___performance_now_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz";
        sha1 = "6309f4e0e5fa913ec1c69307ae364b4b377c9e7b";
      };
    }
    {
      name = "picomatch___picomatch_2.2.2.tgz";
      path = fetchurl {
        name = "picomatch___picomatch_2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/picomatch/-/picomatch-2.2.2.tgz";
        sha1 = "21f333e9b6b8eaff02468f5146ea406d345f4dad";
      };
    }
    {
      name = "pify___pify_3.0.0.tgz";
      path = fetchurl {
        name = "pify___pify_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz";
        sha1 = "e5a4acd2c101fdf3d9a4d07f0dbc4db49dd28176";
      };
    }
    {
      name = "pirates___pirates_4.0.1.tgz";
      path = fetchurl {
        name = "pirates___pirates_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pirates/-/pirates-4.0.1.tgz";
        sha1 = "643a92caf894566f91b2b986d2c66950a8e2fb87";
      };
    }
    {
      name = "pkg_dir___pkg_dir_4.2.0.tgz";
      path = fetchurl {
        name = "pkg_dir___pkg_dir_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz";
        sha1 = "f099133df7ede422e81d1d8448270eeb3e4261f3";
      };
    }
    {
      name = "posix_character_classes___posix_character_classes_0.1.1.tgz";
      path = fetchurl {
        name = "posix_character_classes___posix_character_classes_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz";
        sha1 = "01eac0fe3b5af71a2a6c02feabb8c1fef7e00eab";
      };
    }
    {
      name = "prelude_ls___prelude_ls_1.2.1.tgz";
      path = fetchurl {
        name = "prelude_ls___prelude_ls_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz";
        sha1 = "debc6489d7a6e6b0e7611888cec880337d316396";
      };
    }
    {
      name = "prelude_ls___prelude_ls_1.1.2.tgz";
      path = fetchurl {
        name = "prelude_ls___prelude_ls_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz";
        sha1 = "21932a549f5e52ffd9a827f570e04be62a97da54";
      };
    }
    {
      name = "prepend_http___prepend_http_2.0.0.tgz";
      path = fetchurl {
        name = "prepend_http___prepend_http_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/prepend-http/-/prepend-http-2.0.0.tgz";
        sha1 = "e92434bfa5ea8c19f41cdfd401d741a3c819d897";
      };
    }
    {
      name = "pretty_format___pretty_format_26.6.2.tgz";
      path = fetchurl {
        name = "pretty_format___pretty_format_26.6.2.tgz";
        url  = "https://registry.yarnpkg.com/pretty-format/-/pretty-format-26.6.2.tgz";
        sha1 = "e35c2705f14cb7fe2fe94fa078345b444120fc93";
      };
    }
    {
      name = "printj___printj_1.1.2.tgz";
      path = fetchurl {
        name = "printj___printj_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/printj/-/printj-1.1.2.tgz";
        sha1 = "d90deb2975a8b9f600fb3a1c94e3f4c53c78a222";
      };
    }
    {
      name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
      path = fetchurl {
        name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz";
        sha1 = "7820d9b16120cc55ca9ae7792680ae7dba6d7fe2";
      };
    }
    {
      name = "progress___progress_2.0.3.tgz";
      path = fetchurl {
        name = "progress___progress_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz";
        sha1 = "7e8cf8d8f5b8f239c1bc68beb4eb78567d572ef8";
      };
    }
    {
      name = "prompts___prompts_2.4.0.tgz";
      path = fetchurl {
        name = "prompts___prompts_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/prompts/-/prompts-2.4.0.tgz";
        sha1 = "4aa5de0723a231d1ee9121c40fdf663df73f61d7";
      };
    }
    {
      name = "proto_list___proto_list_1.2.4.tgz";
      path = fetchurl {
        name = "proto_list___proto_list_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/proto-list/-/proto-list-1.2.4.tgz";
        sha1 = "212d5bfe1318306a420f6402b8e26ff39647a849";
      };
    }
    {
      name = "psl___psl_1.8.0.tgz";
      path = fetchurl {
        name = "psl___psl_1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/psl/-/psl-1.8.0.tgz";
        sha1 = "9326f8bcfb013adcc005fdff056acce020e51c24";
      };
    }
    {
      name = "pump___pump_3.0.0.tgz";
      path = fetchurl {
        name = "pump___pump_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz";
        sha1 = "b4a2116815bde2f4e1ea602354e8c75565107a64";
      };
    }
    {
      name = "punycode___punycode_2.1.1.tgz";
      path = fetchurl {
        name = "punycode___punycode_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz";
        sha1 = "b58b010ac40c22c5657616c8d2c2c02c7bf479ec";
      };
    }
    {
      name = "pupa___pupa_2.1.1.tgz";
      path = fetchurl {
        name = "pupa___pupa_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/pupa/-/pupa-2.1.1.tgz";
        sha1 = "f5e8fd4afc2c5d97828faa523549ed8744a20d62";
      };
    }
    {
      name = "qs___qs_6.5.2.tgz";
      path = fetchurl {
        name = "qs___qs_6.5.2.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.5.2.tgz";
        sha1 = "cb3ae806e8740444584ef154ce8ee98d403f3e36";
      };
    }
    {
      name = "rc___rc_1.2.8.tgz";
      path = fetchurl {
        name = "rc___rc_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz";
        sha1 = "cd924bf5200a075b83c188cd6b9e211b7fc0d3ed";
      };
    }
    {
      name = "react_is___react_is_17.0.1.tgz";
      path = fetchurl {
        name = "react_is___react_is_17.0.1.tgz";
        url  = "https://registry.yarnpkg.com/react-is/-/react-is-17.0.1.tgz";
        sha1 = "5b3531bd76a645a4c9fb6e693ed36419e3301339";
      };
    }
    {
      name = "read_config_file___read_config_file_6.0.0.tgz";
      path = fetchurl {
        name = "read_config_file___read_config_file_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/read-config-file/-/read-config-file-6.0.0.tgz";
        sha1 = "224b5dca6a5bdc1fb19e63f89f342680efdb9299";
      };
    }
    {
      name = "read_pkg_up___read_pkg_up_7.0.1.tgz";
      path = fetchurl {
        name = "read_pkg_up___read_pkg_up_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-7.0.1.tgz";
        sha1 = "f3a6135758459733ae2b95638056e1854e7ef507";
      };
    }
    {
      name = "read_pkg___read_pkg_5.2.0.tgz";
      path = fetchurl {
        name = "read_pkg___read_pkg_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg/-/read-pkg-5.2.0.tgz";
        sha1 = "7bf295438ca5a33e56cd30e053b34ee7250c93cc";
      };
    }
    {
      name = "readable_stream___readable_stream_2.3.7.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_2.3.7.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.7.tgz";
        sha1 = "1eca1cf711aef814c04f62252a36a62f6cb23b57";
      };
    }
    {
      name = "readable_stream___readable_stream_3.6.0.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_3.6.0.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz";
        sha1 = "337bbda3adc0706bd3e024426a286d4b4b2c9198";
      };
    }
    {
      name = "readdir_glob___readdir_glob_1.1.1.tgz";
      path = fetchurl {
        name = "readdir_glob___readdir_glob_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/readdir-glob/-/readdir-glob-1.1.1.tgz";
        sha1 = "f0e10bb7bf7bfa7e0add8baffdc54c3f7dbee6c4";
      };
    }
    {
      name = "regex_not___regex_not_1.0.2.tgz";
      path = fetchurl {
        name = "regex_not___regex_not_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz";
        sha1 = "1f4ece27e00b0b65e0247a6810e6a85d83a5752c";
      };
    }
    {
      name = "regexpp___regexpp_3.1.0.tgz";
      path = fetchurl {
        name = "regexpp___regexpp_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpp/-/regexpp-3.1.0.tgz";
        sha1 = "206d0ad0a5648cffbdb8ae46438f3dc51c9f78e2";
      };
    }
    {
      name = "registry_auth_token___registry_auth_token_4.2.1.tgz";
      path = fetchurl {
        name = "registry_auth_token___registry_auth_token_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-4.2.1.tgz";
        sha1 = "6d7b4006441918972ccd5fedcd41dc322c79b250";
      };
    }
    {
      name = "registry_url___registry_url_5.1.0.tgz";
      path = fetchurl {
        name = "registry_url___registry_url_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/registry-url/-/registry-url-5.1.0.tgz";
        sha1 = "e98334b50d5434b81136b44ec638d9c2009c5009";
      };
    }
    {
      name = "remove_trailing_separator___remove_trailing_separator_1.1.0.tgz";
      path = fetchurl {
        name = "remove_trailing_separator___remove_trailing_separator_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz";
        sha1 = "c24bce2a283adad5bc3f58e0d48249b92379d8ef";
      };
    }
    {
      name = "repeat_element___repeat_element_1.1.3.tgz";
      path = fetchurl {
        name = "repeat_element___repeat_element_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.3.tgz";
        sha1 = "782e0d825c0c5a3bb39731f84efee6b742e6b1ce";
      };
    }
    {
      name = "repeat_string___repeat_string_1.6.1.tgz";
      path = fetchurl {
        name = "repeat_string___repeat_string_1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz";
        sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
      };
    }
    {
      name = "request_promise_core___request_promise_core_1.1.4.tgz";
      path = fetchurl {
        name = "request_promise_core___request_promise_core_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/request-promise-core/-/request-promise-core-1.1.4.tgz";
        sha1 = "3eedd4223208d419867b78ce815167d10593a22f";
      };
    }
    {
      name = "request_promise_native___request_promise_native_1.0.9.tgz";
      path = fetchurl {
        name = "request_promise_native___request_promise_native_1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/request-promise-native/-/request-promise-native-1.0.9.tgz";
        sha1 = "e407120526a5efdc9a39b28a5679bf47b9d9dc28";
      };
    }
    {
      name = "request___request_2.88.2.tgz";
      path = fetchurl {
        name = "request___request_2.88.2.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.88.2.tgz";
        sha1 = "d73c918731cb5a87da047e207234146f664d12b3";
      };
    }
    {
      name = "require_directory___require_directory_2.1.1.tgz";
      path = fetchurl {
        name = "require_directory___require_directory_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz";
        sha1 = "8c64ad5fd30dab1c976e2344ffe7f792a6a6df42";
      };
    }
    {
      name = "require_main_filename___require_main_filename_2.0.0.tgz";
      path = fetchurl {
        name = "require_main_filename___require_main_filename_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz";
        sha1 = "d0b329ecc7cc0f61649f62215be69af54aa8989b";
      };
    }
    {
      name = "resolve_cwd___resolve_cwd_3.0.0.tgz";
      path = fetchurl {
        name = "resolve_cwd___resolve_cwd_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-3.0.0.tgz";
        sha1 = "0f0075f1bb2544766cf73ba6a6e2adfebcb13f2d";
      };
    }
    {
      name = "resolve_from___resolve_from_4.0.0.tgz";
      path = fetchurl {
        name = "resolve_from___resolve_from_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz";
        sha1 = "4abcd852ad32dd7baabfe9b40e00a36db5f392e6";
      };
    }
    {
      name = "resolve_from___resolve_from_5.0.0.tgz";
      path = fetchurl {
        name = "resolve_from___resolve_from_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz";
        sha1 = "c35225843df8f776df21c57557bc087e9dfdfc69";
      };
    }
    {
      name = "resolve_url___resolve_url_0.2.1.tgz";
      path = fetchurl {
        name = "resolve_url___resolve_url_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz";
        sha1 = "2c637fe77c893afd2a663fe21aa9080068e2052a";
      };
    }
    {
      name = "resolve___resolve_1.19.0.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.19.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.19.0.tgz";
        sha1 = "1af5bf630409734a067cae29318aac7fa29a267c";
      };
    }
    {
      name = "responselike___responselike_1.0.2.tgz";
      path = fetchurl {
        name = "responselike___responselike_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/responselike/-/responselike-1.0.2.tgz";
        sha1 = "918720ef3b631c5642be068f15ade5a46f4ba1e7";
      };
    }
    {
      name = "ret___ret_0.1.15.tgz";
      path = fetchurl {
        name = "ret___ret_0.1.15.tgz";
        url  = "https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz";
        sha1 = "b8a4825d5bdb1fc3f6f53c2bc33f81388681c7bc";
      };
    }
    {
      name = "rimraf___rimraf_3.0.2.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz";
        sha1 = "f1a5402ba6220ad52cc1282bac1ae3aa49fd061a";
      };
    }
    {
      name = "roarr___roarr_2.15.4.tgz";
      path = fetchurl {
        name = "roarr___roarr_2.15.4.tgz";
        url  = "https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz";
        sha1 = "f5fe795b7b838ccfe35dc608e0282b9eba2e7afd";
      };
    }
    {
      name = "rsvp___rsvp_4.8.5.tgz";
      path = fetchurl {
        name = "rsvp___rsvp_4.8.5.tgz";
        url  = "https://registry.yarnpkg.com/rsvp/-/rsvp-4.8.5.tgz";
        sha1 = "c8f155311d167f68f21e168df71ec5b083113734";
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.2.1.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz";
        sha1 = "1eaf9fa9bdb1fdd4ec75f58f9cdb4e6b7827eec6";
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.1.2.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha1 = "991ec69d296e0313747d59bdfd2b745c35f8828d";
      };
    }
    {
      name = "safe_regex___safe_regex_1.1.0.tgz";
      path = fetchurl {
        name = "safe_regex___safe_regex_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz";
        sha1 = "40a3669f3b077d1e943d44629e157dd48023bf2e";
      };
    }
    {
      name = "safer_buffer___safer_buffer_2.1.2.tgz";
      path = fetchurl {
        name = "safer_buffer___safer_buffer_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz";
        sha1 = "44fa161b0187b9549dd84bb91802f9bd8385cd6a";
      };
    }
    {
      name = "sane___sane_4.1.0.tgz";
      path = fetchurl {
        name = "sane___sane_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sane/-/sane-4.1.0.tgz";
        sha1 = "ed881fd922733a6c461bc189dc2b6c006f3ffded";
      };
    }
    {
      name = "sanitize_filename___sanitize_filename_1.6.3.tgz";
      path = fetchurl {
        name = "sanitize_filename___sanitize_filename_1.6.3.tgz";
        url  = "https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz";
        sha1 = "755ebd752045931977e30b2025d340d7c9090378";
      };
    }
    {
      name = "sax___sax_1.2.4.tgz";
      path = fetchurl {
        name = "sax___sax_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz";
        sha1 = "2816234e2378bddc4e5354fab5caa895df7100d9";
      };
    }
    {
      name = "saxes___saxes_5.0.1.tgz";
      path = fetchurl {
        name = "saxes___saxes_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/saxes/-/saxes-5.0.1.tgz";
        sha1 = "eebab953fa3b7608dbe94e5dadb15c888fa6696d";
      };
    }
    {
      name = "semver_compare___semver_compare_1.0.0.tgz";
      path = fetchurl {
        name = "semver_compare___semver_compare_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz";
        sha1 = "0dee216a1c941ab37e9efb1788f6afc5ff5537fc";
      };
    }
    {
      name = "semver_diff___semver_diff_3.1.1.tgz";
      path = fetchurl {
        name = "semver_diff___semver_diff_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/semver-diff/-/semver-diff-3.1.1.tgz";
        sha1 = "05f77ce59f325e00e2706afd67bb506ddb1ca32b";
      };
    }
    {
      name = "semver___semver_5.7.1.tgz";
      path = fetchurl {
        name = "semver___semver_5.7.1.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz";
        sha1 = "a954f931aeba508d307bbf069eff0c01c96116f7";
      };
    }
    {
      name = "semver___semver_6.3.0.tgz";
      path = fetchurl {
        name = "semver___semver_6.3.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz";
        sha1 = "ee0a64c8af5e8ceea67687b133761e1becbd1d3d";
      };
    }
    {
      name = "semver___semver_7.3.4.tgz";
      path = fetchurl {
        name = "semver___semver_7.3.4.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.3.4.tgz";
        sha1 = "27aaa7d2e4ca76452f98d3add093a72c943edc97";
      };
    }
    {
      name = "serialize_error___serialize_error_7.0.1.tgz";
      path = fetchurl {
        name = "serialize_error___serialize_error_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz";
        sha1 = "f1360b0447f61ffb483ec4157c737fab7d778e18";
      };
    }
    {
      name = "set_blocking___set_blocking_2.0.0.tgz";
      path = fetchurl {
        name = "set_blocking___set_blocking_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz";
        sha1 = "045f9782d011ae9a6803ddd382b24392b3d890f7";
      };
    }
    {
      name = "set_value___set_value_2.0.1.tgz";
      path = fetchurl {
        name = "set_value___set_value_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/set-value/-/set-value-2.0.1.tgz";
        sha1 = "a18d40530e6f07de4228c7defe4227af8cad005b";
      };
    }
    {
      name = "shebang_command___shebang_command_1.2.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz";
        sha1 = "44aac65b695b03398968c39f363fee5deafdf1ea";
      };
    }
    {
      name = "shebang_command___shebang_command_2.0.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz";
        sha1 = "ccd0af4f8835fbdc265b82461aaf0c36663f34ea";
      };
    }
    {
      name = "shebang_regex___shebang_regex_1.0.0.tgz";
      path = fetchurl {
        name = "shebang_regex___shebang_regex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz";
        sha1 = "da42f49740c0b42db2ca9728571cb190c98efea3";
      };
    }
    {
      name = "shebang_regex___shebang_regex_3.0.0.tgz";
      path = fetchurl {
        name = "shebang_regex___shebang_regex_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz";
        sha1 = "ae16f1644d873ecad843b0307b143362d4c42172";
      };
    }
    {
      name = "shellwords___shellwords_0.1.1.tgz";
      path = fetchurl {
        name = "shellwords___shellwords_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/shellwords/-/shellwords-0.1.1.tgz";
        sha1 = "d6b9181c1a48d397324c84871efbcfc73fc0654b";
      };
    }
    {
      name = "signal_exit___signal_exit_3.0.3.tgz";
      path = fetchurl {
        name = "signal_exit___signal_exit_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.3.tgz";
        sha1 = "a1410c2edd8f077b08b4e253c8eacfcaf057461c";
      };
    }
    {
      name = "sisteransi___sisteransi_1.0.5.tgz";
      path = fetchurl {
        name = "sisteransi___sisteransi_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/sisteransi/-/sisteransi-1.0.5.tgz";
        sha1 = "134d681297756437cc05ca01370d3a7a571075ed";
      };
    }
    {
      name = "slash___slash_3.0.0.tgz";
      path = fetchurl {
        name = "slash___slash_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz";
        sha1 = "6539be870c165adbd5240220dbe361f1bc4d4634";
      };
    }
    {
      name = "slice_ansi___slice_ansi_2.1.0.tgz";
      path = fetchurl {
        name = "slice_ansi___slice_ansi_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-2.1.0.tgz";
        sha1 = "cacd7693461a637a5788d92a7dd4fba068e81636";
      };
    }
    {
      name = "snapdragon_node___snapdragon_node_2.1.1.tgz";
      path = fetchurl {
        name = "snapdragon_node___snapdragon_node_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz";
        sha1 = "6c175f86ff14bdb0724563e8f3c1b021a286853b";
      };
    }
    {
      name = "snapdragon_util___snapdragon_util_3.0.1.tgz";
      path = fetchurl {
        name = "snapdragon_util___snapdragon_util_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz";
        sha1 = "f956479486f2acd79700693f6f7b805e45ab56e2";
      };
    }
    {
      name = "snapdragon___snapdragon_0.8.2.tgz";
      path = fetchurl {
        name = "snapdragon___snapdragon_0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz";
        sha1 = "64922e7c565b0e14204ba1aa7d6964278d25182d";
      };
    }
    {
      name = "source_map_resolve___source_map_resolve_0.5.3.tgz";
      path = fetchurl {
        name = "source_map_resolve___source_map_resolve_0.5.3.tgz";
        url  = "https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.3.tgz";
        sha1 = "190866bece7553e1f8f267a2ee82c606b5509a1a";
      };
    }
    {
      name = "source_map_support___source_map_support_0.5.19.tgz";
      path = fetchurl {
        name = "source_map_support___source_map_support_0.5.19.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.19.tgz";
        sha1 = "a98b62f86dcaf4f67399648c085291ab9e8fed61";
      };
    }
    {
      name = "source_map_url___source_map_url_0.4.0.tgz";
      path = fetchurl {
        name = "source_map_url___source_map_url_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.0.tgz";
        sha1 = "3e935d7ddd73631b97659956d55128e87b5084a3";
      };
    }
    {
      name = "source_map___source_map_0.5.7.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.5.7.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz";
        sha1 = "8a039d2d1021d22d1ea14c80d8ea468ba2ef3fcc";
      };
    }
    {
      name = "source_map___source_map_0.6.1.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz";
        sha1 = "74722af32e9614e9c287a8d0bbde48b5e2f1a263";
      };
    }
    {
      name = "source_map___source_map_0.7.3.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.7.3.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.7.3.tgz";
        sha1 = "5302f8169031735226544092e64981f751750383";
      };
    }
    {
      name = "spdx_correct___spdx_correct_3.1.1.tgz";
      path = fetchurl {
        name = "spdx_correct___spdx_correct_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.1.1.tgz";
        sha1 = "dece81ac9c1e6713e5f7d1b6f17d468fa53d89a9";
      };
    }
    {
      name = "spdx_exceptions___spdx_exceptions_2.3.0.tgz";
      path = fetchurl {
        name = "spdx_exceptions___spdx_exceptions_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz";
        sha1 = "3f28ce1a77a00372683eade4a433183527a2163d";
      };
    }
    {
      name = "spdx_expression_parse___spdx_expression_parse_3.0.1.tgz";
      path = fetchurl {
        name = "spdx_expression_parse___spdx_expression_parse_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz";
        sha1 = "cf70f50482eefdc98e3ce0a6833e4a53ceeba679";
      };
    }
    {
      name = "spdx_license_ids___spdx_license_ids_3.0.7.tgz";
      path = fetchurl {
        name = "spdx_license_ids___spdx_license_ids_3.0.7.tgz";
        url  = "https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.7.tgz";
        sha1 = "e9c18a410e5ed7e12442a549fbd8afa767038d65";
      };
    }
    {
      name = "split_string___split_string_3.1.0.tgz";
      path = fetchurl {
        name = "split_string___split_string_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz";
        sha1 = "7cb09dda3a86585705c64b39a6466038682e8fe2";
      };
    }
    {
      name = "sprintf_js___sprintf_js_1.1.2.tgz";
      path = fetchurl {
        name = "sprintf_js___sprintf_js_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz";
        sha1 = "da1765262bf8c0f571749f2ad6c26300207ae673";
      };
    }
    {
      name = "sprintf_js___sprintf_js_1.0.3.tgz";
      path = fetchurl {
        name = "sprintf_js___sprintf_js_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz";
        sha1 = "04e6926f662895354f3dd015203633b857297e2c";
      };
    }
    {
      name = "sshpk___sshpk_1.16.1.tgz";
      path = fetchurl {
        name = "sshpk___sshpk_1.16.1.tgz";
        url  = "https://registry.yarnpkg.com/sshpk/-/sshpk-1.16.1.tgz";
        sha1 = "fb661c0bef29b39db40769ee39fa70093d6f6877";
      };
    }
    {
      name = "stack_utils___stack_utils_2.0.3.tgz";
      path = fetchurl {
        name = "stack_utils___stack_utils_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/stack-utils/-/stack-utils-2.0.3.tgz";
        sha1 = "cd5f030126ff116b78ccb3c027fe302713b61277";
      };
    }
    {
      name = "stat_mode___stat_mode_1.0.0.tgz";
      path = fetchurl {
        name = "stat_mode___stat_mode_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stat-mode/-/stat-mode-1.0.0.tgz";
        sha1 = "68b55cb61ea639ff57136f36b216a291800d1465";
      };
    }
    {
      name = "static_extend___static_extend_0.1.2.tgz";
      path = fetchurl {
        name = "static_extend___static_extend_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz";
        sha1 = "60809c39cbff55337226fd5e0b520f341f1fb5c6";
      };
    }
    {
      name = "stealthy_require___stealthy_require_1.1.1.tgz";
      path = fetchurl {
        name = "stealthy_require___stealthy_require_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/stealthy-require/-/stealthy-require-1.1.1.tgz";
        sha1 = "35b09875b4ff49f26a777e509b3090a3226bf24b";
      };
    }
    {
      name = "string_length___string_length_4.0.1.tgz";
      path = fetchurl {
        name = "string_length___string_length_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/string-length/-/string-length-4.0.1.tgz";
        sha1 = "4a973bf31ef77c4edbceadd6af2611996985f8a1";
      };
    }
    {
      name = "string_width___string_width_3.1.0.tgz";
      path = fetchurl {
        name = "string_width___string_width_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-3.1.0.tgz";
        sha1 = "22767be21b62af1081574306f69ac51b62203961";
      };
    }
    {
      name = "string_width___string_width_4.2.0.tgz";
      path = fetchurl {
        name = "string_width___string_width_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-4.2.0.tgz";
        sha1 = "952182c46cc7b2c313d1596e623992bd163b72b5";
      };
    }
    {
      name = "string_decoder___string_decoder_1.3.0.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz";
        sha1 = "42f114594a46cf1a8e30b0a84f56c78c3edac21e";
      };
    }
    {
      name = "string_decoder___string_decoder_1.1.1.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz";
        sha1 = "9cf1611ba62685d7030ae9e4ba34149c3af03fc8";
      };
    }
    {
      name = "strip_ansi___strip_ansi_5.2.0.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz";
        sha1 = "8c9a536feb6afc962bdfa5b104a5091c1ad9c0ae";
      };
    }
    {
      name = "strip_ansi___strip_ansi_6.0.0.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.0.tgz";
        sha1 = "0b1571dd7669ccd4f3e06e14ef1eed26225ae532";
      };
    }
    {
      name = "strip_bom___strip_bom_4.0.0.tgz";
      path = fetchurl {
        name = "strip_bom___strip_bom_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-4.0.0.tgz";
        sha1 = "9c3505c1db45bcedca3d9cf7a16f5c5aa3901878";
      };
    }
    {
      name = "strip_eof___strip_eof_1.0.0.tgz";
      path = fetchurl {
        name = "strip_eof___strip_eof_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz";
        sha1 = "bb43ff5598a6eb05d89b59fcd129c983313606bf";
      };
    }
    {
      name = "strip_final_newline___strip_final_newline_2.0.0.tgz";
      path = fetchurl {
        name = "strip_final_newline___strip_final_newline_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz";
        sha1 = "89b852fb2fcbe936f6f4b3187afb0a12c1ab58ad";
      };
    }
    {
      name = "strip_json_comments___strip_json_comments_3.1.1.tgz";
      path = fetchurl {
        name = "strip_json_comments___strip_json_comments_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz";
        sha1 = "31f1281b3832630434831c310c01cccda8cbe006";
      };
    }
    {
      name = "strip_json_comments___strip_json_comments_2.0.1.tgz";
      path = fetchurl {
        name = "strip_json_comments___strip_json_comments_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz";
        sha1 = "3c531942e908c2697c0ec344858c286c7ca0a60a";
      };
    }
    {
      name = "sumchecker___sumchecker_3.0.1.tgz";
      path = fetchurl {
        name = "sumchecker___sumchecker_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz";
        sha1 = "6377e996795abb0b6d348e9b3e1dfb24345a8e42";
      };
    }
    {
      name = "supports_color___supports_color_5.5.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_5.5.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz";
        sha1 = "e2e69a44ac8772f78a1ec0b35b689df6530efc8f";
      };
    }
    {
      name = "supports_color___supports_color_7.2.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz";
        sha1 = "1b7dcdcb32b8138801b3e478ba6a51caa89648da";
      };
    }
    {
      name = "supports_hyperlinks___supports_hyperlinks_2.1.0.tgz";
      path = fetchurl {
        name = "supports_hyperlinks___supports_hyperlinks_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-hyperlinks/-/supports-hyperlinks-2.1.0.tgz";
        sha1 = "f663df252af5f37c5d49bbd7eeefa9e0b9e59e47";
      };
    }
    {
      name = "symbol_tree___symbol_tree_3.2.4.tgz";
      path = fetchurl {
        name = "symbol_tree___symbol_tree_3.2.4.tgz";
        url  = "https://registry.yarnpkg.com/symbol-tree/-/symbol-tree-3.2.4.tgz";
        sha1 = "430637d248ba77e078883951fb9aa0eed7c63fa2";
      };
    }
    {
      name = "table___table_5.4.6.tgz";
      path = fetchurl {
        name = "table___table_5.4.6.tgz";
        url  = "https://registry.yarnpkg.com/table/-/table-5.4.6.tgz";
        sha1 = "1292d19500ce3f86053b05f0e8e7e4a3bb21079e";
      };
    }
    {
      name = "tar_stream___tar_stream_2.1.4.tgz";
      path = fetchurl {
        name = "tar_stream___tar_stream_2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/tar-stream/-/tar-stream-2.1.4.tgz";
        sha1 = "c4fb1a11eb0da29b893a5b25476397ba2d053bfa";
      };
    }
    {
      name = "temp_file___temp_file_3.3.7.tgz";
      path = fetchurl {
        name = "temp_file___temp_file_3.3.7.tgz";
        url  = "https://registry.yarnpkg.com/temp-file/-/temp-file-3.3.7.tgz";
        sha1 = "686885d635f872748e384e871855958470aeb18a";
      };
    }
    {
      name = "term_size___term_size_2.2.1.tgz";
      path = fetchurl {
        name = "term_size___term_size_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/term-size/-/term-size-2.2.1.tgz";
        sha1 = "2a6a54840432c2fb6320fea0f415531e90189f54";
      };
    }
    {
      name = "terminal_link___terminal_link_2.1.1.tgz";
      path = fetchurl {
        name = "terminal_link___terminal_link_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/terminal-link/-/terminal-link-2.1.1.tgz";
        sha1 = "14a64a27ab3c0df933ea546fba55f2d078edc994";
      };
    }
    {
      name = "test_exclude___test_exclude_6.0.0.tgz";
      path = fetchurl {
        name = "test_exclude___test_exclude_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/test-exclude/-/test-exclude-6.0.0.tgz";
        sha1 = "04a8698661d805ea6fa293b6cb9e63ac044ef15e";
      };
    }
    {
      name = "text_table___text_table_0.2.0.tgz";
      path = fetchurl {
        name = "text_table___text_table_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz";
        sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
      };
    }
    {
      name = "throat___throat_5.0.0.tgz";
      path = fetchurl {
        name = "throat___throat_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/throat/-/throat-5.0.0.tgz";
        sha1 = "c5199235803aad18754a667d659b5e72ce16764b";
      };
    }
    {
      name = "tldts_core___tldts_core_5.6.64.tgz";
      path = fetchurl {
        name = "tldts_core___tldts_core_5.6.64.tgz";
        url  = "https://registry.yarnpkg.com/tldts-core/-/tldts-core-5.6.64.tgz";
        sha1 = "0f80d0c9607d7583acc477a10dae7e62e7c08063";
      };
    }
    {
      name = "tldts_experimental___tldts_experimental_5.6.64.tgz";
      path = fetchurl {
        name = "tldts_experimental___tldts_experimental_5.6.64.tgz";
        url  = "https://registry.yarnpkg.com/tldts-experimental/-/tldts-experimental-5.6.64.tgz";
        sha1 = "f867449964d94c6a17a499335658f42a9fbdc7d3";
      };
    }
    {
      name = "tmpl___tmpl_1.0.4.tgz";
      path = fetchurl {
        name = "tmpl___tmpl_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/tmpl/-/tmpl-1.0.4.tgz";
        sha1 = "23640dd7b42d00433911140820e5cf440e521dd1";
      };
    }
    {
      name = "to_fast_properties___to_fast_properties_2.0.0.tgz";
      path = fetchurl {
        name = "to_fast_properties___to_fast_properties_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz";
        sha1 = "dc5e698cbd079265bc73e0377681a4e4e83f616e";
      };
    }
    {
      name = "to_object_path___to_object_path_0.3.0.tgz";
      path = fetchurl {
        name = "to_object_path___to_object_path_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz";
        sha1 = "297588b7b0e7e0ac08e04e672f85c1f4999e17af";
      };
    }
    {
      name = "to_readable_stream___to_readable_stream_1.0.0.tgz";
      path = fetchurl {
        name = "to_readable_stream___to_readable_stream_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/to-readable-stream/-/to-readable-stream-1.0.0.tgz";
        sha1 = "ce0aa0c2f3df6adf852efb404a783e77c0475771";
      };
    }
    {
      name = "to_regex_range___to_regex_range_2.1.1.tgz";
      path = fetchurl {
        name = "to_regex_range___to_regex_range_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz";
        sha1 = "7c80c17b9dfebe599e27367e0d4dd5590141db38";
      };
    }
    {
      name = "to_regex_range___to_regex_range_5.0.1.tgz";
      path = fetchurl {
        name = "to_regex_range___to_regex_range_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz";
        sha1 = "1648c44aae7c8d988a326018ed72f5b4dd0392e4";
      };
    }
    {
      name = "to_regex___to_regex_3.0.2.tgz";
      path = fetchurl {
        name = "to_regex___to_regex_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz";
        sha1 = "13cfdd9b336552f30b51f33a8ae1b42a7a7599ce";
      };
    }
    {
      name = "tough_cookie___tough_cookie_2.5.0.tgz";
      path = fetchurl {
        name = "tough_cookie___tough_cookie_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.5.0.tgz";
        sha1 = "cd9fb2a0aa1d5a12b473bd9fb96fa3dcff65ade2";
      };
    }
    {
      name = "tough_cookie___tough_cookie_3.0.1.tgz";
      path = fetchurl {
        name = "tough_cookie___tough_cookie_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-3.0.1.tgz";
        sha1 = "9df4f57e739c26930a018184887f4adb7dca73b2";
      };
    }
    {
      name = "tr46___tr46_2.0.2.tgz";
      path = fetchurl {
        name = "tr46___tr46_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/tr46/-/tr46-2.0.2.tgz";
        sha1 = "03273586def1595ae08fedb38d7733cee91d2479";
      };
    }
    {
      name = "truncate_utf8_bytes___truncate_utf8_bytes_1.0.2.tgz";
      path = fetchurl {
        name = "truncate_utf8_bytes___truncate_utf8_bytes_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz";
        sha1 = "405923909592d56f78a5818434b0b78489ca5f2b";
      };
    }
    {
      name = "tunnel_agent___tunnel_agent_0.6.0.tgz";
      path = fetchurl {
        name = "tunnel_agent___tunnel_agent_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz";
        sha1 = "27a5dea06b36b04a0a9966774b290868f0fc40fd";
      };
    }
    {
      name = "tunnel___tunnel_0.0.6.tgz";
      path = fetchurl {
        name = "tunnel___tunnel_0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz";
        sha1 = "72f1314b34a5b192db012324df2cc587ca47f92c";
      };
    }
    {
      name = "tweetnacl___tweetnacl_0.14.5.tgz";
      path = fetchurl {
        name = "tweetnacl___tweetnacl_0.14.5.tgz";
        url  = "https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz";
        sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
      };
    }
    {
      name = "type_check___type_check_0.4.0.tgz";
      path = fetchurl {
        name = "type_check___type_check_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz";
        sha1 = "07b8203bfa7056c0657050e3ccd2c37730bab8f1";
      };
    }
    {
      name = "type_check___type_check_0.3.2.tgz";
      path = fetchurl {
        name = "type_check___type_check_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz";
        sha1 = "5884cab512cf1d355e3fb784f30804b2b520db72";
      };
    }
    {
      name = "type_detect___type_detect_4.0.8.tgz";
      path = fetchurl {
        name = "type_detect___type_detect_4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/type-detect/-/type-detect-4.0.8.tgz";
        sha1 = "7646fb5f18871cfbb7749e69bd39a6388eb7450c";
      };
    }
    {
      name = "type_fest___type_fest_0.11.0.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.11.0.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.11.0.tgz";
        sha1 = "97abf0872310fed88a5c466b25681576145e33f1";
      };
    }
    {
      name = "type_fest___type_fest_0.13.1.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.13.1.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz";
        sha1 = "0172cb5bce80b0bd542ea348db50c7e21834d934";
      };
    }
    {
      name = "type_fest___type_fest_0.6.0.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.6.0.tgz";
        sha1 = "8d2a2370d3df886eb5c90ada1c5bf6188acf838b";
      };
    }
    {
      name = "type_fest___type_fest_0.8.1.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.8.1.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.8.1.tgz";
        sha1 = "09e249ebde851d3b1e48d27c105444667f17b83d";
      };
    }
    {
      name = "typedarray_to_buffer___typedarray_to_buffer_3.1.5.tgz";
      path = fetchurl {
        name = "typedarray_to_buffer___typedarray_to_buffer_3.1.5.tgz";
        url  = "https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz";
        sha1 = "a97ee7a9ff42691b9f783ff1bc5112fe3fca9080";
      };
    }
    {
      name = "typedarray___typedarray_0.0.6.tgz";
      path = fetchurl {
        name = "typedarray___typedarray_0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz";
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      };
    }
    {
      name = "union_value___union_value_1.0.1.tgz";
      path = fetchurl {
        name = "union_value___union_value_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/union-value/-/union-value-1.0.1.tgz";
        sha1 = "0b6fe7b835aecda61c6ea4d4f02c14221e109847";
      };
    }
    {
      name = "unique_string___unique_string_2.0.0.tgz";
      path = fetchurl {
        name = "unique_string___unique_string_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unique-string/-/unique-string-2.0.0.tgz";
        sha1 = "39c6451f81afb2749de2b233e3f7c5e8843bd89d";
      };
    }
    {
      name = "universalify___universalify_0.1.2.tgz";
      path = fetchurl {
        name = "universalify___universalify_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz";
        sha1 = "b646f69be3942dabcecc9d6639c80dc105efaa66";
      };
    }
    {
      name = "universalify___universalify_1.0.0.tgz";
      path = fetchurl {
        name = "universalify___universalify_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-1.0.0.tgz";
        sha1 = "b61a1da173e8435b2fe3c67d29b9adf8594bd16d";
      };
    }
    {
      name = "universalify___universalify_2.0.0.tgz";
      path = fetchurl {
        name = "universalify___universalify_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz";
        sha1 = "75a4984efedc4b08975c5aeb73f530d02df25717";
      };
    }
    {
      name = "unset_value___unset_value_1.0.0.tgz";
      path = fetchurl {
        name = "unset_value___unset_value_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz";
        sha1 = "8376873f7d2335179ffb1e6fc3a8ed0dfc8ab559";
      };
    }
    {
      name = "update_notifier___update_notifier_4.1.3.tgz";
      path = fetchurl {
        name = "update_notifier___update_notifier_4.1.3.tgz";
        url  = "https://registry.yarnpkg.com/update-notifier/-/update-notifier-4.1.3.tgz";
        sha1 = "be86ee13e8ce48fb50043ff72057b5bd598e1ea3";
      };
    }
    {
      name = "uri_js___uri_js_4.4.0.tgz";
      path = fetchurl {
        name = "uri_js___uri_js_4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.0.tgz";
        sha1 = "aa714261de793e8a82347a7bcc9ce74e86f28602";
      };
    }
    {
      name = "urix___urix_0.1.0.tgz";
      path = fetchurl {
        name = "urix___urix_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz";
        sha1 = "da937f7a62e21fec1fd18d49b35c2935067a6c72";
      };
    }
    {
      name = "url_parse_lax___url_parse_lax_3.0.0.tgz";
      path = fetchurl {
        name = "url_parse_lax___url_parse_lax_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-3.0.0.tgz";
        sha1 = "16b5cafc07dbe3676c1b1999177823d6503acb0c";
      };
    }
    {
      name = "use___use_3.1.1.tgz";
      path = fetchurl {
        name = "use___use_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/use/-/use-3.1.1.tgz";
        sha1 = "d50c8cac79a19fbc20f2911f56eb973f4e10070f";
      };
    }
    {
      name = "utf8_byte_length___utf8_byte_length_1.0.4.tgz";
      path = fetchurl {
        name = "utf8_byte_length___utf8_byte_length_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz";
        sha1 = "f45f150c4c66eee968186505ab93fcbb8ad6bf61";
      };
    }
    {
      name = "util_deprecate___util_deprecate_1.0.2.tgz";
      path = fetchurl {
        name = "util_deprecate___util_deprecate_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    }
    {
      name = "uuid___uuid_3.4.0.tgz";
      path = fetchurl {
        name = "uuid___uuid_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.4.0.tgz";
        sha1 = "b23e4358afa8a202fe7a100af1f5f883f02007ee";
      };
    }
    {
      name = "uuid___uuid_8.3.2.tgz";
      path = fetchurl {
        name = "uuid___uuid_8.3.2.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-8.3.2.tgz";
        sha1 = "80d5b5ced271bb9af6c445f21a1a04c606cefbe2";
      };
    }
    {
      name = "v8_compile_cache___v8_compile_cache_2.2.0.tgz";
      path = fetchurl {
        name = "v8_compile_cache___v8_compile_cache_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.2.0.tgz";
        sha1 = "9471efa3ef9128d2f7c6a7ca39c4dd6b5055b132";
      };
    }
    {
      name = "v8_to_istanbul___v8_to_istanbul_7.0.0.tgz";
      path = fetchurl {
        name = "v8_to_istanbul___v8_to_istanbul_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/v8-to-istanbul/-/v8-to-istanbul-7.0.0.tgz";
        sha1 = "b4fe00e35649ef7785a9b7fcebcea05f37c332fc";
      };
    }
    {
      name = "validate_npm_package_license___validate_npm_package_license_3.0.4.tgz";
      path = fetchurl {
        name = "validate_npm_package_license___validate_npm_package_license_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz";
        sha1 = "fc91f6b9c7ba15c857f4cb2c5defeec39d4f410a";
      };
    }
    {
      name = "verror___verror_1.10.0.tgz";
      path = fetchurl {
        name = "verror___verror_1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/verror/-/verror-1.10.0.tgz";
        sha1 = "3a105ca17053af55d6e270c1f8288682e18da400";
      };
    }
    {
      name = "w3c_hr_time___w3c_hr_time_1.0.2.tgz";
      path = fetchurl {
        name = "w3c_hr_time___w3c_hr_time_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz";
        sha1 = "0a89cdf5cc15822df9c360543676963e0cc308cd";
      };
    }
    {
      name = "w3c_xmlserializer___w3c_xmlserializer_2.0.0.tgz";
      path = fetchurl {
        name = "w3c_xmlserializer___w3c_xmlserializer_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/w3c-xmlserializer/-/w3c-xmlserializer-2.0.0.tgz";
        sha1 = "3e7104a05b75146cc60f564380b7f683acf1020a";
      };
    }
    {
      name = "walker___walker_1.0.7.tgz";
      path = fetchurl {
        name = "walker___walker_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/walker/-/walker-1.0.7.tgz";
        sha1 = "2f7f9b8fd10d677262b18a884e28d19618e028fb";
      };
    }
    {
      name = "webidl_conversions___webidl_conversions_5.0.0.tgz";
      path = fetchurl {
        name = "webidl_conversions___webidl_conversions_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-5.0.0.tgz";
        sha1 = "ae59c8a00b121543a2acc65c0434f57b0fc11aff";
      };
    }
    {
      name = "webidl_conversions___webidl_conversions_6.1.0.tgz";
      path = fetchurl {
        name = "webidl_conversions___webidl_conversions_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-6.1.0.tgz";
        sha1 = "9111b4d7ea80acd40f5270d666621afa78b69514";
      };
    }
    {
      name = "whatwg_encoding___whatwg_encoding_1.0.5.tgz";
      path = fetchurl {
        name = "whatwg_encoding___whatwg_encoding_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz";
        sha1 = "5abacf777c32166a51d085d6b4f3e7d27113ddb0";
      };
    }
    {
      name = "whatwg_mimetype___whatwg_mimetype_2.3.0.tgz";
      path = fetchurl {
        name = "whatwg_mimetype___whatwg_mimetype_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz";
        sha1 = "3d4b1e0312d2079879f826aff18dbeeca5960fbf";
      };
    }
    {
      name = "whatwg_url___whatwg_url_8.4.0.tgz";
      path = fetchurl {
        name = "whatwg_url___whatwg_url_8.4.0.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-8.4.0.tgz";
        sha1 = "50fb9615b05469591d2b2bd6dfaed2942ed72837";
      };
    }
    {
      name = "which_module___which_module_2.0.0.tgz";
      path = fetchurl {
        name = "which_module___which_module_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz";
        sha1 = "d9ef07dce77b9902b8a3a8fa4b31c3e3f7e6e87a";
      };
    }
    {
      name = "which___which_1.3.1.tgz";
      path = fetchurl {
        name = "which___which_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-1.3.1.tgz";
        sha1 = "a45043d54f5805316da8d62f9f50918d3da70b0a";
      };
    }
    {
      name = "which___which_2.0.2.tgz";
      path = fetchurl {
        name = "which___which_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-2.0.2.tgz";
        sha1 = "7c6a8dd0a636a0327e10b59c9286eee93f3f51b1";
      };
    }
    {
      name = "widest_line___widest_line_3.1.0.tgz";
      path = fetchurl {
        name = "widest_line___widest_line_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/widest-line/-/widest-line-3.1.0.tgz";
        sha1 = "8292333bbf66cb45ff0de1603b136b7ae1496eca";
      };
    }
    {
      name = "word_wrap___word_wrap_1.2.3.tgz";
      path = fetchurl {
        name = "word_wrap___word_wrap_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz";
        sha1 = "610636f6b1f703891bd34771ccb17fb93b47079c";
      };
    }
    {
      name = "wrap_ansi___wrap_ansi_6.2.0.tgz";
      path = fetchurl {
        name = "wrap_ansi___wrap_ansi_6.2.0.tgz";
        url  = "https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-6.2.0.tgz";
        sha1 = "e9393ba07102e6c91a3b221478f0257cd2856e53";
      };
    }
    {
      name = "wrap_ansi___wrap_ansi_7.0.0.tgz";
      path = fetchurl {
        name = "wrap_ansi___wrap_ansi_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz";
        sha1 = "67e145cff510a6a6984bdf1152911d69d2eb9e43";
      };
    }
    {
      name = "wrappy___wrappy_1.0.2.tgz";
      path = fetchurl {
        name = "wrappy___wrappy_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    }
    {
      name = "write_file_atomic___write_file_atomic_3.0.3.tgz";
      path = fetchurl {
        name = "write_file_atomic___write_file_atomic_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-3.0.3.tgz";
        sha1 = "56bd5c5a5c70481cd19c571bd39ab965a5de56e8";
      };
    }
    {
      name = "ws___ws_7.4.1.tgz";
      path = fetchurl {
        name = "ws___ws_7.4.1.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-7.4.1.tgz";
        sha1 = "a333be02696bd0e54cea0434e21dcc8a9ac294bb";
      };
    }
    {
      name = "xdg_basedir___xdg_basedir_4.0.0.tgz";
      path = fetchurl {
        name = "xdg_basedir___xdg_basedir_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-4.0.0.tgz";
        sha1 = "4bc8d9984403696225ef83a1573cbbcb4e79db13";
      };
    }
    {
      name = "xml_name_validator___xml_name_validator_3.0.0.tgz";
      path = fetchurl {
        name = "xml_name_validator___xml_name_validator_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xml-name-validator/-/xml-name-validator-3.0.0.tgz";
        sha1 = "6ae73e06de4d8c6e47f9fb181f78d648ad457c6a";
      };
    }
    {
      name = "xmlchars___xmlchars_2.2.0.tgz";
      path = fetchurl {
        name = "xmlchars___xmlchars_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/xmlchars/-/xmlchars-2.2.0.tgz";
        sha1 = "060fe1bcb7f9c76fe2a17db86a9bc3ab894210cb";
      };
    }
    {
      name = "y18n___y18n_4.0.1.tgz";
      path = fetchurl {
        name = "y18n___y18n_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-4.0.1.tgz";
        sha1 = "8db2b83c31c5d75099bb890b23f3094891e247d4";
      };
    }
    {
      name = "y18n___y18n_5.0.5.tgz";
      path = fetchurl {
        name = "y18n___y18n_5.0.5.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-5.0.5.tgz";
        sha1 = "8769ec08d03b1ea2df2500acef561743bbb9ab18";
      };
    }
    {
      name = "yallist___yallist_4.0.0.tgz";
      path = fetchurl {
        name = "yallist___yallist_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz";
        sha1 = "9bb92790d9c0effec63be73519e11a35019a3a72";
      };
    }
    {
      name = "yargs_parser___yargs_parser_18.1.3.tgz";
      path = fetchurl {
        name = "yargs_parser___yargs_parser_18.1.3.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-18.1.3.tgz";
        sha1 = "be68c4975c6b2abf469236b0c870362fab09a7b0";
      };
    }
    {
      name = "yargs_parser___yargs_parser_20.2.4.tgz";
      path = fetchurl {
        name = "yargs_parser___yargs_parser_20.2.4.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.4.tgz";
        sha1 = "b42890f14566796f85ae8e3a25290d205f154a54";
      };
    }
    {
      name = "yargs___yargs_15.4.1.tgz";
      path = fetchurl {
        name = "yargs___yargs_15.4.1.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-15.4.1.tgz";
        sha1 = "0d87a16de01aee9d8bec2bfbf74f67851730f4f8";
      };
    }
    {
      name = "yargs___yargs_16.2.0.tgz";
      path = fetchurl {
        name = "yargs___yargs_16.2.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz";
        sha1 = "1c82bf0f6b6a66eafce7ef30e376f49a12477f66";
      };
    }
    {
      name = "yauzl___yauzl_2.10.0.tgz";
      path = fetchurl {
        name = "yauzl___yauzl_2.10.0.tgz";
        url  = "https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz";
        sha1 = "c7eb17c93e112cb1086fa6d8e51fb0667b79a5f9";
      };
    }
    {
      name = "zip_stream___zip_stream_4.0.4.tgz";
      path = fetchurl {
        name = "zip_stream___zip_stream_4.0.4.tgz";
        url  = "https://registry.yarnpkg.com/zip-stream/-/zip-stream-4.0.4.tgz";
        sha1 = "3a8f100b73afaa7d1ae9338d910b321dec77ff3a";
      };
    }
  ];
}
