{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "7zip_bin___7zip_bin_5.1.1.tgz";
      path = fetchurl {
        name = "7zip_bin___7zip_bin_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/7zip-bin/-/7zip-bin-5.1.1.tgz";
        sha1 = "9274ec7460652f9c632c59addf24efb1684ef876";
      };
    }
    {
      name = "_babel_code_frame___code_frame_7.12.11.tgz";
      path = fetchurl {
        name = "_babel_code_frame___code_frame_7.12.11.tgz";
        url  = "https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.12.11.tgz";
        sha1 = "f4ad435aa263db935b8f10f2c552d23fb716a63f";
      };
    }
    {
      name = "_babel_code_frame___code_frame_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_code_frame___code_frame_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.14.5.tgz";
        sha1 = "23b08d740e83f49c5e59945fbf1b43e80bbf4edb";
      };
    }
    {
      name = "_babel_compat_data___compat_data_7.14.7.tgz";
      path = fetchurl {
        name = "_babel_compat_data___compat_data_7.14.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.14.7.tgz";
        sha1 = "7b047d7a3a89a67d2258dc61f604f098f1bc7e08";
      };
    }
    {
      name = "_babel_core___core_7.14.6.tgz";
      path = fetchurl {
        name = "_babel_core___core_7.14.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/core/-/core-7.14.6.tgz";
        sha1 = "e0814ec1a950032ff16c13a2721de39a8416fcab";
      };
    }
    {
      name = "_babel_generator___generator_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_generator___generator_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/generator/-/generator-7.14.5.tgz";
        sha1 = "848d7b9f031caca9d0cd0af01b063f226f52d785";
      };
    }
    {
      name = "_babel_helper_compilation_targets___helper_compilation_targets_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_compilation_targets___helper_compilation_targets_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.14.5.tgz";
        sha1 = "7a99c5d0967911e972fe2c3411f7d5b498498ecf";
      };
    }
    {
      name = "_babel_helper_function_name___helper_function_name_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_function_name___helper_function_name_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.14.5.tgz";
        sha1 = "89e2c474972f15d8e233b52ee8c480e2cfcd50c4";
      };
    }
    {
      name = "_babel_helper_get_function_arity___helper_get_function_arity_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_get_function_arity___helper_get_function_arity_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-get-function-arity/-/helper-get-function-arity-7.14.5.tgz";
        sha1 = "25fbfa579b0937eee1f3b805ece4ce398c431815";
      };
    }
    {
      name = "_babel_helper_hoist_variables___helper_hoist_variables_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_hoist_variables___helper_hoist_variables_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.14.5.tgz";
        sha1 = "e0dd27c33a78e577d7c8884916a3e7ef1f7c7f8d";
      };
    }
    {
      name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.14.7.tgz";
      path = fetchurl {
        name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.14.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.14.7.tgz";
        sha1 = "97e56244beb94211fe277bd818e3a329c66f7970";
      };
    }
    {
      name = "_babel_helper_module_imports___helper_module_imports_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_module_imports___helper_module_imports_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.14.5.tgz";
        sha1 = "6d1a44df6a38c957aa7c312da076429f11b422f3";
      };
    }
    {
      name = "_babel_helper_module_transforms___helper_module_transforms_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_module_transforms___helper_module_transforms_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.14.5.tgz";
        sha1 = "7de42f10d789b423eb902ebd24031ca77cb1e10e";
      };
    }
    {
      name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.14.5.tgz";
        sha1 = "f27395a8619e0665b3f0364cddb41c25d71b499c";
      };
    }
    {
      name = "_babel_helper_plugin_utils___helper_plugin_utils_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_plugin_utils___helper_plugin_utils_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.14.5.tgz";
        sha1 = "5ac822ce97eec46741ab70a517971e443a70c5a9";
      };
    }
    {
      name = "_babel_helper_replace_supers___helper_replace_supers_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_replace_supers___helper_replace_supers_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.14.5.tgz";
        sha1 = "0ecc0b03c41cd567b4024ea016134c28414abb94";
      };
    }
    {
      name = "_babel_helper_simple_access___helper_simple_access_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_simple_access___helper_simple_access_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.14.5.tgz";
        sha1 = "66ea85cf53ba0b4e588ba77fc813f53abcaa41c4";
      };
    }
    {
      name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.14.5.tgz";
        sha1 = "22b23a54ef51c2b7605d851930c1976dd0bc693a";
      };
    }
    {
      name = "_babel_helper_validator_identifier___helper_validator_identifier_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_validator_identifier___helper_validator_identifier_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.14.5.tgz";
        sha1 = "d0f0e277c512e0c938277faa85a3968c9a44c0e8";
      };
    }
    {
      name = "_babel_helper_validator_option___helper_validator_option_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_helper_validator_option___helper_validator_option_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.14.5.tgz";
        sha1 = "6e72a1fff18d5dfcb878e1e62f1a021c4b72d5a3";
      };
    }
    {
      name = "_babel_helpers___helpers_7.14.6.tgz";
      path = fetchurl {
        name = "_babel_helpers___helpers_7.14.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.14.6.tgz";
        sha1 = "5b58306b95f1b47e2a0199434fa8658fa6c21635";
      };
    }
    {
      name = "_babel_highlight___highlight_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_highlight___highlight_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.14.5.tgz";
        sha1 = "6861a52f03966405001f6aa534a01a24d99e8cd9";
      };
    }
    {
      name = "_babel_parser___parser_7.14.7.tgz";
      path = fetchurl {
        name = "_babel_parser___parser_7.14.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/parser/-/parser-7.14.7.tgz";
        sha1 = "6099720c8839ca865a2637e6c85852ead0bdb595";
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
      name = "_babel_plugin_syntax_class_properties___plugin_syntax_class_properties_7.12.13.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_class_properties___plugin_syntax_class_properties_7.12.13.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz";
        sha1 = "b5c987274c4a3a82b89714796931a6b53544ae10";
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
      name = "_babel_plugin_syntax_top_level_await___plugin_syntax_top_level_await_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_top_level_await___plugin_syntax_top_level_await_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz";
        sha1 = "c1cfdadc35a646240001f06138247b741c34d94c";
      };
    }
    {
      name = "_babel_plugin_syntax_typescript___plugin_syntax_typescript_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_typescript___plugin_syntax_typescript_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.14.5.tgz";
        sha1 = "b82c6ce471b165b5ce420cf92914d6fb46225716";
      };
    }
    {
      name = "_babel_template___template_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_template___template_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/template/-/template-7.14.5.tgz";
        sha1 = "a9bc9d8b33354ff6e55a9c60d1109200a68974f4";
      };
    }
    {
      name = "_babel_traverse___traverse_7.14.7.tgz";
      path = fetchurl {
        name = "_babel_traverse___traverse_7.14.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.14.7.tgz";
        sha1 = "64007c9774cfdc3abd23b0780bc18a3ce3631753";
      };
    }
    {
      name = "_babel_types___types_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_types___types_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/types/-/types-7.14.5.tgz";
        sha1 = "3bb997ba829a2104cedb20689c4a5b8121d383ff";
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
      name = "_cliqz_adblocker_content___adblocker_content_1.22.2.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker_content___adblocker_content_1.22.2.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker-content/-/adblocker-content-1.22.2.tgz";
        sha1 = "643849d5f08c167eb84a2e7e3f1f9fbc41a3889b";
      };
    }
    {
      name = "_cliqz_adblocker_electron_preload___adblocker_electron_preload_1.22.2.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker_electron_preload___adblocker_electron_preload_1.22.2.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker-electron-preload/-/adblocker-electron-preload-1.22.2.tgz";
        sha1 = "eea674767a60abe4e5f9ccb46188d33656f551d0";
      };
    }
    {
      name = "_cliqz_adblocker_electron___adblocker_electron_1.22.2.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker_electron___adblocker_electron_1.22.2.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker-electron/-/adblocker-electron-1.22.2.tgz";
        sha1 = "85af3b49f7f653e6fb0d008b6523e3b3ba0dd41e";
      };
    }
    {
      name = "_cliqz_adblocker_extended_selectors___adblocker_extended_selectors_1.22.2.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker_extended_selectors___adblocker_extended_selectors_1.22.2.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker-extended-selectors/-/adblocker-extended-selectors-1.22.2.tgz";
        sha1 = "1cad3c1569b765d9e7f8672c85b2a7b1e8e9ee90";
      };
    }
    {
      name = "_cliqz_adblocker___adblocker_1.22.2.tgz";
      path = fetchurl {
        name = "_cliqz_adblocker___adblocker_1.22.2.tgz";
        url  = "https://registry.yarnpkg.com/@cliqz/adblocker/-/adblocker-1.22.2.tgz";
        sha1 = "99a14d56327734d3083a077d96fe7b91c236bf7a";
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
      name = "_electron_get___get_1.12.4.tgz";
      path = fetchurl {
        name = "_electron_get___get_1.12.4.tgz";
        url  = "https://registry.yarnpkg.com/@electron/get/-/get-1.12.4.tgz";
        sha1 = "a5971113fc1bf8fa12a8789dc20152a7359f06ab";
      };
    }
    {
      name = "_electron_universal___universal_1.0.5.tgz";
      path = fetchurl {
        name = "_electron_universal___universal_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/@electron/universal/-/universal-1.0.5.tgz";
        sha1 = "b812340e4ef21da2b3ee77b2b4d35c9b86defe37";
      };
    }
    {
      name = "_eslint_eslintrc___eslintrc_0.4.2.tgz";
      path = fetchurl {
        name = "_eslint_eslintrc___eslintrc_0.4.2.tgz";
        url  = "https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-0.4.2.tgz";
        sha1 = "f63d0ef06f5c0c57d76c4ab5f63d3835c51b0179";
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
      name = "_istanbuljs_schema___schema_0.1.3.tgz";
      path = fetchurl {
        name = "_istanbuljs_schema___schema_0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/@istanbuljs/schema/-/schema-0.1.3.tgz";
        sha1 = "e45e384e4b8ec16bce2fd903af78450f6bf7ec98";
      };
    }
    {
      name = "_jest_console___console_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_console___console_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/console/-/console-27.0.6.tgz";
        sha1 = "3eb72ea80897495c3d73dd97aab7f26770e2260f";
      };
    }
    {
      name = "_jest_core___core_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_core___core_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/core/-/core-27.0.6.tgz";
        sha1 = "c5f642727a0b3bf0f37c4b46c675372d0978d4a1";
      };
    }
    {
      name = "_jest_environment___environment_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_environment___environment_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/environment/-/environment-27.0.6.tgz";
        sha1 = "ee293fe996db01d7d663b8108fa0e1ff436219d2";
      };
    }
    {
      name = "_jest_fake_timers___fake_timers_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_fake_timers___fake_timers_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/fake-timers/-/fake-timers-27.0.6.tgz";
        sha1 = "cbad52f3fe6abe30e7acb8cd5fa3466b9588e3df";
      };
    }
    {
      name = "_jest_globals___globals_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_globals___globals_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/globals/-/globals-27.0.6.tgz";
        sha1 = "48e3903f99a4650673d8657334d13c9caf0e8f82";
      };
    }
    {
      name = "_jest_reporters___reporters_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_reporters___reporters_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/reporters/-/reporters-27.0.6.tgz";
        sha1 = "91e7f2d98c002ad5df94d5b5167c1eb0b9fd5b00";
      };
    }
    {
      name = "_jest_source_map___source_map_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_source_map___source_map_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/source-map/-/source-map-27.0.6.tgz";
        sha1 = "be9e9b93565d49b0548b86e232092491fb60551f";
      };
    }
    {
      name = "_jest_test_result___test_result_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_test_result___test_result_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/test-result/-/test-result-27.0.6.tgz";
        sha1 = "3fa42015a14e4fdede6acd042ce98c7f36627051";
      };
    }
    {
      name = "_jest_test_sequencer___test_sequencer_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_test_sequencer___test_sequencer_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/test-sequencer/-/test-sequencer-27.0.6.tgz";
        sha1 = "80a913ed7a1130545b1cd777ff2735dd3af5d34b";
      };
    }
    {
      name = "_jest_transform___transform_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_transform___transform_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/transform/-/transform-27.0.6.tgz";
        sha1 = "189ad7107413208f7600f4719f81dd2f7278cc95";
      };
    }
    {
      name = "_jest_types___types_27.0.6.tgz";
      path = fetchurl {
        name = "_jest_types___types_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@jest/types/-/types-27.0.6.tgz";
        sha1 = "9a992bc517e0c49f035938b8549719c2de40706b";
      };
    }
    {
      name = "_malept_cross_spawn_promise___cross_spawn_promise_1.1.1.tgz";
      path = fetchurl {
        name = "_malept_cross_spawn_promise___cross_spawn_promise_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz";
        sha1 = "504af200af6b98e198bce768bc1730c6936ae01d";
      };
    }
    {
      name = "_malept_flatpak_bundler___flatpak_bundler_0.4.0.tgz";
      path = fetchurl {
        name = "_malept_flatpak_bundler___flatpak_bundler_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz";
        sha1 = "e8a32c30a95d20c2b1bb635cc580981a06389858";
      };
    }
    {
      name = "_mdn_browser_compat_data___browser_compat_data_2.0.7.tgz";
      path = fetchurl {
        name = "_mdn_browser_compat_data___browser_compat_data_2.0.7.tgz";
        url  = "https://registry.yarnpkg.com/@mdn/browser-compat-data/-/browser-compat-data-2.0.7.tgz";
        sha1 = "72ec37b9c1e00ce0b4e0309d753be18e2da12ee3";
      };
    }
    {
      name = "_remusao_guess_url_type___guess_url_type_1.2.1.tgz";
      path = fetchurl {
        name = "_remusao_guess_url_type___guess_url_type_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/guess-url-type/-/guess-url-type-1.2.1.tgz";
        sha1 = "b3e7c32abdf98d0fb4f93cc67cad580b5fe4ba57";
      };
    }
    {
      name = "_remusao_small___small_1.2.1.tgz";
      path = fetchurl {
        name = "_remusao_small___small_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/small/-/small-1.2.1.tgz";
        sha1 = "63bfe4548832289f94ac868a0c305970c9a0e5f9";
      };
    }
    {
      name = "_remusao_smaz_compress___smaz_compress_1.9.1.tgz";
      path = fetchurl {
        name = "_remusao_smaz_compress___smaz_compress_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/smaz-compress/-/smaz-compress-1.9.1.tgz";
        sha1 = "fc75eaf9bcac2d58bc4c3d518183a7cb9612d275";
      };
    }
    {
      name = "_remusao_smaz_decompress___smaz_decompress_1.9.1.tgz";
      path = fetchurl {
        name = "_remusao_smaz_decompress___smaz_decompress_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/smaz-decompress/-/smaz-decompress-1.9.1.tgz";
        sha1 = "8094f997e8fb591a678cda9cf08c209c825eba5b";
      };
    }
    {
      name = "_remusao_smaz___smaz_1.9.1.tgz";
      path = fetchurl {
        name = "_remusao_smaz___smaz_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/smaz/-/smaz-1.9.1.tgz";
        sha1 = "a2b9b045385f81e1615a68d932b7cc8b04c9db8d";
      };
    }
    {
      name = "_remusao_trie___trie_1.4.1.tgz";
      path = fetchurl {
        name = "_remusao_trie___trie_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/@remusao/trie/-/trie-1.4.1.tgz";
        sha1 = "755d09f8a007476334e611f42719b2d581f00720";
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
      name = "_sinonjs_commons___commons_1.8.3.tgz";
      path = fetchurl {
        name = "_sinonjs_commons___commons_1.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@sinonjs/commons/-/commons-1.8.3.tgz";
        sha1 = "3802ddd21a50a949b6721ddd72da36e67e7f1b2d";
      };
    }
    {
      name = "_sinonjs_fake_timers___fake_timers_7.1.2.tgz";
      path = fetchurl {
        name = "_sinonjs_fake_timers___fake_timers_7.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@sinonjs/fake-timers/-/fake-timers-7.1.2.tgz";
        sha1 = "2524eae70c4910edccf99b2f4e6efc5894aff7b5";
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
      name = "_tootallnate_once___once_1.1.2.tgz";
      path = fetchurl {
        name = "_tootallnate_once___once_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@tootallnate/once/-/once-1.1.2.tgz";
        sha1 = "ccb91445360179a04e7fe6aff78c00ffc1eeaf82";
      };
    }
    {
      name = "_types_babel__core___babel__core_7.1.14.tgz";
      path = fetchurl {
        name = "_types_babel__core___babel__core_7.1.14.tgz";
        url  = "https://registry.yarnpkg.com/@types/babel__core/-/babel__core-7.1.14.tgz";
        sha1 = "faaeefc4185ec71c389f4501ee5ec84b170cc402";
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
      name = "_types_babel__traverse___babel__traverse_7.14.0.tgz";
      path = fetchurl {
        name = "_types_babel__traverse___babel__traverse_7.14.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/babel__traverse/-/babel__traverse-7.14.0.tgz";
        sha1 = "a34277cf8acbd3185ea74129e1f100491eb1da7f";
      };
    }
    {
      name = "_types_chrome___chrome_0.0.145.tgz";
      path = fetchurl {
        name = "_types_chrome___chrome_0.0.145.tgz";
        url  = "https://registry.yarnpkg.com/@types/chrome/-/chrome-0.0.145.tgz";
        sha1 = "6c53ae0af5f25350b07bfd24cf459b5fe65cd9b8";
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
      name = "_types_filesystem___filesystem_0.0.31.tgz";
      path = fetchurl {
        name = "_types_filesystem___filesystem_0.0.31.tgz";
        url  = "https://registry.yarnpkg.com/@types/filesystem/-/filesystem-0.0.31.tgz";
        sha1 = "121a1ded274a2dc731d5e0d90163a920ad6a9ef1";
      };
    }
    {
      name = "_types_filewriter___filewriter_0.0.29.tgz";
      path = fetchurl {
        name = "_types_filewriter___filewriter_0.0.29.tgz";
        url  = "https://registry.yarnpkg.com/@types/filewriter/-/filewriter-0.0.29.tgz";
        sha1 = "a48795ecadf957f6c0d10e0c34af86c098fa5bee";
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
      name = "_types_fs_extra___fs_extra_9.0.11.tgz";
      path = fetchurl {
        name = "_types_fs_extra___fs_extra_9.0.11.tgz";
        url  = "https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.11.tgz";
        sha1 = "8cc99e103499eab9f347dbc6ca4e99fb8d2c2b87";
      };
    }
    {
      name = "_types_glob___glob_7.1.3.tgz";
      path = fetchurl {
        name = "_types_glob___glob_7.1.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/glob/-/glob-7.1.3.tgz";
        sha1 = "e6ba80f36b7daad2c685acd9266382e68985c183";
      };
    }
    {
      name = "_types_graceful_fs___graceful_fs_4.1.5.tgz";
      path = fetchurl {
        name = "_types_graceful_fs___graceful_fs_4.1.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/graceful-fs/-/graceful-fs-4.1.5.tgz";
        sha1 = "21ffba0d98da4350db64891f92a9e5db3cdb4e15";
      };
    }
    {
      name = "_types_har_format___har_format_1.2.6.tgz";
      path = fetchurl {
        name = "_types_har_format___har_format_1.2.6.tgz";
        url  = "https://registry.yarnpkg.com/@types/har-format/-/har-format-1.2.6.tgz";
        sha1 = "471c83acdf6a2ea429620daee4c6dc1784a0e85f";
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
      name = "_types_istanbul_reports___istanbul_reports_3.0.1.tgz";
      path = fetchurl {
        name = "_types_istanbul_reports___istanbul_reports_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz";
        sha1 = "9153fe98bba2bd565a63add9436d6f0d7f8468ff";
      };
    }
    {
      name = "_types_minimatch___minimatch_3.0.4.tgz";
      path = fetchurl {
        name = "_types_minimatch___minimatch_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/minimatch/-/minimatch-3.0.4.tgz";
        sha1 = "f0ec25dbf2f0e4b18647313ac031134ca5b24b21";
      };
    }
    {
      name = "_types_node___node_15.12.5.tgz";
      path = fetchurl {
        name = "_types_node___node_15.12.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-15.12.5.tgz";
        sha1 = "9a78318a45d75c9523d2396131bd3cca54b2d185";
      };
    }
    {
      name = "_types_node___node_14.17.4.tgz";
      path = fetchurl {
        name = "_types_node___node_14.17.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-14.17.4.tgz";
        sha1 = "218712242446fc868d0e007af29a4408c7765bc0";
      };
    }
    {
      name = "_types_plist___plist_3.0.2.tgz";
      path = fetchurl {
        name = "_types_plist___plist_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/plist/-/plist-3.0.2.tgz";
        sha1 = "61b3727bba0f5c462fe333542534a0c3e19ccb01";
      };
    }
    {
      name = "_types_prettier___prettier_2.3.0.tgz";
      path = fetchurl {
        name = "_types_prettier___prettier_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/prettier/-/prettier-2.3.0.tgz";
        sha1 = "2e8332cc7363f887d32ec5496b207d26ba8052bb";
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
      name = "_types_verror___verror_1.10.4.tgz";
      path = fetchurl {
        name = "_types_verror___verror_1.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/verror/-/verror-1.10.4.tgz";
        sha1 = "805c0612b3a0c124cf99f517364142946b74ba3b";
      };
    }
    {
      name = "_types_yargs_parser___yargs_parser_20.2.0.tgz";
      path = fetchurl {
        name = "_types_yargs_parser___yargs_parser_20.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-20.2.0.tgz";
        sha1 = "dd3e6699ba3237f0348cd085e4698780204842f9";
      };
    }
    {
      name = "_types_yargs___yargs_16.0.3.tgz";
      path = fetchurl {
        name = "_types_yargs___yargs_16.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/yargs/-/yargs-16.0.3.tgz";
        sha1 = "4b6d35bb8e680510a7dc2308518a80ee1ef27e01";
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
      name = "acorn___acorn_8.4.1.tgz";
      path = fetchurl {
        name = "acorn___acorn_8.4.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-8.4.1.tgz";
        sha1 = "56c36251fc7cabc7096adc18f05afe814321a28c";
      };
    }
    {
      name = "agent_base___agent_base_6.0.2.tgz";
      path = fetchurl {
        name = "agent_base___agent_base_6.0.2.tgz";
        url  = "https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz";
        sha1 = "49fff58577cfee3f37176feab4c22e00f86d7f77";
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
      name = "ajv___ajv_8.6.0.tgz";
      path = fetchurl {
        name = "ajv___ajv_8.6.0.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-8.6.0.tgz";
        sha1 = "60cc45d9c46a477d80d92c48076d972c342e5720";
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
      name = "ansi_escapes___ansi_escapes_4.3.2.tgz";
      path = fetchurl {
        name = "ansi_escapes___ansi_escapes_4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-4.3.2.tgz";
        sha1 = "6b2291d1db7d98b6521d5f1efa42d0f3a9feb65e";
      };
    }
    {
      name = "ansi_regex___ansi_regex_3.0.0.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.0.tgz";
        sha1 = "ed0317c322064f79466c02966bddb605ab37d998";
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
      name = "ansi_styles___ansi_styles_5.2.0.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-5.2.0.tgz";
        sha1 = "07449690ad45777d1924ac2abb2fc8895dba836b";
      };
    }
    {
      name = "anymatch___anymatch_3.1.2.tgz";
      path = fetchurl {
        name = "anymatch___anymatch_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz";
        sha1 = "c0557c096af32f106198f4f4e2a383537e378716";
      };
    }
    {
      name = "app_builder_bin___app_builder_bin_3.5.13.tgz";
      path = fetchurl {
        name = "app_builder_bin___app_builder_bin_3.5.13.tgz";
        url  = "https://registry.yarnpkg.com/app-builder-bin/-/app-builder-bin-3.5.13.tgz";
        sha1 = "6dd7f4de34a4e408806f99b8c7d6ef1601305b7e";
      };
    }
    {
      name = "app_builder_lib___app_builder_lib_22.11.7.tgz";
      path = fetchurl {
        name = "app_builder_lib___app_builder_lib_22.11.7.tgz";
        url  = "https://registry.yarnpkg.com/app-builder-lib/-/app-builder-lib-22.11.7.tgz";
        sha1 = "c0ad1119ebfbf4189a8280ad693625f5e684dca6";
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
      name = "archiver___archiver_5.3.0.tgz";
      path = fetchurl {
        name = "archiver___archiver_5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/archiver/-/archiver-5.3.0.tgz";
        sha1 = "dd3e097624481741df626267564f7dd8640a45ba";
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
      name = "argparse___argparse_2.0.1.tgz";
      path = fetchurl {
        name = "argparse___argparse_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz";
        sha1 = "246f50f3ca78a3240f6c997e8a9bd1eac49e4b38";
      };
    }
    {
      name = "asar___asar_3.0.3.tgz";
      path = fetchurl {
        name = "asar___asar_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/asar/-/asar-3.0.3.tgz";
        sha1 = "1fef03c2d6d2de0cbad138788e4f7ae03b129c7b";
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
      name = "ast_metadata_inferer___ast_metadata_inferer_0.4.0.tgz";
      path = fetchurl {
        name = "ast_metadata_inferer___ast_metadata_inferer_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/ast-metadata-inferer/-/ast-metadata-inferer-0.4.0.tgz";
        sha1 = "6be85ceeffcf267bd79db8e1ae731da44880b45f";
      };
    }
    {
      name = "astral_regex___astral_regex_2.0.0.tgz";
      path = fetchurl {
        name = "astral_regex___astral_regex_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz";
        sha1 = "483143c567aeed4785759c0865786dc77d7d2e31";
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
      name = "babel_jest___babel_jest_27.0.6.tgz";
      path = fetchurl {
        name = "babel_jest___babel_jest_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/babel-jest/-/babel-jest-27.0.6.tgz";
        sha1 = "e99c6e0577da2655118e3608b68761a5a69bd0d8";
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
      name = "babel_plugin_jest_hoist___babel_plugin_jest_hoist_27.0.6.tgz";
      path = fetchurl {
        name = "babel_plugin_jest_hoist___babel_plugin_jest_hoist_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-27.0.6.tgz";
        sha1 = "f7c6b3d764af21cb4a2a1ab6870117dbde15b456";
      };
    }
    {
      name = "babel_preset_current_node_syntax___babel_preset_current_node_syntax_1.0.1.tgz";
      path = fetchurl {
        name = "babel_preset_current_node_syntax___babel_preset_current_node_syntax_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz";
        sha1 = "b4399239b89b2a011f9ddbe3e4f401fc40cff73b";
      };
    }
    {
      name = "babel_preset_jest___babel_preset_jest_27.0.6.tgz";
      path = fetchurl {
        name = "babel_preset_jest___babel_preset_jest_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-jest/-/babel-preset-jest-27.0.6.tgz";
        sha1 = "909ef08e9f24a4679768be2f60a3df0856843f9d";
      };
    }
    {
      name = "balanced_match___balanced_match_1.0.2.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz";
        sha1 = "e83e3a7e3f300b34cb9d87f615fa0cbf357690ee";
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
      name = "bl___bl_4.1.0.tgz";
      path = fetchurl {
        name = "bl___bl_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/bl/-/bl-4.1.0.tgz";
        sha1 = "451535264182bec2fbbc83a62ab98cf11d9f7b3a";
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
      name = "boolean___boolean_3.1.2.tgz";
      path = fetchurl {
        name = "boolean___boolean_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/boolean/-/boolean-3.1.2.tgz";
        sha1 = "e30f210a26b02458482a8cc353ab06f262a780c2";
      };
    }
    {
      name = "boxen___boxen_5.0.1.tgz";
      path = fetchurl {
        name = "boxen___boxen_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/boxen/-/boxen-5.0.1.tgz";
        sha1 = "657528bdd3f59a772b8279b831f27ec2c744664b";
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
      name = "browserslist___browserslist_4.16.6.tgz";
      path = fetchurl {
        name = "browserslist___browserslist_4.16.6.tgz";
        url  = "https://registry.yarnpkg.com/browserslist/-/browserslist-4.16.6.tgz";
        sha1 = "d7901277a5a88e554ed305b183ec9b0c08f66fa2";
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
      name = "buffer_equal___buffer_equal_1.0.0.tgz";
      path = fetchurl {
        name = "buffer_equal___buffer_equal_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-1.0.0.tgz";
        sha1 = "59616b498304d556abd466966b22eeda3eca5fbe";
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
      name = "builder_util_runtime___builder_util_runtime_8.7.6.tgz";
      path = fetchurl {
        name = "builder_util_runtime___builder_util_runtime_8.7.6.tgz";
        url  = "https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-8.7.6.tgz";
        sha1 = "4b43c96db2bd494ced7694bcd7674934655e8324";
      };
    }
    {
      name = "builder_util_runtime___builder_util_runtime_8.7.7.tgz";
      path = fetchurl {
        name = "builder_util_runtime___builder_util_runtime_8.7.7.tgz";
        url  = "https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-8.7.7.tgz";
        sha1 = "6c83cc3abe7a7a5c8b4ec8878f68adc828c07f0d";
      };
    }
    {
      name = "builder_util___builder_util_22.11.7.tgz";
      path = fetchurl {
        name = "builder_util___builder_util_22.11.7.tgz";
        url  = "https://registry.yarnpkg.com/builder-util/-/builder-util-22.11.7.tgz";
        sha1 = "ae9707afa6a31feafa13c274ac83b4fe28ef1467";
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
      name = "caniuse_lite___caniuse_lite_1.0.30001241.tgz";
      path = fetchurl {
        name = "caniuse_lite___caniuse_lite_1.0.30001241.tgz";
        url  = "https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001241.tgz";
        sha1 = "cd3fae47eb3d7691692b406568d7a3e5b23c7598";
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
      name = "chalk___chalk_4.1.1.tgz";
      path = fetchurl {
        name = "chalk___chalk_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-4.1.1.tgz";
        sha1 = "c80b3fab28bf6371e6863325eee67e618b77e6ad";
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
      name = "ci_info___ci_info_3.2.0.tgz";
      path = fetchurl {
        name = "ci_info___ci_info_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ci-info/-/ci-info-3.2.0.tgz";
        sha1 = "2876cb948a498797b5236f0095bc057d0dca38b6";
      };
    }
    {
      name = "cjs_module_lexer___cjs_module_lexer_1.2.1.tgz";
      path = fetchurl {
        name = "cjs_module_lexer___cjs_module_lexer_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/cjs-module-lexer/-/cjs-module-lexer-1.2.1.tgz";
        sha1 = "2fd46d9906a126965aa541345c499aaa18e8cd73";
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
      name = "cli_truncate___cli_truncate_1.1.0.tgz";
      path = fetchurl {
        name = "cli_truncate___cli_truncate_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-1.1.0.tgz";
        sha1 = "2b2dfd83c53cfd3572b87fc4d430a808afb04086";
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
      name = "colorette___colorette_1.2.2.tgz";
      path = fetchurl {
        name = "colorette___colorette_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/colorette/-/colorette-1.2.2.tgz";
        sha1 = "cbcc79d5e99caea2dbf10eb3a26fd8b3e6acfa94";
      };
    }
    {
      name = "colors___colors_1.0.3.tgz";
      path = fetchurl {
        name = "colors___colors_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/colors/-/colors-1.0.3.tgz";
        sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
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
      name = "commander___commander_2.9.0.tgz";
      path = fetchurl {
        name = "commander___commander_2.9.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.9.0.tgz";
        sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
      };
    }
    {
      name = "commander___commander_5.1.0.tgz";
      path = fetchurl {
        name = "commander___commander_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-5.1.0.tgz";
        sha1 = "46abbd1652f8e059bddaef99bbdcb2ad9cf179ae";
      };
    }
    {
      name = "compress_commons___compress_commons_4.1.1.tgz";
      path = fetchurl {
        name = "compress_commons___compress_commons_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/compress-commons/-/compress-commons-4.1.1.tgz";
        sha1 = "df2a09a7ed17447642bad10a85cc9a19e5c42a7d";
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
      name = "config_chain___config_chain_1.1.13.tgz";
      path = fetchurl {
        name = "config_chain___config_chain_1.1.13.tgz";
        url  = "https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.13.tgz";
        sha1 = "fad0795aa6a6cdaff9ed1b68e9dff94372c232f4";
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
      name = "convert_source_map___convert_source_map_1.8.0.tgz";
      path = fetchurl {
        name = "convert_source_map___convert_source_map_1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.8.0.tgz";
        sha1 = "f3373c32d21b4d780dd8004514684fb791ca4369";
      };
    }
    {
      name = "core_js___core_js_3.15.2.tgz";
      path = fetchurl {
        name = "core_js___core_js_3.15.2.tgz";
        url  = "https://registry.yarnpkg.com/core-js/-/core-js-3.15.2.tgz";
        sha1 = "740660d2ff55ef34ce664d7e2455119c5bdd3d61";
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
      name = "crc32_stream___crc32_stream_4.0.2.tgz";
      path = fetchurl {
        name = "crc32_stream___crc32_stream_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/crc32-stream/-/crc32-stream-4.0.2.tgz";
        sha1 = "c922ad22b38395abe9d3870f02fa8134ed709007";
      };
    }
    {
      name = "crc___crc_3.8.0.tgz";
      path = fetchurl {
        name = "crc___crc_3.8.0.tgz";
        url  = "https://registry.yarnpkg.com/crc/-/crc-3.8.0.tgz";
        sha1 = "ad60269c2c856f8c299e2c4cc0de4556914056c6";
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
      name = "data_urls___data_urls_2.0.0.tgz";
      path = fetchurl {
        name = "data_urls___data_urls_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/data-urls/-/data-urls-2.0.0.tgz";
        sha1 = "156485a72963a970f5d5821aaf642bef2bf2db9b";
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
      name = "debug___debug_2.6.9.tgz";
      path = fetchurl {
        name = "debug___debug_2.6.9.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha1 = "5d128515df134ff327e90a4c93f4e077a536341f";
      };
    }
    {
      name = "debug___debug_4.3.2.tgz";
      path = fetchurl {
        name = "debug___debug_4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-4.3.2.tgz";
        sha1 = "f0a49c18ac8779e31d4a0c6029dfb76873c7428b";
      };
    }
    {
      name = "decimal.js___decimal.js_10.3.1.tgz";
      path = fetchurl {
        name = "decimal.js___decimal.js_10.3.1.tgz";
        url  = "https://registry.yarnpkg.com/decimal.js/-/decimal.js-10.3.1.tgz";
        sha1 = "d8c3a444a9c6774ba60ca6ad7261c3a94fd5e783";
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
      name = "dedent___dedent_0.7.0.tgz";
      path = fetchurl {
        name = "dedent___dedent_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/dedent/-/dedent-0.7.0.tgz";
        sha1 = "2495ddbaf6eb874abb0e1be9df22d2e5a544326c";
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
      name = "detect_node___detect_node_2.1.0.tgz";
      path = fetchurl {
        name = "detect_node___detect_node_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz";
        sha1 = "c9c70775a49c3d03bc2c06d9a73be550f978f8b1";
      };
    }
    {
      name = "diff_sequences___diff_sequences_27.0.6.tgz";
      path = fetchurl {
        name = "diff_sequences___diff_sequences_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/diff-sequences/-/diff-sequences-27.0.6.tgz";
        sha1 = "3305cb2e55a033924054695cc66019fd7f8e5723";
      };
    }
    {
      name = "dir_compare___dir_compare_2.4.0.tgz";
      path = fetchurl {
        name = "dir_compare___dir_compare_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/dir-compare/-/dir-compare-2.4.0.tgz";
        sha1 = "785c41dc5f645b34343a4eafc50b79bac7f11631";
      };
    }
    {
      name = "dmg_builder___dmg_builder_22.11.7.tgz";
      path = fetchurl {
        name = "dmg_builder___dmg_builder_22.11.7.tgz";
        url  = "https://registry.yarnpkg.com/dmg-builder/-/dmg-builder-22.11.7.tgz";
        sha1 = "5956008c18d40ee72c0ea01ffea9590dbf51df89";
      };
    }
    {
      name = "dmg_license___dmg_license_1.0.9.tgz";
      path = fetchurl {
        name = "dmg_license___dmg_license_1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/dmg-license/-/dmg-license-1.0.9.tgz";
        sha1 = "a2fb8d692af0e30b0730b5afc91ed9edc2d9cb4f";
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
      name = "dotenv___dotenv_9.0.2.tgz";
      path = fetchurl {
        name = "dotenv___dotenv_9.0.2.tgz";
        url  = "https://registry.yarnpkg.com/dotenv/-/dotenv-9.0.2.tgz";
        sha1 = "dacc20160935a37dea6364aa1bef819fb9b6ab05";
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
      name = "ejs___ejs_3.1.6.tgz";
      path = fetchurl {
        name = "ejs___ejs_3.1.6.tgz";
        url  = "https://registry.yarnpkg.com/ejs/-/ejs-3.1.6.tgz";
        sha1 = "5bfd0a0689743bb5268b3550cceeebbc1702822a";
      };
    }
    {
      name = "electron_builder___electron_builder_22.11.7.tgz";
      path = fetchurl {
        name = "electron_builder___electron_builder_22.11.7.tgz";
        url  = "https://registry.yarnpkg.com/electron-builder/-/electron-builder-22.11.7.tgz";
        sha1 = "cd97a0d9f6e6d388112e66b4376de431cca4d596";
      };
    }
    {
      name = "electron_publish___electron_publish_22.11.7.tgz";
      path = fetchurl {
        name = "electron_publish___electron_publish_22.11.7.tgz";
        url  = "https://registry.yarnpkg.com/electron-publish/-/electron-publish-22.11.7.tgz";
        sha1 = "4126cbb08ccf082a2aa7fef89ee629b3a4b8ae9a";
      };
    }
    {
      name = "electron_to_chromium___electron_to_chromium_1.3.763.tgz";
      path = fetchurl {
        name = "electron_to_chromium___electron_to_chromium_1.3.763.tgz";
        url  = "https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.3.763.tgz";
        sha1 = "93f6f02506d099941f557b9db9ba50b30215bf15";
      };
    }
    {
      name = "electron___electron_13.1.4.tgz";
      path = fetchurl {
        name = "electron___electron_13.1.4.tgz";
        url  = "https://registry.yarnpkg.com/electron/-/electron-13.1.4.tgz";
        sha1 = "6d20d932a0651c3cba9f09a3d08cbaf5b69aa84b";
      };
    }
    {
      name = "emittery___emittery_0.8.1.tgz";
      path = fetchurl {
        name = "emittery___emittery_0.8.1.tgz";
        url  = "https://registry.yarnpkg.com/emittery/-/emittery-0.8.1.tgz";
        sha1 = "bb23cc86d03b30aa75a7f734819dee2e1ba70860";
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
      name = "env_paths___env_paths_2.2.1.tgz";
      path = fetchurl {
        name = "env_paths___env_paths_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz";
        sha1 = "420399d416ce1fbe9bc0a07c62fa68d67fd0f8f2";
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
      name = "escodegen___escodegen_2.0.0.tgz";
      path = fetchurl {
        name = "escodegen___escodegen_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-2.0.0.tgz";
        sha1 = "5e32b12833e8aa8fa35e1bf0befa89380484c7dd";
      };
    }
    {
      name = "eslint_plugin_compat___eslint_plugin_compat_3.9.0.tgz";
      path = fetchurl {
        name = "eslint_plugin_compat___eslint_plugin_compat_3.9.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-compat/-/eslint-plugin-compat-3.9.0.tgz";
        sha1 = "a7a224e09b102b58e7f7dff52c936428ff3e0186";
      };
    }
    {
      name = "eslint_plugin_sort_keys_fix___eslint_plugin_sort_keys_fix_1.1.1.tgz";
      path = fetchurl {
        name = "eslint_plugin_sort_keys_fix___eslint_plugin_sort_keys_fix_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-sort-keys-fix/-/eslint-plugin-sort-keys-fix-1.1.1.tgz";
        sha1 = "2ed201b53fd4a89552c6e2abd38933f330a4b62e";
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
      name = "eslint_visitor_keys___eslint_visitor_keys_2.1.0.tgz";
      path = fetchurl {
        name = "eslint_visitor_keys___eslint_visitor_keys_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz";
        sha1 = "f65328259305927392c938ed44eb0a5c9b2bd303";
      };
    }
    {
      name = "eslint___eslint_7.29.0.tgz";
      path = fetchurl {
        name = "eslint___eslint_7.29.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint/-/eslint-7.29.0.tgz";
        sha1 = "ee2a7648f2e729485e4d0bd6383ec1deabc8b3c0";
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
      name = "esquery___esquery_1.4.0.tgz";
      path = fetchurl {
        name = "esquery___esquery_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/esquery/-/esquery-1.4.0.tgz";
        sha1 = "2148ffc38b82e8c7057dfed48425b3e61f0f24a5";
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
      name = "execa___execa_5.1.1.tgz";
      path = fetchurl {
        name = "execa___execa_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-5.1.1.tgz";
        sha1 = "f80ad9cbf4298f7bd1d4c9555c21e93741c411dd";
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
      name = "expect___expect_27.0.6.tgz";
      path = fetchurl {
        name = "expect___expect_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/expect/-/expect-27.0.6.tgz";
        sha1 = "a4d74fbe27222c718fff68ef49d78e26a8fd4c05";
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
      name = "extract_zip___extract_zip_1.7.0.tgz";
      path = fetchurl {
        name = "extract_zip___extract_zip_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.7.0.tgz";
        sha1 = "556cc3ae9df7f452c493a0cfb51cc30277940927";
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
      name = "fast_xml_parser___fast_xml_parser_3.19.0.tgz";
      path = fetchurl {
        name = "fast_xml_parser___fast_xml_parser_3.19.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-xml-parser/-/fast-xml-parser-3.19.0.tgz";
        sha1 = "cb637ec3f3999f51406dd8ff0e6fc4d83e520d01";
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
      name = "file_entry_cache___file_entry_cache_6.0.1.tgz";
      path = fetchurl {
        name = "file_entry_cache___file_entry_cache_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz";
        sha1 = "211b2dd9659cb0394b073e7323ac3c933d522027";
      };
    }
    {
      name = "filelist___filelist_1.0.2.tgz";
      path = fetchurl {
        name = "filelist___filelist_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/filelist/-/filelist-1.0.2.tgz";
        sha1 = "80202f21462d4d1c2e214119b1807c1bc0380e5b";
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
      name = "flatted___flatted_3.1.1.tgz";
      path = fetchurl {
        name = "flatted___flatted_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/flatted/-/flatted-3.1.1.tgz";
        sha1 = "c4b489e80096d9df1dfc97c79871aea7c617c469";
      };
    }
    {
      name = "form_data___form_data_3.0.1.tgz";
      path = fetchurl {
        name = "form_data___form_data_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-3.0.1.tgz";
        sha1 = "ebd53791b78356a99af9a300d4282c4d5eb9755f";
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
      name = "fs_extra___fs_extra_10.0.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_10.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.0.0.tgz";
        sha1 = "9ff61b655dde53fb34a82df84bb214ce802e17c1";
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
      name = "fs_extra___fs_extra_9.1.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_9.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.1.0.tgz";
        sha1 = "5954460c764a8da2094ba3554bf839e6b9a7c86d";
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
      name = "fsevents___fsevents_2.3.2.tgz";
      path = fetchurl {
        name = "fsevents___fsevents_2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz";
        sha1 = "8a526f78b8fdf4623b709e0b975c52c24c02fd1a";
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
      name = "get_stream___get_stream_6.0.1.tgz";
      path = fetchurl {
        name = "get_stream___get_stream_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.1.tgz";
        sha1 = "a262d8eef67aced57c2852ad6167526a43cbf7b7";
      };
    }
    {
      name = "glob_parent___glob_parent_5.1.2.tgz";
      path = fetchurl {
        name = "glob_parent___glob_parent_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz";
        sha1 = "869832c58034fe68a4093c17dc15e8340d8401c4";
      };
    }
    {
      name = "glob___glob_7.1.7.tgz";
      path = fetchurl {
        name = "glob___glob_7.1.7.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.7.tgz";
        sha1 = "3b193e9233f01d42d0b3f78294bbeeb418f94a90";
      };
    }
    {
      name = "global_agent___global_agent_2.2.0.tgz";
      path = fetchurl {
        name = "global_agent___global_agent_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/global-agent/-/global-agent-2.2.0.tgz";
        sha1 = "566331b0646e6bf79429a16877685c4a1fbf76dc";
      };
    }
    {
      name = "global_dirs___global_dirs_3.0.0.tgz";
      path = fetchurl {
        name = "global_dirs___global_dirs_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/global-dirs/-/global-dirs-3.0.0.tgz";
        sha1 = "70a76fe84ea315ab37b1f5576cbde7d48ef72686";
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
      name = "globals___globals_13.9.0.tgz";
      path = fetchurl {
        name = "globals___globals_13.9.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-13.9.0.tgz";
        sha1 = "4bf2bf635b334a173fb1daf7c5e6b218ecdc06cb";
      };
    }
    {
      name = "globalthis___globalthis_1.0.2.tgz";
      path = fetchurl {
        name = "globalthis___globalthis_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.2.tgz";
        sha1 = "2a235d34f4d8036219f7e34929b5de9e18166b8b";
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
      name = "graceful_fs___graceful_fs_4.2.6.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.6.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.6.tgz";
        sha1 = "ff040b2b0853b23c3d31027523706f1885d76bee";
      };
    }
    {
      name = "graceful_readlink___graceful_readlink_1.0.1.tgz";
      path = fetchurl {
        name = "graceful_readlink___graceful_readlink_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
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
      name = "hosted_git_info___hosted_git_info_4.0.2.tgz";
      path = fetchurl {
        name = "hosted_git_info___hosted_git_info_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-4.0.2.tgz";
        sha1 = "5e425507eede4fea846b7262f0838456c4209961";
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
      name = "http_proxy_agent___http_proxy_agent_4.0.1.tgz";
      path = fetchurl {
        name = "http_proxy_agent___http_proxy_agent_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz";
        sha1 = "8a8c8ef7f5932ccf953c296ca8291b95aa74aa3a";
      };
    }
    {
      name = "https_proxy_agent___https_proxy_agent_5.0.0.tgz";
      path = fetchurl {
        name = "https_proxy_agent___https_proxy_agent_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.0.tgz";
        sha1 = "e2a90542abb68a762e0a0850f6c9edadfd8506b2";
      };
    }
    {
      name = "human_signals___human_signals_2.1.0.tgz";
      path = fetchurl {
        name = "human_signals___human_signals_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/human-signals/-/human-signals-2.1.0.tgz";
        sha1 = "dc91fcba42e4d06e4abaed33b3e7a3c02f514ea0";
      };
    }
    {
      name = "iconv_corefoundation___iconv_corefoundation_1.1.6.tgz";
      path = fetchurl {
        name = "iconv_corefoundation___iconv_corefoundation_1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/iconv-corefoundation/-/iconv-corefoundation-1.1.6.tgz";
        sha1 = "27c135470237f6f8d13462fa1f5eaf250523c29a";
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
      name = "iconv_lite___iconv_lite_0.6.3.tgz";
      path = fetchurl {
        name = "iconv_lite___iconv_lite_0.6.3.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz";
        sha1 = "a52f80bf38da1952eb5c681790719871a1a72501";
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
      name = "import_fresh___import_fresh_3.3.0.tgz";
      path = fetchurl {
        name = "import_fresh___import_fresh_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz";
        sha1 = "37162c25fcb9ebaa2e6e53d5b4d88ce17d9e0c2b";
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
      name = "ini___ini_2.0.0.tgz";
      path = fetchurl {
        name = "ini___ini_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ini/-/ini-2.0.0.tgz";
        sha1 = "e5fd556ecdd5726be978fa1001862eacb0a94bc5";
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
      name = "is_ci___is_ci_2.0.0.tgz";
      path = fetchurl {
        name = "is_ci___is_ci_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz";
        sha1 = "6bc6334181810e04b5c22b3d589fdca55026404c";
      };
    }
    {
      name = "is_ci___is_ci_3.0.0.tgz";
      path = fetchurl {
        name = "is_ci___is_ci_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-ci/-/is-ci-3.0.0.tgz";
        sha1 = "c7e7be3c9d8eef7d0fa144390bd1e4b88dc4c994";
      };
    }
    {
      name = "is_core_module___is_core_module_2.4.0.tgz";
      path = fetchurl {
        name = "is_core_module___is_core_module_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.4.0.tgz";
        sha1 = "8e9fc8e15027b011418026e98f0e6f4d86305cc1";
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
      name = "is_installed_globally___is_installed_globally_0.4.0.tgz";
      path = fetchurl {
        name = "is_installed_globally___is_installed_globally_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.4.0.tgz";
        sha1 = "9a0fd407949c30f86eb6959ef1b7994ed0b7b520";
      };
    }
    {
      name = "is_npm___is_npm_5.0.0.tgz";
      path = fetchurl {
        name = "is_npm___is_npm_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-npm/-/is-npm-5.0.0.tgz";
        sha1 = "43e8d65cc56e1b67f8d47262cf667099193f45a8";
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
      name = "is_path_inside___is_path_inside_3.0.3.tgz";
      path = fetchurl {
        name = "is_path_inside___is_path_inside_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.3.tgz";
        sha1 = "d231362e53a07ff2b0e0ea7fed049161ffd16283";
      };
    }
    {
      name = "is_potential_custom_element_name___is_potential_custom_element_name_1.0.1.tgz";
      path = fetchurl {
        name = "is_potential_custom_element_name___is_potential_custom_element_name_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz";
        sha1 = "171ed6f19e3ac554394edf78caa05784a45bebb5";
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
      name = "is_svg___is_svg_4.3.1.tgz";
      path = fetchurl {
        name = "is_svg___is_svg_4.3.1.tgz";
        url  = "https://registry.yarnpkg.com/is-svg/-/is-svg-4.3.1.tgz";
        sha1 = "8c63ec8c67c8c7f0a8de0a71c8c7d58eccf4406b";
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
      name = "isbinaryfile___isbinaryfile_4.0.8.tgz";
      path = fetchurl {
        name = "isbinaryfile___isbinaryfile_4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.8.tgz";
        sha1 = "5d34b94865bd4946633ecc78a026fc76c5b11fcf";
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
      name = "jest_changed_files___jest_changed_files_27.0.6.tgz";
      path = fetchurl {
        name = "jest_changed_files___jest_changed_files_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-changed-files/-/jest-changed-files-27.0.6.tgz";
        sha1 = "bed6183fcdea8a285482e3b50a9a7712d49a7a8b";
      };
    }
    {
      name = "jest_circus___jest_circus_27.0.6.tgz";
      path = fetchurl {
        name = "jest_circus___jest_circus_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-circus/-/jest-circus-27.0.6.tgz";
        sha1 = "dd4df17c4697db6a2c232aaad4e9cec666926668";
      };
    }
    {
      name = "jest_cli___jest_cli_27.0.6.tgz";
      path = fetchurl {
        name = "jest_cli___jest_cli_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-cli/-/jest-cli-27.0.6.tgz";
        sha1 = "d021e5f4d86d6a212450d4c7b86cb219f1e6864f";
      };
    }
    {
      name = "jest_config___jest_config_27.0.6.tgz";
      path = fetchurl {
        name = "jest_config___jest_config_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-config/-/jest-config-27.0.6.tgz";
        sha1 = "119fb10f149ba63d9c50621baa4f1f179500277f";
      };
    }
    {
      name = "jest_diff___jest_diff_27.0.6.tgz";
      path = fetchurl {
        name = "jest_diff___jest_diff_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-diff/-/jest-diff-27.0.6.tgz";
        sha1 = "4a7a19ee6f04ad70e0e3388f35829394a44c7b5e";
      };
    }
    {
      name = "jest_docblock___jest_docblock_27.0.6.tgz";
      path = fetchurl {
        name = "jest_docblock___jest_docblock_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-docblock/-/jest-docblock-27.0.6.tgz";
        sha1 = "cc78266acf7fe693ca462cbbda0ea4e639e4e5f3";
      };
    }
    {
      name = "jest_each___jest_each_27.0.6.tgz";
      path = fetchurl {
        name = "jest_each___jest_each_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-each/-/jest-each-27.0.6.tgz";
        sha1 = "cee117071b04060158dc8d9a66dc50ad40ef453b";
      };
    }
    {
      name = "jest_environment_jsdom___jest_environment_jsdom_27.0.6.tgz";
      path = fetchurl {
        name = "jest_environment_jsdom___jest_environment_jsdom_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-environment-jsdom/-/jest-environment-jsdom-27.0.6.tgz";
        sha1 = "f66426c4c9950807d0a9f209c590ce544f73291f";
      };
    }
    {
      name = "jest_environment_node___jest_environment_node_27.0.6.tgz";
      path = fetchurl {
        name = "jest_environment_node___jest_environment_node_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-environment-node/-/jest-environment-node-27.0.6.tgz";
        sha1 = "a6699b7ceb52e8d68138b9808b0c404e505f3e07";
      };
    }
    {
      name = "jest_get_type___jest_get_type_27.0.6.tgz";
      path = fetchurl {
        name = "jest_get_type___jest_get_type_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-get-type/-/jest-get-type-27.0.6.tgz";
        sha1 = "0eb5c7f755854279ce9b68a9f1a4122f69047cfe";
      };
    }
    {
      name = "jest_haste_map___jest_haste_map_27.0.6.tgz";
      path = fetchurl {
        name = "jest_haste_map___jest_haste_map_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-haste-map/-/jest-haste-map-27.0.6.tgz";
        sha1 = "4683a4e68f6ecaa74231679dca237279562c8dc7";
      };
    }
    {
      name = "jest_jasmine2___jest_jasmine2_27.0.6.tgz";
      path = fetchurl {
        name = "jest_jasmine2___jest_jasmine2_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-jasmine2/-/jest-jasmine2-27.0.6.tgz";
        sha1 = "fd509a9ed3d92bd6edb68a779f4738b100655b37";
      };
    }
    {
      name = "jest_leak_detector___jest_leak_detector_27.0.6.tgz";
      path = fetchurl {
        name = "jest_leak_detector___jest_leak_detector_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-leak-detector/-/jest-leak-detector-27.0.6.tgz";
        sha1 = "545854275f85450d4ef4b8fe305ca2a26450450f";
      };
    }
    {
      name = "jest_matcher_utils___jest_matcher_utils_27.0.6.tgz";
      path = fetchurl {
        name = "jest_matcher_utils___jest_matcher_utils_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-matcher-utils/-/jest-matcher-utils-27.0.6.tgz";
        sha1 = "2a8da1e86c620b39459f4352eaa255f0d43e39a9";
      };
    }
    {
      name = "jest_message_util___jest_message_util_27.0.6.tgz";
      path = fetchurl {
        name = "jest_message_util___jest_message_util_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-message-util/-/jest-message-util-27.0.6.tgz";
        sha1 = "158bcdf4785706492d164a39abca6a14da5ab8b5";
      };
    }
    {
      name = "jest_mock___jest_mock_27.0.6.tgz";
      path = fetchurl {
        name = "jest_mock___jest_mock_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-mock/-/jest-mock-27.0.6.tgz";
        sha1 = "0efdd40851398307ba16778728f6d34d583e3467";
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
      name = "jest_regex_util___jest_regex_util_27.0.6.tgz";
      path = fetchurl {
        name = "jest_regex_util___jest_regex_util_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-regex-util/-/jest-regex-util-27.0.6.tgz";
        sha1 = "02e112082935ae949ce5d13b2675db3d8c87d9c5";
      };
    }
    {
      name = "jest_resolve_dependencies___jest_resolve_dependencies_27.0.6.tgz";
      path = fetchurl {
        name = "jest_resolve_dependencies___jest_resolve_dependencies_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-resolve-dependencies/-/jest-resolve-dependencies-27.0.6.tgz";
        sha1 = "3e619e0ef391c3ecfcf6ef4056207a3d2be3269f";
      };
    }
    {
      name = "jest_resolve___jest_resolve_27.0.6.tgz";
      path = fetchurl {
        name = "jest_resolve___jest_resolve_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-resolve/-/jest-resolve-27.0.6.tgz";
        sha1 = "e90f436dd4f8fbf53f58a91c42344864f8e55bff";
      };
    }
    {
      name = "jest_runner___jest_runner_27.0.6.tgz";
      path = fetchurl {
        name = "jest_runner___jest_runner_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-runner/-/jest-runner-27.0.6.tgz";
        sha1 = "1325f45055539222bbc7256a6976e993ad2f9520";
      };
    }
    {
      name = "jest_runtime___jest_runtime_27.0.6.tgz";
      path = fetchurl {
        name = "jest_runtime___jest_runtime_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-runtime/-/jest-runtime-27.0.6.tgz";
        sha1 = "45877cfcd386afdd4f317def551fc369794c27c9";
      };
    }
    {
      name = "jest_serializer___jest_serializer_27.0.6.tgz";
      path = fetchurl {
        name = "jest_serializer___jest_serializer_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-serializer/-/jest-serializer-27.0.6.tgz";
        sha1 = "93a6c74e0132b81a2d54623251c46c498bb5bec1";
      };
    }
    {
      name = "jest_snapshot___jest_snapshot_27.0.6.tgz";
      path = fetchurl {
        name = "jest_snapshot___jest_snapshot_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-snapshot/-/jest-snapshot-27.0.6.tgz";
        sha1 = "f4e6b208bd2e92e888344d78f0f650bcff05a4bf";
      };
    }
    {
      name = "jest_util___jest_util_27.0.6.tgz";
      path = fetchurl {
        name = "jest_util___jest_util_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-util/-/jest-util-27.0.6.tgz";
        sha1 = "e8e04eec159de2f4d5f57f795df9cdc091e50297";
      };
    }
    {
      name = "jest_validate___jest_validate_27.0.6.tgz";
      path = fetchurl {
        name = "jest_validate___jest_validate_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-validate/-/jest-validate-27.0.6.tgz";
        sha1 = "930a527c7a951927df269f43b2dc23262457e2a6";
      };
    }
    {
      name = "jest_watcher___jest_watcher_27.0.6.tgz";
      path = fetchurl {
        name = "jest_watcher___jest_watcher_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-watcher/-/jest-watcher-27.0.6.tgz";
        sha1 = "89526f7f9edf1eac4e4be989bcb6dec6b8878d9c";
      };
    }
    {
      name = "jest_worker___jest_worker_27.0.6.tgz";
      path = fetchurl {
        name = "jest_worker___jest_worker_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-worker/-/jest-worker-27.0.6.tgz";
        sha1 = "a5fdb1e14ad34eb228cfe162d9f729cdbfa28aed";
      };
    }
    {
      name = "jest___jest_27.0.6.tgz";
      path = fetchurl {
        name = "jest___jest_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/jest/-/jest-27.0.6.tgz";
        sha1 = "10517b2a628f0409087fbf473db44777d7a04505";
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
      name = "js_yaml___js_yaml_4.1.0.tgz";
      path = fetchurl {
        name = "js_yaml___js_yaml_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz";
        sha1 = "c1fb65f8f5017901cdd2c951864ba18458a10602";
      };
    }
    {
      name = "jsdom___jsdom_16.6.0.tgz";
      path = fetchurl {
        name = "jsdom___jsdom_16.6.0.tgz";
        url  = "https://registry.yarnpkg.com/jsdom/-/jsdom-16.6.0.tgz";
        sha1 = "f79b3786682065492a3da6a60a4695da983805ac";
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
      name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz";
        sha1 = "69f6a87d9513ab8bb8fe63bdb0979c448e684660";
      };
    }
    {
      name = "json_schema_traverse___json_schema_traverse_1.0.0.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz";
        sha1 = "ae7bcb3656ab77a73ba5c49bf654f38e6b6860e2";
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
      name = "json5___json5_2.2.0.tgz";
      path = fetchurl {
        name = "json5___json5_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-2.2.0.tgz";
        sha1 = "2dfefe720c6ba525d9ebd909950f0515316c89a3";
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
      name = "keyv___keyv_3.1.0.tgz";
      path = fetchurl {
        name = "keyv___keyv_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/keyv/-/keyv-3.1.0.tgz";
        sha1 = "ecc228486f69991e49e9476485a5be1e8fc5c4d9";
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
      name = "lazy_val___lazy_val_1.0.5.tgz";
      path = fetchurl {
        name = "lazy_val___lazy_val_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/lazy-val/-/lazy-val-1.0.5.tgz";
        sha1 = "6cf3b9f5bc31cee7ee3e369c0832b7583dcd923d";
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
      name = "locate_path___locate_path_5.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz";
        sha1 = "1afba396afd676a6d42504d0a67a3a7eb9f62aa0";
      };
    }
    {
      name = "lodash.clonedeep___lodash.clonedeep_4.5.0.tgz";
      path = fetchurl {
        name = "lodash.clonedeep___lodash.clonedeep_4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz";
        sha1 = "e23f3f9c4f8fbdde872529c1071857a086e5ccef";
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
      name = "lodash.memoize___lodash.memoize_4.1.2.tgz";
      path = fetchurl {
        name = "lodash.memoize___lodash.memoize_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.memoize/-/lodash.memoize-4.1.2.tgz";
        sha1 = "bcc6c49a42a2840ed997f323eada5ecd182e0bfe";
      };
    }
    {
      name = "lodash.merge___lodash.merge_4.6.2.tgz";
      path = fetchurl {
        name = "lodash.merge___lodash.merge_4.6.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz";
        sha1 = "558aa53b43b661e1925a0afdfa36a9a1085fe57a";
      };
    }
    {
      name = "lodash.truncate___lodash.truncate_4.4.2.tgz";
      path = fetchurl {
        name = "lodash.truncate___lodash.truncate_4.4.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.truncate/-/lodash.truncate-4.4.2.tgz";
        sha1 = "5a350da0b1113b837ecfffd5812cbe58d6eae193";
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
      name = "lodash___lodash_4.17.21.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.21.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz";
        sha1 = "679591c564c3bffaae8454cf0b3df370c3d6911c";
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
      name = "micromatch___micromatch_4.0.4.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_4.0.4.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.4.tgz";
        sha1 = "896d519dfe9db25fce94ceb7a500919bf881ebf9";
      };
    }
    {
      name = "mime_db___mime_db_1.48.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.48.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.48.0.tgz";
        sha1 = "e35b31045dd7eada3aaad537ed88a33afbef2d1d";
      };
    }
    {
      name = "mime_types___mime_types_2.1.31.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.31.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.31.tgz";
        sha1 = "a00d76b74317c61f9c2db2218b8e9f8e9c5c9e6b";
      };
    }
    {
      name = "mime___mime_2.5.2.tgz";
      path = fetchurl {
        name = "mime___mime_2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-2.5.2.tgz";
        sha1 = "6e3dc6cc2b9510643830e5f19d5cb753da5eeabe";
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
      name = "natural_compare___natural_compare_1.4.0.tgz";
      path = fetchurl {
        name = "natural_compare___natural_compare_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz";
        sha1 = "4abebfeed7541f2c27acfb29bdbbd15c8d5ba4f7";
      };
    }
    {
      name = "node_addon_api___node_addon_api_1.7.2.tgz";
      path = fetchurl {
        name = "node_addon_api___node_addon_api_1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-1.7.2.tgz";
        sha1 = "3df30b95720b53c24e59948b49532b662444f54d";
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
      name = "node_releases___node_releases_1.1.73.tgz";
      path = fetchurl {
        name = "node_releases___node_releases_1.1.73.tgz";
        url  = "https://registry.yarnpkg.com/node-releases/-/node-releases-1.1.73.tgz";
        sha1 = "dd4e81ddd5277ff846b80b52bb40c49edf7a7b20";
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
      name = "normalize_url___normalize_url_4.5.1.tgz";
      path = fetchurl {
        name = "normalize_url___normalize_url_4.5.1.tgz";
        url  = "https://registry.yarnpkg.com/normalize-url/-/normalize-url-4.5.1.tgz";
        sha1 = "0dd90cf1288ee1d1313b87081c9a5932ee48518a";
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
      name = "object_keys___object_keys_1.1.1.tgz";
      path = fetchurl {
        name = "object_keys___object_keys_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz";
        sha1 = "1c47f272df277f3b1daf061677d9c82e2322c60e";
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
      name = "parse5___parse5_6.0.1.tgz";
      path = fetchurl {
        name = "parse5___parse5_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/parse5/-/parse5-6.0.1.tgz";
        sha1 = "e1a1c085c569b3dc08321184f19a39cc27f7c30b";
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
      name = "path_key___path_key_3.1.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz";
        sha1 = "581f6ade658cbba65a0d3380de7753295054f375";
      };
    }
    {
      name = "path_parse___path_parse_1.0.7.tgz";
      path = fetchurl {
        name = "path_parse___path_parse_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz";
        sha1 = "fbc114b60ca42b30d9daf5858e4bd68bbedb6735";
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
      name = "picomatch___picomatch_2.3.0.tgz";
      path = fetchurl {
        name = "picomatch___picomatch_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.0.tgz";
        sha1 = "f1f061de8f6a4bf022892e2d128234fb98302972";
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
      name = "plist___plist_3.0.2.tgz";
      path = fetchurl {
        name = "plist___plist_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/plist/-/plist-3.0.2.tgz";
        sha1 = "74bbf011124b90421c22d15779cee60060ba95bc";
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
      name = "pretty_format___pretty_format_27.0.6.tgz";
      path = fetchurl {
        name = "pretty_format___pretty_format_27.0.6.tgz";
        url  = "https://registry.yarnpkg.com/pretty-format/-/pretty-format-27.0.6.tgz";
        sha1 = "ab770c47b2c6f893a21aefc57b75da63ef49a11f";
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
      name = "prompts___prompts_2.4.1.tgz";
      path = fetchurl {
        name = "prompts___prompts_2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/prompts/-/prompts-2.4.1.tgz";
        sha1 = "befd3b1195ba052f9fd2fde8a486c4e82ee77f61";
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
      name = "rc___rc_1.2.8.tgz";
      path = fetchurl {
        name = "rc___rc_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz";
        sha1 = "cd924bf5200a075b83c188cd6b9e211b7fc0d3ed";
      };
    }
    {
      name = "react_is___react_is_17.0.2.tgz";
      path = fetchurl {
        name = "react_is___react_is_17.0.2.tgz";
        url  = "https://registry.yarnpkg.com/react-is/-/react-is-17.0.2.tgz";
        sha1 = "e691d4a8e9c789365655539ab372762b0efb54f0";
      };
    }
    {
      name = "read_config_file___read_config_file_6.2.0.tgz";
      path = fetchurl {
        name = "read_config_file___read_config_file_6.2.0.tgz";
        url  = "https://registry.yarnpkg.com/read-config-file/-/read-config-file-6.2.0.tgz";
        sha1 = "71536072330bcd62ba814f91458b12add9fc7ade";
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
      name = "regexpp___regexpp_3.2.0.tgz";
      path = fetchurl {
        name = "regexpp___regexpp_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpp/-/regexpp-3.2.0.tgz";
        sha1 = "0425a2768d8f23bad70ca4b90461fa2f1213e1b2";
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
      name = "require_directory___require_directory_2.1.1.tgz";
      path = fetchurl {
        name = "require_directory___require_directory_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz";
        sha1 = "8c64ad5fd30dab1c976e2344ffe7f792a6a6df42";
      };
    }
    {
      name = "require_from_string___require_from_string_2.0.2.tgz";
      path = fetchurl {
        name = "require_from_string___require_from_string_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz";
        sha1 = "89a7fdd938261267318eafe14f9c32e598c36909";
      };
    }
    {
      name = "requireindex___requireindex_1.2.0.tgz";
      path = fetchurl {
        name = "requireindex___requireindex_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/requireindex/-/requireindex-1.2.0.tgz";
        sha1 = "3463cdb22ee151902635aa6c9535d4de9c2ef1ef";
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
      name = "resolve___resolve_1.20.0.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.20.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.20.0.tgz";
        sha1 = "629a013fb3f70755d6f0b7935cc1c2c5378b1975";
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
      name = "safe_buffer___safe_buffer_5.1.2.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha1 = "991ec69d296e0313747d59bdfd2b745c35f8828d";
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
      name = "safer_buffer___safer_buffer_2.1.2.tgz";
      path = fetchurl {
        name = "safer_buffer___safer_buffer_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz";
        sha1 = "44fa161b0187b9549dd84bb91802f9bd8385cd6a";
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
      name = "semver___semver_7.3.2.tgz";
      path = fetchurl {
        name = "semver___semver_7.3.2.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.3.2.tgz";
        sha1 = "604962b052b81ed0786aae84389ffba70ffd3938";
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
      name = "semver___semver_7.3.5.tgz";
      path = fetchurl {
        name = "semver___semver_7.3.5.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.3.5.tgz";
        sha1 = "0b621c879348d8998e4b0e4be94b3f12e6018ef7";
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
      name = "shebang_command___shebang_command_2.0.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz";
        sha1 = "ccd0af4f8835fbdc265b82461aaf0c36663f34ea";
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
      name = "slice_ansi___slice_ansi_1.0.0.tgz";
      path = fetchurl {
        name = "slice_ansi___slice_ansi_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-1.0.0.tgz";
        sha1 = "044f1a49d8842ff307aad6b505ed178bd950134d";
      };
    }
    {
      name = "slice_ansi___slice_ansi_4.0.0.tgz";
      path = fetchurl {
        name = "slice_ansi___slice_ansi_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz";
        sha1 = "500e8dd0fd55b05815086255b3195adf2a45fe6b";
      };
    }
    {
      name = "smart_buffer___smart_buffer_4.1.0.tgz";
      path = fetchurl {
        name = "smart_buffer___smart_buffer_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.1.0.tgz";
        sha1 = "91605c25d91652f4661ea69ccf45f1b331ca21ba";
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
      name = "string_length___string_length_4.0.2.tgz";
      path = fetchurl {
        name = "string_length___string_length_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/string-length/-/string-length-4.0.2.tgz";
        sha1 = "a8a8dc7bd5c1a82b9b3c8b87e125f66871b6e57a";
      };
    }
    {
      name = "string_width___string_width_2.1.1.tgz";
      path = fetchurl {
        name = "string_width___string_width_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz";
        sha1 = "ab93f27a8dc13d28cac815c462143a6d9012ae9e";
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
      name = "string_width___string_width_4.2.2.tgz";
      path = fetchurl {
        name = "string_width___string_width_4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-4.2.2.tgz";
        sha1 = "dafd4f9559a7585cfba529c6a0a4f73488ebd4c5";
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
      name = "strip_ansi___strip_ansi_4.0.0.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz";
        sha1 = "a8479022eb1ac368a871389b635262c505ee368f";
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
      name = "supports_color___supports_color_8.1.1.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_8.1.1.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz";
        sha1 = "cd6fc17e28500cff56c1b86c0a7fd4a54a73005c";
      };
    }
    {
      name = "supports_hyperlinks___supports_hyperlinks_2.2.0.tgz";
      path = fetchurl {
        name = "supports_hyperlinks___supports_hyperlinks_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-hyperlinks/-/supports-hyperlinks-2.2.0.tgz";
        sha1 = "4f77b42488765891774b70c79babd87f9bd594bb";
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
      name = "table___table_6.7.1.tgz";
      path = fetchurl {
        name = "table___table_6.7.1.tgz";
        url  = "https://registry.yarnpkg.com/table/-/table-6.7.1.tgz";
        sha1 = "ee05592b7143831a8c94f3cee6aae4c1ccef33e2";
      };
    }
    {
      name = "tar_stream___tar_stream_2.2.0.tgz";
      path = fetchurl {
        name = "tar_stream___tar_stream_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/tar-stream/-/tar-stream-2.2.0.tgz";
        sha1 = "acad84c284136b060dc3faa64474aa9aebd77287";
      };
    }
    {
      name = "temp_file___temp_file_3.4.0.tgz";
      path = fetchurl {
        name = "temp_file___temp_file_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/temp-file/-/temp-file-3.4.0.tgz";
        sha1 = "766ea28911c683996c248ef1a20eea04d51652c7";
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
      name = "throat___throat_6.0.1.tgz";
      path = fetchurl {
        name = "throat___throat_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/throat/-/throat-6.0.1.tgz";
        sha1 = "d514fedad95740c12c2d7fc70ea863eb51ade375";
      };
    }
    {
      name = "tldts_core___tldts_core_5.7.38.tgz";
      path = fetchurl {
        name = "tldts_core___tldts_core_5.7.38.tgz";
        url  = "https://registry.yarnpkg.com/tldts-core/-/tldts-core-5.7.38.tgz";
        sha1 = "779092c90941803fb682c3d7094a88f12aad4508";
      };
    }
    {
      name = "tldts_experimental___tldts_experimental_5.7.38.tgz";
      path = fetchurl {
        name = "tldts_experimental___tldts_experimental_5.7.38.tgz";
        url  = "https://registry.yarnpkg.com/tldts-experimental/-/tldts-experimental-5.7.38.tgz";
        sha1 = "a2b03ae0282ee7439b1ed1618a1d7d2e9e66be78";
      };
    }
    {
      name = "tmp_promise___tmp_promise_3.0.2.tgz";
      path = fetchurl {
        name = "tmp_promise___tmp_promise_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/tmp-promise/-/tmp-promise-3.0.2.tgz";
        sha1 = "6e933782abff8b00c3119d63589ca1fb9caaa62a";
      };
    }
    {
      name = "tmp___tmp_0.2.1.tgz";
      path = fetchurl {
        name = "tmp___tmp_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz";
        sha1 = "8457fc3037dcf4719c251367a1af6500ee1ccf14";
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
      name = "to_readable_stream___to_readable_stream_1.0.0.tgz";
      path = fetchurl {
        name = "to_readable_stream___to_readable_stream_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/to-readable-stream/-/to-readable-stream-1.0.0.tgz";
        sha1 = "ce0aa0c2f3df6adf852efb404a783e77c0475771";
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
      name = "tough_cookie___tough_cookie_4.0.0.tgz";
      path = fetchurl {
        name = "tough_cookie___tough_cookie_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-4.0.0.tgz";
        sha1 = "d822234eeca882f991f0f908824ad2622ddbece4";
      };
    }
    {
      name = "tr46___tr46_2.1.0.tgz";
      path = fetchurl {
        name = "tr46___tr46_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/tr46/-/tr46-2.1.0.tgz";
        sha1 = "fa87aa81ca5d5941da8cbf1f9b749dc969a4e240";
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
      name = "tunnel___tunnel_0.0.6.tgz";
      path = fetchurl {
        name = "tunnel___tunnel_0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz";
        sha1 = "72f1314b34a5b192db012324df2cc587ca47f92c";
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
      name = "type_fest___type_fest_0.13.1.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.13.1.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz";
        sha1 = "0172cb5bce80b0bd542ea348db50c7e21834d934";
      };
    }
    {
      name = "type_fest___type_fest_0.20.2.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.20.2.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz";
        sha1 = "1bf207f4b28f91583666cb5fbd327887301cd5f4";
      };
    }
    {
      name = "type_fest___type_fest_0.21.3.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.21.3.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.21.3.tgz";
        sha1 = "d260a24b0198436e133fa26a524a6d65fa3b2e37";
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
      name = "universalify___universalify_2.0.0.tgz";
      path = fetchurl {
        name = "universalify___universalify_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz";
        sha1 = "75a4984efedc4b08975c5aeb73f530d02df25717";
      };
    }
    {
      name = "update_notifier___update_notifier_5.1.0.tgz";
      path = fetchurl {
        name = "update_notifier___update_notifier_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/update-notifier/-/update-notifier-5.1.0.tgz";
        sha1 = "4ab0d7c7f36a231dd7316cf7729313f0214d9ad9";
      };
    }
    {
      name = "uri_js___uri_js_4.4.1.tgz";
      path = fetchurl {
        name = "uri_js___uri_js_4.4.1.tgz";
        url  = "https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz";
        sha1 = "9b1a52595225859e55f669d928f88c6c57f2a77e";
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
      name = "v8_compile_cache___v8_compile_cache_2.3.0.tgz";
      path = fetchurl {
        name = "v8_compile_cache___v8_compile_cache_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.3.0.tgz";
        sha1 = "2de19618c66dc247dcfb6f99338035d8245a2cee";
      };
    }
    {
      name = "v8_to_istanbul___v8_to_istanbul_8.0.0.tgz";
      path = fetchurl {
        name = "v8_to_istanbul___v8_to_istanbul_8.0.0.tgz";
        url  = "https://registry.yarnpkg.com/v8-to-istanbul/-/v8-to-istanbul-8.0.0.tgz";
        sha1 = "4229f2a99e367f3f018fa1d5c2b8ec684667c69c";
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
      name = "whatwg_url___whatwg_url_8.7.0.tgz";
      path = fetchurl {
        name = "whatwg_url___whatwg_url_8.7.0.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-8.7.0.tgz";
        sha1 = "656a78e510ff8f3937bc0bcbe9f5c0ac35941b77";
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
      name = "ws___ws_7.5.1.tgz";
      path = fetchurl {
        name = "ws___ws_7.5.1.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-7.5.1.tgz";
        sha1 = "44fc000d87edb1d9c53e51fbc69a0ac1f6871d66";
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
      name = "xmlbuilder___xmlbuilder_15.1.1.tgz";
      path = fetchurl {
        name = "xmlbuilder___xmlbuilder_15.1.1.tgz";
        url  = "https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-15.1.1.tgz";
        sha1 = "9dcdce49eea66d8d10b42cae94a79c3c8d0c2ec5";
      };
    }
    {
      name = "xmlbuilder___xmlbuilder_9.0.7.tgz";
      path = fetchurl {
        name = "xmlbuilder___xmlbuilder_9.0.7.tgz";
        url  = "https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-9.0.7.tgz";
        sha1 = "132ee63d2ec5565c557e20f4c22df9aca686b10d";
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
      name = "xmldom___xmldom_0.5.0.tgz";
      path = fetchurl {
        name = "xmldom___xmldom_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/xmldom/-/xmldom-0.5.0.tgz";
        sha1 = "193cb96b84aa3486127ea6272c4596354cb4962e";
      };
    }
    {
      name = "y18n___y18n_5.0.8.tgz";
      path = fetchurl {
        name = "y18n___y18n_5.0.8.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz";
        sha1 = "7f4934d0f7ca8c56f95314939ddcd2dd91ce1d55";
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
      name = "yargs_parser___yargs_parser_20.2.9.tgz";
      path = fetchurl {
        name = "yargs_parser___yargs_parser_20.2.9.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz";
        sha1 = "2eb7dc3b0289718fc295f362753845c41a0c94ee";
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
      name = "yargs___yargs_17.0.1.tgz";
      path = fetchurl {
        name = "yargs___yargs_17.0.1.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-17.0.1.tgz";
        sha1 = "6a1ced4ed5ee0b388010ba9fd67af83b9362e0bb";
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
      name = "zip_stream___zip_stream_4.1.0.tgz";
      path = fetchurl {
        name = "zip_stream___zip_stream_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/zip-stream/-/zip-stream-4.1.0.tgz";
        sha1 = "51dd326571544e36aa3f756430b313576dc8fc79";
      };
    }
  ];
}
