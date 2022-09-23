{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "JSONStream___JSONStream_1.3.3.tgz";
      path = fetchurl {
        name = "JSONStream___JSONStream_1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/JSONStream/-/JSONStream-1.3.3.tgz";
        sha1 = "27b4b8fbbfeab4e71bcf551e7f27be8d952239bf";
      };
    }
    {
      name = "acorn_node___acorn_node_1.3.0.tgz";
      path = fetchurl {
        name = "acorn_node___acorn_node_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-node/-/acorn-node-1.3.0.tgz";
        sha1 = "5f86d73346743810ef1269b901dbcbded020861b";
      };
    }
    {
      name = "acorn___acorn_4.0.13.tgz";
      path = fetchurl {
        name = "acorn___acorn_4.0.13.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-4.0.13.tgz";
        sha1 = "105495ae5361d697bd195c825192e1ad7f253787";
      };
    }
    {
      name = "acorn___acorn_5.6.2.tgz";
      path = fetchurl {
        name = "acorn___acorn_5.6.2.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-5.6.2.tgz";
        sha1 = "b1da1d7be2ac1b4a327fb9eab851702c5045b4e7";
      };
    }
    {
      name = "admin_lte___admin_lte_2.4.9.tgz";
      path = fetchurl {
        name = "admin_lte___admin_lte_2.4.9.tgz";
        url  = "https://registry.yarnpkg.com/admin-lte/-/admin-lte-2.4.9.tgz";
        sha512 = "+u3zt5sWPPT8HmBvRg4F8IGZPaE5wD0K10+IjXoynfe/jEUrMMj+4eA1LGH9fMK6QulmFr1NCtc1Tk+mTgC24A==";
      };
    }
    {
      name = "almond___almond_0.3.3.tgz";
      path = fetchurl {
        name = "almond___almond_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/almond/-/almond-0.3.3.tgz";
        sha1 = "a0e7c95ac7624d6417b4494b1e68bff693168a20";
      };
    }
    {
      name = "asn1.js___asn1.js_4.10.1.tgz";
      path = fetchurl {
        name = "asn1.js___asn1.js_4.10.1.tgz";
        url  = "https://registry.yarnpkg.com/asn1.js/-/asn1.js-4.10.1.tgz";
        sha1 = "b9c2bf5805f1e64aadeed6df3a2bfafb5a73f5a0";
      };
    }
    {
      name = "assert___assert_1.4.1.tgz";
      path = fetchurl {
        name = "assert___assert_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/assert/-/assert-1.4.1.tgz";
        sha1 = "99912d591836b5a6f5b345c0f07eefc08fc65d91";
      };
    }
    {
      name = "astw___astw_2.2.0.tgz";
      path = fetchurl {
        name = "astw___astw_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/astw/-/astw-2.2.0.tgz";
        sha1 = "7bd41784d32493987aeb239b6b4e1c57a873b917";
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
      name = "base64_js___base64_js_1.3.0.tgz";
      path = fetchurl {
        name = "base64_js___base64_js_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/base64-js/-/base64-js-1.3.0.tgz";
        sha1 = "cab1e6118f051095e58b5281aea8c1cd22bfc0e3";
      };
    }
    {
      name = "bn.js___bn.js_4.12.0.tgz";
      path = fetchurl {
        name = "bn.js___bn.js_4.12.0.tgz";
        url  = "https://registry.yarnpkg.com/bn.js/-/bn.js-4.12.0.tgz";
        sha512 = "c98Bf3tPniI+scsdk237ku1Dc3ujXQTSgyiPUDEOe7tRkhrqridvh8klBv0HCEso1OLOYcHuCv/cS6DNxKH+ZA==";
      };
    }
    {
      name = "bootstrap_colorpicker___bootstrap_colorpicker_2.5.3.tgz";
      path = fetchurl {
        name = "bootstrap_colorpicker___bootstrap_colorpicker_2.5.3.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-colorpicker/-/bootstrap-colorpicker-2.5.3.tgz";
        sha512 = "xdllX8LSMvKULs3b8JrgRXTvyvjkSMHHHVuHjjN5FNMqr6kRe5NPiMHFmeAFjlgDF73MspikudLuEwR28LbzLw==";
      };
    }
    {
      name = "bootstrap_datepicker___bootstrap_datepicker_1.8.0.tgz";
      path = fetchurl {
        name = "bootstrap_datepicker___bootstrap_datepicker_1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-datepicker/-/bootstrap-datepicker-1.8.0.tgz";
        sha512 = "213St/G8KT3mjs4qu4qwww74KWysMaIeqgq5OhrboZjIjemIpyuxlSo9FNNI5+KzpkkxkRRba+oewiRGV42B1A==";
      };
    }
    {
      name = "bootstrap_daterangepicker___bootstrap_daterangepicker_2.1.30.tgz";
      path = fetchurl {
        name = "bootstrap_daterangepicker___bootstrap_daterangepicker_2.1.30.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-daterangepicker/-/bootstrap-daterangepicker-2.1.30.tgz";
        sha1 = "f893dbfff5a4d7dfaab75460e8ea6969bb89689a";
      };
    }
    {
      name = "bootstrap_slider___bootstrap_slider_9.10.0.tgz";
      path = fetchurl {
        name = "bootstrap_slider___bootstrap_slider_9.10.0.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-slider/-/bootstrap-slider-9.10.0.tgz";
        sha1 = "1103d6bc00cfbfa8cfc9a2599ab518c55643da3f";
      };
    }
    {
      name = "bootstrap_timepicker___bootstrap_timepicker_0.5.2.tgz";
      path = fetchurl {
        name = "bootstrap_timepicker___bootstrap_timepicker_0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-timepicker/-/bootstrap-timepicker-0.5.2.tgz";
        sha1 = "10ed9f2a2f0b8ccaefcde0fcf6a0738b919a3835";
      };
    }
    {
      name = "bootstrap_validator___bootstrap_validator_0.11.9.tgz";
      path = fetchurl {
        name = "bootstrap_validator___bootstrap_validator_0.11.9.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-validator/-/bootstrap-validator-0.11.9.tgz";
        sha1 = "fb7058eef53623e78f5aa7967026f98f875a9404";
      };
    }
    {
      name = "bootstrap___bootstrap_3.4.1.tgz";
      path = fetchurl {
        name = "bootstrap___bootstrap_3.4.1.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap/-/bootstrap-3.4.1.tgz";
        sha512 = "yN5oZVmRCwe5aKwzRj6736nSmKDX7pLYwsXiCj/EYmo16hODaBiT4En5btW/jhBF/seV+XMx3aYwukYC3A49DA==";
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
      name = "brorand___brorand_1.1.0.tgz";
      path = fetchurl {
        name = "brorand___brorand_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/brorand/-/brorand-1.1.0.tgz";
        sha1 = "EsJe/kCkXjwyPrhnWgoM5XsiNx8=";
      };
    }
    {
      name = "browser_pack___browser_pack_6.1.0.tgz";
      path = fetchurl {
        name = "browser_pack___browser_pack_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/browser-pack/-/browser-pack-6.1.0.tgz";
        sha1 = "c34ba10d0b9ce162b5af227c7131c92c2ecd5774";
      };
    }
    {
      name = "browser_resolve___browser_resolve_1.11.2.tgz";
      path = fetchurl {
        name = "browser_resolve___browser_resolve_1.11.2.tgz";
        url  = "https://registry.yarnpkg.com/browser-resolve/-/browser-resolve-1.11.2.tgz";
        sha1 = "8ff09b0a2c421718a1051c260b32e48f442938ce";
      };
    }
    {
      name = "browserify_aes___browserify_aes_1.2.0.tgz";
      path = fetchurl {
        name = "browserify_aes___browserify_aes_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/browserify-aes/-/browserify-aes-1.2.0.tgz";
        sha1 = "326734642f403dabc3003209853bb70ad428ef48";
      };
    }
    {
      name = "browserify_cipher___browserify_cipher_1.0.1.tgz";
      path = fetchurl {
        name = "browserify_cipher___browserify_cipher_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-cipher/-/browserify-cipher-1.0.1.tgz";
        sha1 = "8d6474c1b870bfdabcd3bcfcc1934a10e94f15f0";
      };
    }
    {
      name = "browserify_des___browserify_des_1.0.1.tgz";
      path = fetchurl {
        name = "browserify_des___browserify_des_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-des/-/browserify-des-1.0.1.tgz";
        sha1 = "3343124db6d7ad53e26a8826318712bdc8450f9c";
      };
    }
    {
      name = "browserify_rsa___browserify_rsa_4.0.1.tgz";
      path = fetchurl {
        name = "browserify_rsa___browserify_rsa_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-rsa/-/browserify-rsa-4.0.1.tgz";
        sha1 = "21e0abfaf6f2029cf2fafb133567a701d4135524";
      };
    }
    {
      name = "browserify_sign___browserify_sign_4.0.4.tgz";
      path = fetchurl {
        name = "browserify_sign___browserify_sign_4.0.4.tgz";
        url  = "https://registry.yarnpkg.com/browserify-sign/-/browserify-sign-4.0.4.tgz";
        sha1 = "aa4eb68e5d7b658baa6bf6a57e630cbd7a93d298";
      };
    }
    {
      name = "browserify_zlib___browserify_zlib_0.2.0.tgz";
      path = fetchurl {
        name = "browserify_zlib___browserify_zlib_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/browserify-zlib/-/browserify-zlib-0.2.0.tgz";
        sha1 = "2869459d9aa3be245fe8fe2ca1f46e2e7f54d73f";
      };
    }
    {
      name = "browserify___browserify_16.2.2.tgz";
      path = fetchurl {
        name = "browserify___browserify_16.2.2.tgz";
        url  = "https://registry.yarnpkg.com/browserify/-/browserify-16.2.2.tgz";
        sha1 = "4b1f66ba0e54fa39dbc5aa4be9629142143d91b0";
      };
    }
    {
      name = "buffer_from___buffer_from_1.1.0.tgz";
      path = fetchurl {
        name = "buffer_from___buffer_from_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.0.tgz";
        sha1 = "87fcaa3a298358e0ade6e442cfce840740d1ad04";
      };
    }
    {
      name = "buffer_xor___buffer_xor_1.0.3.tgz";
      path = fetchurl {
        name = "buffer_xor___buffer_xor_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/buffer-xor/-/buffer-xor-1.0.3.tgz";
        sha1 = "26e61ed1422fb70dd42e6e36729ed51d855fe8d9";
      };
    }
    {
      name = "buffer___buffer_5.1.0.tgz";
      path = fetchurl {
        name = "buffer___buffer_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer/-/buffer-5.1.0.tgz";
        sha1 = "c913e43678c7cb7c8bd16afbcddb6c5505e8f9fe";
      };
    }
    {
      name = "builtin_status_codes___builtin_status_codes_3.0.0.tgz";
      path = fetchurl {
        name = "builtin_status_codes___builtin_status_codes_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz";
        sha1 = "85982878e21b98e1c66425e03d0174788f569ee8";
      };
    }
    {
      name = "cached_path_relative___cached_path_relative_1.1.0.tgz";
      path = fetchurl {
        name = "cached_path_relative___cached_path_relative_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cached-path-relative/-/cached-path-relative-1.1.0.tgz";
        sha512 = "WF0LihfemtesFcJgO7xfOoOcnWzY/QHR4qeDqV44jPU3HTI54+LnfXK3SA27AVVGCdZFgjjFFaqUA9Jx7dMJZA==";
      };
    }
    {
      name = "charm___charm_0.1.2.tgz";
      path = fetchurl {
        name = "charm___charm_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/charm/-/charm-0.1.2.tgz";
        sha1 = "06c21eed1a1b06aeb67553cdc53e23274bac2296";
      };
    }
    {
      name = "chart.js___chart.js_1.0.2.tgz";
      path = fetchurl {
        name = "chart.js___chart.js_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/chart.js/-/chart.js-1.0.2.tgz";
        sha1 = "ad57d2229cfd8ccf5955147e8121b4911e69dfe7";
      };
    }
    {
      name = "cipher_base___cipher_base_1.0.4.tgz";
      path = fetchurl {
        name = "cipher_base___cipher_base_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/cipher-base/-/cipher-base-1.0.4.tgz";
        sha1 = "8760e4ecc272f4c363532f926d874aae2c1397de";
      };
    }
    {
      name = "ckeditor___ckeditor_4.11.3.tgz";
      path = fetchurl {
        name = "ckeditor___ckeditor_4.11.3.tgz";
        url  = "https://registry.yarnpkg.com/ckeditor/-/ckeditor-4.11.3.tgz";
        sha512 = "v6G+v16WAcukKuQH6m+trA9RCOQntFM2nxPO/GFiLYsdD/5IbZAZ2n7GwMxQmxDXpx4AixpnMWF+yAE1t9wq6Q==";
      };
    }
    {
      name = "classie___classie_1.0.0.tgz";
      path = fetchurl {
        name = "classie___classie_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/classie/-/classie-1.0.0.tgz";
        sha1 = "fc9b29b47e64e374a2062fb624d05a61cd703ab2";
      };
    }
    {
      name = "combine_source_map___combine_source_map_0.8.0.tgz";
      path = fetchurl {
        name = "combine_source_map___combine_source_map_0.8.0.tgz";
        url  = "https://registry.yarnpkg.com/combine-source-map/-/combine-source-map-0.8.0.tgz";
        sha1 = "a58d0df042c186fcf822a8e8015f5450d2d79a8b";
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
      name = "console_browserify___console_browserify_1.1.0.tgz";
      path = fetchurl {
        name = "console_browserify___console_browserify_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/console-browserify/-/console-browserify-1.1.0.tgz";
        sha1 = "f0241c45730a9fc6323b206dbf38edc741d0bb10";
      };
    }
    {
      name = "constants_browserify___constants_browserify_1.0.0.tgz";
      path = fetchurl {
        name = "constants_browserify___constants_browserify_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/constants-browserify/-/constants-browserify-1.0.0.tgz";
        sha1 = "c20b96d8c617748aaf1c16021760cd27fcb8cb75";
      };
    }
    {
      name = "convert_source_map___convert_source_map_1.1.3.tgz";
      path = fetchurl {
        name = "convert_source_map___convert_source_map_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.1.3.tgz";
        sha1 = "4829c877e9fe49b3161f3bf3673888e204699860";
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
      name = "create_ecdh___create_ecdh_4.0.3.tgz";
      path = fetchurl {
        name = "create_ecdh___create_ecdh_4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/create-ecdh/-/create-ecdh-4.0.3.tgz";
        sha1 = "c9111b6f33045c4697f144787f9254cdc77c45ff";
      };
    }
    {
      name = "create_hash___create_hash_1.2.0.tgz";
      path = fetchurl {
        name = "create_hash___create_hash_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/create-hash/-/create-hash-1.2.0.tgz";
        sha1 = "889078af11a63756bcfb59bd221996be3a9ef196";
      };
    }
    {
      name = "create_hmac___create_hmac_1.1.7.tgz";
      path = fetchurl {
        name = "create_hmac___create_hmac_1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/create-hmac/-/create-hmac-1.1.7.tgz";
        sha1 = "69170c78b3ab957147b2b8b04572e47ead2243ff";
      };
    }
    {
      name = "crypto_browserify___crypto_browserify_3.12.0.tgz";
      path = fetchurl {
        name = "crypto_browserify___crypto_browserify_3.12.0.tgz";
        url  = "https://registry.yarnpkg.com/crypto-browserify/-/crypto-browserify-3.12.0.tgz";
        sha1 = "396cf9f3137f03e4b8e532c58f698254e00f80ec";
      };
    }
    {
      name = "datatables.net_bs___datatables.net_bs_1.10.19.tgz";
      path = fetchurl {
        name = "datatables.net_bs___datatables.net_bs_1.10.19.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-bs/-/datatables.net-bs-1.10.19.tgz";
        sha512 = "5gxoI2n+duZP06+4xVC2TtH6zcY369/TRKTZ1DdSgDcDUl4OYQsrXCuaLJmbVzna/5Y5lrMmK7CxgvYgIynICA==";
      };
    }
    {
      name = "datatables.net_plugins___datatables.net_plugins_1.10.20.tgz";
      path = fetchurl {
        name = "datatables.net_plugins___datatables.net_plugins_1.10.20.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-plugins/-/datatables.net-plugins-1.10.20.tgz";
        sha512 = "rnhNmRHe9UEzvM7gtjBay1QodkWUmxLUhHNbmJMYhhUggjtm+BRSlE0PRilkeUkwckpNWzq+0fPd7/i0fpQgzA==";
      };
    }
    {
      name = "datatables.net___datatables.net_1.10.19.tgz";
      path = fetchurl {
        name = "datatables.net___datatables.net_1.10.19.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net/-/datatables.net-1.10.19.tgz";
        sha512 = "+ljXcI6Pj3PTGy5pesp3E5Dr3x3AV45EZe0o1r0gKENN2gafBKXodVnk2ypKwl2tTmivjxbkiqoWnipTefyBTA==";
      };
    }
    {
      name = "date_now___date_now_0.1.4.tgz";
      path = fetchurl {
        name = "date_now___date_now_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/date-now/-/date-now-0.1.4.tgz";
        sha1 = "eaf439fd4d4848ad74e5cc7dbef200672b9e345b";
      };
    }
    {
      name = "defined___defined_1.0.0.tgz";
      path = fetchurl {
        name = "defined___defined_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/defined/-/defined-1.0.0.tgz";
        sha1 = "c98d9bcef75674188e110969151199e39b1fa693";
      };
    }
    {
      name = "deps_sort___deps_sort_2.0.0.tgz";
      path = fetchurl {
        name = "deps_sort___deps_sort_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/deps-sort/-/deps-sort-2.0.0.tgz";
        sha1 = "091724902e84658260eb910748cccd1af6e21fb5";
      };
    }
    {
      name = "des.js___des.js_1.0.0.tgz";
      path = fetchurl {
        name = "des.js___des.js_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/des.js/-/des.js-1.0.0.tgz";
        sha1 = "c074d2e2aa6a8a9a07dbd61f9a15c2cd83ec8ecc";
      };
    }
    {
      name = "detective___detective_5.1.0.tgz";
      path = fetchurl {
        name = "detective___detective_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/detective/-/detective-5.1.0.tgz";
        sha1 = "7a20d89236d7b331ccea65832e7123b5551bb7cb";
      };
    }
    {
      name = "diffie_hellman___diffie_hellman_5.0.3.tgz";
      path = fetchurl {
        name = "diffie_hellman___diffie_hellman_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/diffie-hellman/-/diffie-hellman-5.0.3.tgz";
        sha1 = "40e8ee98f55a2149607146921c63e1ae5f3d2875";
      };
    }
    {
      name = "domain_browser___domain_browser_1.2.0.tgz";
      path = fetchurl {
        name = "domain_browser___domain_browser_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/domain-browser/-/domain-browser-1.2.0.tgz";
        sha1 = "3d31f50191a6749dd1375a7f522e823d42e54eda";
      };
    }
    {
      name = "domhelper___domhelper_0.9.1.tgz";
      path = fetchurl {
        name = "domhelper___domhelper_0.9.1.tgz";
        url  = "https://registry.yarnpkg.com/domhelper/-/domhelper-0.9.1.tgz";
        sha1 = "26554e5bac2c9e9585dca500978df5067d64bd00";
      };
    }
    {
      name = "duplexer2___duplexer2_0.1.4.tgz";
      path = fetchurl {
        name = "duplexer2___duplexer2_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/duplexer2/-/duplexer2-0.1.4.tgz";
        sha1 = "8b12dab878c0d69e3e7891051662a32fc6bddcc1";
      };
    }
    {
      name = "elliptic___elliptic_6.5.4.tgz";
      path = fetchurl {
        name = "elliptic___elliptic_6.5.4.tgz";
        url  = "https://registry.yarnpkg.com/elliptic/-/elliptic-6.5.4.tgz";
        sha512 = "iLhC6ULemrljPZb+QutR5TQGB+pdW6KGD5RSegS+8sorOZT+rdQFbsQFJgvN3eRqNALqJer4oQ16YvJHlU8hzQ==";
      };
    }
    {
      name = "eve_raphael___eve_raphael_0.5.0.tgz";
      path = fetchurl {
        name = "eve_raphael___eve_raphael_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/eve-raphael/-/eve-raphael-0.5.0.tgz";
        sha1 = "17c754b792beef3fa6684d79cf5a47c63c4cda30";
      };
    }
    {
      name = "events___events_2.1.0.tgz";
      path = fetchurl {
        name = "events___events_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/events/-/events-2.1.0.tgz";
        sha1 = "2a9a1e18e6106e0e812aa9ebd4a819b3c29c0ba5";
      };
    }
    {
      name = "evp_bytestokey___evp_bytestokey_1.0.3.tgz";
      path = fetchurl {
        name = "evp_bytestokey___evp_bytestokey_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz";
        sha1 = "7fcbdb198dc71959432efe13842684e0525acb02";
      };
    }
    {
      name = "fastclick___fastclick_1.0.6.tgz";
      path = fetchurl {
        name = "fastclick___fastclick_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fastclick/-/fastclick-1.0.6.tgz";
        sha1 = "161625b27b1a5806405936bda9a2c1926d06be6a";
      };
    }
    {
      name = "flot___flot_0.8.3.tgz";
      path = fetchurl {
        name = "flot___flot_0.8.3.tgz";
        url  = "https://registry.yarnpkg.com/flot/-/flot-0.8.3.tgz";
        sha512 = "xg2otcTJDvS+ERK+my4wxG/ASq90QURXtoM4LhacCq0jQW2jbyjdttbRNqU2cPykrpMvJ6b2uSp6SAgYAzj9tQ==";
      };
    }
    {
      name = "font_awesome___font_awesome_4.7.0.tgz";
      path = fetchurl {
        name = "font_awesome___font_awesome_4.7.0.tgz";
        url  = "https://registry.yarnpkg.com/font-awesome/-/font-awesome-4.7.0.tgz";
        sha1 = "8fa8cf0411a1a31afd07b06d2902bb9fc815a133";
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
      name = "fullcalendar___fullcalendar_3.10.0.tgz";
      path = fetchurl {
        name = "fullcalendar___fullcalendar_3.10.0.tgz";
        url  = "https://registry.yarnpkg.com/fullcalendar/-/fullcalendar-3.10.0.tgz";
        sha512 = "0OtsHhmdYhtFmQwXzyo8VqHzYgamg+zVOoytv5N13gI+iF6CGjevpCi/yBaQs0O4wY3OAp8I688IxdNYe0iAvw==";
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
      name = "glob___glob_7.1.2.tgz";
      path = fetchurl {
        name = "glob___glob_7.1.2.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.2.tgz";
        sha1 = "c19c9df9a028702d678612384a6552404c636d15";
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
      name = "hash_base___hash_base_3.0.4.tgz";
      path = fetchurl {
        name = "hash_base___hash_base_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/hash-base/-/hash-base-3.0.4.tgz";
        sha1 = "5fc8686847ecd73499403319a6b0a3f3f6ae4918";
      };
    }
    {
      name = "hash.js___hash.js_1.1.7.tgz";
      path = fetchurl {
        name = "hash.js___hash.js_1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/hash.js/-/hash.js-1.1.7.tgz";
        sha512 = "taOaskGt4z4SOANNseOviYDvjEJinIkRgmp7LbKP2YTTmVxWBl87s/uzK9r+44BclBSp2X7K1hqeNfz9JbBeXA==";
      };
    }
    {
      name = "hmac_drbg___hmac_drbg_1.0.1.tgz";
      path = fetchurl {
        name = "hmac_drbg___hmac_drbg_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/hmac-drbg/-/hmac-drbg-1.0.1.tgz";
        sha1 = "0nRXAQJabHdabFRXk+1QL8DGSaE=";
      };
    }
    {
      name = "htmlescape___htmlescape_1.1.1.tgz";
      path = fetchurl {
        name = "htmlescape___htmlescape_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/htmlescape/-/htmlescape-1.1.1.tgz";
        sha1 = "3a03edc2214bca3b66424a3e7959349509cb0351";
      };
    }
    {
      name = "https_browserify___https_browserify_1.0.0.tgz";
      path = fetchurl {
        name = "https_browserify___https_browserify_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/https-browserify/-/https-browserify-1.0.0.tgz";
        sha1 = "ec06c10e0a34c0f2faf199f7fd7fc78fffd03c73";
      };
    }
    {
      name = "icheck___icheck_1.0.2.tgz";
      path = fetchurl {
        name = "icheck___icheck_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/icheck/-/icheck-1.0.2.tgz";
        sha1 = "06d08da3d47ae448c153b2639b86e9ad7fdf7128";
      };
    }
    {
      name = "ieee754___ieee754_1.1.12.tgz";
      path = fetchurl {
        name = "ieee754___ieee754_1.1.12.tgz";
        url  = "https://registry.yarnpkg.com/ieee754/-/ieee754-1.1.12.tgz";
        sha1 = "50bf24e5b9c8bb98af4964c941cdb0918da7b60b";
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
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
      };
    }
    {
      name = "inherits___inherits_2.0.1.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      };
    }
    {
      name = "inherits___inherits_2.0.3.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz";
        sha1 = "633c2c83e3da42a502f52466022480f4208261de";
      };
    }
    {
      name = "inline_source_map___inline_source_map_0.6.2.tgz";
      path = fetchurl {
        name = "inline_source_map___inline_source_map_0.6.2.tgz";
        url  = "https://registry.yarnpkg.com/inline-source-map/-/inline-source-map-0.6.2.tgz";
        sha1 = "f9393471c18a79d1724f863fa38b586370ade2a5";
      };
    }
    {
      name = "inputmask___inputmask_3.3.11.tgz";
      path = fetchurl {
        name = "inputmask___inputmask_3.3.11.tgz";
        url  = "https://registry.yarnpkg.com/inputmask/-/inputmask-3.3.11.tgz";
        sha1 = "1421c94ae28c3dcd1b4d26337b508bb34998e2d8";
      };
    }
    {
      name = "insert_module_globals___insert_module_globals_7.1.0.tgz";
      path = fetchurl {
        name = "insert_module_globals___insert_module_globals_7.1.0.tgz";
        url  = "https://registry.yarnpkg.com/insert-module-globals/-/insert-module-globals-7.1.0.tgz";
        sha1 = "dbb3cea71d3a43d5a07ef0310fe5f078aa4dbf35";
      };
    }
    {
      name = "ion_rangeslider___ion_rangeslider_2.3.0.tgz";
      path = fetchurl {
        name = "ion_rangeslider___ion_rangeslider_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ion-rangeslider/-/ion-rangeslider-2.3.0.tgz";
        sha512 = "7TtH9/X4Aq/xCzboWxjwlv20gVqR90Ysc3aehMlTuH2/ULaSxpB80hq+yvD1N0FwWbPDtxQpjQrz/iX+LWXKmg==";
      };
    }
    {
      name = "ionicons___ionicons_3.0.0.tgz";
      path = fetchurl {
        name = "ionicons___ionicons_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ionicons/-/ionicons-3.0.0.tgz";
        sha1 = "40b8daf4fd7a31150bd002160f66496e22a98c3c";
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
      name = "isarray___isarray_2.0.4.tgz";
      path = fetchurl {
        name = "isarray___isarray_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-2.0.4.tgz";
        sha1 = "38e7bcbb0f3ba1b7933c86ba1894ddfc3781bbb7";
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
      name = "jquery_knob___jquery_knob_1.2.11.tgz";
      path = fetchurl {
        name = "jquery_knob___jquery_knob_1.2.11.tgz";
        url  = "https://registry.yarnpkg.com/jquery-knob/-/jquery-knob-1.2.11.tgz";
        sha1 = "f37c39dbc1c7a6a6c12cdb2ed4f6bffb683f10d6";
      };
    }
    {
      name = "jquery_mousewheel___jquery_mousewheel_3.1.13.tgz";
      path = fetchurl {
        name = "jquery_mousewheel___jquery_mousewheel_3.1.13.tgz";
        url  = "https://registry.yarnpkg.com/jquery-mousewheel/-/jquery-mousewheel-3.1.13.tgz";
        sha1 = "06f0335f16e353a695e7206bf50503cb523a6ee5";
      };
    }
    {
      name = "jquery_slimscroll___jquery_slimscroll_1.3.8.tgz";
      path = fetchurl {
        name = "jquery_slimscroll___jquery_slimscroll_1.3.8.tgz";
        url  = "https://registry.yarnpkg.com/jquery-slimscroll/-/jquery-slimscroll-1.3.8.tgz";
        sha1 = "8481c44e7a47687653908a28f7f70aed64c84e36";
      };
    }
    {
      name = "jquery_sparkline___jquery_sparkline_2.4.0.tgz";
      path = fetchurl {
        name = "jquery_sparkline___jquery_sparkline_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/jquery-sparkline/-/jquery-sparkline-2.4.0.tgz";
        sha1 = "1be8b7b704dd3857152708aefb1d4a4b3a69fb33";
      };
    }
    {
      name = "jquery_ui_dist___jquery_ui_dist_1.12.1.tgz";
      path = fetchurl {
        name = "jquery_ui_dist___jquery_ui_dist_1.12.1.tgz";
        url  = "https://registry.yarnpkg.com/jquery-ui-dist/-/jquery-ui-dist-1.12.1.tgz";
        sha1 = "5c0815d3cc6f90ff5faaf5b268a6e23b4ca904fa";
      };
    }
    {
      name = "jquery_ui___jquery_ui_1.13.0.tgz";
      path = fetchurl {
        name = "jquery_ui___jquery_ui_1.13.0.tgz";
        url  = "https://registry.yarnpkg.com/jquery-ui/-/jquery-ui-1.13.0.tgz";
        sha512 = "Osf7ECXNTYHtKBkn9xzbIf9kifNrBhfywFEKxOeB/OVctVmLlouV9mfc2qXCp6uyO4Pn72PXKOnj09qXetopCw==";
      };
    }
    {
      name = "jquery.quicksearch___jquery.quicksearch_2.4.0.tgz";
      path = fetchurl {
        name = "jquery.quicksearch___jquery.quicksearch_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/jquery.quicksearch/-/jquery.quicksearch-2.4.0.tgz";
        sha512 = "20FJSCW3kTawO6Jvy/6MtUCURvgUZFqRUOAGTxH/VaPlwLG4kba82sKaM3ghTi1DsmSZrM2BvrwLUwNWmwDXiw==";
      };
    }
    {
      name = "jquery___jquery_3.6.0.tgz";
      path = fetchurl {
        name = "jquery___jquery_3.6.0.tgz";
        url  = "https://registry.yarnpkg.com/jquery/-/jquery-3.6.0.tgz";
        sha512 = "JVzAR/AjBvVt2BmYhxRCSYysDsPcssdmTFnzyLEts9qNwmjmu4JTAMYubEfwVOSwpQ1I1sKKFcxhZCI2buerfw==";
      };
    }
    {
      name = "json_stable_stringify___json_stable_stringify_0.0.1.tgz";
      path = fetchurl {
        name = "json_stable_stringify___json_stable_stringify_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stable-stringify/-/json-stable-stringify-0.0.1.tgz";
        sha1 = "611c23e814db375527df851193db59dd2af27f45";
      };
    }
    {
      name = "jsonify___jsonify_0.0.0.tgz";
      path = fetchurl {
        name = "jsonify___jsonify_0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonify/-/jsonify-0.0.0.tgz";
        sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
      };
    }
    {
      name = "jsonparse___jsonparse_1.3.1.tgz";
      path = fetchurl {
        name = "jsonparse___jsonparse_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/jsonparse/-/jsonparse-1.3.1.tgz";
        sha1 = "3f4dae4a91fac315f71062f8521cc239f1366280";
      };
    }
    {
      name = "jtimeout___jtimeout_3.1.0.tgz";
      path = fetchurl {
        name = "jtimeout___jtimeout_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/jtimeout/-/jtimeout-3.1.0.tgz";
        sha512 = "xA2TlImMGj4c0yAiM9BUq+8aAFVYVYUX2tkcC8u8das9qoZSs13SxhVcfWqI4cHOsv3huj2D0VRNHeVCLO3mVQ==";
      };
    }
    {
      name = "jvectormap___jvectormap_1.2.2.tgz";
      path = fetchurl {
        name = "jvectormap___jvectormap_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/jvectormap/-/jvectormap-1.2.2.tgz";
        sha1 = "2e4408b24a60473ff106c1e7243e375ae5ca85da";
      };
    }
    {
      name = "labeled_stream_splicer___labeled_stream_splicer_2.0.1.tgz";
      path = fetchurl {
        name = "labeled_stream_splicer___labeled_stream_splicer_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/labeled-stream-splicer/-/labeled-stream-splicer-2.0.1.tgz";
        sha1 = "9cffa32fd99e1612fd1d86a8db962416d5292926";
      };
    }
    {
      name = "lexical_scope___lexical_scope_1.2.0.tgz";
      path = fetchurl {
        name = "lexical_scope___lexical_scope_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lexical-scope/-/lexical-scope-1.2.0.tgz";
        sha1 = "fcea5edc704a4b3a8796cdca419c3a0afaf22df4";
      };
    }
    {
      name = "lodash.memoize___lodash.memoize_3.0.4.tgz";
      path = fetchurl {
        name = "lodash.memoize___lodash.memoize_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/lodash.memoize/-/lodash.memoize-3.0.4.tgz";
        sha1 = "2dcbd2c287cbc0a55cc42328bd0c736150d53e3f";
      };
    }
    {
      name = "md5.js___md5.js_1.3.4.tgz";
      path = fetchurl {
        name = "md5.js___md5.js_1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/md5.js/-/md5.js-1.3.4.tgz";
        sha1 = "e9bdbde94a20a5ac18b04340fc5764d5b09d901d";
      };
    }
    {
      name = "miller_rabin___miller_rabin_4.0.1.tgz";
      path = fetchurl {
        name = "miller_rabin___miller_rabin_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/miller-rabin/-/miller-rabin-4.0.1.tgz";
        sha1 = "f080351c865b0dc562a8462966daa53543c78a4d";
      };
    }
    {
      name = "minimalistic_assert___minimalistic_assert_1.0.1.tgz";
      path = fetchurl {
        name = "minimalistic_assert___minimalistic_assert_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz";
        sha512 = "UtJcAD4yEaGtjPezWuO9wC4nwUnVH/8/Im3yEHQP4b67cXlD/Qr9hdITCU1xDbSEXg2XKNaP8jsReV7vQd00/A==";
      };
    }
    {
      name = "minimalistic_crypto_utils___minimalistic_crypto_utils_1.0.1.tgz";
      path = fetchurl {
        name = "minimalistic_crypto_utils___minimalistic_crypto_utils_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz";
        sha1 = "9sAMHAsIIkblxNmd+4x8CDsrWCo=";
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
      name = "module_deps___module_deps_6.1.0.tgz";
      path = fetchurl {
        name = "module_deps___module_deps_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/module-deps/-/module-deps-6.1.0.tgz";
        sha1 = "d1e1efc481c6886269f7112c52c3236188e16479";
      };
    }
    {
      name = "moment___moment_2.29.2.tgz";
      path = fetchurl {
        name = "moment___moment_2.29.2.tgz";
        url  = "https://registry.yarnpkg.com/moment/-/moment-2.29.2.tgz";
        sha512 = "UgzG4rvxYpN15jgCmVJwac49h9ly9NurikMWGPdVxm8GZD6XjkKPxDTjQQ43gtGgnV3X0cAyWDdP2Wexoquifg==";
      };
    }
    {
      name = "morris.js___morris.js_0.5.0.tgz";
      path = fetchurl {
        name = "morris.js___morris.js_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/morris.js/-/morris.js-0.5.0.tgz";
        sha1 = "725767135cfae059aae75999bb2ce6a1c5d1b44b";
      };
    }
    {
      name = "multiselect___multiselect_0.9.12.tgz";
      path = fetchurl {
        name = "multiselect___multiselect_0.9.12.tgz";
        url  = "https://registry.yarnpkg.com/multiselect/-/multiselect-0.9.12.tgz";
        sha1 = "d15536e986dd6a0029b160d6613bcedf81e4c7ed";
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
      name = "os_browserify___os_browserify_0.3.0.tgz";
      path = fetchurl {
        name = "os_browserify___os_browserify_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/os-browserify/-/os-browserify-0.3.0.tgz";
        sha1 = "854373c7f5c2315914fc9bfc6bd8238fdda1ec27";
      };
    }
    {
      name = "pace___pace_0.0.4.tgz";
      path = fetchurl {
        name = "pace___pace_0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/pace/-/pace-0.0.4.tgz";
        sha1 = "d66405d5f5bc12d25441a6e26c878dbc69e77a77";
      };
    }
    {
      name = "pako___pako_1.0.6.tgz";
      path = fetchurl {
        name = "pako___pako_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/pako/-/pako-1.0.6.tgz";
        sha1 = "0101211baa70c4bca4a0f63f2206e97b7dfaf258";
      };
    }
    {
      name = "parents___parents_1.0.1.tgz";
      path = fetchurl {
        name = "parents___parents_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/parents/-/parents-1.0.1.tgz";
        sha1 = "fedd4d2bf193a77745fe71e371d73c3307d9c751";
      };
    }
    {
      name = "parse_asn1___parse_asn1_5.1.1.tgz";
      path = fetchurl {
        name = "parse_asn1___parse_asn1_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/parse-asn1/-/parse-asn1-5.1.1.tgz";
        sha1 = "f6bf293818332bd0dab54efb16087724745e6ca8";
      };
    }
    {
      name = "path_browserify___path_browserify_0.0.0.tgz";
      path = fetchurl {
        name = "path_browserify___path_browserify_0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-browserify/-/path-browserify-0.0.0.tgz";
        sha1 = "a0b870729aae214005b7d5032ec2cbbb0fb4451a";
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
      name = "path_parse___path_parse_1.0.7.tgz";
      path = fetchurl {
        name = "path_parse___path_parse_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz";
        sha512 = "LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==";
      };
    }
    {
      name = "path_platform___path_platform_0.11.15.tgz";
      path = fetchurl {
        name = "path_platform___path_platform_0.11.15.tgz";
        url  = "https://registry.yarnpkg.com/path-platform/-/path-platform-0.11.15.tgz";
        sha1 = "e864217f74c36850f0852b78dc7bf7d4a5721bf2";
      };
    }
    {
      name = "pbkdf2___pbkdf2_3.0.16.tgz";
      path = fetchurl {
        name = "pbkdf2___pbkdf2_3.0.16.tgz";
        url  = "https://registry.yarnpkg.com/pbkdf2/-/pbkdf2-3.0.16.tgz";
        sha1 = "7404208ec6b01b62d85bf83853a8064f8d9c2a5c";
      };
    }
    {
      name = "process_nextick_args___process_nextick_args_2.0.0.tgz";
      path = fetchurl {
        name = "process_nextick_args___process_nextick_args_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.0.tgz";
        sha1 = "a37d732f4271b4ab1ad070d35508e8290788ffaa";
      };
    }
    {
      name = "process___process_0.11.10.tgz";
      path = fetchurl {
        name = "process___process_0.11.10.tgz";
        url  = "https://registry.yarnpkg.com/process/-/process-0.11.10.tgz";
        sha1 = "7332300e840161bda3e69a1d1d91a7d4bc16f182";
      };
    }
    {
      name = "public_encrypt___public_encrypt_4.0.2.tgz";
      path = fetchurl {
        name = "public_encrypt___public_encrypt_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/public-encrypt/-/public-encrypt-4.0.2.tgz";
        sha1 = "46eb9107206bf73489f8b85b69d91334c6610994";
      };
    }
    {
      name = "punycode___punycode_1.3.2.tgz";
      path = fetchurl {
        name = "punycode___punycode_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-1.3.2.tgz";
        sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
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
      name = "querystring_es3___querystring_es3_0.2.1.tgz";
      path = fetchurl {
        name = "querystring_es3___querystring_es3_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/querystring-es3/-/querystring-es3-0.2.1.tgz";
        sha1 = "9ec61f79049875707d69414596fd907a4d711e73";
      };
    }
    {
      name = "querystring___querystring_0.2.0.tgz";
      path = fetchurl {
        name = "querystring___querystring_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/querystring/-/querystring-0.2.0.tgz";
        sha1 = "b209849203bb25df820da756e747005878521620";
      };
    }
    {
      name = "randombytes___randombytes_2.0.6.tgz";
      path = fetchurl {
        name = "randombytes___randombytes_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/randombytes/-/randombytes-2.0.6.tgz";
        sha1 = "d302c522948588848a8d300c932b44c24231da80";
      };
    }
    {
      name = "randomfill___randomfill_1.0.4.tgz";
      path = fetchurl {
        name = "randomfill___randomfill_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/randomfill/-/randomfill-1.0.4.tgz";
        sha1 = "c92196fc86ab42be983f1bf31778224931d61458";
      };
    }
    {
      name = "raphael___raphael_2.2.7.tgz";
      path = fetchurl {
        name = "raphael___raphael_2.2.7.tgz";
        url  = "https://registry.yarnpkg.com/raphael/-/raphael-2.2.7.tgz";
        sha1 = "231b19141f8d086986d8faceb66f8b562ee2c810";
      };
    }
    {
      name = "read_only_stream___read_only_stream_2.0.0.tgz";
      path = fetchurl {
        name = "read_only_stream___read_only_stream_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/read-only-stream/-/read-only-stream-2.0.0.tgz";
        sha1 = "2724fd6a8113d73764ac288d4386270c1dbf17f0";
      };
    }
    {
      name = "readable_stream___readable_stream_2.3.6.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_2.3.6.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.6.tgz";
        sha1 = "b11c27d88b8ff1fbe070643cf94b0c79ae1b0aaf";
      };
    }
    {
      name = "resolve___resolve_1.1.7.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.1.7.tgz";
        sha1 = "203114d82ad2c5ed9e8e0411b3932875e889e97b";
      };
    }
    {
      name = "resolve___resolve_1.7.1.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.7.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.7.1.tgz";
        sha1 = "aadd656374fd298aee895bc026b8297418677fd3";
      };
    }
    {
      name = "ripemd160___ripemd160_2.0.2.tgz";
      path = fetchurl {
        name = "ripemd160___ripemd160_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ripemd160/-/ripemd160-2.0.2.tgz";
        sha1 = "a1c1a6f624751577ba5d07914cbc92850585890c";
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
      name = "select2___select2_4.0.5.tgz";
      path = fetchurl {
        name = "select2___select2_4.0.5.tgz";
        url  = "https://registry.yarnpkg.com/select2/-/select2-4.0.5.tgz";
        sha1 = "7aac50692561985b34d3b82ec55e226f8960d40a";
      };
    }
    {
      name = "sha.js___sha.js_2.4.11.tgz";
      path = fetchurl {
        name = "sha.js___sha.js_2.4.11.tgz";
        url  = "https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.11.tgz";
        sha1 = "37a5cf0b81ecbc6943de109ba2960d1b26584ae7";
      };
    }
    {
      name = "shasum___shasum_1.0.2.tgz";
      path = fetchurl {
        name = "shasum___shasum_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/shasum/-/shasum-1.0.2.tgz";
        sha1 = "e7012310d8f417f4deb5712150e5678b87ae565f";
      };
    }
    {
      name = "shell_quote___shell_quote_1.7.3.tgz";
      path = fetchurl {
        name = "shell_quote___shell_quote_1.7.3.tgz";
        url  = "https://registry.yarnpkg.com/shell-quote/-/shell-quote-1.7.3.tgz";
        sha512 = "Vpfqwm4EnqGdlsBFNmHhxhElJYrdfcxPThu+ryKS5J8L/fhAwLazFZtq+S+TWZ9ANj2piSQLGj6NQg+lKPmxrw==";
      };
    }
    {
      name = "slimscroll___slimscroll_0.9.1.tgz";
      path = fetchurl {
        name = "slimscroll___slimscroll_0.9.1.tgz";
        url  = "https://registry.yarnpkg.com/slimscroll/-/slimscroll-0.9.1.tgz";
        sha1 = "f675cdc601d80ada20f16004d227d156fd1187b2";
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
      name = "stream_browserify___stream_browserify_2.0.1.tgz";
      path = fetchurl {
        name = "stream_browserify___stream_browserify_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/stream-browserify/-/stream-browserify-2.0.1.tgz";
        sha1 = "66266ee5f9bdb9940a4e4514cafb43bb71e5c9db";
      };
    }
    {
      name = "stream_combiner2___stream_combiner2_1.1.1.tgz";
      path = fetchurl {
        name = "stream_combiner2___stream_combiner2_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/stream-combiner2/-/stream-combiner2-1.1.1.tgz";
        sha1 = "fb4d8a1420ea362764e21ad4780397bebcb41cbe";
      };
    }
    {
      name = "stream_http___stream_http_2.8.3.tgz";
      path = fetchurl {
        name = "stream_http___stream_http_2.8.3.tgz";
        url  = "https://registry.yarnpkg.com/stream-http/-/stream-http-2.8.3.tgz";
        sha1 = "b2d242469288a5a27ec4fe8933acf623de6514fc";
      };
    }
    {
      name = "stream_splicer___stream_splicer_2.0.0.tgz";
      path = fetchurl {
        name = "stream_splicer___stream_splicer_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-splicer/-/stream-splicer-2.0.0.tgz";
        sha1 = "1b63be438a133e4b671cc1935197600175910d83";
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
      name = "subarg___subarg_1.0.0.tgz";
      path = fetchurl {
        name = "subarg___subarg_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/subarg/-/subarg-1.0.0.tgz";
        sha1 = "f62cf17581e996b48fc965699f54c06ae268b8d2";
      };
    }
    {
      name = "syntax_error___syntax_error_1.4.0.tgz";
      path = fetchurl {
        name = "syntax_error___syntax_error_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/syntax-error/-/syntax-error-1.4.0.tgz";
        sha1 = "2d9d4ff5c064acb711594a3e3b95054ad51d907c";
      };
    }
    {
      name = "through2___through2_2.0.3.tgz";
      path = fetchurl {
        name = "through2___through2_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-2.0.3.tgz";
        sha1 = "0004569b37c7c74ba39c43f3ced78d1ad94140be";
      };
    }
    {
      name = "through___through_2.3.8.tgz";
      path = fetchurl {
        name = "through___through_2.3.8.tgz";
        url  = "https://registry.yarnpkg.com/through/-/through-2.3.8.tgz";
        sha1 = "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5";
      };
    }
    {
      name = "timers_browserify___timers_browserify_1.4.2.tgz";
      path = fetchurl {
        name = "timers_browserify___timers_browserify_1.4.2.tgz";
        url  = "https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-1.4.2.tgz";
        sha1 = "c9c58b575be8407375cb5e2462dacee74359f41d";
      };
    }
    {
      name = "to_arraybuffer___to_arraybuffer_1.0.1.tgz";
      path = fetchurl {
        name = "to_arraybuffer___to_arraybuffer_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz";
        sha1 = "7d229b1fcc637e466ca081180836a7aabff83f43";
      };
    }
    {
      name = "tty_browserify___tty_browserify_0.0.1.tgz";
      path = fetchurl {
        name = "tty_browserify___tty_browserify_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/tty-browserify/-/tty-browserify-0.0.1.tgz";
        sha1 = "3f05251ee17904dfd0677546670db9651682b811";
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
      name = "umd___umd_3.0.3.tgz";
      path = fetchurl {
        name = "umd___umd_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/umd/-/umd-3.0.3.tgz";
        sha1 = "aa9fe653c42b9097678489c01000acb69f0b26cf";
      };
    }
    {
      name = "url___url_0.11.0.tgz";
      path = fetchurl {
        name = "url___url_0.11.0.tgz";
        url  = "https://registry.yarnpkg.com/url/-/url-0.11.0.tgz";
        sha1 = "3838e97cfc60521eb73c525a8e55bfdd9e2e28f1";
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
      name = "util_extend___util_extend_1.0.3.tgz";
      path = fetchurl {
        name = "util_extend___util_extend_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/util-extend/-/util-extend-1.0.3.tgz";
        sha1 = "a7c216d267545169637b3b6edc6ca9119e2ff93f";
      };
    }
    {
      name = "util___util_0.10.3.tgz";
      path = fetchurl {
        name = "util___util_0.10.3.tgz";
        url  = "https://registry.yarnpkg.com/util/-/util-0.10.3.tgz";
        sha1 = "7afb1afe50805246489e3db7fe0ed379336ac0f9";
      };
    }
    {
      name = "util___util_0.10.4.tgz";
      path = fetchurl {
        name = "util___util_0.10.4.tgz";
        url  = "https://registry.yarnpkg.com/util/-/util-0.10.4.tgz";
        sha1 = "3aa0125bfe668a4672de58857d3ace27ecb76901";
      };
    }
    {
      name = "vm_browserify___vm_browserify_1.0.1.tgz";
      path = fetchurl {
        name = "vm_browserify___vm_browserify_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/vm-browserify/-/vm-browserify-1.0.1.tgz";
        sha1 = "a15d7762c4c48fa6bf9f3309a21340f00ed23063";
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
      name = "xtend___xtend_4.0.1.tgz";
      path = fetchurl {
        name = "xtend___xtend_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.1.tgz";
        sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
      };
    }
  ];
}
