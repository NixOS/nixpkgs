{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "7zip_bin___7zip_bin_5.1.1.tgz";
      path = fetchurl {
        name = "7zip_bin___7zip_bin_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/7zip-bin/-/7zip-bin-5.1.1.tgz";
        sha512 = "sAP4LldeWNz0lNzmTird3uWfFDWWTeg6V/MsmyyLR9X1idwKBWIgt/ZvinqQldJm3LecKEs1emkbquO6PCiLVQ==";
      };
    }
    {
      name = "_develar_schema_utils___schema_utils_2.6.5.tgz";
      path = fetchurl {
        name = "_develar_schema_utils___schema_utils_2.6.5.tgz";
        url  = "https://registry.yarnpkg.com/@develar/schema-utils/-/schema-utils-2.6.5.tgz";
        sha512 = "0cp4PsWQ/9avqTVMCtZ+GirikIA36ikvjtHweU4/j8yLtgObI0+JUPhYFScgwlteveGB1rt3Cm8UhN04XayDig==";
      };
    }
    {
      name = "_electron_get___get_2.0.2.tgz";
      path = fetchurl {
        name = "_electron_get___get_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/@electron/get/-/get-2.0.2.tgz";
        sha512 = "eFZVFoRXb3GFGd7Ak7W4+6jBl9wBtiZ4AaYOse97ej6mKj5tkyO0dUnUChs1IhJZtx1BENo4/p4WUTXpi6vT+g==";
      };
    }
    {
      name = "_electron_universal___universal_1.2.1.tgz";
      path = fetchurl {
        name = "_electron_universal___universal_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/@electron/universal/-/universal-1.2.1.tgz";
        sha512 = "7323HyMh7KBAl/nPDppdLsC87G6RwRU02dy5FPeGB1eS7rUePh55+WNWiDPLhFQqqVPHzh77M69uhmoT8XnwMQ==";
      };
    }
    {
      name = "_malept_cross_spawn_promise___cross_spawn_promise_1.1.1.tgz";
      path = fetchurl {
        name = "_malept_cross_spawn_promise___cross_spawn_promise_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz";
        sha512 = "RTBGWL5FWQcg9orDOCcp4LvItNzUPcyEU9bwaeJX0rJ1IQxzucC48Y0/sQLp/g6t99IQgAlGIaesJS+gTn7tVQ==";
      };
    }
    {
      name = "_malept_flatpak_bundler___flatpak_bundler_0.4.0.tgz";
      path = fetchurl {
        name = "_malept_flatpak_bundler___flatpak_bundler_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz";
        sha512 = "9QOtNffcOF/c1seMCDnjckb3R9WHcG34tky+FHpNKKCW0wc/scYLwMtO+ptyGUfMW0/b/n4qRiALlaFHc9Oj7Q==";
      };
    }
    {
      name = "_sindresorhus_is___is_4.6.0.tgz";
      path = fetchurl {
        name = "_sindresorhus_is___is_4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/@sindresorhus/is/-/is-4.6.0.tgz";
        sha512 = "t09vSN3MdfsyCHoFcTRCH/iUtG7OJ0CsjzB8cjAmKc/va/kIgeDI/TxsigdncE/4be734m0cvIYwNaV4i2XqAw==";
      };
    }
    {
      name = "_szmarczak_http_timer___http_timer_4.0.6.tgz";
      path = fetchurl {
        name = "_szmarczak_http_timer___http_timer_4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-4.0.6.tgz";
        sha512 = "4BAffykYOgO+5nzBWYwE3W90sBgLJoUPRWWcL8wlyiM8IB8ipJz3UMJ9KXQd1RKQXpKp8Tutn80HZtWsu2u76w==";
      };
    }
    {
      name = "_tootallnate_once___once_2.0.0.tgz";
      path = fetchurl {
        name = "_tootallnate_once___once_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@tootallnate/once/-/once-2.0.0.tgz";
        sha512 = "XCuKFP5PS55gnMVu3dty8KPatLqUoy/ZYzDzAGCQ8JNFCkLXzmI7vNHCR+XpbZaMWQK/vQubr7PkYq8g470J/A==";
      };
    }
    {
      name = "_types_cacheable_request___cacheable_request_6.0.3.tgz";
      path = fetchurl {
        name = "_types_cacheable_request___cacheable_request_6.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/cacheable-request/-/cacheable-request-6.0.3.tgz";
        sha512 = "IQ3EbTzGxIigb1I3qPZc1rWJnH0BmSKv5QYTalEwweFvyBDLSAe24zP0le/hyi7ecGfZVlIVAg4BZqb8WBwKqw==";
      };
    }
    {
      name = "_types_debug___debug_4.1.7.tgz";
      path = fetchurl {
        name = "_types_debug___debug_4.1.7.tgz";
        url  = "https://registry.yarnpkg.com/@types/debug/-/debug-4.1.7.tgz";
        sha512 = "9AonUzyTjXXhEOa0DnqpzZi6VHlqKMswga9EXjpXnnqxwLtdvPPtlO8evrI5D9S6asFRCQ6v+wpiUKbw+vKqyg==";
      };
    }
    {
      name = "_types_fs_extra___fs_extra_9.0.13.tgz";
      path = fetchurl {
        name = "_types_fs_extra___fs_extra_9.0.13.tgz";
        url  = "https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.13.tgz";
        sha512 = "nEnwB++1u5lVDM2UI4c1+5R+FYaKfaAzS4OococimjVm3nQw3TuzH5UNsocrcTBbhnerblyHj4A49qXbIiZdpA==";
      };
    }
    {
      name = "_types_glob___glob_7.2.0.tgz";
      path = fetchurl {
        name = "_types_glob___glob_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/glob/-/glob-7.2.0.tgz";
        sha512 = "ZUxbzKl0IfJILTS6t7ip5fQQM/J3TJYubDm3nMbgubNNYS62eXeUpoLUC8/7fJNiFYHTrGPQn7hspDUzIHX3UA==";
      };
    }
    {
      name = "_types_http_cache_semantics___http_cache_semantics_4.0.1.tgz";
      path = fetchurl {
        name = "_types_http_cache_semantics___http_cache_semantics_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/http-cache-semantics/-/http-cache-semantics-4.0.1.tgz";
        sha512 = "SZs7ekbP8CN0txVG2xVRH6EgKmEm31BOxA07vkFaETzZz1xh+cbt8BcI0slpymvwhx5dlFnQG2rTlPVQn+iRPQ==";
      };
    }
    {
      name = "_types_keyv___keyv_3.1.4.tgz";
      path = fetchurl {
        name = "_types_keyv___keyv_3.1.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/keyv/-/keyv-3.1.4.tgz";
        sha512 = "BQ5aZNSCpj7D6K2ksrRCTmKRLEpnPvWDiLPfoGyhZ++8YtiK9d/3DBKPJgry359X/P1PfruyYwvnvwFjuEiEIg==";
      };
    }
    {
      name = "_types_minimatch___minimatch_5.1.2.tgz";
      path = fetchurl {
        name = "_types_minimatch___minimatch_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz";
        sha512 = "K0VQKziLUWkVKiRVrx4a40iPaxTUefQmjtkQofBkYRcoaaL/8rhwDWww9qWbrgicNOgnpIsMxyNIUM4+n6dUIA==";
      };
    }
    {
      name = "_types_ms___ms_0.7.31.tgz";
      path = fetchurl {
        name = "_types_ms___ms_0.7.31.tgz";
        url  = "https://registry.yarnpkg.com/@types/ms/-/ms-0.7.31.tgz";
        sha512 = "iiUgKzV9AuaEkZqkOLDIvlQiL6ltuZd9tGcW3gwpnX8JbuiuhFlEGmmFXEXkN50Cvq7Os88IY2v0dkDqXYWVgA==";
      };
    }
    {
      name = "_types_node___node_18.15.0.tgz";
      path = fetchurl {
        name = "_types_node___node_18.15.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-18.15.0.tgz";
        sha512 = "z6nr0TTEOBGkzLGmbypWOGnpSpSIBorEhC4L+4HeQ2iezKCi4f77kyslRwvHeNitymGQ+oFyIWGP96l/DPSV9w==";
      };
    }
    {
      name = "_types_node___node_16.18.14.tgz";
      path = fetchurl {
        name = "_types_node___node_16.18.14.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-16.18.14.tgz";
        sha512 = "wvzClDGQXOCVNU4APPopC2KtMYukaF1MN/W3xAmslx22Z4/IF1/izDMekuyoUlwfnDHYCIZGaj7jMwnJKBTxKw==";
      };
    }
    {
      name = "_types_plist___plist_3.0.2.tgz";
      path = fetchurl {
        name = "_types_plist___plist_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/plist/-/plist-3.0.2.tgz";
        sha512 = "ULqvZNGMv0zRFvqn8/4LSPtnmN4MfhlPNtJCTpKuIIxGVGZ2rYWzFXrvEBoh9CVyqSE7D6YFRJ1hydLHI6kbWw==";
      };
    }
    {
      name = "_types_responselike___responselike_1.0.0.tgz";
      path = fetchurl {
        name = "_types_responselike___responselike_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/responselike/-/responselike-1.0.0.tgz";
        sha512 = "85Y2BjiufFzaMIlvJDvTTB8Fxl2xfLo4HgmHzVBz08w4wDePCTjYw66PdrolO0kzli3yam/YCgRufyo1DdQVTA==";
      };
    }
    {
      name = "_types_verror___verror_1.10.6.tgz";
      path = fetchurl {
        name = "_types_verror___verror_1.10.6.tgz";
        url  = "https://registry.yarnpkg.com/@types/verror/-/verror-1.10.6.tgz";
        sha512 = "NNm+gdePAX1VGvPcGZCDKQZKYSiAWigKhKaz5KF94hG6f2s8de9Ow5+7AbXoeKxL8gavZfk4UquSAygOF2duEQ==";
      };
    }
    {
      name = "_types_yargs_parser___yargs_parser_21.0.0.tgz";
      path = fetchurl {
        name = "_types_yargs_parser___yargs_parser_21.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-21.0.0.tgz";
        sha512 = "iO9ZQHkZxHn4mSakYV0vFHAVDyEOIJQrV2uZ06HxEPcx+mt8swXoZHIbaaJ2crJYFfErySgktuTZ3BeLz+XmFA==";
      };
    }
    {
      name = "_types_yargs___yargs_17.0.22.tgz";
      path = fetchurl {
        name = "_types_yargs___yargs_17.0.22.tgz";
        url  = "https://registry.yarnpkg.com/@types/yargs/-/yargs-17.0.22.tgz";
        sha512 = "pet5WJ9U8yPVRhkwuEIp5ktAeAqRZOq4UdAyWLWzxbtpyXnzbtLdKiXAjJzi/KLmPGS9wk86lUFWZFN6sISo4g==";
      };
    }
    {
      name = "_types_yauzl___yauzl_2.10.0.tgz";
      path = fetchurl {
        name = "_types_yauzl___yauzl_2.10.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/yauzl/-/yauzl-2.10.0.tgz";
        sha512 = "Cn6WYCm0tXv8p6k+A8PvbDG763EDpBoTzHdA+Q/MF6H3sapGjCm9NzoaJncJS9tUKSuCoDs9XHxYYsQDgxR6kw==";
      };
    }
    {
      name = "agent_base___agent_base_6.0.2.tgz";
      path = fetchurl {
        name = "agent_base___agent_base_6.0.2.tgz";
        url  = "https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz";
        sha512 = "RZNwNclF7+MS/8bDg70amg32dyeZGZxiDuQmZxKLAlQjr3jGyLx+4Kkk58UO7D2QdgFIQCovuSuZESne6RG6XQ==";
      };
    }
    {
      name = "ajv_keywords___ajv_keywords_3.5.2.tgz";
      path = fetchurl {
        name = "ajv_keywords___ajv_keywords_3.5.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz";
        sha512 = "5p6WTN0DdTGVQk6VjcEju19IgaHudalcfabD7yhDGeA6bcQnmL+CpveLJq/3hvfwd1aof6L386Ougkx6RfyMIQ==";
      };
    }
    {
      name = "ajv___ajv_6.12.6.tgz";
      path = fetchurl {
        name = "ajv___ajv_6.12.6.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz";
        sha512 = "j3fVLgvTo527anyYyJOGTYJbG+vnnQYvE0m5mmkc1TK+nxAppkCLMIL0aZ4dblVCNoGShhm+kzE4ZUykBoMg4g==";
      };
    }
    {
      name = "ansi_regex___ansi_regex_5.0.1.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz";
        sha512 = "quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==";
      };
    }
    {
      name = "ansi_styles___ansi_styles_4.3.0.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz";
        sha512 = "zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==";
      };
    }
    {
      name = "app_builder_bin___app_builder_bin_4.0.0.tgz";
      path = fetchurl {
        name = "app_builder_bin___app_builder_bin_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/app-builder-bin/-/app-builder-bin-4.0.0.tgz";
        sha512 = "xwdG0FJPQMe0M0UA4Tz0zEB8rBJTRA5a476ZawAqiBkMv16GRK5xpXThOjMaEOFnZ6zabejjG4J3da0SXG63KA==";
      };
    }
    {
      name = "app_builder_lib___app_builder_lib_23.6.0.tgz";
      path = fetchurl {
        name = "app_builder_lib___app_builder_lib_23.6.0.tgz";
        url  = "https://registry.yarnpkg.com/app-builder-lib/-/app-builder-lib-23.6.0.tgz";
        sha512 = "dQYDuqm/rmy8GSCE6Xl/3ShJg6Ab4bZJMT8KaTKGzT436gl1DN4REP3FCWfXoh75qGTJ+u+WsdnnpO9Jl8nyMA==";
      };
    }
    {
      name = "argparse___argparse_2.0.1.tgz";
      path = fetchurl {
        name = "argparse___argparse_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz";
        sha512 = "8+9WqebbFzpX9OR+Wa6O29asIogeRMzcGtAINdpMHHyAg10f05aSFVBbcEqGf/PXw1EjAZ+q2/bEBg3DvurK3Q==";
      };
    }
    {
      name = "asar___asar_3.2.0.tgz";
      path = fetchurl {
        name = "asar___asar_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/asar/-/asar-3.2.0.tgz";
        sha512 = "COdw2ZQvKdFGFxXwX3oYh2/sOsJWJegrdJCGxnN4MZ7IULgRBp9P6665aqj9z1v9VwP4oP1hRBojRDQ//IGgAg==";
      };
    }
    {
      name = "assert_plus___assert_plus_1.0.0.tgz";
      path = fetchurl {
        name = "assert_plus___assert_plus_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz";
        sha512 = "NfJ4UzBCcQGLDlQq7nHxH+tv3kyZ0hHQqF5BO6J7tNJeP5do1llPr8dZ8zHonfhAu0PHAdMkSo+8o0wxg9lZWw==";
      };
    }
    {
      name = "astral_regex___astral_regex_2.0.0.tgz";
      path = fetchurl {
        name = "astral_regex___astral_regex_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz";
        sha512 = "Z7tMw1ytTXt5jqMcOP+OQteU1VuNK9Y02uuJtKQ1Sv69jXQKKg5cibLwGJow8yzZP+eAc18EmLGPal0bp36rvQ==";
      };
    }
    {
      name = "async_exit_hook___async_exit_hook_2.0.1.tgz";
      path = fetchurl {
        name = "async_exit_hook___async_exit_hook_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/async-exit-hook/-/async-exit-hook-2.0.1.tgz";
        sha512 = "NW2cX8m1Q7KPA7a5M2ULQeZ2wR5qI5PAbw5L0UOMxdioVk9PMZ0h1TmyZEkPYrCvYjDlFICusOu1dlEKAAeXBw==";
      };
    }
    {
      name = "async___async_3.2.4.tgz";
      path = fetchurl {
        name = "async___async_3.2.4.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-3.2.4.tgz";
        sha512 = "iAB+JbDEGXhyIUavoDl9WP/Jj106Kz9DEn1DPgYw5ruDn0e3Wgi3sKFm55sASdGBNOQB8F59d9qQ7deqrHA8wQ==";
      };
    }
    {
      name = "asynckit___asynckit_0.4.0.tgz";
      path = fetchurl {
        name = "asynckit___asynckit_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz";
        sha512 = "Oei9OH4tRh0YqU3GxhX79dM/mwVgvbZJaSNaRk+bshkj0S5cfHcgYakreBjrHwatXKbz+IoIdYLxrKim2MjW0Q==";
      };
    }
    {
      name = "at_least_node___at_least_node_1.0.0.tgz";
      path = fetchurl {
        name = "at_least_node___at_least_node_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz";
        sha512 = "+q/t7Ekv1EDY2l6Gda6LLiX14rU9TV20Wa3ofeQmwPFZbOMo9DXrLbOjFaaclkXKWidIaopwAObQDqwWtGUjqg==";
      };
    }
    {
      name = "balanced_match___balanced_match_1.0.2.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz";
        sha512 = "3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==";
      };
    }
    {
      name = "base64_js___base64_js_1.5.1.tgz";
      path = fetchurl {
        name = "base64_js___base64_js_1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz";
        sha512 = "AKpaYlHn8t4SVbOHCy+b5+KKgvR4vrsD8vbvrbiQJps7fKDTkjkDry6ji0rUJjC0kzbNePLwzxq8iypo41qeWA==";
      };
    }
    {
      name = "bluebird_lst___bluebird_lst_1.0.9.tgz";
      path = fetchurl {
        name = "bluebird_lst___bluebird_lst_1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/bluebird-lst/-/bluebird-lst-1.0.9.tgz";
        sha512 = "7B1Rtx82hjnSD4PGLAjVWeYH3tHAcVUmChh85a3lltKQm6FresXh9ErQo6oAv6CqxttczC3/kEg8SY5NluPuUw==";
      };
    }
    {
      name = "bluebird___bluebird_3.7.2.tgz";
      path = fetchurl {
        name = "bluebird___bluebird_3.7.2.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz";
        sha512 = "XpNj6GDQzdfW+r2Wnn7xiSAd7TM3jzkxGXBGTtWKuSXv1xUV+azxAm8jdWZN06QTQk+2N2XB9jRDkvbmQmcRtg==";
      };
    }
    {
      name = "boolean___boolean_3.2.0.tgz";
      path = fetchurl {
        name = "boolean___boolean_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/boolean/-/boolean-3.2.0.tgz";
        sha512 = "d0II/GO9uf9lfUHH2BQsjxzRJZBdsjgsBiW4BvhWk/3qoKwQFjIDVN19PfX8F2D/r9PCMTtLWjYVCFrpeYUzsw==";
      };
    }
    {
      name = "brace_expansion___brace_expansion_1.1.11.tgz";
      path = fetchurl {
        name = "brace_expansion___brace_expansion_1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha512 = "iCuPHDFgrHX7H2vEI/5xpz07zSHB00TpugqhmYtVmMO6518mCuRMoOYFldEBl0g187ufozdaHgWKcYFb61qGiA==";
      };
    }
    {
      name = "brace_expansion___brace_expansion_2.0.1.tgz";
      path = fetchurl {
        name = "brace_expansion___brace_expansion_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz";
        sha512 = "XnAIvQ8eM+kC6aULx6wuQiwVsnzsi9d3WxzV3FpWTGA19F621kwdbsAcFKXgKUHZWsy+mY6iL1sHTxWEFCytDA==";
      };
    }
    {
      name = "buffer_alloc_unsafe___buffer_alloc_unsafe_1.1.0.tgz";
      path = fetchurl {
        name = "buffer_alloc_unsafe___buffer_alloc_unsafe_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz";
        sha512 = "TEM2iMIEQdJ2yjPJoSIsldnleVaAk1oW3DBVUykyOLsEsFmEc9kn+SFFPz+gl54KQNxlDnAwCXosOS9Okx2xAg==";
      };
    }
    {
      name = "buffer_alloc___buffer_alloc_1.2.0.tgz";
      path = fetchurl {
        name = "buffer_alloc___buffer_alloc_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-alloc/-/buffer-alloc-1.2.0.tgz";
        sha512 = "CFsHQgjtW1UChdXgbyJGtnm+O/uLQeZdtbDo8mfUgYXCHSM1wgrVxXm6bSyrUuErEb+4sYVGCzASBRot7zyrow==";
      };
    }
    {
      name = "buffer_crc32___buffer_crc32_0.2.13.tgz";
      path = fetchurl {
        name = "buffer_crc32___buffer_crc32_0.2.13.tgz";
        url  = "https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz";
        sha512 = "VO9Ht/+p3SN7SKWqcrgEzjGbRSJYTx+Q1pTQC0wrWqHx0vpJraQ6GtHx8tvcg1rlK1byhU5gccxgOgj7B0TDkQ==";
      };
    }
    {
      name = "buffer_equal___buffer_equal_1.0.0.tgz";
      path = fetchurl {
        name = "buffer_equal___buffer_equal_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-1.0.0.tgz";
        sha512 = "tcBWO2Dl4e7Asr9hTGcpVrCe+F7DubpmqWCTbj4FHLmjqO2hIaC383acQubWtRJhdceqs5uBHs6Es+Sk//RKiQ==";
      };
    }
    {
      name = "buffer_fill___buffer_fill_1.0.0.tgz";
      path = fetchurl {
        name = "buffer_fill___buffer_fill_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-fill/-/buffer-fill-1.0.0.tgz";
        sha512 = "T7zexNBwiiaCOGDg9xNX9PBmjrubblRkENuptryuI64URkXDFum9il/JGL8Lm8wYfAXpredVXXZz7eMHilimiQ==";
      };
    }
    {
      name = "buffer_from___buffer_from_1.1.2.tgz";
      path = fetchurl {
        name = "buffer_from___buffer_from_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz";
        sha512 = "E+XQCRwSbaaiChtv6k6Dwgc+bx+Bs6vuKJHHl5kox/BaKbhiXzqQOwK4cO22yElGp2OCmjwVhT3HmxgyPGnJfQ==";
      };
    }
    {
      name = "buffer___buffer_5.7.1.tgz";
      path = fetchurl {
        name = "buffer___buffer_5.7.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer/-/buffer-5.7.1.tgz";
        sha512 = "EHcyIPBQ4BSGlvjB16k5KgAJ27CIsHY/2JBmCRReo48y9rQ3MaUzWX3KVlBa4U7MyX02HdVj0K7C3WaB3ju7FQ==";
      };
    }
    {
      name = "builder_util_runtime___builder_util_runtime_9.1.1.tgz";
      path = fetchurl {
        name = "builder_util_runtime___builder_util_runtime_9.1.1.tgz";
        url  = "https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-9.1.1.tgz";
        sha512 = "azRhYLEoDvRDR8Dhis4JatELC/jUvYjm4cVSj7n9dauGTOM2eeNn9KS0z6YA6oDsjI1xphjNbY6PZZeHPzzqaw==";
      };
    }
    {
      name = "builder_util___builder_util_23.6.0.tgz";
      path = fetchurl {
        name = "builder_util___builder_util_23.6.0.tgz";
        url  = "https://registry.yarnpkg.com/builder-util/-/builder-util-23.6.0.tgz";
        sha512 = "QiQHweYsh8o+U/KNCZFSvISRnvRctb8m/2rB2I1JdByzvNKxPeFLlHFRPQRXab6aYeXc18j9LpsDLJ3sGQmWTQ==";
      };
    }
    {
      name = "cacheable_lookup___cacheable_lookup_5.0.4.tgz";
      path = fetchurl {
        name = "cacheable_lookup___cacheable_lookup_5.0.4.tgz";
        url  = "https://registry.yarnpkg.com/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz";
        sha512 = "2/kNscPhpcxrOigMZzbiWF7dz8ilhb/nIHU3EyZiXWXpeq/au8qJ8VhdftMkty3n7Gj6HIGalQG8oiBNB3AJgA==";
      };
    }
    {
      name = "cacheable_request___cacheable_request_7.0.2.tgz";
      path = fetchurl {
        name = "cacheable_request___cacheable_request_7.0.2.tgz";
        url  = "https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-7.0.2.tgz";
        sha512 = "pouW8/FmiPQbuGpkXQ9BAPv/Mo5xDGANgSNXzTzJ8DrKGuXOssM4wIQRjfanNRh3Yu5cfYPvcorqbhg2KIJtew==";
      };
    }
    {
      name = "chalk___chalk_4.1.2.tgz";
      path = fetchurl {
        name = "chalk___chalk_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz";
        sha512 = "oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA==";
      };
    }
    {
      name = "chownr___chownr_2.0.0.tgz";
      path = fetchurl {
        name = "chownr___chownr_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz";
        sha512 = "bIomtDF5KGpdogkLd9VspvFzk9KfpyyGlS8YFVZl7TGPBHL5snIOnxeshwVgPteQ9b4Eydl+pVbIyE1DcvCWgQ==";
      };
    }
    {
      name = "chromium_pickle_js___chromium_pickle_js_0.2.0.tgz";
      path = fetchurl {
        name = "chromium_pickle_js___chromium_pickle_js_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz";
        sha512 = "1R5Fho+jBq0DDydt+/vHWj5KJNJCKdARKOCwZUen84I5BreWoLqRLANH1U87eJy1tiASPtMnGqJJq0ZsLoRPOw==";
      };
    }
    {
      name = "ci_info___ci_info_3.8.0.tgz";
      path = fetchurl {
        name = "ci_info___ci_info_3.8.0.tgz";
        url  = "https://registry.yarnpkg.com/ci-info/-/ci-info-3.8.0.tgz";
        sha512 = "eXTggHWSooYhq49F2opQhuHWgzucfF2YgODK4e1566GQs5BIfP30B0oenwBJHfWxAs2fyPB1s7Mg949zLf61Yw==";
      };
    }
    {
      name = "cli_truncate___cli_truncate_2.1.0.tgz";
      path = fetchurl {
        name = "cli_truncate___cli_truncate_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-2.1.0.tgz";
        sha512 = "n8fOixwDD6b/ObinzTrp1ZKFzbgvKZvuz/TvejnLn1aQfC6r52XEx85FmuC+3HI+JM7coBRXUvNqEU2PHVrHpg==";
      };
    }
    {
      name = "cliui___cliui_8.0.1.tgz";
      path = fetchurl {
        name = "cliui___cliui_8.0.1.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-8.0.1.tgz";
        sha512 = "BSeNnyus75C4//NQ9gQt1/csTXyo/8Sb+afLAkzAptFuMsod9HFokGNudZpi/oQV73hnVK+sR+5PVRMd+Dr7YQ==";
      };
    }
    {
      name = "clone_response___clone_response_1.0.3.tgz";
      path = fetchurl {
        name = "clone_response___clone_response_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.3.tgz";
        sha512 = "ROoL94jJH2dUVML2Y/5PEDNaSHgeOdSDicUyS7izcF63G6sTc/FTjLub4b8Il9S8S0beOfYt0TaA5qvFK+w0wA==";
      };
    }
    {
      name = "color_convert___color_convert_2.0.1.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz";
        sha512 = "RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==";
      };
    }
    {
      name = "color_name___color_name_1.1.4.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz";
        sha512 = "dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==";
      };
    }
    {
      name = "colors___colors_1.0.3.tgz";
      path = fetchurl {
        name = "colors___colors_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/colors/-/colors-1.0.3.tgz";
        sha512 = "pFGrxThWcWQ2MsAz6RtgeWe4NK2kUE1WfsrvvlctdII745EW9I0yflqhe7++M5LEc7bV2c/9/5zc8sFcpL0Drw==";
      };
    }
    {
      name = "combined_stream___combined_stream_1.0.8.tgz";
      path = fetchurl {
        name = "combined_stream___combined_stream_1.0.8.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz";
        sha512 = "FQN4MRfuJeHf7cBbBMJFXhKSDq+2kAArBlmRBvcvFE5BB1HZKXtSFASDhdlz9zOYwxh8lDdnvmMOe/+5cdoEdg==";
      };
    }
    {
      name = "commander___commander_2.9.0.tgz";
      path = fetchurl {
        name = "commander___commander_2.9.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.9.0.tgz";
        sha512 = "bmkUukX8wAOjHdN26xj5c4ctEV22TQ7dQYhSmuckKhToXrkUn0iIaolHdIxYYqD55nhpSPA9zPQ1yP57GdXP2A==";
      };
    }
    {
      name = "commander___commander_5.1.0.tgz";
      path = fetchurl {
        name = "commander___commander_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-5.1.0.tgz";
        sha512 = "P0CysNDQ7rtVw4QIQtm+MRxV66vKFSvlsQvGYXZWR3qFU0jlMKHZZZgw8e+8DSah4UDKMqnknRDQz+xuQXQ/Zg==";
      };
    }
    {
      name = "compare_version___compare_version_0.1.2.tgz";
      path = fetchurl {
        name = "compare_version___compare_version_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/compare-version/-/compare-version-0.1.2.tgz";
        sha512 = "pJDh5/4wrEnXX/VWRZvruAGHkzKdr46z11OlTPN+VrATlWWhSKewNCJ1futCO5C7eJB3nPMFZA1LeYtcFboZ2A==";
      };
    }
    {
      name = "concat_map___concat_map_0.0.1.tgz";
      path = fetchurl {
        name = "concat_map___concat_map_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
        sha512 = "/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==";
      };
    }
    {
      name = "core_util_is___core_util_is_1.0.2.tgz";
      path = fetchurl {
        name = "core_util_is___core_util_is_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz";
        sha512 = "3lqz5YjWTYnW6dlDa5TLaTCcShfar1e40rmcJVwCBJC6mWlFuj0eCHIElmG1g5kyuJ/GD+8Wn4FFCcz4gJPfaQ==";
      };
    }
    {
      name = "crc___crc_3.8.0.tgz";
      path = fetchurl {
        name = "crc___crc_3.8.0.tgz";
        url  = "https://registry.yarnpkg.com/crc/-/crc-3.8.0.tgz";
        sha512 = "iX3mfgcTMIq3ZKLIsVFAbv7+Mc10kxabAGQb8HvjA1o3T1PIYprbakQ65d3I+2HGHt6nSKkM9PYjgoJO2KcFBQ==";
      };
    }
    {
      name = "cross_spawn___cross_spawn_7.0.3.tgz";
      path = fetchurl {
        name = "cross_spawn___cross_spawn_7.0.3.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz";
        sha512 = "iRDPJKUPVEND7dHPO8rkbOnPpyDygcDFtWjpeWNCgy8WP2rXcxXL8TskReQl6OrB2G7+UJrags1q15Fudc7G6w==";
      };
    }
    {
      name = "debug___debug_4.3.4.tgz";
      path = fetchurl {
        name = "debug___debug_4.3.4.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz";
        sha512 = "PRWFHuSU3eDtQJPvnNY7Jcket1j0t5OuOsFzPPzsekD52Zl8qUfFIPEiswXqIvHWGVHOgX+7G/vCNNhehwxfkQ==";
      };
    }
    {
      name = "debug___debug_2.6.9.tgz";
      path = fetchurl {
        name = "debug___debug_2.6.9.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha512 = "bC7ElrdJaJnPbAP+1EotYvqZsb3ecl5wi6Bfi6BJTUcNowp6cvspg0jXznRTKDjm/E7AdgFBVeAPVMNcKGsHMA==";
      };
    }
    {
      name = "decompress_response___decompress_response_6.0.0.tgz";
      path = fetchurl {
        name = "decompress_response___decompress_response_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/decompress-response/-/decompress-response-6.0.0.tgz";
        sha512 = "aW35yZM6Bb/4oJlZncMH2LCoZtJXTRxES17vE3hoRiowU2kWHaJKFkSBDnDR+cm9J+9QhXmREyIfv0pji9ejCQ==";
      };
    }
    {
      name = "defer_to_connect___defer_to_connect_2.0.1.tgz";
      path = fetchurl {
        name = "defer_to_connect___defer_to_connect_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-2.0.1.tgz";
        sha512 = "4tvttepXG1VaYGrRibk5EwJd1t4udunSOVMdLSAL6mId1ix438oPwPZMALY41FCijukO1L0twNcGsdzS7dHgDg==";
      };
    }
    {
      name = "define_properties___define_properties_1.2.0.tgz";
      path = fetchurl {
        name = "define_properties___define_properties_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz";
        sha512 = "xvqAVKGfT1+UAvPwKTVw/njhdQ8ZhXK4lI0bCIuCMrp2up9nPnaDftrLtmpTazqd1o+UY4zgzU+avtMbDP+ldA==";
      };
    }
    {
      name = "delayed_stream___delayed_stream_1.0.0.tgz";
      path = fetchurl {
        name = "delayed_stream___delayed_stream_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha512 = "ZySD7Nf91aLB0RxL4KGrKHBXl7Eds1DAmEdcoVawXnLD7SDhpNgtuII2aAkg7a7QS41jxPSZ17p4VdGnMHk3MQ==";
      };
    }
    {
      name = "detect_node___detect_node_2.1.0.tgz";
      path = fetchurl {
        name = "detect_node___detect_node_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz";
        sha512 = "T0NIuQpnTvFDATNuHN5roPwSBG83rFsuO+MXXH9/3N1eFbn4wcPjttvjMLEPWJ0RGUYgQE7cGgS3tNxbqCGM7g==";
      };
    }
    {
      name = "dictionary_en_au___dictionary_en_au_2.4.0.tgz";
      path = fetchurl {
        name = "dictionary_en_au___dictionary_en_au_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/dictionary-en-au/-/dictionary-en-au-2.4.0.tgz";
        sha512 = "SEETr3rqt26/Umc43gemwaH/ez4gPv7I4alifu/QLi8uxiCm6a7cn3wKb22HNB5l6j/R7/Sfkq9NTKk/QRVUHw==";
      };
    }
    {
      name = "dictionary_en___dictionary_en_3.2.0.tgz";
      path = fetchurl {
        name = "dictionary_en___dictionary_en_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dictionary-en/-/dictionary-en-3.2.0.tgz";
        sha512 = "oujbJhuplUTlDntmOoultEcNyk8ge7cFI6yXNn7eJvpbBJOhGNhWtK0XjOJsiwl4EfIeyvDKwGB95vJXv1d+lQ==";
      };
    }
    {
      name = "dir_compare___dir_compare_2.4.0.tgz";
      path = fetchurl {
        name = "dir_compare___dir_compare_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/dir-compare/-/dir-compare-2.4.0.tgz";
        sha512 = "l9hmu8x/rjVC9Z2zmGzkhOEowZvW7pmYws5CWHutg8u1JgvsKWMx7Q/UODeu4djLZ4FgW5besw5yvMQnBHzuCA==";
      };
    }
    {
      name = "dmg_builder___dmg_builder_23.6.0.tgz";
      path = fetchurl {
        name = "dmg_builder___dmg_builder_23.6.0.tgz";
        url  = "https://registry.yarnpkg.com/dmg-builder/-/dmg-builder-23.6.0.tgz";
        sha512 = "jFZvY1JohyHarIAlTbfQOk+HnceGjjAdFjVn3n8xlDWKsYNqbO4muca6qXEZTfGXeQMG7TYim6CeS5XKSfSsGA==";
      };
    }
    {
      name = "dmg_license___dmg_license_1.0.11.tgz";
      path = fetchurl {
        name = "dmg_license___dmg_license_1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/dmg-license/-/dmg-license-1.0.11.tgz";
        sha512 = "ZdzmqwKmECOWJpqefloC5OJy1+WZBBse5+MR88z9g9Zn4VY+WYUkAyojmhzJckH5YbbZGcYIuGAkY5/Ys5OM2Q==";
      };
    }
    {
      name = "dotenv_expand___dotenv_expand_5.1.0.tgz";
      path = fetchurl {
        name = "dotenv_expand___dotenv_expand_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/dotenv-expand/-/dotenv-expand-5.1.0.tgz";
        sha512 = "YXQl1DSa4/PQyRfgrv6aoNjhasp/p4qs9FjJ4q4cQk+8m4r6k4ZSiEyytKG8f8W9gi8WsQtIObNmKd+tMzNTmA==";
      };
    }
    {
      name = "dotenv___dotenv_9.0.2.tgz";
      path = fetchurl {
        name = "dotenv___dotenv_9.0.2.tgz";
        url  = "https://registry.yarnpkg.com/dotenv/-/dotenv-9.0.2.tgz";
        sha512 = "I9OvvrHp4pIARv4+x9iuewrWycX6CcZtoAu1XrzPxc5UygMJXJZYmBsynku8IkrJwgypE5DGNjDPmPRhDCptUg==";
      };
    }
    {
      name = "ejs___ejs_3.1.8.tgz";
      path = fetchurl {
        name = "ejs___ejs_3.1.8.tgz";
        url  = "https://registry.yarnpkg.com/ejs/-/ejs-3.1.8.tgz";
        sha512 = "/sXZeMlhS0ArkfX2Aw780gJzXSMPnKjtspYZv+f3NiKLlubezAHDU5+9xz6gd3/NhG3txQCo6xlglmTS+oTGEQ==";
      };
    }
    {
      name = "electron_builder___electron_builder_23.6.0.tgz";
      path = fetchurl {
        name = "electron_builder___electron_builder_23.6.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-builder/-/electron-builder-23.6.0.tgz";
        sha512 = "y8D4zO+HXGCNxFBV/JlyhFnoQ0Y0K7/sFH+XwIbj47pqaW8S6PGYQbjoObolKBR1ddQFPt4rwp4CnwMJrW3HAw==";
      };
    }
    {
      name = "electron_context_menu___electron_context_menu_3.6.1.tgz";
      path = fetchurl {
        name = "electron_context_menu___electron_context_menu_3.6.1.tgz";
        url  = "https://registry.yarnpkg.com/electron-context-menu/-/electron-context-menu-3.6.1.tgz";
        sha512 = "lcpO6tzzKUROeirhzBjdBWNqayEThmdW+2I2s6H6QMrwqTVyT3EK47jW3Nxm60KTxl5/bWfEoIruoUNn57/QkQ==";
      };
    }
    {
      name = "electron_dl___electron_dl_3.5.0.tgz";
      path = fetchurl {
        name = "electron_dl___electron_dl_3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-dl/-/electron-dl-3.5.0.tgz";
        sha512 = "Oj+VSuScVx8hEKM2HEvTQswTX6G3MLh7UoAz/oZuvKyNDfudNi1zY6PK/UnFoK1nCl9DF6k+3PFwElKbtZlDig==";
      };
    }
    {
      name = "electron_is_dev___electron_is_dev_2.0.0.tgz";
      path = fetchurl {
        name = "electron_is_dev___electron_is_dev_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-is-dev/-/electron-is-dev-2.0.0.tgz";
        sha512 = "3X99K852Yoqu9AcW50qz3ibYBWY79/pBhlMCab8ToEWS48R0T9tyxRiQhwylE7zQdXrMnx2JKqUJyMPmt5FBqA==";
      };
    }
    {
      name = "electron_osx_sign___electron_osx_sign_0.6.0.tgz";
      path = fetchurl {
        name = "electron_osx_sign___electron_osx_sign_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-osx-sign/-/electron-osx-sign-0.6.0.tgz";
        sha512 = "+hiIEb2Xxk6eDKJ2FFlpofCnemCbjbT5jz+BKGpVBrRNT3kWTGs4DfNX6IzGwgi33hUcXF+kFs9JW+r6Wc1LRg==";
      };
    }
    {
      name = "electron_publish___electron_publish_23.6.0.tgz";
      path = fetchurl {
        name = "electron_publish___electron_publish_23.6.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-publish/-/electron-publish-23.6.0.tgz";
        sha512 = "jPj3y+eIZQJF/+t5SLvsI5eS4mazCbNYqatv5JihbqOstIM13k0d1Z3vAWntvtt13Itl61SO6seicWdioOU5dg==";
      };
    }
    {
      name = "electron_window_state___electron_window_state_5.0.3.tgz";
      path = fetchurl {
        name = "electron_window_state___electron_window_state_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/electron-window-state/-/electron-window-state-5.0.3.tgz";
        sha512 = "1mNTwCfkolXl3kMf50yW3vE2lZj0y92P/HYWFBrb+v2S/pCka5mdwN3cagKm458A7NjndSwijynXgcLWRodsVg==";
      };
    }
    {
      name = "electron___electron_23.1.3.tgz";
      path = fetchurl {
        name = "electron___electron_23.1.3.tgz";
        url  = "https://registry.yarnpkg.com/electron/-/electron-23.1.3.tgz";
        sha512 = "MNjuUS2K6/OxlJ0zTC77djo1R3xM038v1kUunvNFgDMZHYKpSOzOMNsPiwM2BGp+uZbkUb0nTnYafxXrM8H16w==";
      };
    }
    {
      name = "emoji_regex___emoji_regex_8.0.0.tgz";
      path = fetchurl {
        name = "emoji_regex___emoji_regex_8.0.0.tgz";
        url  = "https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz";
        sha512 = "MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==";
      };
    }
    {
      name = "end_of_stream___end_of_stream_1.4.4.tgz";
      path = fetchurl {
        name = "end_of_stream___end_of_stream_1.4.4.tgz";
        url  = "https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz";
        sha512 = "+uw1inIHVPQoaVuHzRyXd21icM+cnt4CzD5rW+NC1wjOUSTOs+Te7FOv7AhN7vS9x/oIyhLP5PR1H+phQAHu5Q==";
      };
    }
    {
      name = "env_paths___env_paths_2.2.1.tgz";
      path = fetchurl {
        name = "env_paths___env_paths_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz";
        sha512 = "+h1lkLKhZMTYjog1VEpJNG7NZJWcuc2DDk/qsqSTRRCOXiLjeQ1d1/udrUGhqMxUgAlwKNZ0cf2uqan5GLuS2A==";
      };
    }
    {
      name = "es6_error___es6_error_4.1.1.tgz";
      path = fetchurl {
        name = "es6_error___es6_error_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz";
        sha512 = "Um/+FxMr9CISWh0bi5Zv0iOD+4cFh5qLeks1qhAopKVAJw3drgKbKySikp7wGhDL0HPeaja0P5ULZrxLkniUVg==";
      };
    }
    {
      name = "escalade___escalade_3.1.1.tgz";
      path = fetchurl {
        name = "escalade___escalade_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz";
        sha512 = "k0er2gUkLf8O0zKJiAhmkTnJlTvINGv7ygDNPbeIsX/TJjGJZHuh9B2UxbsaEkmlEo9MfhrSzmhIlhRlI2GXnw==";
      };
    }
    {
      name = "escape_goat___escape_goat_2.1.1.tgz";
      path = fetchurl {
        name = "escape_goat___escape_goat_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/escape-goat/-/escape-goat-2.1.1.tgz";
        sha512 = "8/uIhbG12Csjy2JEW7D9pHbreaVaS/OpN3ycnyvElTdwM5n6GY6W6e2IPemfvGZeUMqZ9A/3GqIZMgKnBhAw/Q==";
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_4.0.0.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz";
        sha512 = "TtpcNJ3XAzx3Gq8sWRzJaVajRs0uVxA2YAkdb1jm2YkPz4G6egUFAyA3n5vtEIZefPk5Wa4UXbKuS5fKkJWdgA==";
      };
    }
    {
      name = "ext_list___ext_list_2.2.2.tgz";
      path = fetchurl {
        name = "ext_list___ext_list_2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/ext-list/-/ext-list-2.2.2.tgz";
        sha512 = "u+SQgsubraE6zItfVA0tBuCBhfU9ogSRnsvygI7wht9TS510oLkBRXBsqopeUG/GBOIQyKZO9wjTqIu/sf5zFA==";
      };
    }
    {
      name = "ext_name___ext_name_5.0.0.tgz";
      path = fetchurl {
        name = "ext_name___ext_name_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ext-name/-/ext-name-5.0.0.tgz";
        sha512 = "yblEwXAbGv1VQDmow7s38W77hzAgJAO50ztBLMcUyUBfxv1HC+LGwtiEN+Co6LtlqT/5uwVOxsD4TNIilWhwdQ==";
      };
    }
    {
      name = "extract_zip___extract_zip_2.0.1.tgz";
      path = fetchurl {
        name = "extract_zip___extract_zip_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/extract-zip/-/extract-zip-2.0.1.tgz";
        sha512 = "GDhU9ntwuKyGXdZBUgTIe+vXnWj0fppUEtMDL0+idd5Sta8TGpHssn/eusA9mrPr9qNDym6SxAYZjNvCn/9RBg==";
      };
    }
    {
      name = "extsprintf___extsprintf_1.4.1.tgz";
      path = fetchurl {
        name = "extsprintf___extsprintf_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.1.tgz";
        sha512 = "Wrk35e8ydCKDj/ArClo1VrPVmN8zph5V4AtHwIuHhvMXsKf73UT3BOD+azBIW+3wOJ4FhEH7zyaJCFvChjYvMA==";
      };
    }
    {
      name = "fast_deep_equal___fast_deep_equal_3.1.3.tgz";
      path = fetchurl {
        name = "fast_deep_equal___fast_deep_equal_3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz";
        sha512 = "f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==";
      };
    }
    {
      name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
      path = fetchurl {
        name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz";
        sha512 = "lhd/wF+Lk98HZoTCtlVraHtfh5XYijIjalXck7saUtuanSDyLMxnHhSXEDJqHxD7msR8D0uCmqlkwjCV8xvwHw==";
      };
    }
    {
      name = "fd_slicer___fd_slicer_1.1.0.tgz";
      path = fetchurl {
        name = "fd_slicer___fd_slicer_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz";
        sha512 = "cE1qsB/VwyQozZ+q1dGxR8LBYNZeofhEdUNGSMbQD3Gw2lAzX9Zb3uIU6Ebc/Fmyjo9AWWfnn0AUCHqtevs/8g==";
      };
    }
    {
      name = "filelist___filelist_1.0.4.tgz";
      path = fetchurl {
        name = "filelist___filelist_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/filelist/-/filelist-1.0.4.tgz";
        sha512 = "w1cEuf3S+DrLCQL7ET6kz+gmlJdbq9J7yXCSjK/OZCPA+qEN1WyF4ZAf0YYJa4/shHJra2t/d/r8SV4Ji+x+8Q==";
      };
    }
    {
      name = "form_data___form_data_4.0.0.tgz";
      path = fetchurl {
        name = "form_data___form_data_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-4.0.0.tgz";
        sha512 = "ETEklSGi5t0QMZuiXoA/Q6vcnxcLQP5vdugSpuAyi6SVGi2clPPp+xgEhuMaHC+zGgn31Kd235W35f7Hykkaww==";
      };
    }
    {
      name = "fs_extra___fs_extra_10.1.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_10.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.1.0.tgz";
        sha512 = "oRXApq54ETRj4eMiFzGnHWGy+zo5raudjuxN0b8H7s/RU2oW0Wvsx9O0ACRN/kRq9E8Vu/ReskGB5o3ji+FzHQ==";
      };
    }
    {
      name = "fs_extra___fs_extra_8.1.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_8.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz";
        sha512 = "yhlQgA6mnOJUKOsRUFsgJdQCvkKhcz8tlZG5HBQfReYZy46OwLcY+Zia0mtdHsOo9y/hP+CxMN0TU9QxoOtG4g==";
      };
    }
    {
      name = "fs_extra___fs_extra_9.1.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_9.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.1.0.tgz";
        sha512 = "hcg3ZmepS30/7BSFqRvoo3DOMQu7IjqxO5nCDt+zM9XWjb33Wg7ziNT+Qvqbuc3+gWpzO02JubVyk2G4Zvo1OQ==";
      };
    }
    {
      name = "fs_minipass___fs_minipass_2.1.0.tgz";
      path = fetchurl {
        name = "fs_minipass___fs_minipass_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz";
        sha512 = "V/JgOLFCS+R6Vcq0slCuaeWEdNC3ouDlJMNIsacH2VtALiu9mV4LPrHc5cDl8k5aw6J8jwgWWpiTo5RYhmIzvg==";
      };
    }
    {
      name = "fs.realpath___fs.realpath_1.0.0.tgz";
      path = fetchurl {
        name = "fs.realpath___fs.realpath_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha512 = "OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==";
      };
    }
    {
      name = "function_bind___function_bind_1.1.1.tgz";
      path = fetchurl {
        name = "function_bind___function_bind_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
        sha512 = "yIovAzMX49sF8Yl58fSCWJ5svSLuaibPxXQJFLmBObTuCr0Mf1KiPopGM9NiFjiYBCbfaa2Fh6breQ6ANVTI0A==";
      };
    }
    {
      name = "get_caller_file___get_caller_file_2.0.5.tgz";
      path = fetchurl {
        name = "get_caller_file___get_caller_file_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz";
        sha512 = "DyFP3BM/3YHTQOCUL/w0OZHR0lpKeGrxotcHWcqNEdnltqFwXVfhEBQ94eIo34AfQpo0rGki4cyIiftY06h2Fg==";
      };
    }
    {
      name = "get_intrinsic___get_intrinsic_1.2.0.tgz";
      path = fetchurl {
        name = "get_intrinsic___get_intrinsic_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz";
        sha512 = "L049y6nFOuom5wGyRc3/gdTLO94dySVKRACj1RmJZBQXlbTMhtNIgkWkUHq+jYmZvKf14EW1EoJnnjbmoHij0Q==";
      };
    }
    {
      name = "get_stream___get_stream_5.2.0.tgz";
      path = fetchurl {
        name = "get_stream___get_stream_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz";
        sha512 = "nBF+F1rAZVCu/p7rjzgA+Yb4lfYXrpl7a6VmJrU8wF9I1CKvP/QwPNZHnOlwbTkY6dvtFIzFMSyQXbLoTQPRpA==";
      };
    }
    {
      name = "glob___glob_7.2.3.tgz";
      path = fetchurl {
        name = "glob___glob_7.2.3.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz";
        sha512 = "nFR0zLpU2YCaRxwoCJvL6UvCH2JFyFVIvwTLsIf21AuHlMskA1hhTdk+LlYJtOlYt9v6dvszD2BGRqBL+iQK9Q==";
      };
    }
    {
      name = "global_agent___global_agent_3.0.0.tgz";
      path = fetchurl {
        name = "global_agent___global_agent_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/global-agent/-/global-agent-3.0.0.tgz";
        sha512 = "PT6XReJ+D07JvGoxQMkT6qji/jVNfX/h364XHZOWeRzy64sSFr+xJ5OX7LI3b4MPQzdL4H8Y8M0xzPpsVMwA8Q==";
      };
    }
    {
      name = "globalthis___globalthis_1.0.3.tgz";
      path = fetchurl {
        name = "globalthis___globalthis_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz";
        sha512 = "sFdI5LyBiNTHjRd7cGPWapiHWMOXKyuBNX/cWJ3NfzrZQVa8GI/8cofCl74AOVqq9W5kNmguTIzJ/1s2gyI9wA==";
      };
    }
    {
      name = "got___got_11.8.6.tgz";
      path = fetchurl {
        name = "got___got_11.8.6.tgz";
        url  = "https://registry.yarnpkg.com/got/-/got-11.8.6.tgz";
        sha512 = "6tfZ91bOr7bOXnK7PRDCGBLa1H4U080YHNaAQ2KsMGlLEzRbk44nsZF2E1IeRc3vtJHPVbKCYgdFbaGO2ljd8g==";
      };
    }
    {
      name = "graceful_fs___graceful_fs_4.2.10.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.10.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.10.tgz";
        sha512 = "9ByhssR2fPVsNZj478qUUbKfmL0+t5BDVyjShtyZZLiK7ZDAArFFfopyOTj0M05wE2tJPisA4iTnnXl2YoPvOA==";
      };
    }
    {
      name = "graceful_readlink___graceful_readlink_1.0.1.tgz";
      path = fetchurl {
        name = "graceful_readlink___graceful_readlink_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha512 = "8tLu60LgxF6XpdbK8OW3FA+IfTNBn1ZHGHKF4KQbEeSkajYw5PlYJcKluntgegDPTg8UkHjpet1T82vk6TQ68w==";
      };
    }
    {
      name = "has_flag___has_flag_4.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz";
        sha512 = "EykJT/Q1KjTWctppgIAgfSO0tKVuZUjhgMr17kqTumMl6Afv3EISleU7qZUzoXDFTAHTDC4NOoG/ZxU3EvlMPQ==";
      };
    }
    {
      name = "has_property_descriptors___has_property_descriptors_1.0.0.tgz";
      path = fetchurl {
        name = "has_property_descriptors___has_property_descriptors_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz";
        sha512 = "62DVLZGoiEBDHQyqG4w9xCuZ7eJEwNmJRWw2VY84Oedb7WFcA27fiEVe8oUQx9hAUJ4ekurquucTGwsyO1XGdQ==";
      };
    }
    {
      name = "has_symbols___has_symbols_1.0.3.tgz";
      path = fetchurl {
        name = "has_symbols___has_symbols_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz";
        sha512 = "l3LCuF6MgDNwTDKkdYGEihYjt5pRPbEg46rtlmnSPlUbgmB8LOIrKJbYYFBSbnPaJexMKtiPO8hmeRjRz2Td+A==";
      };
    }
    {
      name = "has___has_1.0.3.tgz";
      path = fetchurl {
        name = "has___has_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has/-/has-1.0.3.tgz";
        sha512 = "f2dvO0VU6Oej7RkWJGrehjbzMAjFp5/VKPp5tTpWIV4JHHZK1/BxbFRtf/siA2SWTe09caDmVtYYzWEIbBS4zw==";
      };
    }
    {
      name = "hosted_git_info___hosted_git_info_4.1.0.tgz";
      path = fetchurl {
        name = "hosted_git_info___hosted_git_info_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-4.1.0.tgz";
        sha512 = "kyCuEOWjJqZuDbRHzL8V93NzQhwIB71oFWSyzVo+KPZI+pnQPPxucdkrOZvkLRnrf5URsQM+IJ09Dw29cRALIA==";
      };
    }
    {
      name = "http_cache_semantics___http_cache_semantics_4.1.1.tgz";
      path = fetchurl {
        name = "http_cache_semantics___http_cache_semantics_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz";
        sha512 = "er295DKPVsV82j5kw1Gjt+ADA/XYHsajl82cGNQG2eyoPkvgUhX+nDIyelzhIWbbsXP39EHcI6l5tYs2FYqYXQ==";
      };
    }
    {
      name = "http_proxy_agent___http_proxy_agent_5.0.0.tgz";
      path = fetchurl {
        name = "http_proxy_agent___http_proxy_agent_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz";
        sha512 = "n2hY8YdoRE1i7r6M0w9DIw5GgZN0G25P8zLCRQ8rjXtTU3vsNFBI/vWK/UIeE6g5MUUz6avwAPXmL6Fy9D/90w==";
      };
    }
    {
      name = "http2_wrapper___http2_wrapper_1.0.3.tgz";
      path = fetchurl {
        name = "http2_wrapper___http2_wrapper_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/http2-wrapper/-/http2-wrapper-1.0.3.tgz";
        sha512 = "V+23sDMr12Wnz7iTcDeJr3O6AIxlnvT/bmaAAAP/Xda35C90p9599p0F1eHR/N1KILWSoWVAiOMFjBBXaXSMxg==";
      };
    }
    {
      name = "https_proxy_agent___https_proxy_agent_5.0.1.tgz";
      path = fetchurl {
        name = "https_proxy_agent___https_proxy_agent_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz";
        sha512 = "dFcAjpTQFgoLMzC2VwU+C/CbS7uRL0lWmxDITmqm7C+7F0Odmj6s9l6alZc6AELXhrnggM2CeWSXHGOdX2YtwA==";
      };
    }
    {
      name = "iconv_corefoundation___iconv_corefoundation_1.1.7.tgz";
      path = fetchurl {
        name = "iconv_corefoundation___iconv_corefoundation_1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz";
        sha512 = "T10qvkw0zz4wnm560lOEg0PovVqUXuOFhhHAkixw8/sycy7TJt7v/RrkEKEQnAw2viPSJu6iAkErxnzR0g8PpQ==";
      };
    }
    {
      name = "iconv_lite___iconv_lite_0.6.3.tgz";
      path = fetchurl {
        name = "iconv_lite___iconv_lite_0.6.3.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz";
        sha512 = "4fCk79wshMdzMp2rH06qWrJE4iolqLhCUH+OiuIgU++RB0+94NlDL81atO7GX55uUKueo0txHNtvEyI6D7WdMw==";
      };
    }
    {
      name = "ieee754___ieee754_1.2.1.tgz";
      path = fetchurl {
        name = "ieee754___ieee754_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz";
        sha512 = "dcyqhDvX1C46lXZcVqCpK+FtMRQVdIMN6/Df5js2zouUsqG7I6sFxitIC+7KYK29KdXOLHdu9zL4sFnoVQnqaA==";
      };
    }
    {
      name = "immediate___immediate_3.0.6.tgz";
      path = fetchurl {
        name = "immediate___immediate_3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/immediate/-/immediate-3.0.6.tgz";
        sha512 = "XXOFtyqDjNDAQxVfYxuF7g9Il/IbWmmlQg2MYKOH8ExIT1qg6xc4zyS3HaEEATgs1btfzxq15ciUiY7gjSXRGQ==";
      };
    }
    {
      name = "inflight___inflight_1.0.6.tgz";
      path = fetchurl {
        name = "inflight___inflight_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha512 = "k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==";
      };
    }
    {
      name = "inherits___inherits_2.0.4.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz";
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
      };
    }
    {
      name = "is_ci___is_ci_3.0.1.tgz";
      path = fetchurl {
        name = "is_ci___is_ci_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-ci/-/is-ci-3.0.1.tgz";
        sha512 = "ZYvCgrefwqoQ6yTyYUbQu64HsITZ3NfKX1lzaEYdkTDcfKzzCI/wthRRYKkdjHKFVgNiXKAKm65Zo1pk2as/QQ==";
      };
    }
    {
      name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
      path = fetchurl {
        name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz";
        sha512 = "zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==";
      };
    }
    {
      name = "is_plain_obj___is_plain_obj_1.1.0.tgz";
      path = fetchurl {
        name = "is_plain_obj___is_plain_obj_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz";
        sha512 = "yvkRyxmFKEOQ4pNXCmJG5AEQNlXJS5LaONXo5/cLdTZdWvsZ1ioJEonLGAosKlMWE8lwUy/bJzMjcw8az73+Fg==";
      };
    }
    {
      name = "isbinaryfile___isbinaryfile_3.0.3.tgz";
      path = fetchurl {
        name = "isbinaryfile___isbinaryfile_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-3.0.3.tgz";
        sha512 = "8cJBL5tTd2OS0dM4jz07wQd5g0dCCqIhUxPIGtZfa5L6hWlvV5MHTITy/DBAsF+Oe2LS1X3krBUhNwaGUWpWxw==";
      };
    }
    {
      name = "isbinaryfile___isbinaryfile_4.0.10.tgz";
      path = fetchurl {
        name = "isbinaryfile___isbinaryfile_4.0.10.tgz";
        url  = "https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.10.tgz";
        sha512 = "iHrqe5shvBUcFbmZq9zOQHBoeOhZJu6RQGrDpBgenUm/Am+F3JM2MgQj+rK3Z601fzrL5gLZWtAPH2OBaSVcyw==";
      };
    }
    {
      name = "isexe___isexe_2.0.0.tgz";
      path = fetchurl {
        name = "isexe___isexe_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha512 = "RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==";
      };
    }
    {
      name = "jake___jake_10.8.5.tgz";
      path = fetchurl {
        name = "jake___jake_10.8.5.tgz";
        url  = "https://registry.yarnpkg.com/jake/-/jake-10.8.5.tgz";
        sha512 = "sVpxYeuAhWt0OTWITwT98oyV0GsXyMlXCF+3L1SuafBVUIr/uILGRB+NqwkzhgXKvoJpDIpQvqkUALgdmQsQxw==";
      };
    }
    {
      name = "js_yaml___js_yaml_4.1.0.tgz";
      path = fetchurl {
        name = "js_yaml___js_yaml_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz";
        sha512 = "wpxZs9NoxZaJESJGIZTyDEaYpl0FKSA+FB9aJiyemKhMwkxQg63h4T1KJgUGHpTqPDNRcmmYLugrRjJlBtWvRA==";
      };
    }
    {
      name = "json_buffer___json_buffer_3.0.1.tgz";
      path = fetchurl {
        name = "json_buffer___json_buffer_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.1.tgz";
        sha512 = "4bV5BfR2mqfQTJm+V5tPPdf+ZpuhiIvTuAB5g8kcrXOZpTT/QwwVRWBywX1ozr6lEuPdbHxwaJlm9G6mI2sfSQ==";
      };
    }
    {
      name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz";
        sha512 = "xbbCH5dCYU5T8LcEhhuh7HJ88HXuW3qsI3Y0zOZFKfZEHcpWiHU/Jxzk629Brsab/mMiHQti9wMP+845RPe3Vg==";
      };
    }
    {
      name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
      path = fetchurl {
        name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha512 = "ZClg6AaYvamvYEE82d3Iyd3vSSIjQ+odgjaTzRuO3s7toCdFKczob2i0zCh7JE8kWn17yvAWhUVxvqGwUalsRA==";
      };
    }
    {
      name = "json5___json5_2.2.3.tgz";
      path = fetchurl {
        name = "json5___json5_2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz";
        sha512 = "XmOWe7eyHYH14cLdVPoyg+GOH3rYX++KpzrylJwSW98t3Nk+U8XOl8FWKOgwtzdb8lXGf6zYwDUzeHMWfxasyg==";
      };
    }
    {
      name = "jsonfile___jsonfile_4.0.0.tgz";
      path = fetchurl {
        name = "jsonfile___jsonfile_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz";
        sha512 = "m6F1R3z8jjlf2imQHS2Qez5sjKWQzbuuhuJ/FKYFRZvPE3PuHcSMVZzfsLhGVOkfd20obL5SWEBew5ShlquNxg==";
      };
    }
    {
      name = "jsonfile___jsonfile_6.1.0.tgz";
      path = fetchurl {
        name = "jsonfile___jsonfile_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz";
        sha512 = "5dgndWOriYSm5cnYaJNhalLNDKOqFwyDB/rr1E9ZsGciGvKPs8R2xYGCacuf3z6K1YKDz182fd+fY3cn3pMqXQ==";
      };
    }
    {
      name = "keyv___keyv_4.5.2.tgz";
      path = fetchurl {
        name = "keyv___keyv_4.5.2.tgz";
        url  = "https://registry.yarnpkg.com/keyv/-/keyv-4.5.2.tgz";
        sha512 = "5MHbFaKn8cNSmVW7BYnijeAVlE4cYA/SVkifVgrh7yotnfhKmjuXpDKjrABLnT0SfHWV21P8ow07OGfRrNDg8g==";
      };
    }
    {
      name = "lazy_val___lazy_val_1.0.5.tgz";
      path = fetchurl {
        name = "lazy_val___lazy_val_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/lazy-val/-/lazy-val-1.0.5.tgz";
        sha512 = "0/BnGCCfyUMkBpeDgWihanIAF9JmZhHBgUhEqzvf+adhNGLoP6TaiI5oF8oyb3I45P+PcnrqihSf01M0l0G5+Q==";
      };
    }
    {
      name = "lie___lie_3.1.1.tgz";
      path = fetchurl {
        name = "lie___lie_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lie/-/lie-3.1.1.tgz";
        sha512 = "RiNhHysUjhrDQntfYSfY4MU24coXXdEOgw9WGcKHNeEwffDYbF//u87M1EWaMGzuFoSbqW0C9C6lEEhDOAswfw==";
      };
    }
    {
      name = "localforage___localforage_1.10.0.tgz";
      path = fetchurl {
        name = "localforage___localforage_1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/localforage/-/localforage-1.10.0.tgz";
        sha512 = "14/H1aX7hzBBmmh7sGPd+AOMkkIrHM3Z1PAyGgZigA1H1p5O5ANnMyWzvpAETtG68/dC4pC0ncy3+PPGzXZHPg==";
      };
    }
    {
      name = "lodash___lodash_4.17.21.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.21.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz";
        sha512 = "v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg==";
      };
    }
    {
      name = "lowercase_keys___lowercase_keys_2.0.0.tgz";
      path = fetchurl {
        name = "lowercase_keys___lowercase_keys_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz";
        sha512 = "tqNXrS78oMOE73NMxK4EMLQsQowWf8jKooH9g7xPavRT706R6bkQJ6DY2Te7QukaZsulxa30wQ7bk0pm4XiHmA==";
      };
    }
    {
      name = "lru_cache___lru_cache_6.0.0.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz";
        sha512 = "Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==";
      };
    }
    {
      name = "matcher___matcher_3.0.0.tgz";
      path = fetchurl {
        name = "matcher___matcher_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz";
        sha512 = "OkeDaAZ/bQCxeFAozM55PKcKU0yJMPGifLwV4Qgjitu+5MoAfSQN4lsLJeXZ1b8w0x+/Emda6MZgXS1jvsapng==";
      };
    }
    {
      name = "mime_db___mime_db_1.52.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.52.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz";
        sha512 = "sPU4uV7dYlvtWJxwwxHD0PuihVNiE7TyAbQ5SWxDCB9mUYvOgroQOwYQQOKPJ8CIbE+1ETVlOoK1UC2nU3gYvg==";
      };
    }
    {
      name = "mime_types___mime_types_2.1.35.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.35.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz";
        sha512 = "ZDY+bPm5zTTF+YpCrAU9nK0UgICYPT0QtT1NZWFv4s++TNkcgVaT0g6+4R2uI4MjQjzysHB1zxuWL50hzaeXiw==";
      };
    }
    {
      name = "mime___mime_2.6.0.tgz";
      path = fetchurl {
        name = "mime___mime_2.6.0.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-2.6.0.tgz";
        sha512 = "USPkMeET31rOMiarsBNIHZKLGgvKc/LrjofAnBlOttf5ajRvqiRA8QsenbcooctK6d6Ts6aqZXBA+XbkKthiQg==";
      };
    }
    {
      name = "mimic_response___mimic_response_1.0.1.tgz";
      path = fetchurl {
        name = "mimic_response___mimic_response_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz";
        sha512 = "j5EctnkH7amfV/q5Hgmoal1g2QHFJRraOtmx0JpIqkxhBhI/lJSl1nMpQ45hVarwNETOoWEimndZ4QK0RHxuxQ==";
      };
    }
    {
      name = "mimic_response___mimic_response_3.1.0.tgz";
      path = fetchurl {
        name = "mimic_response___mimic_response_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-response/-/mimic-response-3.1.0.tgz";
        sha512 = "z0yWI+4FDrrweS8Zmt4Ej5HdJmky15+L2e6Wgn3+iK5fWzb6T3fhNFq2+MeTRb064c6Wr4N/wv0DzQTjNzHNGQ==";
      };
    }
    {
      name = "minimatch___minimatch_3.0.4.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz";
        sha512 = "yJHVQEhyqPLUTgt9B83PXu6W3rx4MvvHvSUvToogpwoGDOUQ+yDrR0HRot+yOCdCO7u4hX3pWft6kWBBcqh0UA==";
      };
    }
    {
      name = "minimatch___minimatch_3.1.2.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz";
        sha512 = "J7p63hRiAjw1NDEww1W7i37+ByIrOWO5XQQAzZ3VOcL0PNybwpfmV/N05zFAzwQ9USyEcX6t3UO+K5aqBQOIHw==";
      };
    }
    {
      name = "minimatch___minimatch_5.1.6.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_5.1.6.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.6.tgz";
        sha512 = "lKwV/1brpG6mBUFHtb7NUmtABCb2WZZmm2wNiOA5hAb8VdCS4B3dtMWyvcoViccwAW/COERjXLt0zP1zXUN26g==";
      };
    }
    {
      name = "minimist___minimist_1.2.8.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz";
        sha512 = "2yyAR8qBkN3YuheJanUpWC5U3bb5osDywNB8RzDVlDwDHbocAJveqqj1u8+SVD7jkWT4yvsHCpWqqWqAxb0zCA==";
      };
    }
    {
      name = "minipass___minipass_3.3.6.tgz";
      path = fetchurl {
        name = "minipass___minipass_3.3.6.tgz";
        url  = "https://registry.yarnpkg.com/minipass/-/minipass-3.3.6.tgz";
        sha512 = "DxiNidxSEK+tHG6zOIklvNOwm3hvCrbUrdtzY74U6HKTJxvIDfOUL5W5P2Ghd3DTkhhKPYGqeNUIh5qcM4YBfw==";
      };
    }
    {
      name = "minipass___minipass_4.2.4.tgz";
      path = fetchurl {
        name = "minipass___minipass_4.2.4.tgz";
        url  = "https://registry.yarnpkg.com/minipass/-/minipass-4.2.4.tgz";
        sha512 = "lwycX3cBMTvcejsHITUgYj6Gy6A7Nh4Q6h9NP4sTHY1ccJlC7yKzDmiShEHsJ16Jf1nKGDEaiHxiltsJEvk0nQ==";
      };
    }
    {
      name = "minizlib___minizlib_2.1.2.tgz";
      path = fetchurl {
        name = "minizlib___minizlib_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.2.tgz";
        sha512 = "bAxsR8BVfj60DWXHE3u30oHzfl4G7khkSuPW+qvpd7jFRHm7dLxOjUk1EHACJ/hxLY8phGJ0YhYHZo7jil7Qdg==";
      };
    }
    {
      name = "mkdirp___mkdirp_0.5.6.tgz";
      path = fetchurl {
        name = "mkdirp___mkdirp_0.5.6.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz";
        sha512 = "FP+p8RB8OWpF3YZBCrP5gtADmtXApB5AMLn+vdyA+PyxCjrCs00mjyUozssO33cwDeT3wNGdLxJ5M//YqtHAJw==";
      };
    }
    {
      name = "mkdirp___mkdirp_1.0.4.tgz";
      path = fetchurl {
        name = "mkdirp___mkdirp_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz";
        sha512 = "vVqVZQyf3WLx2Shd0qJ9xuvqgAyKPLAiqITEtqW0oIUjzo3PePDd6fW9iFz30ef7Ysp/oiWqbhszeGWW2T6Gzw==";
      };
    }
    {
      name = "modify_filename___modify_filename_1.1.0.tgz";
      path = fetchurl {
        name = "modify_filename___modify_filename_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/modify-filename/-/modify-filename-1.1.0.tgz";
        sha512 = "EickqnKq3kVVaZisYuCxhtKbZjInCuwgwZWyAmRIp1NTMhri7r3380/uqwrUHfaDiPzLVTuoNy4whX66bxPVog==";
      };
    }
    {
      name = "ms___ms_2.0.0.tgz";
      path = fetchurl {
        name = "ms___ms_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha512 = "Tpp60P6IUJDTuOq/5Z8cdskzJujfwqfOTkrwIwj7IRISpnkJnT6SyJ4PCPnGMoFjC9ddhal5KVIYtAt97ix05A==";
      };
    }
    {
      name = "ms___ms_2.1.2.tgz";
      path = fetchurl {
        name = "ms___ms_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz";
        sha512 = "sGkPx+VjMtmA6MX27oA4FBFELFCZZ4S4XqeGOXCv68tT+jb3vk/RyaKWP0PTKyWtmLSM0b+adUTEvbs1PEaH2w==";
      };
    }
    {
      name = "node_addon_api___node_addon_api_1.7.2.tgz";
      path = fetchurl {
        name = "node_addon_api___node_addon_api_1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-1.7.2.tgz";
        sha512 = "ibPK3iA+vaY1eEjESkQkM0BbCqFOaZMiXRTtdB0u7b4djtY6JnsjvPdUHVMg6xQt3B8fpTTWHI9A+ADjM9frzg==";
      };
    }
    {
      name = "normalize_url___normalize_url_6.1.0.tgz";
      path = fetchurl {
        name = "normalize_url___normalize_url_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-url/-/normalize-url-6.1.0.tgz";
        sha512 = "DlL+XwOy3NxAQ8xuC0okPgK46iuVNAK01YN7RueYBqqFeGsBjV9XmCAzAdgt+667bCl5kPh9EqKKDwnaPG1I7A==";
      };
    }
    {
      name = "object_keys___object_keys_1.1.1.tgz";
      path = fetchurl {
        name = "object_keys___object_keys_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz";
        sha512 = "NuAESUOUMrlIXOfHKzD6bpPu3tYt3xvjNdRIQ+FeT0lNb4K8WR70CaDxhuNguS2XG+GjkyMwOzsN5ZktImfhLA==";
      };
    }
    {
      name = "once___once_1.4.0.tgz";
      path = fetchurl {
        name = "once___once_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
        sha512 = "lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==";
      };
    }
    {
      name = "p_cancelable___p_cancelable_2.1.1.tgz";
      path = fetchurl {
        name = "p_cancelable___p_cancelable_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-2.1.1.tgz";
        sha512 = "BZOr3nRQHOntUjTrH8+Lh54smKHoHyur8We1V8DSMVrl5A2malOOwuJRnKRDjSnkoeBh4at6BwEnb5I7Jl31wg==";
      };
    }
    {
      name = "path_exists___path_exists_4.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz";
        sha512 = "ak9Qy5Q7jYb2Wwcey5Fpvg2KoAc/ZIhLSLOSBmRmygPsGwkVVt0fZa0qrtMz+m6tJTAHfZQ8FnmB4MG4LWy7/w==";
      };
    }
    {
      name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
      path = fetchurl {
        name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha512 = "AVbw3UJ2e9bq64vSaS9Am0fje1Pa8pbGqTTsmXfaIiMpnr5DlDhfJOuLj9Sf95ZPVDAUerDfEk88MPmPe7UCQg==";
      };
    }
    {
      name = "path_key___path_key_3.1.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz";
        sha512 = "ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==";
      };
    }
    {
      name = "pend___pend_1.2.0.tgz";
      path = fetchurl {
        name = "pend___pend_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz";
        sha512 = "F3asv42UuXchdzt+xXqfW1OGlVBe+mxa2mqI0pg5yAHZPvFmY3Y6drSf/GQ1A86WgWEN9Kzh/WrgKa6iGcHXLg==";
      };
    }
    {
      name = "plist___plist_3.0.6.tgz";
      path = fetchurl {
        name = "plist___plist_3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/plist/-/plist-3.0.6.tgz";
        sha512 = "WiIVYyrp8TD4w8yCvyeIr+lkmrGRd5u0VbRnU+tP/aRLxP/YadJUYOMZJ/6hIa3oUyVCsycXvtNRgd5XBJIbiA==";
      };
    }
    {
      name = "progress___progress_2.0.3.tgz";
      path = fetchurl {
        name = "progress___progress_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz";
        sha512 = "7PiHtLll5LdnKIMw100I+8xJXR5gW2QwWYkT6iJva0bXitZKa/XMrSbdmg3r2Xnaidz9Qumd0VPaMrZlF9V9sA==";
      };
    }
    {
      name = "pump___pump_3.0.0.tgz";
      path = fetchurl {
        name = "pump___pump_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz";
        sha512 = "LwZy+p3SFs1Pytd/jYct4wpv49HiYCqd9Rlc5ZVdk0V+8Yzv6jR5Blk3TRmPL1ft69TxP0IMZGJ+WPFU2BFhww==";
      };
    }
    {
      name = "punycode___punycode_2.3.0.tgz";
      path = fetchurl {
        name = "punycode___punycode_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz";
        sha512 = "rRV+zQD8tVFys26lAGR9WUuS4iUAngJScM+ZRSKtvl5tKeZ2t5bvdNFdNHBW9FWR4guGHlgmsZ1G7BSm2wTbuA==";
      };
    }
    {
      name = "pupa___pupa_2.1.1.tgz";
      path = fetchurl {
        name = "pupa___pupa_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/pupa/-/pupa-2.1.1.tgz";
        sha512 = "l1jNAspIBSFqbT+y+5FosojNpVpF94nlI+wDUpqP9enwOTfHx9f0gh5nB96vl+6yTpsJsypeNrwfzPrKuHB41A==";
      };
    }
    {
      name = "quick_lru___quick_lru_5.1.1.tgz";
      path = fetchurl {
        name = "quick_lru___quick_lru_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/quick-lru/-/quick-lru-5.1.1.tgz";
        sha512 = "WuyALRjWPDGtt/wzJiadO5AXY+8hZ80hVpe6MyivgraREW751X3SbhRvG3eLKOYN+8VEvqLcf3wdnt44Z4S4SA==";
      };
    }
    {
      name = "read_config_file___read_config_file_6.2.0.tgz";
      path = fetchurl {
        name = "read_config_file___read_config_file_6.2.0.tgz";
        url  = "https://registry.yarnpkg.com/read-config-file/-/read-config-file-6.2.0.tgz";
        sha512 = "gx7Pgr5I56JtYz+WuqEbQHj/xWo+5Vwua2jhb1VwM4Wid5PqYmZ4i00ZB0YEGIfkVBsCv9UrjgyqCiQfS/Oosg==";
      };
    }
    {
      name = "require_directory___require_directory_2.1.1.tgz";
      path = fetchurl {
        name = "require_directory___require_directory_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz";
        sha512 = "fGxEI7+wsG9xrvdjsrlmL22OMTTiHRwAMroiEeMgq8gzoLC/PQr7RsRDSTLUg/bZAZtF+TVIkHc6/4RIKrui+Q==";
      };
    }
    {
      name = "resolve_alpn___resolve_alpn_1.2.1.tgz";
      path = fetchurl {
        name = "resolve_alpn___resolve_alpn_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve-alpn/-/resolve-alpn-1.2.1.tgz";
        sha512 = "0a1F4l73/ZFZOakJnQ3FvkJ2+gSTQWz/r2KE5OdDY0TxPm5h4GkqkWWfM47T7HsbnOtcJVEF4epCVy6u7Q3K+g==";
      };
    }
    {
      name = "responselike___responselike_2.0.1.tgz";
      path = fetchurl {
        name = "responselike___responselike_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/responselike/-/responselike-2.0.1.tgz";
        sha512 = "4gl03wn3hj1HP3yzgdI7d3lCkF95F21Pz4BPGvKHinyQzALR5CapwC8yIi0Rh58DEMQ/SguC03wFj2k0M/mHhw==";
      };
    }
    {
      name = "rimraf___rimraf_3.0.2.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz";
        sha512 = "JZkJMZkAGFFPP2YqXZXPbMlMBgsxzE8ILs4lMIX/2o0L9UBw9O/Y3o6wFw/i9YLapcUJWwqbi3kdxIPdC62TIA==";
      };
    }
    {
      name = "roarr___roarr_2.15.4.tgz";
      path = fetchurl {
        name = "roarr___roarr_2.15.4.tgz";
        url  = "https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz";
        sha512 = "CHhPh+UNHD2GTXNYhPWLnU8ONHdI+5DI+4EYIAOaiD63rHeYlZvyh8P+in5999TTSFgUYuKUAjzRI4mdh/p+2A==";
      };
    }
    {
      name = "safer_buffer___safer_buffer_2.1.2.tgz";
      path = fetchurl {
        name = "safer_buffer___safer_buffer_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz";
        sha512 = "YZo3K82SD7Riyi0E1EQPojLz7kpepnSQI9IyPbHHg1XXXevb5dJI7tpyN2ADxGcQbHG7vcyRHk0cbwqcQriUtg==";
      };
    }
    {
      name = "sanitize_filename___sanitize_filename_1.6.3.tgz";
      path = fetchurl {
        name = "sanitize_filename___sanitize_filename_1.6.3.tgz";
        url  = "https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz";
        sha512 = "y/52Mcy7aw3gRm7IrcGDFx/bCk4AhRh2eI9luHOQM86nZsqwiRkkq2GekHXBBD+SmPidc8i2PqtYZl+pWJ8Oeg==";
      };
    }
    {
      name = "sax___sax_1.2.4.tgz";
      path = fetchurl {
        name = "sax___sax_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz";
        sha512 = "NqVDv9TpANUjFm0N8uM5GxL36UgKi9/atZw+x7YFnQ8ckwFGKrl4xX4yWtrey3UJm5nP1kUbnYgLopqWNSRhWw==";
      };
    }
    {
      name = "semver_compare___semver_compare_1.0.0.tgz";
      path = fetchurl {
        name = "semver_compare___semver_compare_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz";
        sha512 = "YM3/ITh2MJ5MtzaM429anh+x2jiLVjqILF4m4oyQB18W7Ggea7BfqdH/wGMK7dDiMghv/6WG7znWMwUDzJiXow==";
      };
    }
    {
      name = "semver___semver_6.3.0.tgz";
      path = fetchurl {
        name = "semver___semver_6.3.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz";
        sha512 = "b39TBaTSfV6yBrapU89p5fKekE2m/NwnDocOVruQFS1/veMgdzuPcnOM34M6CwxW8jH/lxEa5rBoDeUwu5HHTw==";
      };
    }
    {
      name = "semver___semver_7.3.8.tgz";
      path = fetchurl {
        name = "semver___semver_7.3.8.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz";
        sha512 = "NB1ctGL5rlHrPJtFDVIVzTyQylMLu9N9VICA6HSFJo8MCGVTMW6gfpicwKmmK/dAjTOrqu5l63JJOpDSrAis3A==";
      };
    }
    {
      name = "semver___semver_7.0.0.tgz";
      path = fetchurl {
        name = "semver___semver_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.0.0.tgz";
        sha512 = "+GB6zVA9LWh6zovYQLALHwv5rb2PHGlJi3lfiqIHxR0uuwCgefcOJc59v9fv1w8GbStwxuuqqAjI9NMAOOgq1A==";
      };
    }
    {
      name = "serialize_error___serialize_error_7.0.1.tgz";
      path = fetchurl {
        name = "serialize_error___serialize_error_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz";
        sha512 = "8I8TjW5KMOKsZQTvoxjuSIa7foAwPWGOts+6o7sgjz41/qMD9VQHEDxi6PBvK2l0MXUmqZyNpUK+T2tQaaElvw==";
      };
    }
    {
      name = "shebang_command___shebang_command_2.0.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz";
        sha512 = "kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==";
      };
    }
    {
      name = "shebang_regex___shebang_regex_3.0.0.tgz";
      path = fetchurl {
        name = "shebang_regex___shebang_regex_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz";
        sha512 = "7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==";
      };
    }
    {
      name = "simple_update_notifier___simple_update_notifier_1.1.0.tgz";
      path = fetchurl {
        name = "simple_update_notifier___simple_update_notifier_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/simple-update-notifier/-/simple-update-notifier-1.1.0.tgz";
        sha512 = "VpsrsJSUcJEseSbMHkrsrAVSdvVS5I96Qo1QAQ4FxQ9wXFcB+pjj7FB7/us9+GcgfW4ziHtYMc1J0PLczb55mg==";
      };
    }
    {
      name = "slice_ansi___slice_ansi_3.0.0.tgz";
      path = fetchurl {
        name = "slice_ansi___slice_ansi_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-3.0.0.tgz";
        sha512 = "pSyv7bSTC7ig9Dcgbw9AuRNUb5k5V6oDudjZoMBSr13qpLBG7tB+zgCkARjq7xIUgdz5P1Qe8u+rSGdouOOIyQ==";
      };
    }
    {
      name = "smart_buffer___smart_buffer_4.2.0.tgz";
      path = fetchurl {
        name = "smart_buffer___smart_buffer_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.2.0.tgz";
        sha512 = "94hK0Hh8rPqQl2xXc3HsaBoOXKV20MToPkcXvwbISWLEs+64sBq5kFgn2kJDHb1Pry9yrP0dxrCI9RRci7RXKg==";
      };
    }
    {
      name = "sort_keys_length___sort_keys_length_1.0.1.tgz";
      path = fetchurl {
        name = "sort_keys_length___sort_keys_length_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sort-keys-length/-/sort-keys-length-1.0.1.tgz";
        sha512 = "GRbEOUqCxemTAk/b32F2xa8wDTs+Z1QHOkbhJDQTvv/6G3ZkbJ+frYWsTcc7cBB3Fu4wy4XlLCuNtJuMn7Gsvw==";
      };
    }
    {
      name = "sort_keys___sort_keys_1.1.2.tgz";
      path = fetchurl {
        name = "sort_keys___sort_keys_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/sort-keys/-/sort-keys-1.1.2.tgz";
        sha512 = "vzn8aSqKgytVik0iwdBEi+zevbTYZogewTUM6dtpmGwEcdzbub/TX4bCzRhebDCRC3QzXgJsLRKB2V/Oof7HXg==";
      };
    }
    {
      name = "source_map_support___source_map_support_0.5.21.tgz";
      path = fetchurl {
        name = "source_map_support___source_map_support_0.5.21.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz";
        sha512 = "uBHU3L3czsIyYXKX88fdrGovxdSCoTGDRZ6SYXtSRxLZUzHg5P/66Ht6uoUlHu9EZod+inXhKo3qQgwXUT/y1w==";
      };
    }
    {
      name = "source_map___source_map_0.6.1.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz";
        sha512 = "UjgapumWlbMhkBgzT7Ykc5YXUT46F0iKu8SGXq0bcwP5dz/h0Plj6enJqjz1Zbq2l5WaqYnrVbwWOWMyF3F47g==";
      };
    }
    {
      name = "sprintf_js___sprintf_js_1.1.2.tgz";
      path = fetchurl {
        name = "sprintf_js___sprintf_js_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz";
        sha512 = "VE0SOVEHCk7Qc8ulkWw3ntAzXuqf7S2lvwQaDLRnUeIEaKNQJzV6BwmLKhOqT61aGhfUMrXeaBk+oDGCzvhcug==";
      };
    }
    {
      name = "stat_mode___stat_mode_1.0.0.tgz";
      path = fetchurl {
        name = "stat_mode___stat_mode_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stat-mode/-/stat-mode-1.0.0.tgz";
        sha512 = "jH9EhtKIjuXZ2cWxmXS8ZP80XyC3iasQxMDV8jzhNJpfDb7VbQLVW4Wvsxz9QZvzV+G4YoSfBUVKDOyxLzi/sg==";
      };
    }
    {
      name = "string_width___string_width_4.2.3.tgz";
      path = fetchurl {
        name = "string_width___string_width_4.2.3.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz";
        sha512 = "wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==";
      };
    }
    {
      name = "strip_ansi___strip_ansi_6.0.1.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz";
        sha512 = "Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==";
      };
    }
    {
      name = "sumchecker___sumchecker_3.0.1.tgz";
      path = fetchurl {
        name = "sumchecker___sumchecker_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz";
        sha512 = "MvjXzkz/BOfyVDkG0oFOtBxHX2u3gKbMHIF/dXblZsgD3BWOFLmHovIpZY7BykJdAjcqRCBi1WYBNdEC9yI7vg==";
      };
    }
    {
      name = "supports_color___supports_color_7.2.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz";
        sha512 = "qpCAvRl9stuOHveKsn7HncJRvv501qIacKzQlO/+Lwxc9+0q2wLyv4Dfvt80/DPn2pqOBsJdDiogXGR9+OvwRw==";
      };
    }
    {
      name = "tar___tar_6.1.13.tgz";
      path = fetchurl {
        name = "tar___tar_6.1.13.tgz";
        url  = "https://registry.yarnpkg.com/tar/-/tar-6.1.13.tgz";
        sha512 = "jdIBIN6LTIe2jqzay/2vtYLlBHa3JF42ot3h1dW8Q0PaAG4v8rm0cvpVePtau5C6OKXGGcgO9q2AMNSWxiLqKw==";
      };
    }
    {
      name = "temp_file___temp_file_3.4.0.tgz";
      path = fetchurl {
        name = "temp_file___temp_file_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/temp-file/-/temp-file-3.4.0.tgz";
        sha512 = "C5tjlC/HCtVUOi3KWVokd4vHVViOmGjtLwIh4MuzPo/nMYTV/p1urt3RnMz2IWXDdKEGJH3k5+KPxtqRsUYGtg==";
      };
    }
    {
      name = "tmp_promise___tmp_promise_3.0.3.tgz";
      path = fetchurl {
        name = "tmp_promise___tmp_promise_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/tmp-promise/-/tmp-promise-3.0.3.tgz";
        sha512 = "RwM7MoPojPxsOBYnyd2hy0bxtIlVrihNs9pj5SUvY8Zz1sQcQG2tG1hSr8PDxfgEB8RNKDhqbIlroIarSNDNsQ==";
      };
    }
    {
      name = "tmp___tmp_0.2.1.tgz";
      path = fetchurl {
        name = "tmp___tmp_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz";
        sha512 = "76SUhtfqR2Ijn+xllcI5P1oyannHNHByD80W1q447gU3mp9G9PSpGdWmjUOHRDPiHYacIk66W7ubDTuPF3BEtQ==";
      };
    }
    {
      name = "truncate_utf8_bytes___truncate_utf8_bytes_1.0.2.tgz";
      path = fetchurl {
        name = "truncate_utf8_bytes___truncate_utf8_bytes_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz";
        sha512 = "95Pu1QXQvruGEhv62XCMO3Mm90GscOCClvrIUwCM0PYOXK3kaF3l3sIHxx71ThJfcbM2O5Au6SO3AWCSEfW4mQ==";
      };
    }
    {
      name = "type_fest___type_fest_0.13.1.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.13.1.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz";
        sha512 = "34R7HTnG0XIJcBSn5XhDd7nNFPRcXYRZrBB2O2jdKqYODldSzBAqzsWoZYYvduky73toYS/ESqxPvkDf/F0XMg==";
      };
    }
    {
      name = "typescript___typescript_4.9.5.tgz";
      path = fetchurl {
        name = "typescript___typescript_4.9.5.tgz";
        url  = "https://registry.yarnpkg.com/typescript/-/typescript-4.9.5.tgz";
        sha512 = "1FXk9E2Hm+QzZQ7z+McJiHL4NW1F2EzMu9Nq9i3zAaGqibafqYwCVU6WyWAuyQRRzOlxou8xZSyXLEN8oKj24g==";
      };
    }
    {
      name = "typo_js___typo_js_1.2.2.tgz";
      path = fetchurl {
        name = "typo_js___typo_js_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/typo-js/-/typo-js-1.2.2.tgz";
        sha512 = "C7pYBQK17EjSg8tVNY91KHdUt5Nf6FMJ+c3js076quPmBML57PmNMzAcIq/2kf/hSYtFABNDIYNYlJRl5BJhGw==";
      };
    }
    {
      name = "universalify___universalify_0.1.2.tgz";
      path = fetchurl {
        name = "universalify___universalify_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz";
        sha512 = "rBJeI5CXAlmy1pV+617WB9J63U6XcazHHF2f2dbJix4XzpUF0RS3Zbj0FGIOCAva5P/d/GBOYaACQ1w+0azUkg==";
      };
    }
    {
      name = "universalify___universalify_2.0.0.tgz";
      path = fetchurl {
        name = "universalify___universalify_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz";
        sha512 = "hAZsKq7Yy11Zu1DE0OzWjw7nnLZmJZYTDZZyEFHZdUhV8FkH5MCfoU1XMaxXovpyW5nq5scPqq0ZDP9Zyl04oQ==";
      };
    }
    {
      name = "unused_filename___unused_filename_2.1.0.tgz";
      path = fetchurl {
        name = "unused_filename___unused_filename_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/unused-filename/-/unused-filename-2.1.0.tgz";
        sha512 = "BMiNwJbuWmqCpAM1FqxCTD7lXF97AvfQC8Kr/DIeA6VtvhJaMDupZ82+inbjl5yVP44PcxOuCSxye1QMS0wZyg==";
      };
    }
    {
      name = "uri_js___uri_js_4.4.1.tgz";
      path = fetchurl {
        name = "uri_js___uri_js_4.4.1.tgz";
        url  = "https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz";
        sha512 = "7rKUyy33Q1yc98pQ1DAmLtwX109F7TIfWlW1Ydo8Wl1ii1SeHieeh0HHfPeL2fMXK6z0s8ecKs9frCuLJvndBg==";
      };
    }
    {
      name = "utf8_byte_length___utf8_byte_length_1.0.4.tgz";
      path = fetchurl {
        name = "utf8_byte_length___utf8_byte_length_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz";
        sha512 = "4+wkEYLBbWxqTahEsWrhxepcoVOJ+1z5PGIjPZxRkytcdSUaNjIjBM7Xn8E+pdSuV7SzvWovBFA54FO0JSoqhA==";
      };
    }
    {
      name = "verror___verror_1.10.1.tgz";
      path = fetchurl {
        name = "verror___verror_1.10.1.tgz";
        url  = "https://registry.yarnpkg.com/verror/-/verror-1.10.1.tgz";
        sha512 = "veufcmxri4e3XSrT0xwfUR7kguIkaxBeosDg00yDWhk49wdwkSUrvvsm7nc75e1PUyvIeZj6nS8VQRYz2/S4Xg==";
      };
    }
    {
      name = "which___which_2.0.2.tgz";
      path = fetchurl {
        name = "which___which_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-2.0.2.tgz";
        sha512 = "BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==";
      };
    }
    {
      name = "wrap_ansi___wrap_ansi_7.0.0.tgz";
      path = fetchurl {
        name = "wrap_ansi___wrap_ansi_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz";
        sha512 = "YVGIj2kamLSTxw6NsZjoBxfSwsn0ycdesmc4p+Q21c5zPuZ1pl+NfxVdxPtdHvmNVOQ6XSYG4AUtyt/Fi7D16Q==";
      };
    }
    {
      name = "wrappy___wrappy_1.0.2.tgz";
      path = fetchurl {
        name = "wrappy___wrappy_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha512 = "l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==";
      };
    }
    {
      name = "xmlbuilder___xmlbuilder_15.1.1.tgz";
      path = fetchurl {
        name = "xmlbuilder___xmlbuilder_15.1.1.tgz";
        url  = "https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-15.1.1.tgz";
        sha512 = "yMqGBqtXyeN1e3TGYvgNgDVZ3j84W4cwkOXQswghol6APgZWaff9lnbvN7MHYJOiXsvGPXtjTYJEiC9J2wv9Eg==";
      };
    }
    {
      name = "y18n___y18n_5.0.8.tgz";
      path = fetchurl {
        name = "y18n___y18n_5.0.8.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz";
        sha512 = "0pfFzegeDWJHJIAmTLRP2DwHjdF5s7jo9tuztdQxAhINCdvS+3nGINqPd00AphqJR/0LhANUS6/+7SCb98YOfA==";
      };
    }
    {
      name = "yallist___yallist_4.0.0.tgz";
      path = fetchurl {
        name = "yallist___yallist_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz";
        sha512 = "3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==";
      };
    }
    {
      name = "yargs_parser___yargs_parser_21.1.1.tgz";
      path = fetchurl {
        name = "yargs_parser___yargs_parser_21.1.1.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-21.1.1.tgz";
        sha512 = "tVpsJW7DdjecAiFpbIB1e3qxIQsE6NoPc5/eTdrbbIC4h0LVsWhnoa3g+m2HclBIujHzsxZ4VJVA+GUuc2/LBw==";
      };
    }
    {
      name = "yargs___yargs_17.7.1.tgz";
      path = fetchurl {
        name = "yargs___yargs_17.7.1.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-17.7.1.tgz";
        sha512 = "cwiTb08Xuv5fqF4AovYacTFNxk62th7LKJ6BL9IGUpTJrWoU7/7WdQGTP2SjKf1dUNBGzDd28p/Yfs/GI6JrLw==";
      };
    }
    {
      name = "yauzl___yauzl_2.10.0.tgz";
      path = fetchurl {
        name = "yauzl___yauzl_2.10.0.tgz";
        url  = "https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz";
        sha512 = "p4a9I6X6nu6IhoGmBqAcbJy1mlC4j27vEPZX9F4L4/vZT3Lyq1VkFHw/V/PUcB9Buo+DG3iHkT0x3Qya58zc3g==";
      };
    }
  ];
}
