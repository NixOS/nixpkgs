{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "370c480ac103bd17c7bcfb34bf5d577dc40d3660";
      path = fetchurl {
        name = "370c480ac103bd17c7bcfb34bf5d577dc40d3660";
        url  = "https://codeload.github.com/ramya-rao-a/css-parser/tar.gz/370c480ac103bd17c7bcfb34bf5d577dc40d3660";
        sha1 = "d35990e1b627e7654e67ec4ae98a91a5e72706a7";
      };
    }
    {
      name = "_emmetio_extract_abbreviation___extract_abbreviation_0.1.6.tgz";
      path = fetchurl {
        name = "_emmetio_extract_abbreviation___extract_abbreviation_0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/@emmetio/extract-abbreviation/-/extract-abbreviation-0.1.6.tgz";
        sha1 = "e4a9856c1057f0aff7d443b8536477c243abe28c";
      };
    }
    {
      name = "_emmetio_html_matcher___html_matcher_0.3.3.tgz";
      path = fetchurl {
        name = "_emmetio_html_matcher___html_matcher_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/@emmetio/html-matcher/-/html-matcher-0.3.3.tgz";
        sha1 = "0bbdadc0882e185950f03737dc6dbf8f7bd90728";
      };
    }
    {
      name = "_emmetio_math_expression___math_expression_0.1.1.tgz";
      path = fetchurl {
        name = "_emmetio_math_expression___math_expression_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@emmetio/math-expression/-/math-expression-0.1.1.tgz";
        sha1 = "1ff2c7f05800f64c57ca89038ee18bce9f5776dc";
      };
    }
    {
      name = "_emmetio_stream_reader_utils___stream_reader_utils_0.1.0.tgz";
      path = fetchurl {
        name = "_emmetio_stream_reader_utils___stream_reader_utils_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/@emmetio/stream-reader-utils/-/stream-reader-utils-0.1.0.tgz";
        sha1 = "244cb02c77ec2e74f78a9bd318218abc9c500a61";
      };
    }
    {
      name = "_emmetio_stream_reader___stream_reader_2.2.0.tgz";
      path = fetchurl {
        name = "_emmetio_stream_reader___stream_reader_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@emmetio/stream-reader/-/stream-reader-2.2.0.tgz";
        sha1 = "46cffea119a0a003312a21c2d9b5628cb5fcd442";
      };
    }
    {
      name = "agent_base___agent_base_4.3.0.tgz";
      path = fetchurl {
        name = "agent_base___agent_base_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/agent-base/-/agent-base-4.3.0.tgz";
        sha1 = "8165f01c436009bccad0b1d122f05ed770efc6ee";
      };
    }
    {
      name = "applicationinsights___applicationinsights_1.0.8.tgz";
      path = fetchurl {
        name = "applicationinsights___applicationinsights_1.0.8.tgz";
        url  = "https://registry.yarnpkg.com/applicationinsights/-/applicationinsights-1.0.8.tgz";
        sha1 = "db6e3d983cf9f9405fe1ee5ba30ac6e1914537b5";
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
      name = "balanced_match___balanced_match_1.0.0.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
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
      name = "byline___byline_5.0.0.tgz";
      path = fetchurl {
        name = "byline___byline_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/byline/-/byline-5.0.0.tgz";
        sha1 = "741c5216468eadc457b03410118ad77de8c1ddb1";
      };
    }
    {
      name = "commander___commander_2.20.3.tgz";
      path = fetchurl {
        name = "commander___commander_2.20.3.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz";
        sha1 = "fd485e84c03eb4881c20722ba48035e8531aeb33";
      };
    }
    {
      name = "commandpost___commandpost_1.4.0.tgz";
      path = fetchurl {
        name = "commandpost___commandpost_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/commandpost/-/commandpost-1.4.0.tgz";
        sha1 = "89218012089dfc9b67a337ba162f15c88e0f1048";
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
      name = "debug___debug_3.1.0.tgz";
      path = fetchurl {
        name = "debug___debug_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.1.0.tgz";
        sha1 = "5bb5a0672628b64149566ba16819e61518c67261";
      };
    }
    {
      name = "debug___debug_3.2.7.tgz";
      path = fetchurl {
        name = "debug___debug_3.2.7.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz";
        sha1 = "72580b7e9145fb39b6676f9c5e5fb100b934179a";
      };
    }
    {
      name = "diagnostic_channel_publishers___diagnostic_channel_publishers_0.2.1.tgz";
      path = fetchurl {
        name = "diagnostic_channel_publishers___diagnostic_channel_publishers_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/diagnostic-channel-publishers/-/diagnostic-channel-publishers-0.2.1.tgz";
        sha1 = "8e2d607a8b6d79fe880b548bc58cc6beb288c4f3";
      };
    }
    {
      name = "diagnostic_channel___diagnostic_channel_0.2.0.tgz";
      path = fetchurl {
        name = "diagnostic_channel___diagnostic_channel_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/diagnostic-channel/-/diagnostic-channel-0.2.0.tgz";
        sha1 = "cc99af9612c23fb1fff13612c72f2cbfaa8d5a17";
      };
    }
    {
      name = "editorconfig___editorconfig_0.15.3.tgz";
      path = fetchurl {
        name = "editorconfig___editorconfig_0.15.3.tgz";
        url  = "https://registry.yarnpkg.com/editorconfig/-/editorconfig-0.15.3.tgz";
        sha1 = "bef84c4e75fb8dcb0ce5cee8efd51c15999befc5";
      };
    }
    {
      name = "entities___entities_2.0.3.tgz";
      path = fetchurl {
        name = "entities___entities_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/entities/-/entities-2.0.3.tgz";
        sha1 = "5c487e5742ab93c15abb5da22759b8590ec03b7f";
      };
    }
    {
      name = "es6_promise___es6_promise_4.2.8.tgz";
      path = fetchurl {
        name = "es6_promise___es6_promise_4.2.8.tgz";
        url  = "https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.2.8.tgz";
        sha1 = "4eb21594c972bc40553d276e510539143db53e0a";
      };
    }
    {
      name = "es6_promisify___es6_promisify_5.0.0.tgz";
      path = fetchurl {
        name = "es6_promisify___es6_promisify_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/es6-promisify/-/es6-promisify-5.0.0.tgz";
        sha1 = "5109d62f3e56ea967c4b63505aef08291c8a5203";
      };
    }
    {
      name = "file_type___file_type_7.7.1.tgz";
      path = fetchurl {
        name = "file_type___file_type_7.7.1.tgz";
        url  = "https://registry.yarnpkg.com/file-type/-/file-type-7.7.1.tgz";
        sha1 = "91c2f5edb8ce70688b9b68a90d931bbb6cb21f65";
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
      name = "glob___glob_7.1.6.tgz";
      path = fetchurl {
        name = "glob___glob_7.1.6.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.6.tgz";
        sha1 = "141f33b81a7c2492e125594307480c46679278a6";
      };
    }
    {
      name = "highlight.js___highlight.js_10.1.2.tgz";
      path = fetchurl {
        name = "highlight.js___highlight.js_10.1.2.tgz";
        url  = "https://registry.yarnpkg.com/highlight.js/-/highlight.js-10.1.2.tgz";
        sha1 = "c20db951ba1c22c055010648dfffd7b2a968e00c";
      };
    }
    {
      name = "http_proxy_agent___http_proxy_agent_2.1.0.tgz";
      path = fetchurl {
        name = "http_proxy_agent___http_proxy_agent_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-2.1.0.tgz";
        sha1 = "e4821beef5b2142a2026bd73926fe537631c5405";
      };
    }
    {
      name = "https_proxy_agent___https_proxy_agent_2.2.4.tgz";
      path = fetchurl {
        name = "https_proxy_agent___https_proxy_agent_2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-2.2.4.tgz";
        sha1 = "4ee7a737abd92678a293d9b34a1af4d0d08c787b";
      };
    }
    {
      name = "iconv_lite_umd___iconv_lite_umd_0.6.8.tgz";
      path = fetchurl {
        name = "iconv_lite_umd___iconv_lite_umd_0.6.8.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite-umd/-/iconv-lite-umd-0.6.8.tgz";
        sha1 = "5ad310ec126b260621471a2d586f7f37b9958ec0";
      };
    }
    {
      name = "image_size___image_size_0.5.5.tgz";
      path = fetchurl {
        name = "image_size___image_size_0.5.5.tgz";
        url  = "https://registry.yarnpkg.com/image-size/-/image-size-0.5.5.tgz";
        sha1 = "09dfd4ab9d20e29eb1c3e80b8990378df9e3cb9c";
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
      name = "isexe___isexe_2.0.0.tgz";
      path = fetchurl {
        name = "isexe___isexe_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
      };
    }
    {
      name = "jschardet___jschardet_2.2.1.tgz";
      path = fetchurl {
        name = "jschardet___jschardet_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/jschardet/-/jschardet-2.2.1.tgz";
        sha1 = "03b0264669a90c7a5c436a68c5a7d4e4cb0c9823";
      };
    }
    {
      name = "jsonc_parser___jsonc_parser_1.0.3.tgz";
      path = fetchurl {
        name = "jsonc_parser___jsonc_parser_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-1.0.3.tgz";
        sha1 = "1d53d7160e401a783dbceabaad82473f80e6ad7e";
      };
    }
    {
      name = "jsonc_parser___jsonc_parser_3.0.0.tgz";
      path = fetchurl {
        name = "jsonc_parser___jsonc_parser_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.0.0.tgz";
        sha1 = "abdd785701c7e7eaca8a9ec8cf070ca51a745a22";
      };
    }
    {
      name = "linkify_it___linkify_it_2.2.0.tgz";
      path = fetchurl {
        name = "linkify_it___linkify_it_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/linkify-it/-/linkify-it-2.2.0.tgz";
        sha1 = "e3b54697e78bf915c70a38acd78fd09e0058b1cf";
      };
    }
    {
      name = "lru_cache___lru_cache_4.1.5.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_4.1.5.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.5.tgz";
        sha1 = "8bbe50ea85bed59bc9e33dcab8235ee9bcf443cd";
      };
    }
    {
      name = "markdown_it_front_matter___markdown_it_front_matter_0.2.3.tgz";
      path = fetchurl {
        name = "markdown_it_front_matter___markdown_it_front_matter_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/markdown-it-front-matter/-/markdown-it-front-matter-0.2.3.tgz";
        sha1 = "d6fa0f4b362e02086dd4ce8219fadf3f4c9cfa37";
      };
    }
    {
      name = "markdown_it___markdown_it_10.0.0.tgz";
      path = fetchurl {
        name = "markdown_it___markdown_it_10.0.0.tgz";
        url  = "https://registry.yarnpkg.com/markdown-it/-/markdown-it-10.0.0.tgz";
        sha1 = "abfc64f141b1722d663402044e43927f1f50a8dc";
      };
    }
    {
      name = "mdurl___mdurl_1.0.1.tgz";
      path = fetchurl {
        name = "mdurl___mdurl_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/mdurl/-/mdurl-1.0.1.tgz";
        sha1 = "fe85b2ec75a59037f2adfec100fd6c601761152e";
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
      name = "ms___ms_2.0.0.tgz";
      path = fetchurl {
        name = "ms___ms_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    }
    {
      name = "ms___ms_2.1.3.tgz";
      path = fetchurl {
        name = "ms___ms_2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz";
        sha1 = "574c8138ce1d2b5861f0b44579dbadd60c6615b2";
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
      name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
      path = fetchurl {
        name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    }
    {
      name = "pseudomap___pseudomap_1.0.2.tgz";
      path = fetchurl {
        name = "pseudomap___pseudomap_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz";
        sha1 = "f052a28da70e618917ef0a8ac34c1ae5a68286b3";
      };
    }
    {
      name = "request_light___request_light_0.4.0.tgz";
      path = fetchurl {
        name = "request_light___request_light_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/request-light/-/request-light-0.4.0.tgz";
        sha1 = "c6b91ef00b18cb0de75d2127e55b3a2c9f7f90f9";
      };
    }
    {
      name = "rimraf___rimraf_2.7.1.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_2.7.1.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz";
        sha1 = "35797f13a7fdadc566142c29d4f07ccad483e3ec";
      };
    }
    {
      name = "semver___semver_5.5.1.tgz";
      path = fetchurl {
        name = "semver___semver_5.5.1.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.5.1.tgz";
        sha1 = "7dfdd8814bdb7cabc7be0fb1d734cfb66c940477";
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
      name = "sigmund___sigmund_1.0.1.tgz";
      path = fetchurl {
        name = "sigmund___sigmund_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sigmund/-/sigmund-1.0.1.tgz";
        sha1 = "3ff21f198cad2175f9f3b781853fd94d0d19b590";
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
      name = "typescript_formatter___typescript_formatter_7.1.0.tgz";
      path = fetchurl {
        name = "typescript_formatter___typescript_formatter_7.1.0.tgz";
        url  = "https://registry.yarnpkg.com/typescript-formatter/-/typescript-formatter-7.1.0.tgz";
        sha1 = "dd1b5547de211065221f765263e15f18c84c66b8";
      };
    }
    {
      name = "typescript_vscode_sh_plugin___typescript_vscode_sh_plugin_0.6.14.tgz";
      path = fetchurl {
        name = "typescript_vscode_sh_plugin___typescript_vscode_sh_plugin_0.6.14.tgz";
        url  = "https://registry.yarnpkg.com/typescript-vscode-sh-plugin/-/typescript-vscode-sh-plugin-0.6.14.tgz";
        sha1 = "a81031b502f6346a26ea49ce082438c3e353bb38";
      };
    }
    {
      name = "typescript___typescript_4.2.0_dev.20201228.tgz";
      path = fetchurl {
        name = "typescript___typescript_4.2.0_dev.20201228.tgz";
        url  = "https://registry.yarnpkg.com/typescript/-/typescript-4.2.0-dev.20201228.tgz";
        sha1 = "be099aa540d4a8faf4e05deb4af43dae602ef326";
      };
    }
    {
      name = "uc.micro___uc.micro_1.0.6.tgz";
      path = fetchurl {
        name = "uc.micro___uc.micro_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/uc.micro/-/uc.micro-1.0.6.tgz";
        sha1 = "9c411a802a409a91fc6cf74081baba34b24499ac";
      };
    }
    {
      name = "vscode_css_languageservice___vscode_css_languageservice_4.4.0.tgz";
      path = fetchurl {
        name = "vscode_css_languageservice___vscode_css_languageservice_4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/vscode-css-languageservice/-/vscode-css-languageservice-4.4.0.tgz";
        sha1 = "a7c5edf3057e707601ca18fa3728784a298513b4";
      };
    }
    {
      name = "vscode_emmet_helper___vscode_emmet_helper_1.2.17.tgz";
      path = fetchurl {
        name = "vscode_emmet_helper___vscode_emmet_helper_1.2.17.tgz";
        url  = "https://registry.yarnpkg.com/vscode-emmet-helper/-/vscode-emmet-helper-1.2.17.tgz";
        sha1 = "f0c6bfcebc4285d081fb2618e6e5b9a08c567afa";
      };
    }
    {
      name = "vscode_extension_telemetry___vscode_extension_telemetry_0.1.1.tgz";
      path = fetchurl {
        name = "vscode_extension_telemetry___vscode_extension_telemetry_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/vscode-extension-telemetry/-/vscode-extension-telemetry-0.1.1.tgz";
        sha1 = "91387e06b33400c57abd48979b0e790415ae110b";
      };
    }
    {
      name = "vscode_html_languageservice___vscode_html_languageservice_3.2.0.tgz";
      path = fetchurl {
        name = "vscode_html_languageservice___vscode_html_languageservice_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/vscode-html-languageservice/-/vscode-html-languageservice-3.2.0.tgz";
        sha1 = "e92269a04097d87bd23431e3a4e491a27b5447b9";
      };
    }
    {
      name = "vscode_json_languageservice___vscode_json_languageservice_3.11.0.tgz";
      path = fetchurl {
        name = "vscode_json_languageservice___vscode_json_languageservice_3.11.0.tgz";
        url  = "https://registry.yarnpkg.com/vscode-json-languageservice/-/vscode-json-languageservice-3.11.0.tgz";
        sha1 = "ad574b36c4346bd7830f1d34b5a5213d3af8d232";
      };
    }
    {
      name = "vscode_jsonrpc___vscode_jsonrpc_6.0.0_next.2.tgz";
      path = fetchurl {
        name = "vscode_jsonrpc___vscode_jsonrpc_6.0.0_next.2.tgz";
        url  = "https://registry.yarnpkg.com/vscode-jsonrpc/-/vscode-jsonrpc-6.0.0-next.2.tgz";
        sha1 = "3d73f86d812304cb91b9fb1efee40ec60b09ed7f";
      };
    }
    {
      name = "vscode_languageclient___vscode_languageclient_7.0.0_next.5.1.tgz";
      path = fetchurl {
        name = "vscode_languageclient___vscode_languageclient_7.0.0_next.5.1.tgz";
        url  = "https://registry.yarnpkg.com/vscode-languageclient/-/vscode-languageclient-7.0.0-next.5.1.tgz";
        sha1 = "ed93f14e4c2cdccedf15002c7bf8ef9cb638f36c";
      };
    }
    {
      name = "vscode_languageserver_protocol___vscode_languageserver_protocol_3.16.0_next.4.tgz";
      path = fetchurl {
        name = "vscode_languageserver_protocol___vscode_languageserver_protocol_3.16.0_next.4.tgz";
        url  = "https://registry.yarnpkg.com/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.16.0-next.4.tgz";
        sha1 = "8f8b1b831d4dfd9b26aa1ba3d2a32c427a91c99f";
      };
    }
    {
      name = "vscode_languageserver_textdocument___vscode_languageserver_textdocument_1.0.1.tgz";
      path = fetchurl {
        name = "vscode_languageserver_textdocument___vscode_languageserver_textdocument_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.1.tgz";
        sha1 = "178168e87efad6171b372add1dea34f53e5d330f";
      };
    }
    {
      name = "vscode_languageserver_types___vscode_languageserver_types_3.16.0_next.2.tgz";
      path = fetchurl {
        name = "vscode_languageserver_types___vscode_languageserver_types_3.16.0_next.2.tgz";
        url  = "https://registry.yarnpkg.com/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0-next.2.tgz";
        sha1 = "940bd15c992295a65eae8ab6b8568a1e8daa3083";
      };
    }
    {
      name = "vscode_languageserver_types___vscode_languageserver_types_3.16.0.tgz";
      path = fetchurl {
        name = "vscode_languageserver_types___vscode_languageserver_types_3.16.0.tgz";
        url  = "https://registry.yarnpkg.com/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz";
        sha1 = "ecf393fc121ec6974b2da3efb3155644c514e247";
      };
    }
    {
      name = "vscode_languageserver___vscode_languageserver_7.0.0_next.3.tgz";
      path = fetchurl {
        name = "vscode_languageserver___vscode_languageserver_7.0.0_next.3.tgz";
        url  = "https://registry.yarnpkg.com/vscode-languageserver/-/vscode-languageserver-7.0.0-next.3.tgz";
        sha1 = "3833bd09259a4a085baeba90783f1e4d06d81095";
      };
    }
    {
      name = "vscode_nls___vscode_nls_4.1.2.tgz";
      path = fetchurl {
        name = "vscode_nls___vscode_nls_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/vscode-nls/-/vscode-nls-4.1.2.tgz";
        sha1 = "ca8bf8bb82a0987b32801f9fddfdd2fb9fd3c167";
      };
    }
    {
      name = "vscode_nls___vscode_nls_5.0.0.tgz";
      path = fetchurl {
        name = "vscode_nls___vscode_nls_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/vscode-nls/-/vscode-nls-5.0.0.tgz";
        sha1 = "99f0da0bd9ea7cda44e565a74c54b1f2bc257840";
      };
    }
    {
      name = "vscode_uri___vscode_uri_2.1.2.tgz";
      path = fetchurl {
        name = "vscode_uri___vscode_uri_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/vscode-uri/-/vscode-uri-2.1.2.tgz";
        sha1 = "c8d40de93eb57af31f3c715dd650e2ca2c096f1c";
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
      name = "wrappy___wrappy_1.0.2.tgz";
      path = fetchurl {
        name = "wrappy___wrappy_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    }
    {
      name = "yallist___yallist_2.1.2.tgz";
      path = fetchurl {
        name = "yallist___yallist_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz";
        sha1 = "1c11f9218f076089a47dd512f93c6699a6a81d52";
      };
    }
    {
      name = "zone.js___zone.js_0.7.6.tgz";
      path = fetchurl {
        name = "zone.js___zone.js_0.7.6.tgz";
        url  = "https://registry.yarnpkg.com/zone.js/-/zone.js-0.7.6.tgz";
        sha1 = "fbbc39d3e0261d0986f1ba06306eb3aeb0d22009";
      };
    }
  ];
}
