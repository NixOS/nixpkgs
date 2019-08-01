{fetchurl, linkFarm}: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [

    {
      name = "_types_node___node_9.6.45.tgz";
      path = fetchurl {
        name = "_types_node___node_9.6.45.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-9.6.45.tgz";
        sha1 = "a9e5cfd026a3abaaf17e3c0318a470da9f2f178e";
      };
    }

    {
      name = "ajv___ajv_6.10.0.tgz";
      path = fetchurl {
        name = "ajv___ajv_6.10.0.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-6.10.0.tgz";
        sha1 = "90d0d54439da587cd7e843bfb7045f50bd22bdf1";
      };
    }

    {
      name = "applescript___applescript_1.0.0.tgz";
      path = fetchurl {
        name = "applescript___applescript_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/applescript/-/applescript-1.0.0.tgz";
        sha1 = "bb87af568cad034a4e48c4bdaf6067a3a2701317";
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
      name = "asynckit___asynckit_0.4.0.tgz";
      path = fetchurl {
        name = "asynckit___asynckit_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz";
        sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
      };
    }

    {
      name = "auto_launch___auto_launch_5.0.5.tgz";
      path = fetchurl {
        name = "auto_launch___auto_launch_5.0.5.tgz";
        url  = "https://registry.yarnpkg.com/auto-launch/-/auto-launch-5.0.5.tgz";
        sha1 = "d14bd002b1ef642f85e991a6195ff5300c8ad3c0";
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
      name = "aws4___aws4_1.8.0.tgz";
      path = fetchurl {
        name = "aws4___aws4_1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/aws4/-/aws4-1.8.0.tgz";
        sha1 = "f0e003d9ca9e7f59c7a508945d7b2ef9a04a542f";
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
      name = "bignumber.js___bignumber.js_2.4.0.tgz";
      path = fetchurl {
        name = "bignumber.js___bignumber.js_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/bignumber.js/-/bignumber.js-2.4.0.tgz";
        sha1 = "838a992da9f9d737e0f4b2db0be62bb09dd0c5e8";
      };
    }

    {
      name = "bmp_js___bmp_js_0.0.3.tgz";
      path = fetchurl {
        name = "bmp_js___bmp_js_0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/bmp-js/-/bmp-js-0.0.3.tgz";
        sha1 = "64113e9c7cf1202b376ed607bf30626ebe57b18a";
      };
    }

    {
      name = "buffer_equal___buffer_equal_0.0.1.tgz";
      path = fetchurl {
        name = "buffer_equal___buffer_equal_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-0.0.1.tgz";
        sha1 = "91bc74b11ea405bc916bc6aa908faafa5b4aac4b";
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
      name = "combined_stream___combined_stream_1.0.7.tgz";
      path = fetchurl {
        name = "combined_stream___combined_stream_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.7.tgz";
        sha1 = "2d1d24317afb8abe95d6d2c0b07b57813539d828";
      };
    }

    {
      name = "conf___conf_2.2.0.tgz";
      path = fetchurl {
        name = "conf___conf_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/conf/-/conf-2.2.0.tgz";
        sha1 = "ee282efafc1450b61e205372041ad7d866802d9a";
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
      name = "dashdash___dashdash_1.14.1.tgz";
      path = fetchurl {
        name = "dashdash___dashdash_1.14.1.tgz";
        url  = "https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz";
        sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
      };
    }

    {
      name = "deep_equal___deep_equal_1.0.1.tgz";
      path = fetchurl {
        name = "deep_equal___deep_equal_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/deep-equal/-/deep-equal-1.0.1.tgz";
        sha1 = "f5d260292b660e084eff4cdbc9f08ad3247448b5";
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
      name = "dom_walk___dom_walk_0.1.1.tgz";
      path = fetchurl {
        name = "dom_walk___dom_walk_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/dom-walk/-/dom-walk-0.1.1.tgz";
        sha1 = "672226dc74c8f799ad35307df936aba11acd6018";
      };
    }

    {
      name = "dot_prop___dot_prop_4.2.0.tgz";
      path = fetchurl {
        name = "dot_prop___dot_prop_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dot-prop/-/dot-prop-4.2.0.tgz";
        sha1 = "1f19e0c2e1aa0e32797c49799f2837ac6af69c57";
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
      name = "electron_store___electron_store_2.0.0.tgz";
      path = fetchurl {
        name = "electron_store___electron_store_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-store/-/electron-store-2.0.0.tgz";
        sha1 = "1035cca2a95409d1f54c7466606345852450d64a";
      };
    }

    {
      name = "electron_window_state___electron_window_state_4.1.1.tgz";
      path = fetchurl {
        name = "electron_window_state___electron_window_state_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/electron-window-state/-/electron-window-state-4.1.1.tgz";
        sha1 = "6b34fdc31b38514dfec8b7c8f7b5d4addb67632d";
      };
    }

    {
      name = "env_paths___env_paths_1.0.0.tgz";
      path = fetchurl {
        name = "env_paths___env_paths_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/env-paths/-/env-paths-1.0.0.tgz";
        sha1 = "4168133b42bb05c38a35b1ae4397c8298ab369e0";
      };
    }

    {
      name = "es_abstract___es_abstract_1.13.0.tgz";
      path = fetchurl {
        name = "es_abstract___es_abstract_1.13.0.tgz";
        url  = "https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.13.0.tgz";
        sha1 = "ac86145fdd5099d8dd49558ccba2eaf9b88e24e9";
      };
    }

    {
      name = "es_to_primitive___es_to_primitive_1.2.0.tgz";
      path = fetchurl {
        name = "es_to_primitive___es_to_primitive_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.0.tgz";
        sha1 = "edf72478033456e8dda8ef09e00ad9650707f377";
      };
    }

    {
      name = "es6_promise___es6_promise_3.3.1.tgz";
      path = fetchurl {
        name = "es6_promise___es6_promise_3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/es6-promise/-/es6-promise-3.3.1.tgz";
        sha1 = "a08cdde84ccdbf34d027a1451bc91d4bcd28a613";
      };
    }

    {
      name = "exif_parser___exif_parser_0.1.12.tgz";
      path = fetchurl {
        name = "exif_parser___exif_parser_0.1.12.tgz";
        url  = "https://registry.yarnpkg.com/exif-parser/-/exif-parser-0.1.12.tgz";
        sha1 = "58a9d2d72c02c1f6f02a0ef4a9166272b7760922";
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
      name = "fast_deep_equal___fast_deep_equal_2.0.1.tgz";
      path = fetchurl {
        name = "fast_deep_equal___fast_deep_equal_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-2.0.1.tgz";
        sha1 = "7b05218ddf9667bf7f370bf7fdb2cb15fdd0aa49";
      };
    }

    {
      name = "fast_json_stable_stringify___fast_json_stable_stringify_2.0.0.tgz";
      path = fetchurl {
        name = "fast_json_stable_stringify___fast_json_stable_stringify_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.0.0.tgz";
        sha1 = "d5142c0caee6b1189f87d3a76111064f86c8bbf2";
      };
    }

    {
      name = "file_type___file_type_3.9.0.tgz";
      path = fetchurl {
        name = "file_type___file_type_3.9.0.tgz";
        url  = "https://registry.yarnpkg.com/file-type/-/file-type-3.9.0.tgz";
        sha1 = "257a078384d1db8087bc449d107d52a52672b9e9";
      };
    }

    {
      name = "find_up___find_up_2.1.0.tgz";
      path = fetchurl {
        name = "find_up___find_up_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz";
        sha1 = "45d1b7e506c717ddd482775a2b77920a3c0c57a7";
      };
    }

    {
      name = "for_each___for_each_0.3.3.tgz";
      path = fetchurl {
        name = "for_each___for_each_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz";
        sha1 = "69b447e88a0a5d32c3e7084f3f1710034b21376e";
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
      name = "function_bind___function_bind_1.1.1.tgz";
      path = fetchurl {
        name = "function_bind___function_bind_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
        sha1 = "a56899d3ea3c9bab874bb9773b7c5ede92f4895d";
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
      name = "global___global_4.3.2.tgz";
      path = fetchurl {
        name = "global___global_4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/global/-/global-4.3.2.tgz";
        sha1 = "e76989268a6c74c38908b1305b10fc0e394e9d0f";
      };
    }

    {
      name = "graceful_fs___graceful_fs_4.1.15.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.1.15.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.1.15.tgz";
        sha1 = "ffb703e1066e8a0eeaa4c8b80ba9253eeefbfb00";
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
      name = "har_validator___har_validator_5.1.3.tgz";
      path = fetchurl {
        name = "har_validator___har_validator_5.1.3.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-5.1.3.tgz";
        sha1 = "1ef89ebd3e4996557675eed9893110dc350fa080";
      };
    }

    {
      name = "has_symbols___has_symbols_1.0.0.tgz";
      path = fetchurl {
        name = "has_symbols___has_symbols_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.0.tgz";
        sha1 = "ba1a8f1af2a0fc39650f5c850367704122063b44";
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
      name = "http_signature___http_signature_1.2.0.tgz";
      path = fetchurl {
        name = "http_signature___http_signature_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz";
        sha1 = "9aecd925114772f3d95b65a60abb8f7c18fbace1";
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
      name = "ip_regex___ip_regex_1.0.3.tgz";
      path = fetchurl {
        name = "ip_regex___ip_regex_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/ip-regex/-/ip-regex-1.0.3.tgz";
        sha1 = "dc589076f659f419c222039a33316f1c7387effd";
      };
    }

    {
      name = "is_callable___is_callable_1.1.4.tgz";
      path = fetchurl {
        name = "is_callable___is_callable_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/is-callable/-/is-callable-1.1.4.tgz";
        sha1 = "1e1adf219e1eeb684d691f9d6a05ff0d30a24d75";
      };
    }

    {
      name = "is_date_object___is_date_object_1.0.1.tgz";
      path = fetchurl {
        name = "is_date_object___is_date_object_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.1.tgz";
        sha1 = "9aa20eb6aeebbff77fbd33e74ca01b33581d3a16";
      };
    }

    {
      name = "is_function___is_function_1.0.1.tgz";
      path = fetchurl {
        name = "is_function___is_function_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-function/-/is-function-1.0.1.tgz";
        sha1 = "12cfb98b65b57dd3d193a3121f5f6e2f437602b5";
      };
    }

    {
      name = "is_obj___is_obj_1.0.1.tgz";
      path = fetchurl {
        name = "is_obj___is_obj_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-obj/-/is-obj-1.0.1.tgz";
        sha1 = "3e4729ac1f5fde025cd7d83a896dab9f4f67db0f";
      };
    }

    {
      name = "is_regex___is_regex_1.0.4.tgz";
      path = fetchurl {
        name = "is_regex___is_regex_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-regex/-/is-regex-1.0.4.tgz";
        sha1 = "5517489b547091b0930e095654ced25ee97e9491";
      };
    }

    {
      name = "is_symbol___is_symbol_1.0.2.tgz";
      path = fetchurl {
        name = "is_symbol___is_symbol_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.2.tgz";
        sha1 = "a055f6ae57192caee329e7a860118b497a950f38";
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
      name = "isstream___isstream_0.1.2.tgz";
      path = fetchurl {
        name = "isstream___isstream_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
    }

    {
      name = "jimp___jimp_0.2.28.tgz";
      path = fetchurl {
        name = "jimp___jimp_0.2.28.tgz";
        url  = "https://registry.yarnpkg.com/jimp/-/jimp-0.2.28.tgz";
        sha1 = "dd529a937190f42957a7937d1acc3a7762996ea2";
      };
    }

    {
      name = "jpeg_js___jpeg_js_0.2.0.tgz";
      path = fetchurl {
        name = "jpeg_js___jpeg_js_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/jpeg-js/-/jpeg-js-0.2.0.tgz";
        sha1 = "53e448ec9d263e683266467e9442d2c5a2ef5482";
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
      name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
      path = fetchurl {
        name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    }

    {
      name = "jsonfile___jsonfile_2.4.0.tgz";
      path = fetchurl {
        name = "jsonfile___jsonfile_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-2.4.0.tgz";
        sha1 = "3736a2b428b87bbda0cc83b53fa3d633a35c2ae8";
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
      name = "load_bmfont___load_bmfont_1.4.0.tgz";
      path = fetchurl {
        name = "load_bmfont___load_bmfont_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/load-bmfont/-/load-bmfont-1.4.0.tgz";
        sha1 = "75f17070b14a8c785fe7f5bee2e6fd4f98093b6b";
      };
    }

    {
      name = "locate_path___locate_path_2.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz";
        sha1 = "2b568b265eec944c6d9c0de9c3dbbbca0354cd8e";
      };
    }

    {
      name = "make_dir___make_dir_1.3.0.tgz";
      path = fetchurl {
        name = "make_dir___make_dir_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/make-dir/-/make-dir-1.3.0.tgz";
        sha1 = "79c1033b80515bd6d24ec9933e860ca75ee27f0c";
      };
    }

    {
      name = "mime_db___mime_db_1.38.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.38.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.38.0.tgz";
        sha1 = "1a2aab16da9eb167b49c6e4df2d9c68d63d8e2ad";
      };
    }

    {
      name = "mime_types___mime_types_2.1.22.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.22.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.22.tgz";
        sha1 = "fe6b355a190926ab7698c9a0556a11199b2199bd";
      };
    }

    {
      name = "mime___mime_1.6.0.tgz";
      path = fetchurl {
        name = "mime___mime_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz";
        sha1 = "32cd9e5c64553bd58d19a568af452acff04981b1";
      };
    }

    {
      name = "min_document___min_document_2.19.0.tgz";
      path = fetchurl {
        name = "min_document___min_document_2.19.0.tgz";
        url  = "https://registry.yarnpkg.com/min-document/-/min-document-2.19.0.tgz";
        sha1 = "7bd282e3f5842ed295bb748cdd9f1ffa2c824685";
      };
    }

    {
      name = "minimist___minimist_0.0.8.tgz";
      path = fetchurl {
        name = "minimist___minimist_0.0.8.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
    }

    {
      name = "minimist___minimist_1.2.0.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.0.tgz";
        sha1 = "a35008b20f41383eec1fb914f4cd5df79a264284";
      };
    }

    {
      name = "mkdirp___mkdirp_0.5.1.tgz";
      path = fetchurl {
        name = "mkdirp___mkdirp_0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
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
      name = "object_keys___object_keys_1.1.0.tgz";
      path = fetchurl {
        name = "object_keys___object_keys_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.0.tgz";
        sha1 = "11bd22348dd2e096a045ab06f6c85bcc340fa032";
      };
    }

    {
      name = "p_limit___p_limit_1.3.0.tgz";
      path = fetchurl {
        name = "p_limit___p_limit_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz";
        sha1 = "b86bd5f0c25690911c7590fcbfc2010d54b3ccb8";
      };
    }

    {
      name = "p_locate___p_locate_2.0.0.tgz";
      path = fetchurl {
        name = "p_locate___p_locate_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz";
        sha1 = "20a0103b222a70c8fd39cc2e580680f3dde5ec43";
      };
    }

    {
      name = "p_try___p_try_1.0.0.tgz";
      path = fetchurl {
        name = "p_try___p_try_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz";
        sha1 = "cbc79cdbaf8fd4228e13f621f2b1a237c1b207b3";
      };
    }

    {
      name = "parse_bmfont_ascii___parse_bmfont_ascii_1.0.6.tgz";
      path = fetchurl {
        name = "parse_bmfont_ascii___parse_bmfont_ascii_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz";
        sha1 = "11ac3c3ff58f7c2020ab22769079108d4dfa0285";
      };
    }

    {
      name = "parse_bmfont_binary___parse_bmfont_binary_1.0.6.tgz";
      path = fetchurl {
        name = "parse_bmfont_binary___parse_bmfont_binary_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz";
        sha1 = "d038b476d3e9dd9db1e11a0b0e53a22792b69006";
      };
    }

    {
      name = "parse_bmfont_xml___parse_bmfont_xml_1.1.4.tgz";
      path = fetchurl {
        name = "parse_bmfont_xml___parse_bmfont_xml_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/parse-bmfont-xml/-/parse-bmfont-xml-1.1.4.tgz";
        sha1 = "015319797e3e12f9e739c4d513872cd2fa35f389";
      };
    }

    {
      name = "parse_headers___parse_headers_2.0.2.tgz";
      path = fetchurl {
        name = "parse_headers___parse_headers_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/parse-headers/-/parse-headers-2.0.2.tgz";
        sha1 = "9545e8a4c1ae5eaea7d24992bca890281ed26e34";
      };
    }

    {
      name = "path_exists___path_exists_3.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz";
        sha1 = "ce0ebeaa5f78cb18925ea7d810d7b59b010fd515";
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
      name = "performance_now___performance_now_2.1.0.tgz";
      path = fetchurl {
        name = "performance_now___performance_now_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz";
        sha1 = "6309f4e0e5fa913ec1c69307ae364b4b377c9e7b";
      };
    }

    {
      name = "phin___phin_2.9.3.tgz";
      path = fetchurl {
        name = "phin___phin_2.9.3.tgz";
        url  = "https://registry.yarnpkg.com/phin/-/phin-2.9.3.tgz";
        sha1 = "f9b6ac10a035636fb65dfc576aaaa17b8743125c";
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
      name = "pixelmatch___pixelmatch_4.0.2.tgz";
      path = fetchurl {
        name = "pixelmatch___pixelmatch_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pixelmatch/-/pixelmatch-4.0.2.tgz";
        sha1 = "8f47dcec5011b477b67db03c243bc1f3085e8854";
      };
    }

    {
      name = "pkg_up___pkg_up_2.0.0.tgz";
      path = fetchurl {
        name = "pkg_up___pkg_up_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-up/-/pkg-up-2.0.0.tgz";
        sha1 = "c819ac728059a461cab1c3889a2be3c49a004d7f";
      };
    }

    {
      name = "png_to_ico___png_to_ico_1.0.7.tgz";
      path = fetchurl {
        name = "png_to_ico___png_to_ico_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/png-to-ico/-/png-to-ico-1.0.7.tgz";
        sha1 = "9346b5f4d6fd7e94cb08fd49eeb585f501c3e5f2";
      };
    }

    {
      name = "pngjs___pngjs_3.4.0.tgz";
      path = fetchurl {
        name = "pngjs___pngjs_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/pngjs/-/pngjs-3.4.0.tgz";
        sha1 = "99ca7d725965fb655814eaf65f38f12bbdbf555f";
      };
    }

    {
      name = "process___process_0.5.2.tgz";
      path = fetchurl {
        name = "process___process_0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/process/-/process-0.5.2.tgz";
        sha1 = "1638d8a8e34c2f440a91db95ab9aeb677fc185cf";
      };
    }

    {
      name = "psl___psl_1.1.31.tgz";
      path = fetchurl {
        name = "psl___psl_1.1.31.tgz";
        url  = "https://registry.yarnpkg.com/psl/-/psl-1.1.31.tgz";
        sha1 = "e9aa86d0101b5b105cbe93ac6b784cd547276184";
      };
    }

    {
      name = "punycode___punycode_1.4.1.tgz";
      path = fetchurl {
        name = "punycode___punycode_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz";
        sha1 = "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e";
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
      name = "qs___qs_6.5.2.tgz";
      path = fetchurl {
        name = "qs___qs_6.5.2.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.5.2.tgz";
        sha1 = "cb3ae806e8740444584ef154ce8ee98d403f3e36";
      };
    }

    {
      name = "read_chunk___read_chunk_1.0.1.tgz";
      path = fetchurl {
        name = "read_chunk___read_chunk_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-chunk/-/read-chunk-1.0.1.tgz";
        sha1 = "5f68cab307e663f19993527d9b589cace4661194";
      };
    }

    {
      name = "request___request_2.88.0.tgz";
      path = fetchurl {
        name = "request___request_2.88.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.88.0.tgz";
        sha1 = "9c2fca4f7d35b592efe57c7f0a55e81052124fef";
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
      name = "safer_buffer___safer_buffer_2.1.2.tgz";
      path = fetchurl {
        name = "safer_buffer___safer_buffer_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz";
        sha1 = "44fa161b0187b9549dd84bb91802f9bd8385cd6a";
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
      name = "signal_exit___signal_exit_3.0.2.tgz";
      path = fetchurl {
        name = "signal_exit___signal_exit_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.2.tgz";
        sha1 = "b5fdc08f1287ea1178628e415e25132b73646c6d";
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
      name = "stream_to_buffer___stream_to_buffer_0.1.0.tgz";
      path = fetchurl {
        name = "stream_to_buffer___stream_to_buffer_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-to-buffer/-/stream-to-buffer-0.1.0.tgz";
        sha1 = "26799d903ab2025c9bd550ac47171b00f8dd80a9";
      };
    }

    {
      name = "stream_to___stream_to_0.2.2.tgz";
      path = fetchurl {
        name = "stream_to___stream_to_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/stream-to/-/stream-to-0.2.2.tgz";
        sha1 = "84306098d85fdb990b9fa300b1b3ccf55e8ef01d";
      };
    }

    {
      name = "string.prototype.trim___string.prototype.trim_1.1.2.tgz";
      path = fetchurl {
        name = "string.prototype.trim___string.prototype.trim_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.1.2.tgz";
        sha1 = "d04de2c89e137f4d7d206f086b5ed2fae6be8cea";
      };
    }

    {
      name = "tinycolor2___tinycolor2_1.4.1.tgz";
      path = fetchurl {
        name = "tinycolor2___tinycolor2_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/tinycolor2/-/tinycolor2-1.4.1.tgz";
        sha1 = "f4fad333447bc0b07d4dc8e9209d8f39a8ac77e8";
      };
    }

    {
      name = "tough_cookie___tough_cookie_2.4.3.tgz";
      path = fetchurl {
        name = "tough_cookie___tough_cookie_2.4.3.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.4.3.tgz";
        sha1 = "53f36da3f47783b0925afa06ff9f3b165280f781";
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
      name = "tweetnacl___tweetnacl_0.14.5.tgz";
      path = fetchurl {
        name = "tweetnacl___tweetnacl_0.14.5.tgz";
        url  = "https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz";
        sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
      };
    }

    {
      name = "untildify___untildify_3.0.3.tgz";
      path = fetchurl {
        name = "untildify___untildify_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/untildify/-/untildify-3.0.3.tgz";
        sha1 = "1e7b42b140bcfd922b22e70ca1265bfe3634c7c9";
      };
    }

    {
      name = "uri_js___uri_js_4.2.2.tgz";
      path = fetchurl {
        name = "uri_js___uri_js_4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/uri-js/-/uri-js-4.2.2.tgz";
        sha1 = "94c540e1ff772956e2299507c010aea6c8838eb0";
      };
    }

    {
      name = "url_regex___url_regex_3.2.0.tgz";
      path = fetchurl {
        name = "url_regex___url_regex_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/url-regex/-/url-regex-3.2.0.tgz";
        sha1 = "dbad1e0c9e29e105dd0b1f09f6862f7fdb482724";
      };
    }

    {
      name = "uuid___uuid_3.3.2.tgz";
      path = fetchurl {
        name = "uuid___uuid_3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.3.2.tgz";
        sha1 = "1b4af4955eb3077c501c23872fc6513811587131";
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
      name = "winreg___winreg_1.2.4.tgz";
      path = fetchurl {
        name = "winreg___winreg_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/winreg/-/winreg-1.2.4.tgz";
        sha1 = "ba065629b7a925130e15779108cf540990e98d1b";
      };
    }

    {
      name = "write_file_atomic___write_file_atomic_2.4.2.tgz";
      path = fetchurl {
        name = "write_file_atomic___write_file_atomic_2.4.2.tgz";
        url  = "https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-2.4.2.tgz";
        sha1 = "a7181706dfba17855d221140a9c06e15fcdd87b9";
      };
    }

    {
      name = "xhr___xhr_2.5.0.tgz";
      path = fetchurl {
        name = "xhr___xhr_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/xhr/-/xhr-2.5.0.tgz";
        sha1 = "bed8d1676d5ca36108667692b74b316c496e49dd";
      };
    }

    {
      name = "xml_parse_from_string___xml_parse_from_string_1.0.1.tgz";
      path = fetchurl {
        name = "xml_parse_from_string___xml_parse_from_string_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz";
        sha1 = "a9029e929d3dbcded169f3c6e28238d95a5d5a28";
      };
    }

    {
      name = "xml2js___xml2js_0.4.19.tgz";
      path = fetchurl {
        name = "xml2js___xml2js_0.4.19.tgz";
        url  = "https://registry.yarnpkg.com/xml2js/-/xml2js-0.4.19.tgz";
        sha1 = "686c20f213209e94abf0d1bcf1efaa291c7827a7";
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
      name = "xtend___xtend_4.0.1.tgz";
      path = fetchurl {
        name = "xtend___xtend_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.1.tgz";
        sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
      };
    }
  ];
}
