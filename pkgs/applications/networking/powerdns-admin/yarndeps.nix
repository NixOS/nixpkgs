{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "_foliojs_fork_fontkit___fontkit_1.9.1.tgz";
      path = fetchurl {
        name = "_foliojs_fork_fontkit___fontkit_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/@foliojs-fork/fontkit/-/fontkit-1.9.1.tgz";
        sha512 = "U589voc2/ROnvx1CyH9aNzOQWJp127JGU1QAylXGQ7LoEAF6hMmahZLQ4eqAcgHUw+uyW4PjtCItq9qudPkK3A==";
      };
    }
    {
      name = "_foliojs_fork_linebreak___linebreak_1.1.1.tgz";
      path = fetchurl {
        name = "_foliojs_fork_linebreak___linebreak_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@foliojs-fork/linebreak/-/linebreak-1.1.1.tgz";
        sha512 = "pgY/+53GqGQI+mvDiyprvPWgkTlVBS8cxqee03ejm6gKAQNsR1tCYCIvN9FHy7otZajzMqCgPOgC4cHdt4JPig==";
      };
    }
    {
      name = "_foliojs_fork_pdfkit___pdfkit_0.13.0.tgz";
      path = fetchurl {
        name = "_foliojs_fork_pdfkit___pdfkit_0.13.0.tgz";
        url  = "https://registry.yarnpkg.com/@foliojs-fork/pdfkit/-/pdfkit-0.13.0.tgz";
        sha512 = "YXeG1fml9k97YNC9K8e292Pj2JzGt9uOIiBFuQFxHsdQ45BlxW+JU3RQK6JAvXU7kjhjP8rCcYvpk36JLD33sQ==";
      };
    }
    {
      name = "_foliojs_fork_restructure___restructure_2.0.2.tgz";
      path = fetchurl {
        name = "_foliojs_fork_restructure___restructure_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/@foliojs-fork/restructure/-/restructure-2.0.2.tgz";
        sha512 = "59SgoZ3EXbkfSX7b63tsou/SDGzwUEK6MuB5sKqgVK1/XE0fxmpsOb9DQI8LXW3KfGnAjImCGhhEb7uPPAUVNA==";
      };
    }
    {
      name = "_fortawesome_fontawesome_free___fontawesome_free_6.3.0.tgz";
      path = fetchurl {
        name = "_fortawesome_fontawesome_free___fontawesome_free_6.3.0.tgz";
        url  = "https://registry.yarnpkg.com/@fortawesome/fontawesome-free/-/fontawesome-free-6.3.0.tgz";
        sha512 = "qVtd5i1Cc7cdrqnTWqTObKQHjPWAiRwjUPaXObaeNPcy7+WKxJumGBx66rfSFgK6LNpIasVKkEgW8oyf0tmPLA==";
      };
    }
    {
      name = "_lgaitan_pace_progress___pace_progress_1.0.7.tgz";
      path = fetchurl {
        name = "_lgaitan_pace_progress___pace_progress_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/@lgaitan/pace-progress/-/pace-progress-1.0.7.tgz";
        sha512 = "GMoTcF6WBpno7a7Iyx7M79os26d5bCDbh7YTZmXZM8YuLR3DDtwo0/CBYddStGD6QIBTieFDz4IAQiO0dAdRGw==";
      };
    }
    {
      name = "_sweetalert2_theme_bootstrap_4___theme_bootstrap_4_5.0.15.tgz";
      path = fetchurl {
        name = "_sweetalert2_theme_bootstrap_4___theme_bootstrap_4_5.0.15.tgz";
        url  = "https://registry.yarnpkg.com/@sweetalert2/theme-bootstrap-4/-/theme-bootstrap-4-5.0.15.tgz";
        sha512 = "WsGXk67Yz3Txe3lJA4FNqQCKbQQ6yJLpVUknyGcoESVvwHm+UBBlIMHAcKuLvF+WXK9Rbq8gXhpDIU8ISoiPlQ==";
      };
    }
    {
      name = "_ttskch_select2_bootstrap4_theme___select2_bootstrap4_theme_1.5.2.tgz";
      path = fetchurl {
        name = "_ttskch_select2_bootstrap4_theme___select2_bootstrap4_theme_1.5.2.tgz";
        url  = "https://registry.yarnpkg.com/@ttskch/select2-bootstrap4-theme/-/select2-bootstrap4-theme-1.5.2.tgz";
        sha512 = "gAj8qNy/VYwQDBkACm0USM66kxFai8flX83ayRXPNhzZckEgSqIBB9sM74SCM3ssgeX+ZVy4BifTnLis+KpIyg==";
      };
    }
    {
      name = "acorn_node___acorn_node_1.8.2.tgz";
      path = fetchurl {
        name = "acorn_node___acorn_node_1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/acorn-node/-/acorn-node-1.8.2.tgz";
        sha512 = "8mt+fslDufLYntIoPAaIMUe/lrbrehIiwmR3t2k9LljIzoigEPF27eLk2hy8zSGzmR/ogr7zbRKINMo1u0yh5A==";
      };
    }
    {
      name = "acorn_walk___acorn_walk_7.2.0.tgz";
      path = fetchurl {
        name = "acorn_walk___acorn_walk_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-7.2.0.tgz";
        sha512 = "OPdCF6GsMIP+Az+aWfAAOEt2/+iVDKE7oy6lJ098aoe59oAmK76qV6Gw60SbZ8jHuG2wH058GF4pLFbYamYrVA==";
      };
    }
    {
      name = "acorn___acorn_7.4.1.tgz";
      path = fetchurl {
        name = "acorn___acorn_7.4.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz";
        sha512 = "nQyp0o1/mNdbTO1PO6kHkwSrmgZ0MT/jCCpNiwbUjGoRN4dlBhqJtoQuCnEOKzgTVwg0ZWiCoQy6SxMebQVh8A==";
      };
    }
    {
      name = "admin_lte___admin_lte_3.2.0.tgz";
      path = fetchurl {
        name = "admin_lte___admin_lte_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/admin-lte/-/admin-lte-3.2.0.tgz";
        sha512 = "IDUfoU8jo9DVlB59lDEASAJXTesAEXDZ68DOHI3qg93r5ehVTkMl2x0ixgIyff8NiHeNYXpcOZh3tr6oGbvu9g==";
      };
    }
    {
      name = "amdefine___amdefine_1.0.1.tgz";
      path = fetchurl {
        name = "amdefine___amdefine_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/amdefine/-/amdefine-1.0.1.tgz";
        sha512 = "S2Hw0TtNkMJhIabBwIojKL9YHO5T0n5eNqWJ7Lrlel/zDbftQpxpapi8tZs3X1HWa+u+QeydGmzzNU0m09+Rcg==";
      };
    }
    {
      name = "array_from___array_from_2.1.1.tgz";
      path = fetchurl {
        name = "array_from___array_from_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/array-from/-/array-from-2.1.1.tgz";
        sha512 = "GQTc6Uupx1FCavi5mPzBvVT7nEOeWMmUA9P95wpfpW1XwMSKs+KaymD5C2Up7KAUKg/mYwbsUYzdZWcoajlNZg==";
      };
    }
    {
      name = "ast_transform___ast_transform_0.0.0.tgz";
      path = fetchurl {
        name = "ast_transform___ast_transform_0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ast-transform/-/ast-transform-0.0.0.tgz";
        sha512 = "e/JfLiSoakfmL4wmTGPjv0HpTICVmxwXgYOB8x+mzozHL8v+dSfCbrJ8J8hJ0YBP0XcYu1aLZ6b/3TnxNK3P2A==";
      };
    }
    {
      name = "ast_types___ast_types_0.7.8.tgz";
      path = fetchurl {
        name = "ast_types___ast_types_0.7.8.tgz";
        url  = "https://registry.yarnpkg.com/ast-types/-/ast-types-0.7.8.tgz";
        sha512 = "RIOpVnVlltB6PcBJ5BMLx+H+6JJ/zjDGU0t7f0L6c2M1dqcK92VQopLBlPQ9R80AVXelfqYgjcPLtHtDbNFg0Q==";
      };
    }
    {
      name = "base64_js___base64_js_1.3.1.tgz";
      path = fetchurl {
        name = "base64_js___base64_js_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/base64-js/-/base64-js-1.3.1.tgz";
        sha512 = "mLQ4i2QO1ytvGWFWmcngKO//JXAQueZvwEKtjgQFM4jIK0kU+ytMfplL8j+n5mspOfjHwoAg+9yhb7BwAHm36g==";
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
      name = "bootstrap_colorpicker___bootstrap_colorpicker_3.4.0.tgz";
      path = fetchurl {
        name = "bootstrap_colorpicker___bootstrap_colorpicker_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-colorpicker/-/bootstrap-colorpicker-3.4.0.tgz";
        sha512 = "7vA0hvLrat3ptobEKlT9+6amzBUJcDAoh6hJRQY/AD+5dVZYXXf1ivRfrTwmuwiVLJo9rZwM8YB4lYzp6agzqg==";
      };
    }
    {
      name = "bootstrap_datepicker___bootstrap_datepicker_1.9.0.tgz";
      path = fetchurl {
        name = "bootstrap_datepicker___bootstrap_datepicker_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-datepicker/-/bootstrap-datepicker-1.9.0.tgz";
        sha512 = "9rYYbaVOheGYxjOr/+bJCmRPihfy+LkLSg4fIFMT9Od8WwWB/MB50w0JO1eBgKUMbb7PFHQD5uAfI3ArAxZRXA==";
      };
    }
    {
      name = "bootstrap_slider___bootstrap_slider_11.0.2.tgz";
      path = fetchurl {
        name = "bootstrap_slider___bootstrap_slider_11.0.2.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-slider/-/bootstrap-slider-11.0.2.tgz";
        sha512 = "CdwS+Z6X79OkLes9RfDgPB9UIY/+81wTkm6ktdSB6hdyiRbjJLFQIjZdnEr55tDyXZfgC7U6yeSXkNN9ZdGqjA==";
      };
    }
    {
      name = "bootstrap_switch___bootstrap_switch_3.3.4.tgz";
      path = fetchurl {
        name = "bootstrap_switch___bootstrap_switch_3.3.4.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-switch/-/bootstrap-switch-3.3.4.tgz";
        sha512 = "7YQo+Ir6gCUqC36FFp1Zvec5dRF/+obq+1drMtdIMi9Xc84Kx63Evi0kdcp4HfiGsZpiz6IskyYDNlSKcxsL7w==";
      };
    }
    {
      name = "bootstrap_validator___bootstrap_validator_0.11.9.tgz";
      path = fetchurl {
        name = "bootstrap_validator___bootstrap_validator_0.11.9.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-validator/-/bootstrap-validator-0.11.9.tgz";
        sha512 = "BJlnaTeFNr5+SNtZ71DNaiFx7qY0X2c7m/KvZE1GiVXbyD8PihJlALvS6TeRGUs8mY8qga/LrhG80N9dw8UWqA==";
      };
    }
    {
      name = "bootstrap4_duallistbox___bootstrap4_duallistbox_4.0.2.tgz";
      path = fetchurl {
        name = "bootstrap4_duallistbox___bootstrap4_duallistbox_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap4-duallistbox/-/bootstrap4-duallistbox-4.0.2.tgz";
        sha512 = "vQdANVE2NN0HMaZO9qWJy0C7u04uTpAmtUGO3KLq3xAZKCboJweQ437hDTszI6pbYV2olJCGZMbdhvIkBNGeGQ==";
      };
    }
    {
      name = "bootstrap___bootstrap_4.6.2.tgz";
      path = fetchurl {
        name = "bootstrap___bootstrap_4.6.2.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap/-/bootstrap-4.6.2.tgz";
        sha512 = "51Bbp/Uxr9aTuy6ca/8FbFloBUJZLHwnhTcnjIeRn2suQWsWzcuJhGjKDB5eppVte/8oCdOL3VuwxvZDUggwGQ==";
      };
    }
    {
      name = "bootstrap___bootstrap_5.2.3.tgz";
      path = fetchurl {
        name = "bootstrap___bootstrap_5.2.3.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap/-/bootstrap-5.2.3.tgz";
        sha512 = "cEKPM+fwb3cT8NzQZYEu4HilJ3anCrWqh3CHAok1p9jXqMPsPTBhU25fBckEJHJ/p+tTxTFTsFQGM+gaHpi3QQ==";
      };
    }
    {
      name = "brfs___brfs_2.0.2.tgz";
      path = fetchurl {
        name = "brfs___brfs_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/brfs/-/brfs-2.0.2.tgz";
        sha512 = "IrFjVtwu4eTJZyu8w/V2gxU7iLTtcHih67sgEdzrhjLBMHp2uYefUBfdM4k2UvcuWMgV7PQDZHSLeNWnLFKWVQ==";
      };
    }
    {
      name = "brotli___brotli_1.3.3.tgz";
      path = fetchurl {
        name = "brotli___brotli_1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/brotli/-/brotli-1.3.3.tgz";
        sha512 = "oTKjJdShmDuGW94SyyaoQvAjf30dZaHnjJ8uAF+u2/vGJkJbJPJAT1gDiOJP5v1Zb6f9KEyW/1HpuaWIXtGHPg==";
      };
    }
    {
      name = "browser_resolve___browser_resolve_1.11.3.tgz";
      path = fetchurl {
        name = "browser_resolve___browser_resolve_1.11.3.tgz";
        url  = "https://registry.yarnpkg.com/browser-resolve/-/browser-resolve-1.11.3.tgz";
        sha512 = "exDi1BYWB/6raKHmDTCicQfTkqwN5fioMFV4j8BsfMU4R2DK/QfZfK7kOVkmWCNANf0snkBzqGqAJBao9gZMdQ==";
      };
    }
    {
      name = "browserify_optional___browserify_optional_1.0.1.tgz";
      path = fetchurl {
        name = "browserify_optional___browserify_optional_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-optional/-/browserify-optional-1.0.1.tgz";
        sha512 = "VrhjbZ+Ba5mDiSYEuPelekQMfTbhcA2DhLk2VQWqdcCROWeFqlTcXZ7yfRkXCIl8E+g4gINJYJiRB7WEtfomAQ==";
      };
    }
    {
      name = "bs_custom_file_input___bs_custom_file_input_1.3.4.tgz";
      path = fetchurl {
        name = "bs_custom_file_input___bs_custom_file_input_1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/bs-custom-file-input/-/bs-custom-file-input-1.3.4.tgz";
        sha512 = "NBsQzTnef3OW1MvdKBbMHAYHssCd613MSeJV7z2McXznWtVMnJCy7Ckyc+PwxV6Pk16cu6YBcYWh/ZE0XWNKCA==";
      };
    }
    {
      name = "bs_stepper___bs_stepper_1.7.0.tgz";
      path = fetchurl {
        name = "bs_stepper___bs_stepper_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/bs-stepper/-/bs-stepper-1.7.0.tgz";
        sha512 = "+DX7UKKgw2GI6ucsSCRd19VHYrxf/8znRCLs1lQVVLxz+h7EqgIOxoHcJ0/QTaaNoR9Cwg78ydo6hXIasyd3LA==";
      };
    }
    {
      name = "buffer_equal___buffer_equal_0.0.1.tgz";
      path = fetchurl {
        name = "buffer_equal___buffer_equal_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-0.0.1.tgz";
        sha512 = "RgSV6InVQ9ODPdLWJ5UAqBqJBOg370Nz6ZQtRzpt6nUjc8v0St97uJ4PYC6NztqIScrAXafKM3mZPMygSe1ggA==";
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
      name = "call_bind___call_bind_1.0.2.tgz";
      path = fetchurl {
        name = "call_bind___call_bind_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz";
        sha512 = "7O+FbCihrB5WGbFYesctwmTKae6rOiIzmz1icreWJ+0aA7LJfuqhEso2T9ncpcFtzMQtzXf2QGGueWJGTYsqrA==";
      };
    }
    {
      name = "chart.js___chart.js_2.9.4.tgz";
      path = fetchurl {
        name = "chart.js___chart.js_2.9.4.tgz";
        url  = "https://registry.yarnpkg.com/chart.js/-/chart.js-2.9.4.tgz";
        sha512 = "B07aAzxcrikjAPyV+01j7BmOpxtQETxTSlQ26BEYJ+3iUkbNKaOJ/nDbT6JjyqYxseM0ON12COHYdU2cTIjC7A==";
      };
    }
    {
      name = "chartjs_color_string___chartjs_color_string_0.6.0.tgz";
      path = fetchurl {
        name = "chartjs_color_string___chartjs_color_string_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/chartjs-color-string/-/chartjs-color-string-0.6.0.tgz";
        sha512 = "TIB5OKn1hPJvO7JcteW4WY/63v6KwEdt6udfnDE9iCAZgy+V4SrbSxoIbTw/xkUIapjEI4ExGtD0+6D3KyFd7A==";
      };
    }
    {
      name = "chartjs_color___chartjs_color_2.4.1.tgz";
      path = fetchurl {
        name = "chartjs_color___chartjs_color_2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/chartjs-color/-/chartjs-color-2.4.1.tgz";
        sha512 = "haqOg1+Yebys/Ts/9bLo/BqUcONQOdr/hoEr2LLTRl6C5LXctUdHxsCYfvQVg5JIxITrfCNUDr4ntqmQk9+/0w==";
      };
    }
    {
      name = "clone___clone_1.0.4.tgz";
      path = fetchurl {
        name = "clone___clone_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/clone/-/clone-1.0.4.tgz";
        sha512 = "JQHZ2QMW6l3aH/j6xCqQThY/9OH4D/9ls34cgkUBiEeocRTU04tHfKPBsUK1PqZCUQM7GiA0IIXJSuXHI64Kbg==";
      };
    }
    {
      name = "codemirror___codemirror_5.65.11.tgz";
      path = fetchurl {
        name = "codemirror___codemirror_5.65.11.tgz";
        url  = "https://registry.yarnpkg.com/codemirror/-/codemirror-5.65.11.tgz";
        sha512 = "Gp62g2eKSCHYt10axmGhKq3WoJSvVpvhXmowNq7pZdRVowwtvBR/hi2LSP5srtctKkRT33T6/n8Kv1UGp7JW4A==";
      };
    }
    {
      name = "color_convert___color_convert_1.9.3.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz";
        sha512 = "QfAUtd+vFdAtFQcC8CCyYt1fYWxSqAiK2cSD6zDB8N3cpsEBAvRxp9zOGg6G/SHHJYAT88/az/IuDGALsNVbGg==";
      };
    }
    {
      name = "color_name___color_name_1.1.3.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz";
        sha512 = "72fSenhMw2HZMTVHeCA9KCmpEIbzWiQsjN+BHcBbS9vr1mtt+vJjPdksIBNUmKAW8TFUDPJK5SUU3QhE9NEXDw==";
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
      name = "concat_stream___concat_stream_1.6.2.tgz";
      path = fetchurl {
        name = "concat_stream___concat_stream_1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz";
        sha512 = "27HBghJxjiZtIk3Ycvn/4kbJk/1uZuJFfuPEns6LaEvpvG1f0hTea8lilrouyo9mVc2GWdcEZ8OLoGmSADlrCw==";
      };
    }
    {
      name = "convert_source_map___convert_source_map_1.9.0.tgz";
      path = fetchurl {
        name = "convert_source_map___convert_source_map_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz";
        sha512 = "ASFBup0Mz1uyiIjANan1jzLQami9z1PoYSZCiiYW2FczPbenXc45FZdBZLzOT+r6+iciuEModtmCti+hjaAk0A==";
      };
    }
    {
      name = "core_util_is___core_util_is_1.0.3.tgz";
      path = fetchurl {
        name = "core_util_is___core_util_is_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz";
        sha512 = "ZQBvi1DcpJ4GDqanjucZ2Hj3wEO5pZDS89BWbkcrvdxksJorwUDDZamX9ldFkp9aw2lmBDLgkObEA4DWNJ9FYQ==";
      };
    }
    {
      name = "crypto_js___crypto_js_4.1.1.tgz";
      path = fetchurl {
        name = "crypto_js___crypto_js_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/crypto-js/-/crypto-js-4.1.1.tgz";
        sha512 = "o2JlM7ydqd3Qk9CA0L4NL6mTzU2sdx96a+oOfPu8Mkl/PK51vSyoi8/rQ8NknZtk44vq15lmhAj9CIAGwgeWKw==";
      };
    }
    {
      name = "d___d_1.0.1.tgz";
      path = fetchurl {
        name = "d___d_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/d/-/d-1.0.1.tgz";
        sha512 = "m62ShEObQ39CfralilEQRjH6oAMtNCV1xJyEx5LpRYUVN+EviphDgUc/F3hnYbADmkiNs67Y+3ylmlG7Lnu+FA==";
      };
    }
    {
      name = "dash_ast___dash_ast_2.0.1.tgz";
      path = fetchurl {
        name = "dash_ast___dash_ast_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/dash-ast/-/dash-ast-2.0.1.tgz";
        sha512 = "5TXltWJGc+RdnabUGzhRae1TRq6m4gr+3K2wQX0is5/F2yS6MJXJvLyI3ErAnsAXuJoGqvfVD5icRgim07DrxQ==";
      };
    }
    {
      name = "datatables.net_autofill_bs4___datatables.net_autofill_bs4_2.5.2.tgz";
      path = fetchurl {
        name = "datatables.net_autofill_bs4___datatables.net_autofill_bs4_2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-autofill-bs4/-/datatables.net-autofill-bs4-2.5.2.tgz";
        sha512 = "k8SU+S0fa8iX2vJLdzfykpawIRNXRygX6pZJZ52zcEMh6pO7wYKFblH4A6N9ToPrkF22lW5kYHqshEb+GMZLiA==";
      };
    }
    {
      name = "datatables.net_autofill___datatables.net_autofill_2.5.2.tgz";
      path = fetchurl {
        name = "datatables.net_autofill___datatables.net_autofill_2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-autofill/-/datatables.net-autofill-2.5.2.tgz";
        sha512 = "sMkHTVv3I8shEt4Qvf3y9Hfp3XLTe8wMi1tMclJw5OV9NOL5UkuHmBkQeJUegZWOBZ6sivYjOvOX7H8AI6OHMg==";
      };
    }
    {
      name = "datatables.net_bs4___datatables.net_bs4_1.13.2.tgz";
      path = fetchurl {
        name = "datatables.net_bs4___datatables.net_bs4_1.13.2.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-bs4/-/datatables.net-bs4-1.13.2.tgz";
        sha512 = "sr5D4pV+VqIfPGPh3oKQDu+denk/bZ3ObyAYp/EbQLoLw2U6dvVJifHeccCC5M+ZhYtucHVID/qpbswx90QQHA==";
      };
    }
    {
      name = "datatables.net_buttons_bs4___datatables.net_buttons_bs4_2.3.4.tgz";
      path = fetchurl {
        name = "datatables.net_buttons_bs4___datatables.net_buttons_bs4_2.3.4.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-buttons-bs4/-/datatables.net-buttons-bs4-2.3.4.tgz";
        sha512 = "rg1OpsPxbXeYStcsHHeh1NnvCIMKnnyKk0cnrNyGck5DJFFunKNySqJk2t1MkQrpEN1NibeuqyMCjfsAx5TQHg==";
      };
    }
    {
      name = "datatables.net_buttons___datatables.net_buttons_2.3.4.tgz";
      path = fetchurl {
        name = "datatables.net_buttons___datatables.net_buttons_2.3.4.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-buttons/-/datatables.net-buttons-2.3.4.tgz";
        sha512 = "1fe/aiKBdKbwJ5j0OobP2dzhbg/alGOphnTfLFGaqlP5yVxDCfcZ9EsuglYeHRJ/KnU7DZ8BgsPFiTE0tOFx8Q==";
      };
    }
    {
      name = "datatables.net_colreorder_bs4___datatables.net_colreorder_bs4_1.6.1.tgz";
      path = fetchurl {
        name = "datatables.net_colreorder_bs4___datatables.net_colreorder_bs4_1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-colreorder-bs4/-/datatables.net-colreorder-bs4-1.6.1.tgz";
        sha512 = "vdr0Padd26pDNdUhasFUGWK6WrYyoBSwoJ5Sq4294hgj1SqblP8pz1vIGUmFiFtlHlOsHaVor3rffeqyYH8Waw==";
      };
    }
    {
      name = "datatables.net_colreorder___datatables.net_colreorder_1.6.1.tgz";
      path = fetchurl {
        name = "datatables.net_colreorder___datatables.net_colreorder_1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-colreorder/-/datatables.net-colreorder-1.6.1.tgz";
        sha512 = "ae0gdkG0OmrEGUrXYm0XgWDzDkuEhEuNrfvQsmtCTl0j+1nxtXPsecIiWBCqv/dM0X4x8PT0dJY8furqPCzXXw==";
      };
    }
    {
      name = "datatables.net_fixedcolumns_bs4___datatables.net_fixedcolumns_bs4_4.2.1.tgz";
      path = fetchurl {
        name = "datatables.net_fixedcolumns_bs4___datatables.net_fixedcolumns_bs4_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-fixedcolumns-bs4/-/datatables.net-fixedcolumns-bs4-4.2.1.tgz";
        sha512 = "RXI0weSNs9MlwKZujIKtih2wAdycjYgE7xunFYNTLJrjMzmRrisHs1FQ8AwZAQZu2CkvUbrUjdiAuaJXwKPyuA==";
      };
    }
    {
      name = "datatables.net_fixedcolumns___datatables.net_fixedcolumns_4.2.1.tgz";
      path = fetchurl {
        name = "datatables.net_fixedcolumns___datatables.net_fixedcolumns_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-fixedcolumns/-/datatables.net-fixedcolumns-4.2.1.tgz";
        sha512 = "XCNM2UyWwLl8Qtaw23/wgMlUhQjIWEKXJSLqB67RTibeyfVUF7zsnNQECPtlPr6kqUN229Ep8UZG15Zc71MytQ==";
      };
    }
    {
      name = "datatables.net_fixedheader_bs4___datatables.net_fixedheader_bs4_3.3.1.tgz";
      path = fetchurl {
        name = "datatables.net_fixedheader_bs4___datatables.net_fixedheader_bs4_3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-fixedheader-bs4/-/datatables.net-fixedheader-bs4-3.3.1.tgz";
        sha512 = "cTSh9VygiEoMwnkuR5xhex/NDCJ5CsgXCLG0VDdOqptUwjYIqlrrVf4hBCj2XnJCxHi/liV1sSW3qu7q1QnpwQ==";
      };
    }
    {
      name = "datatables.net_fixedheader___datatables.net_fixedheader_3.3.1.tgz";
      path = fetchurl {
        name = "datatables.net_fixedheader___datatables.net_fixedheader_3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-fixedheader/-/datatables.net-fixedheader-3.3.1.tgz";
        sha512 = "m1ip5dOOsdjaFw2e5G77o+XLjqy5wWKnBnp+BwbnFCq4J5hFbMqcIV1r5z9X+NeAiKlADqZqteeLoO2xYRXBVA==";
      };
    }
    {
      name = "datatables.net_keytable_bs4___datatables.net_keytable_bs4_2.8.1.tgz";
      path = fetchurl {
        name = "datatables.net_keytable_bs4___datatables.net_keytable_bs4_2.8.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-keytable-bs4/-/datatables.net-keytable-bs4-2.8.1.tgz";
        sha512 = "1RAE6oC8z7EnWXFfi1sbilYpeUyrK3j0MDCH5Bm6DfIsT7fnchjUEzgBy3Nr9+uE5edFUb7FNW0VQjTZKjFd2g==";
      };
    }
    {
      name = "datatables.net_keytable___datatables.net_keytable_2.8.1.tgz";
      path = fetchurl {
        name = "datatables.net_keytable___datatables.net_keytable_2.8.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-keytable/-/datatables.net-keytable-2.8.1.tgz";
        sha512 = "ch9O35OSUgwTCb9cJXV6ABRQ8l296cg/UEtPmLjto9CHVL/XF7o0ZwzvKWevnabXmTVbudfB647mrUtkFd/8og==";
      };
    }
    {
      name = "datatables.net_plugins___datatables.net_plugins_1.13.1.tgz";
      path = fetchurl {
        name = "datatables.net_plugins___datatables.net_plugins_1.13.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-plugins/-/datatables.net-plugins-1.13.1.tgz";
        sha512 = "4UpaRl7ZiTmStjV1QTB3x9V0EKmgdMvF7Ms+HzZ6gSzv33kPrL9Cw76/Uxxl02Z+ajergobvfMN64ndlZ9AXzA==";
      };
    }
    {
      name = "datatables.net_responsive_bs4___datatables.net_responsive_bs4_2.4.0.tgz";
      path = fetchurl {
        name = "datatables.net_responsive_bs4___datatables.net_responsive_bs4_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-responsive-bs4/-/datatables.net-responsive-bs4-2.4.0.tgz";
        sha512 = "zCAxwcuaLneJd3Yy1eKZU3wksIj4IFvcaQEXrFeVBgsl6iH3H+uqW9apwdadDL8agsBHdsln08qYjkz8bYY7Bg==";
      };
    }
    {
      name = "datatables.net_responsive___datatables.net_responsive_2.4.0.tgz";
      path = fetchurl {
        name = "datatables.net_responsive___datatables.net_responsive_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-responsive/-/datatables.net-responsive-2.4.0.tgz";
        sha512 = "Acws4aEPJZX/+CQsXpuDBHfrwgl3XxWEc/zlsnJCXE/GGbqjVAtQt7SM6EBcdReMv1FbyWUlF/Uw+de11NT46A==";
      };
    }
    {
      name = "datatables.net_rowgroup_bs4___datatables.net_rowgroup_bs4_1.3.0.tgz";
      path = fetchurl {
        name = "datatables.net_rowgroup_bs4___datatables.net_rowgroup_bs4_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-rowgroup-bs4/-/datatables.net-rowgroup-bs4-1.3.0.tgz";
        sha512 = "qw4PwsFgVNKazimL/ixYP9NGzsEgZtt1VQfFK/r+JF1uoV7/vVvG7qK/B+wFRAdTAXL+9v6uKlJ/8RI7bPAbvg==";
      };
    }
    {
      name = "datatables.net_rowgroup___datatables.net_rowgroup_1.3.0.tgz";
      path = fetchurl {
        name = "datatables.net_rowgroup___datatables.net_rowgroup_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-rowgroup/-/datatables.net-rowgroup-1.3.0.tgz";
        sha512 = "kLzYxvMmy8wmISksXvHBbZrv0wD7hlmp8NaiZQ6rFMwbTIoMt9YzOA+tpKDZiw3MOnku44QAOBXdPtXwxjE0JA==";
      };
    }
    {
      name = "datatables.net_rowreorder_bs4___datatables.net_rowreorder_bs4_1.3.2.tgz";
      path = fetchurl {
        name = "datatables.net_rowreorder_bs4___datatables.net_rowreorder_bs4_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-rowreorder-bs4/-/datatables.net-rowreorder-bs4-1.3.2.tgz";
        sha512 = "tzPefl59gbw4qytRtwfPGTA49O6Gf2J7jL1xvhR2px2fcKHP2RqNJaHtnBk9nhqTJNWc9YPPy2wtbkIFIkswqQ==";
      };
    }
    {
      name = "datatables.net_rowreorder___datatables.net_rowreorder_1.3.2.tgz";
      path = fetchurl {
        name = "datatables.net_rowreorder___datatables.net_rowreorder_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-rowreorder/-/datatables.net-rowreorder-1.3.2.tgz";
        sha512 = "zF2nsYEdteqIPojl+8ADDF1uMR9v7WttQlMiYkz/5qaNMaMj6GUbrql4eXPFBFH87CKTqnN9fL0HH0CRvewKBg==";
      };
    }
    {
      name = "datatables.net_scroller_bs4___datatables.net_scroller_bs4_2.1.0.tgz";
      path = fetchurl {
        name = "datatables.net_scroller_bs4___datatables.net_scroller_bs4_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-scroller-bs4/-/datatables.net-scroller-bs4-2.1.0.tgz";
        sha512 = "xZa2rhZjKbk1ebPQBrY6pqQRdc8/JTuAzzqhQjU7hDKwQqRyQ6WJuVjdJxJ6MHkB2fFVdj7v9H3VCvUJOuXTEQ==";
      };
    }
    {
      name = "datatables.net_scroller___datatables.net_scroller_2.1.0.tgz";
      path = fetchurl {
        name = "datatables.net_scroller___datatables.net_scroller_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-scroller/-/datatables.net-scroller-2.1.0.tgz";
        sha512 = "B/MxP8YPcFtoa1cexvlcK0PXQdzy6tz+HhQlyjNpRCoRc/8ZM5VcZg+ecYfP/pRBBXZORgkOJjWYkIdoChhE0w==";
      };
    }
    {
      name = "datatables.net_searchbuilder_bs4___datatables.net_searchbuilder_bs4_1.4.0.tgz";
      path = fetchurl {
        name = "datatables.net_searchbuilder_bs4___datatables.net_searchbuilder_bs4_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-searchbuilder-bs4/-/datatables.net-searchbuilder-bs4-1.4.0.tgz";
        sha512 = "iEjhIkKLKoVD7wGWEVNSfpQaqBx+SXbiDTmH3t39h5hNWpYqoLtwEy/PhtaSdaF+hIhlrhcB4y8qHr/mW7KlSw==";
      };
    }
    {
      name = "datatables.net_searchbuilder___datatables.net_searchbuilder_1.4.0.tgz";
      path = fetchurl {
        name = "datatables.net_searchbuilder___datatables.net_searchbuilder_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-searchbuilder/-/datatables.net-searchbuilder-1.4.0.tgz";
        sha512 = "I6+a5EebX6uYFlWmc7TAk1oQvlfoGZqyLgdN4H9Rm6fL5VZv6SvWQ7y2+W9ebshMD0smKdtp8pedYc8PIh80kg==";
      };
    }
    {
      name = "datatables.net_searchpanes_bs4___datatables.net_searchpanes_bs4_1.4.0.tgz";
      path = fetchurl {
        name = "datatables.net_searchpanes_bs4___datatables.net_searchpanes_bs4_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-searchpanes-bs4/-/datatables.net-searchpanes-bs4-1.4.0.tgz";
        sha512 = "Floxzmw2cQkUQdI7Vv4IWtLqLmwPrmY6MPncbEWq4YvkSeaZW7OHzSmZLLUjMn2P6Huvz59WUVcwL0lSDui6GQ==";
      };
    }
    {
      name = "datatables.net_searchpanes___datatables.net_searchpanes_2.1.1.tgz";
      path = fetchurl {
        name = "datatables.net_searchpanes___datatables.net_searchpanes_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-searchpanes/-/datatables.net-searchpanes-2.1.1.tgz";
        sha512 = "WsgnK8C/jCco9oRcpsVaImgTCiD7hk28dLHBmlpbvbIHMHCAhLPn0zVnCB3yInoNC/7kOGKpkeItpIpFHDMnhA==";
      };
    }
    {
      name = "datatables.net_select_bs4___datatables.net_select_bs4_1.6.0.tgz";
      path = fetchurl {
        name = "datatables.net_select_bs4___datatables.net_select_bs4_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-select-bs4/-/datatables.net-select-bs4-1.6.0.tgz";
        sha512 = "oHClu+R1IMpttFse0cAdUhl4uLHGgoHrFEU/QxpASOQLd1h4CtkiVnmDr0fFRvm6XZMRTNt5xgYgwr262YuXyQ==";
      };
    }
    {
      name = "datatables.net_select___datatables.net_select_1.6.0.tgz";
      path = fetchurl {
        name = "datatables.net_select___datatables.net_select_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net-select/-/datatables.net-select-1.6.0.tgz";
        sha512 = "1kj32GOXs/dSpjBL5iDV3pwRwHU0hhJLPnTW/NOUH8Vhv1rGR3/X3PMSCc/T+Fy7J1jCJFbk8hQDsruXQKfSzw==";
      };
    }
    {
      name = "datatables.net___datatables.net_1.13.2.tgz";
      path = fetchurl {
        name = "datatables.net___datatables.net_1.13.2.tgz";
        url  = "https://registry.yarnpkg.com/datatables.net/-/datatables.net-1.13.2.tgz";
        sha512 = "u5nOU+C9SBp1SyPmd6G+niozZtrBwo1E8xzdOk3JJaAkFYgX/KxF3Gd79R8YLbUfmIs2OLnLe5gaz/qs5U8UDA==";
      };
    }
    {
      name = "daterangepicker___daterangepicker_3.1.0.tgz";
      path = fetchurl {
        name = "daterangepicker___daterangepicker_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/daterangepicker/-/daterangepicker-3.1.0.tgz";
        sha512 = "DxWXvvPq4srWLCqFugqSV+6CBt/CvQ0dnpXhQ3gl0autcIDAruG1PuGG3gC7yPRNytAD1oU1AcUOzaYhOawhTw==";
      };
    }
    {
      name = "deep_equal___deep_equal_1.1.1.tgz";
      path = fetchurl {
        name = "deep_equal___deep_equal_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/deep-equal/-/deep-equal-1.1.1.tgz";
        sha512 = "yd9c5AdiqVcR+JjcwUQb9DkhJc8ngNr0MahEBGvDiJw8puWab2yZlh+nkasOnZP+EGTAP6rRp2JzJhJZzvNF8g==";
      };
    }
    {
      name = "deep_is___deep_is_0.1.4.tgz";
      path = fetchurl {
        name = "deep_is___deep_is_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz";
        sha512 = "oIPzksmTg4/MriiaYGO+okXDT7ztn/w3Eptv/+gSIdMdKsJo0u4CfYNFJPy+4SKMuCqGw2wxnA+URMg3t8a/bQ==";
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
      name = "dfa___dfa_1.2.0.tgz";
      path = fetchurl {
        name = "dfa___dfa_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dfa/-/dfa-1.2.0.tgz";
        sha512 = "ED3jP8saaweFTjeGX8HQPjeC1YYyZs98jGNZx6IiBvxW7JG5v492kamAQB3m2wop07CvU/RQmzcKr6bgcC5D/Q==";
      };
    }
    {
      name = "dropzone___dropzone_5.9.3.tgz";
      path = fetchurl {
        name = "dropzone___dropzone_5.9.3.tgz";
        url  = "https://registry.yarnpkg.com/dropzone/-/dropzone-5.9.3.tgz";
        sha512 = "Azk8kD/2/nJIuVPK+zQ9sjKMRIpRvNyqn9XwbBHNq+iNuSccbJS6hwm1Woy0pMST0erSo0u4j+KJaodndDk4vA==";
      };
    }
    {
      name = "duplexer2___duplexer2_0.1.4.tgz";
      path = fetchurl {
        name = "duplexer2___duplexer2_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/duplexer2/-/duplexer2-0.1.4.tgz";
        sha512 = "asLFVfWWtJ90ZyOUHMqk7/S2w2guQKxUI2itj3d92ADHhxUSbCMGi1f1cBcJ7xM1To+pE/Khbwo1yuNbMEPKeA==";
      };
    }
    {
      name = "ekko_lightbox___ekko_lightbox_5.3.0.tgz";
      path = fetchurl {
        name = "ekko_lightbox___ekko_lightbox_5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ekko-lightbox/-/ekko-lightbox-5.3.0.tgz";
        sha512 = "mbacwySuVD3Ad6F2hTkjSTvJt59bcVv2l/TmBerp4xZnLak8tPtA4AScUn4DL42c1ksTiAO6sGhJZ52P/1Qgew==";
      };
    }
    {
      name = "es5_ext___es5_ext_0.10.62.tgz";
      path = fetchurl {
        name = "es5_ext___es5_ext_0.10.62.tgz";
        url  = "https://registry.yarnpkg.com/es5-ext/-/es5-ext-0.10.62.tgz";
        sha512 = "BHLqn0klhEpnOKSrzn/Xsz2UIW8j+cGmo9JLzr8BiUapV8hPL9+FliFqjwr9ngW7jWdnxv6eO+/LqyhJVqgrjA==";
      };
    }
    {
      name = "es6_iterator___es6_iterator_2.0.3.tgz";
      path = fetchurl {
        name = "es6_iterator___es6_iterator_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/es6-iterator/-/es6-iterator-2.0.3.tgz";
        sha512 = "zw4SRzoUkd+cl+ZoE15A9o1oQd920Bb0iOJMQkQhl3jNc03YqVjAhG7scf9C5KWRU/R13Orf588uCC6525o02g==";
      };
    }
    {
      name = "es6_map___es6_map_0.1.5.tgz";
      path = fetchurl {
        name = "es6_map___es6_map_0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/es6-map/-/es6-map-0.1.5.tgz";
        sha512 = "mz3UqCh0uPCIqsw1SSAkB/p0rOzF/M0V++vyN7JqlPtSW/VsYgQBvVvqMLmfBuyMzTpLnNqi6JmcSizs4jy19A==";
      };
    }
    {
      name = "es6_set___es6_set_0.1.6.tgz";
      path = fetchurl {
        name = "es6_set___es6_set_0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/es6-set/-/es6-set-0.1.6.tgz";
        sha512 = "TE3LgGLDIBX332jq3ypv6bcOpkLO0AslAQo7p2VqX/1N46YNsvIWgvjojjSEnWEGWMhr1qUbYeTSir5J6mFHOw==";
      };
    }
    {
      name = "es6_symbol___es6_symbol_3.1.3.tgz";
      path = fetchurl {
        name = "es6_symbol___es6_symbol_3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/es6-symbol/-/es6-symbol-3.1.3.tgz";
        sha512 = "NJ6Yn3FuDinBaBRWl/q5X/s4koRHBrgKAu+yGI6JCBeiu3qrcbJhwT2GeR/EXVfylRk8dpQVJoLEFhK+Mu31NA==";
      };
    }
    {
      name = "escodegen___escodegen_1.14.3.tgz";
      path = fetchurl {
        name = "escodegen___escodegen_1.14.3.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.14.3.tgz";
        sha512 = "qFcX0XJkdg+PB3xjZZG/wKSuT1PnQWx57+TVSjIMmILd2yC/6ByYElPwJnslDsuWuSAp4AwJGumarAAmJch5Kw==";
      };
    }
    {
      name = "escodegen___escodegen_1.2.0.tgz";
      path = fetchurl {
        name = "escodegen___escodegen_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.2.0.tgz";
        sha512 = "yLy3Cc+zAC0WSmoT2fig3J87TpQ8UaZGx8ahCAs9FL8qNbyV7CVyPKS74DG4bsHiL5ew9sxdYx131OkBQMFnvA==";
      };
    }
    {
      name = "esprima___esprima_4.0.1.tgz";
      path = fetchurl {
        name = "esprima___esprima_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz";
        sha512 = "eGuFFw7Upda+g4p+QHvnW0RyTX/SVeJBDM/gCtMARO0cLuT2HcEKnTPvhjV6aGeqrCB/sbNop0Kszm0jsaWU4A==";
      };
    }
    {
      name = "esprima___esprima_1.0.4.tgz";
      path = fetchurl {
        name = "esprima___esprima_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-1.0.4.tgz";
        sha512 = "rp5dMKN8zEs9dfi9g0X1ClLmV//WRyk/R15mppFNICIFRG5P92VP7Z04p8pk++gABo9W2tY+kHyu6P1mEHgmTA==";
      };
    }
    {
      name = "estraverse___estraverse_4.3.0.tgz";
      path = fetchurl {
        name = "estraverse___estraverse_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz";
        sha512 = "39nnKffWz8xN1BU/2c79n9nB9HDzo0niYUqx6xyqUnyoAnQyyWpOTdZEeiCch8BBu515t4wp9ZmgVfVhn9EBpw==";
      };
    }
    {
      name = "estraverse___estraverse_1.5.1.tgz";
      path = fetchurl {
        name = "estraverse___estraverse_1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-1.5.1.tgz";
        sha512 = "FpCjJDfmo3vsc/1zKSeqR5k42tcIhxFIlvq+h9j0fO2q/h2uLKyweq7rYJ+0CoVvrGQOxIS5wyBrW/+vF58BUQ==";
      };
    }
    {
      name = "estree_is_function___estree_is_function_1.0.0.tgz";
      path = fetchurl {
        name = "estree_is_function___estree_is_function_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/estree-is-function/-/estree-is-function-1.0.0.tgz";
        sha512 = "nSCWn1jkSq2QAtkaVLJZY2ezwcFO161HVc174zL1KPW3RJ+O6C3eJb8Nx7OXzvhoEv+nLgSR1g71oWUHUDTrJA==";
      };
    }
    {
      name = "esutils___esutils_2.0.3.tgz";
      path = fetchurl {
        name = "esutils___esutils_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz";
        sha512 = "kVscqXk4OCp68SZ0dkgEKVi6/8ij300KBWTJq32P/dYeWTSwK41WyTxalN1eRmA5Z9UU/LX9D7FWSmV9SAYx6g==";
      };
    }
    {
      name = "esutils___esutils_1.0.0.tgz";
      path = fetchurl {
        name = "esutils___esutils_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-1.0.0.tgz";
        sha512 = "x/iYH53X3quDwfHRz4y8rn4XcEwwCJeWsul9pF1zldMbGtgOtMNBEOuYWwB1EQlK2LRa1fev3YAgym/RElp5Cg==";
      };
    }
    {
      name = "ev_emitter___ev_emitter_1.1.1.tgz";
      path = fetchurl {
        name = "ev_emitter___ev_emitter_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ev-emitter/-/ev-emitter-1.1.1.tgz";
        sha512 = "ipiDYhdQSCZ4hSbX4rMW+XzNKMD1prg/sTvoVmSLkuQ1MVlwjJQQA+sW8tMYR3BLUr9KjodFV4pvzunvRhd33Q==";
      };
    }
    {
      name = "eve_raphael___eve_raphael_0.5.0.tgz";
      path = fetchurl {
        name = "eve_raphael___eve_raphael_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/eve-raphael/-/eve-raphael-0.5.0.tgz";
        sha512 = "jrxnPsCGqng1UZuEp9DecX/AuSyAszATSjf4oEcRxvfxa1Oux4KkIPKBAAWWnpdwfARtr+Q0o9aPYWjsROD7ug==";
      };
    }
    {
      name = "event_emitter___event_emitter_0.3.5.tgz";
      path = fetchurl {
        name = "event_emitter___event_emitter_0.3.5.tgz";
        url  = "https://registry.yarnpkg.com/event-emitter/-/event-emitter-0.3.5.tgz";
        sha512 = "D9rRn9y7kLPnJ+hMq7S/nhvoKwwvVJahBi2BPmx3bvbsEdK3W9ii8cBSGjP+72/LnM4n6fo3+dkCX5FeTQruXA==";
      };
    }
    {
      name = "ext___ext_1.7.0.tgz";
      path = fetchurl {
        name = "ext___ext_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/ext/-/ext-1.7.0.tgz";
        sha512 = "6hxeJYaL110a9b5TEJSj0gojyHQAmA2ch5Os+ySCiA1QGdS697XWY1pzsrSjqA9LDEEgdB/KypIlR59RcLuHYw==";
      };
    }
    {
      name = "fast_levenshtein___fast_levenshtein_2.0.6.tgz";
      path = fetchurl {
        name = "fast_levenshtein___fast_levenshtein_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz";
        sha512 = "DCXu6Ifhqcks7TZKY3Hxp3y6qphY5SJZmrWMDrKcERSOXWQdMhU9Ig/PYrzyw/ul9jOIyh0N4M0tbC5hodg8dw==";
      };
    }
    {
      name = "fast_memoize___fast_memoize_2.5.2.tgz";
      path = fetchurl {
        name = "fast_memoize___fast_memoize_2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/fast-memoize/-/fast-memoize-2.5.2.tgz";
        sha512 = "Ue0LwpDYErFbmNnZSF0UH6eImUwDmogUO1jyE+JbN2gsQz/jICm1Ve7t9QT0rNSsfJt+Hs4/S3GnsDVjL4HVrw==";
      };
    }
    {
      name = "fastclick___fastclick_1.0.6.tgz";
      path = fetchurl {
        name = "fastclick___fastclick_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fastclick/-/fastclick-1.0.6.tgz";
        sha512 = "cXyDBT4g0uWl/Xe75QspBDAgAWQ0lkPi/zgp6YFEUHj6WV6VIZl7R6TiDZhdOVU3W4ehp/8tG61Jev1jit+ztQ==";
      };
    }
    {
      name = "filterizr___filterizr_2.2.4.tgz";
      path = fetchurl {
        name = "filterizr___filterizr_2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/filterizr/-/filterizr-2.2.4.tgz";
        sha512 = "hqyEdg7RrvJMVFOeF0yysS75HP6jLu0wBSUtSPAc3BysAtHpwcXaPnR1kYp2uZtd3YXyhH6JRfF9+H4SRvrqXg==";
      };
    }
    {
      name = "flag_icon_css___flag_icon_css_4.1.7.tgz";
      path = fetchurl {
        name = "flag_icon_css___flag_icon_css_4.1.7.tgz";
        url  = "https://registry.yarnpkg.com/flag-icon-css/-/flag-icon-css-4.1.7.tgz";
        sha512 = "AFjSU+fv98XbU0vnTQ32vcLj89UEr1MhwDFcooQv14qWJCjg9fGZzfh9BVyDhAhIOZW/pGmJmq38RqpgPaeybQ==";
      };
    }
    {
      name = "flot___flot_4.2.3.tgz";
      path = fetchurl {
        name = "flot___flot_4.2.3.tgz";
        url  = "https://registry.yarnpkg.com/flot/-/flot-4.2.3.tgz";
        sha512 = "r1t2gfhILE6dt7cnYDHX/D2VHERyD0YoV0UdFJg5dWbjkcu05MugfhNY7VspfBFTa+hjVNYVZw6/t9ZyYNen+w==";
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
      name = "fullcalendar___fullcalendar_5.11.4.tgz";
      path = fetchurl {
        name = "fullcalendar___fullcalendar_5.11.4.tgz";
        url  = "https://registry.yarnpkg.com/fullcalendar/-/fullcalendar-5.11.4.tgz";
        sha512 = "1TH40KkWFVlZBpqJ/eB69E7nPABleA0skoc7pTIXJNNNYyUuKPjiJg+TSMunjJ9faPLzvbvfCdgttGZnynPA3Q==";
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
      name = "functions_have_names___functions_have_names_1.2.3.tgz";
      path = fetchurl {
        name = "functions_have_names___functions_have_names_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz";
        sha512 = "xckBUXyTIqT97tq2x2AMb+g163b5JFysYk0x4qxNFwbfQkmNZoiRHb6sPzI9/QV33WeuvVYBUIiD4NzNIyqaRQ==";
      };
    }
    {
      name = "get_assigned_identifiers___get_assigned_identifiers_1.2.0.tgz";
      path = fetchurl {
        name = "get_assigned_identifiers___get_assigned_identifiers_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/get-assigned-identifiers/-/get-assigned-identifiers-1.2.0.tgz";
        sha512 = "mBBwmeGTrxEMO4pMaaf/uUEFHnYtwr8FTe8Y/mer4rcV/bye0qGm6pw1bGZFGStxC5O76c5ZAVBGnqHmOaJpdQ==";
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
      name = "graceful_fs___graceful_fs_4.2.10.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.10.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.10.tgz";
        sha512 = "9ByhssR2fPVsNZj478qUUbKfmL0+t5BDVyjShtyZZLiK7ZDAArFFfopyOTj0M05wE2tJPisA4iTnnXl2YoPvOA==";
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
      name = "has_tostringtag___has_tostringtag_1.0.0.tgz";
      path = fetchurl {
        name = "has_tostringtag___has_tostringtag_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz";
        sha512 = "kFjcSNhnlGV1kyoGk7OXKSawH5JOb/LzUc5w9B02hOTO0dfFRjbHQKvg1d6cf3HbeUmtU9VbbV3qzZ2Teh97WQ==";
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
      name = "icheck_bootstrap___icheck_bootstrap_3.0.1.tgz";
      path = fetchurl {
        name = "icheck_bootstrap___icheck_bootstrap_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/icheck-bootstrap/-/icheck-bootstrap-3.0.1.tgz";
        sha512 = "Rj3SybdcMcayhsP4IJ+hmCNgCKclaFcs/5zwCuLXH1WMo468NegjhZVxbSNKhEjJjnwc4gKETogUmPYSQ9lEZQ==";
      };
    }
    {
      name = "icheck___icheck_1.0.2.tgz";
      path = fetchurl {
        name = "icheck___icheck_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/icheck/-/icheck-1.0.2.tgz";
        sha512 = "1oDqj9ikiH4csFWKZnfbD1S9IY/MqzEt4cir6PIfkT84D/8QYaAZFrplXoyz5eaATmaoawY3KMTkMAO+fP4wGg==";
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
      name = "imagesloaded___imagesloaded_4.1.4.tgz";
      path = fetchurl {
        name = "imagesloaded___imagesloaded_4.1.4.tgz";
        url  = "https://registry.yarnpkg.com/imagesloaded/-/imagesloaded-4.1.4.tgz";
        sha512 = "ltiBVcYpc/TYTF5nolkMNsnREHW+ICvfQ3Yla2Sgr71YFwQ86bDwV9hgpFhFtrGPuwEx5+LqOHIrdXBdoWwwsA==";
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
      name = "inherits___inherits_2.0.4.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz";
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
      };
    }
    {
      name = "inputmask___inputmask_5.0.7.tgz";
      path = fetchurl {
        name = "inputmask___inputmask_5.0.7.tgz";
        url  = "https://registry.yarnpkg.com/inputmask/-/inputmask-5.0.7.tgz";
        sha512 = "rUxbRDS25KEib+c/Ow+K01oprU/+EK9t9SOPC8ov94/ftULGDqj1zOgRU/Hko6uzoKRMdwCfuhAafJ/Wk2wffQ==";
      };
    }
    {
      name = "ion_rangeslider___ion_rangeslider_2.3.1.tgz";
      path = fetchurl {
        name = "ion_rangeslider___ion_rangeslider_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/ion-rangeslider/-/ion-rangeslider-2.3.1.tgz";
        sha512 = "6V+24FD13/feliI485gnRHZYD9Ev64M5NAFTxnVib516ATHa9PlXQrC+nOiPngouRYTCLPJyokAJEi3e1Umi5g==";
      };
    }
    {
      name = "is_arguments___is_arguments_1.1.1.tgz";
      path = fetchurl {
        name = "is_arguments___is_arguments_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-arguments/-/is-arguments-1.1.1.tgz";
        sha512 = "8Q7EARjzEnKpt/PCD7e1cgUS0a6X8u5tdSiMqXhojOdoV9TsMsiO+9VLC5vAmO8N7/GmXn7yjR8qnA6bVAEzfA==";
      };
    }
    {
      name = "is_core_module___is_core_module_2.11.0.tgz";
      path = fetchurl {
        name = "is_core_module___is_core_module_2.11.0.tgz";
        url  = "https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz";
        sha512 = "RRjxlvLDkD1YJwDbroBHMb+cukurkDWNyHx7D3oNB5x9rb5ogcksMC5wHCadcXoo67gVr/+3GFySh3134zi6rw==";
      };
    }
    {
      name = "is_date_object___is_date_object_1.0.5.tgz";
      path = fetchurl {
        name = "is_date_object___is_date_object_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz";
        sha512 = "9YQaSxsAiSwcvS33MBk3wTCVnWK+HhF8VZR2jRxehM16QcVOdHqPn4VPHmRK4lSr38n9JriurInLcP90xsYNfQ==";
      };
    }
    {
      name = "is_regex___is_regex_1.1.4.tgz";
      path = fetchurl {
        name = "is_regex___is_regex_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz";
        sha512 = "kvRdxDsxZjhzUX07ZnLydzS1TU/TJlTUHHY4YLL87e37oUA49DfkLqgy+VjFocowy29cKvcSiu+kIv728jTTVg==";
      };
    }
    {
      name = "isarray___isarray_1.0.0.tgz";
      path = fetchurl {
        name = "isarray___isarray_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz";
        sha512 = "VLghIWNM6ELQzo7zwmcg0NmTVyWKYjvIeM83yjp0wRDTmUnrM678fQbcKBo6n2CJEF0szoG//ytg+TKla89ALQ==";
      };
    }
    {
      name = "jquery_knob_chif___jquery_knob_chif_1.2.13.tgz";
      path = fetchurl {
        name = "jquery_knob_chif___jquery_knob_chif_1.2.13.tgz";
        url  = "https://registry.yarnpkg.com/jquery-knob-chif/-/jquery-knob-chif-1.2.13.tgz";
        sha512 = "dveq9MZCr68bRrsziuRusKS+/ciT1yOOHdENOSTcXVRM9MsEyCK/DjqR9nc7V3on41269PFdDE2Fuib8Cw4jAA==";
      };
    }
    {
      name = "jquery_mapael___jquery_mapael_2.2.0.tgz";
      path = fetchurl {
        name = "jquery_mapael___jquery_mapael_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/jquery-mapael/-/jquery-mapael-2.2.0.tgz";
        sha512 = "B5cVcCkfs7Ezia1Zs8bEfVacYD/GvaASyqQeidApR/NJ1C4igcExk9VULVsgLcTPkxohcZrrz5uCaPXvuKeZWw==";
      };
    }
    {
      name = "jquery_mousewheel___jquery_mousewheel_3.1.13.tgz";
      path = fetchurl {
        name = "jquery_mousewheel___jquery_mousewheel_3.1.13.tgz";
        url  = "https://registry.yarnpkg.com/jquery-mousewheel/-/jquery-mousewheel-3.1.13.tgz";
        sha512 = "GXhSjfOPyDemM005YCEHvzrEALhKDIswtxSHSR2e4K/suHVJKJxxRCGz3skPjNxjJjQa9AVSGGlYjv1M3VLIPg==";
      };
    }
    {
      name = "jquery_slimscroll___jquery_slimscroll_1.3.8.tgz";
      path = fetchurl {
        name = "jquery_slimscroll___jquery_slimscroll_1.3.8.tgz";
        url  = "https://registry.yarnpkg.com/jquery-slimscroll/-/jquery-slimscroll-1.3.8.tgz";
        sha512 = "3cNGNCq6i3b+rZQOx1tSBlSFewk4X35eUuQmoRVSA4MSytw3rGPvCw6cEB2oEHf+u15RVzgfh4hN+/3dDNzwiQ==";
      };
    }
    {
      name = "jquery_sparkline___jquery_sparkline_2.4.0.tgz";
      path = fetchurl {
        name = "jquery_sparkline___jquery_sparkline_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/jquery-sparkline/-/jquery-sparkline-2.4.0.tgz";
        sha512 = "SzjpMkOwlnqZpH4Ni2UbdRU5GxDl/BljgN8Smlun7CXUDqRhjPf2eolJ37KKcaG0/ufsMKY+XDERfPTV1hIcjg==";
      };
    }
    {
      name = "jquery_ui_dist___jquery_ui_dist_1.13.2.tgz";
      path = fetchurl {
        name = "jquery_ui_dist___jquery_ui_dist_1.13.2.tgz";
        url  = "https://registry.yarnpkg.com/jquery-ui-dist/-/jquery-ui-dist-1.13.2.tgz";
        sha512 = "oVDRd1NLtTbBwpRKAYdIRgpWVDzeBhfy7Gu0RmY6JEaZtmBq6kDn1pm5SgDiAotrnDS+RoTRXO6xvcNTxA9tOA==";
      };
    }
    {
      name = "jquery_validation___jquery_validation_1.19.5.tgz";
      path = fetchurl {
        name = "jquery_validation___jquery_validation_1.19.5.tgz";
        url  = "https://registry.yarnpkg.com/jquery-validation/-/jquery-validation-1.19.5.tgz";
        sha512 = "X2SmnPq1mRiDecVYL8edWx+yTBZDyC8ohWXFhXdtqFHgU9Wd4KHkvcbCoIZ0JaSaumzS8s2gXSkP8F7ivg/8ZQ==";
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
      name = "jquery___jquery_3.6.3.tgz";
      path = fetchurl {
        name = "jquery___jquery_3.6.3.tgz";
        url  = "https://registry.yarnpkg.com/jquery/-/jquery-3.6.3.tgz";
        sha512 = "bZ5Sy3YzKo9Fyc8wH2iIQK4JImJ6R0GWI9kL1/k7Z91ZBNgkRXE6U0JfHIizZbort8ZunhSI3jw9I6253ahKfg==";
      };
    }
    {
      name = "jqvmap_novulnerability___jqvmap_novulnerability_1.5.1.tgz";
      path = fetchurl {
        name = "jqvmap_novulnerability___jqvmap_novulnerability_1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/jqvmap-novulnerability/-/jqvmap-novulnerability-1.5.1.tgz";
        sha512 = "O6Jr7AGiut9iNJMelPdy8pH83tNXadOqmhJm5FZy9gtaZ5uuhZK3VNu+YLFuTpXeZI8YXUvlFUYbJJi5XHA+tw==";
      };
    }
    {
      name = "jsgrid___jsgrid_1.5.3.tgz";
      path = fetchurl {
        name = "jsgrid___jsgrid_1.5.3.tgz";
        url  = "https://registry.yarnpkg.com/jsgrid/-/jsgrid-1.5.3.tgz";
        sha512 = "/BJgQp7gZe8o/VgNelwXc21jHc9HN+l7WPOkBhC9b9jPXFtOrU9ftNLPVBmKYCNlIulAbGTW8SDJI0mpw7uWxQ==";
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
      name = "jszip___jszip_3.10.1.tgz";
      path = fetchurl {
        name = "jszip___jszip_3.10.1.tgz";
        url  = "https://registry.yarnpkg.com/jszip/-/jszip-3.10.1.tgz";
        sha512 = "xXDvecyTpGLrqFrvkrUSoxxfJI5AH7U8zxxtVclpsUtMCq4JQ290LY8AW5c7Ggnr/Y/oK+bQMbqK2qmtk3pN4g==";
      };
    }
    {
      name = "jtimeout___jtimeout_3.2.0.tgz";
      path = fetchurl {
        name = "jtimeout___jtimeout_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/jtimeout/-/jtimeout-3.2.0.tgz";
        sha512 = "P/cEhmgr8P2Vd3V79uUk6pHAHpMSe+Px7B+mGEir4aZW3/J6C09uH97aAEXVpjqb9i9vHnUyIp7k0UoA+Hy0eg==";
      };
    }
    {
      name = "knockout___knockout_3.5.1.tgz";
      path = fetchurl {
        name = "knockout___knockout_3.5.1.tgz";
        url  = "https://registry.yarnpkg.com/knockout/-/knockout-3.5.1.tgz";
        sha512 = "wRJ9I4az0QcsH7A4v4l0enUpkS++MBx0BnL/68KaLzJg7x1qmbjSlwEoCNol7KTYZ+pmtI7Eh2J0Nu6/2Z5J/Q==";
      };
    }
    {
      name = "levn___levn_0.3.0.tgz";
      path = fetchurl {
        name = "levn___levn_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz";
        sha512 = "0OO4y2iOHix2W6ujICbKIaEQXvFQHue65vUG3pb5EUomzPI90z9hsA1VsO/dbIIpC53J8gxM9Q4Oho0jrCM/yA==";
      };
    }
    {
      name = "lie___lie_3.3.0.tgz";
      path = fetchurl {
        name = "lie___lie_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lie/-/lie-3.3.0.tgz";
        sha512 = "UaiMJzeWRlEujzAuw5LokY1L5ecNQYZKfmyZ9L7wDHb/p5etKaxXhohBcrw0EYby+G/NA52vRSN4N39dxHAIwQ==";
      };
    }
    {
      name = "magic_string___magic_string_0.25.1.tgz";
      path = fetchurl {
        name = "magic_string___magic_string_0.25.1.tgz";
        url  = "https://registry.yarnpkg.com/magic-string/-/magic-string-0.25.1.tgz";
        sha512 = "sCuTz6pYom8Rlt4ISPFn6wuFodbKMIHUMv4Qko9P17dpxb7s52KJTmRuZZqHdGmLCK9AOcDare039nRIcfdkEg==";
      };
    }
    {
      name = "merge_source_map___merge_source_map_1.0.4.tgz";
      path = fetchurl {
        name = "merge_source_map___merge_source_map_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/merge-source-map/-/merge-source-map-1.0.4.tgz";
        sha512 = "PGSmS0kfnTnMJCzJ16BLLCEe6oeYCamKFFdQKshi4BmM6FUwipjVOcBFGxqtQtirtAG4iZvHlqST9CpZKqlRjA==";
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
      name = "moment_timezone___moment_timezone_0.5.40.tgz";
      path = fetchurl {
        name = "moment_timezone___moment_timezone_0.5.40.tgz";
        url  = "https://registry.yarnpkg.com/moment-timezone/-/moment-timezone-0.5.40.tgz";
        sha512 = "tWfmNkRYmBkPJz5mr9GVDn9vRlVZOTe6yqY92rFxiOdWXbjaR0+9LwQnZGGuNR63X456NqmEkbskte8tWL5ePg==";
      };
    }
    {
      name = "moment___moment_2.29.4.tgz";
      path = fetchurl {
        name = "moment___moment_2.29.4.tgz";
        url  = "https://registry.yarnpkg.com/moment/-/moment-2.29.4.tgz";
        sha512 = "5LC9SOxjSc2HF6vO2CyuTDNivEdoz2IvyJJGj6X8DJ0eFyfszE0QiEd+iXmBvUP3WHxSjFH/vIsA0EN00cgr8w==";
      };
    }
    {
      name = "multiselect___multiselect_0.9.12.tgz";
      path = fetchurl {
        name = "multiselect___multiselect_0.9.12.tgz";
        url  = "https://registry.yarnpkg.com/multiselect/-/multiselect-0.9.12.tgz";
        sha512 = "JCuFC288lp9m5xNlxsgX10dhZZv+5lIQQt4kM4H8uLysbiMJTYQBi0LuYguRunCvlXlGjFvH8O/YpL8x2lu9EA==";
      };
    }
    {
      name = "next_tick___next_tick_1.1.0.tgz";
      path = fetchurl {
        name = "next_tick___next_tick_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/next-tick/-/next-tick-1.1.0.tgz";
        sha512 = "CXdUiJembsNjuToQvxayPZF9Vqht7hewsvy2sOWafLvi2awflj9mOC6bHIg50orX8IJvWKY9wYQ/zB2kogPslQ==";
      };
    }
    {
      name = "object_inspect___object_inspect_1.12.3.tgz";
      path = fetchurl {
        name = "object_inspect___object_inspect_1.12.3.tgz";
        url  = "https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz";
        sha512 = "geUvdk7c+eizMNUDkRpW1wJwgfOiOeHbxBR/hLXK1aT6zmVSO0jsQcs7fj6MGw89jC/cjGfLcNOrtMYtGqm81g==";
      };
    }
    {
      name = "object_is___object_is_1.1.5.tgz";
      path = fetchurl {
        name = "object_is___object_is_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/object-is/-/object-is-1.1.5.tgz";
        sha512 = "3cyDsyHgtmi7I7DfSSI2LDp6SK2lwvtbg0p0R1e0RvTqF5ceGx+K2dfSjm1bKDMVCFEDAQvy+o8c6a7VujOddw==";
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
      name = "optionator___optionator_0.8.3.tgz";
      path = fetchurl {
        name = "optionator___optionator_0.8.3.tgz";
        url  = "https://registry.yarnpkg.com/optionator/-/optionator-0.8.3.tgz";
        sha512 = "+IW9pACdk3XWmmTXG8m3upGUJst5XRGzxMRjXzAuJ1XnIFNvfhjjIuYkDvysnPQ7qzqVzLt78BCruntqRhWQbA==";
      };
    }
    {
      name = "overlayscrollbars___overlayscrollbars_1.13.3.tgz";
      path = fetchurl {
        name = "overlayscrollbars___overlayscrollbars_1.13.3.tgz";
        url  = "https://registry.yarnpkg.com/overlayscrollbars/-/overlayscrollbars-1.13.3.tgz";
        sha512 = "1nB/B5kaakJuHXaLXLRK0bUIilWhUGT6q5g+l2s5vqYdLle/sd0kscBHkQC1kuuDg9p9WR4MTdySDOPbeL/86g==";
      };
    }
    {
      name = "pako___pako_0.2.9.tgz";
      path = fetchurl {
        name = "pako___pako_0.2.9.tgz";
        url  = "https://registry.yarnpkg.com/pako/-/pako-0.2.9.tgz";
        sha512 = "NUcwaKxUxWrZLpDG+z/xZaCgQITkA/Dv4V/T6bw7VON6l1Xz/VnrBqrYjZQ12TamKHzITTfOEIYUj48y2KXImA==";
      };
    }
    {
      name = "pako___pako_1.0.11.tgz";
      path = fetchurl {
        name = "pako___pako_1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/pako/-/pako-1.0.11.tgz";
        sha512 = "4hLB8Py4zZce5s4yd9XzopqwVv/yGNhV1Bl8NTmCq1763HeK2+EwVTv+leGeL13Dnh2wfbqowVPXCIO0z4taYw==";
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
      name = "pdfmake___pdfmake_0.2.7.tgz";
      path = fetchurl {
        name = "pdfmake___pdfmake_0.2.7.tgz";
        url  = "https://registry.yarnpkg.com/pdfmake/-/pdfmake-0.2.7.tgz";
        sha512 = "ClLpgx30H5G3EDvRW1MrA1Xih6YxEaSgIVFrOyBMgAAt62V+hxsyWAi6JNP7u1Fc5JKYAbpb4RRVw8Rhvmz5cQ==";
      };
    }
    {
      name = "png_js___png_js_1.0.0.tgz";
      path = fetchurl {
        name = "png_js___png_js_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/png-js/-/png-js-1.0.0.tgz";
        sha512 = "k+YsbhpA9e+EFfKjTCH3VW6aoKlyNYI6NYdTfDL4CIvFnvsuO84ttonmZE7rc+v23SLTH8XX+5w/Ak9v0xGY4g==";
      };
    }
    {
      name = "popper.js___popper.js_1.16.1.tgz";
      path = fetchurl {
        name = "popper.js___popper.js_1.16.1.tgz";
        url  = "https://registry.yarnpkg.com/popper.js/-/popper.js-1.16.1.tgz";
        sha512 = "Wb4p1J4zyFTbM+u6WuO4XstYx4Ky9Cewe4DWrel7B0w6VVICvPwdOpotjzcf6eD8TsckVnIMNONQyPIUFOUbCQ==";
      };
    }
    {
      name = "prelude_ls___prelude_ls_1.1.2.tgz";
      path = fetchurl {
        name = "prelude_ls___prelude_ls_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz";
        sha512 = "ESF23V4SKG6lVSGZgYNpbsiaAkdab6ZgOxe52p7+Kid3W3u3bxR4Vfd/o21dmN7jSt0IwgZ4v5MUd26FEtXE9w==";
      };
    }
    {
      name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
      path = fetchurl {
        name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz";
        sha512 = "3ouUOpQhtgrbOa17J7+uxOTpITYWaGP7/AhoR3+A+/1e9skrzelGi/dXzEYyvbxubEF6Wn2ypscTKiKJFFn1ag==";
      };
    }
    {
      name = "quote_stream___quote_stream_1.0.2.tgz";
      path = fetchurl {
        name = "quote_stream___quote_stream_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/quote-stream/-/quote-stream-1.0.2.tgz";
        sha512 = "kKr2uQ2AokadPjvTyKJQad9xELbZwYzWlNfI3Uz2j/ib5u6H9lDP7fUUR//rMycd0gv4Z5P1qXMfXR8YpIxrjQ==";
      };
    }
    {
      name = "raphael___raphael_2.3.0.tgz";
      path = fetchurl {
        name = "raphael___raphael_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/raphael/-/raphael-2.3.0.tgz";
        sha512 = "w2yIenZAQnp257XUWGni4bLMVxpUpcIl7qgxEgDIXtmSypYtlNxfXWpOBxs7LBTps5sDwhRnrToJrMUrivqNTQ==";
      };
    }
    {
      name = "readable_stream___readable_stream_2.3.7.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_2.3.7.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.7.tgz";
        sha512 = "Ebho8K4jIbHAxnuxi7o42OrZgF/ZTNcsZj6nRKyUmkhLFq8CHItp/fy6hQZuZmP/n3yZ9VBUbp4zz/mX8hmYPw==";
      };
    }
    {
      name = "regexp.prototype.flags___regexp.prototype.flags_1.4.3.tgz";
      path = fetchurl {
        name = "regexp.prototype.flags___regexp.prototype.flags_1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz";
        sha512 = "fjggEOO3slI6Wvgjwflkc4NFRCTZAu5CnNfBd5qOMYhWdn67nJBBu34/TkD++eeFmd8C9r9jfXJ27+nSiRkSUA==";
      };
    }
    {
      name = "resolve___resolve_1.1.7.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.1.7.tgz";
        sha512 = "9znBF0vBcaSN3W2j7wKvdERPwqTxSpCq+if5C0WoTCyV9n24rua28jeuQ2pL/HOf+yUe/Mef+H/5p60K0Id3bg==";
      };
    }
    {
      name = "resolve___resolve_1.22.1.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.22.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.22.1.tgz";
        sha512 = "nBpuuYuY5jFsli/JIs1oldw6fOQCBioohqWZg/2hiaOybXOft4lonv85uDOKXdf8rhyK159cxU5cDcK/NKk8zw==";
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.1.2.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha512 = "Gd2UZBJDkXlY7GbJxfsE8/nvKkUEU1G38c1siN6QP6a9PT9MmHB8GnpscSmMJSoF8LOIrt8ud/wPtojys4G6+g==";
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
      name = "sax___sax_1.2.4.tgz";
      path = fetchurl {
        name = "sax___sax_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz";
        sha512 = "NqVDv9TpANUjFm0N8uM5GxL36UgKi9/atZw+x7YFnQ8ckwFGKrl4xX4yWtrey3UJm5nP1kUbnYgLopqWNSRhWw==";
      };
    }
    {
      name = "scope_analyzer___scope_analyzer_2.1.2.tgz";
      path = fetchurl {
        name = "scope_analyzer___scope_analyzer_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/scope-analyzer/-/scope-analyzer-2.1.2.tgz";
        sha512 = "5cfCmsTYV/wPaRIItNxatw02ua/MThdIUNnUOCYp+3LSEJvnG804ANw2VLaavNILIfWXF1D1G2KNANkBBvInwQ==";
      };
    }
    {
      name = "select2___select2_4.0.13.tgz";
      path = fetchurl {
        name = "select2___select2_4.0.13.tgz";
        url  = "https://registry.yarnpkg.com/select2/-/select2-4.0.13.tgz";
        sha512 = "1JeB87s6oN/TDxQQYCvS5EFoQyvV6eYMZZ0AeA4tdFDYWN3BAGZ8npr17UBFddU0lgAt3H0yjX3X6/ekOj1yjw==";
      };
    }
    {
      name = "setimmediate___setimmediate_1.0.5.tgz";
      path = fetchurl {
        name = "setimmediate___setimmediate_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz";
        sha512 = "MATJdZp8sLqDl/68LfQmbP8zKPLQNV6BIZoIgrscFDQ+RsvK/BxeDQOgyxKKoh0y/8h3BqVFnCqQ/gd+reiIXA==";
      };
    }
    {
      name = "shallow_copy___shallow_copy_0.0.1.tgz";
      path = fetchurl {
        name = "shallow_copy___shallow_copy_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/shallow-copy/-/shallow-copy-0.0.1.tgz";
        sha512 = "b6i4ZpVuUxB9h5gfCxPiusKYkqTMOjEbBs4wMaFbkfia4yFv92UKZ6Df8WXcKbn08JNL/abvg3FnMAOfakDvUw==";
      };
    }
    {
      name = "source_map___source_map_0.5.7.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.5.7.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz";
        sha512 = "LbrmJOMUSdEVxIKvdcJzQC+nQhe8FUZQTXQy6+I75skNgn3OoQ0DZA8YnFa7gp8tqtL3KPf1kmo0R5DoApeSGQ==";
      };
    }
    {
      name = "source_map___source_map_0.1.43.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.1.43.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.1.43.tgz";
        sha512 = "VtCvB9SIQhk3aF6h+N85EaqIaBFIAfZ9Cu+NJHHVvc8BbEcnvDcFw6sqQ2dQrT6SlOrZq3tIvyD9+EGq/lJryQ==";
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
      name = "sourcemap_codec___sourcemap_codec_1.4.8.tgz";
      path = fetchurl {
        name = "sourcemap_codec___sourcemap_codec_1.4.8.tgz";
        url  = "https://registry.yarnpkg.com/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz";
        sha512 = "9NykojV5Uih4lgo5So5dtw+f0JgJX30KCNI8gwhz2J9A15wD0Ml6tjHKwf6fTSa6fAdVBdZeNOs9eJ71qCk8vA==";
      };
    }
    {
      name = "sparklines___sparklines_1.3.0.tgz";
      path = fetchurl {
        name = "sparklines___sparklines_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/sparklines/-/sparklines-1.3.0.tgz";
        sha512 = "CkFtpDE3hmOeu1IJyIQIOH0AQtHnPj1c61ALxJZQ9cPEFKDgWC1fcNAHuwPi1i1klTDYvlKKseoYHSwe7JmdLA==";
      };
    }
    {
      name = "static_eval___static_eval_2.1.0.tgz";
      path = fetchurl {
        name = "static_eval___static_eval_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/static-eval/-/static-eval-2.1.0.tgz";
        sha512 = "agtxZ/kWSsCkI5E4QifRwsaPs0P0JmZV6dkLz6ILYfFYQGn+5plctanRN+IC8dJRiFkyXHrwEE3W9Wmx67uDbw==";
      };
    }
    {
      name = "static_module___static_module_3.0.4.tgz";
      path = fetchurl {
        name = "static_module___static_module_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/static-module/-/static-module-3.0.4.tgz";
        sha512 = "gb0v0rrgpBkifXCa3yZXxqVmXDVE+ETXj6YlC/jt5VzOnGXR2C15+++eXuMDUYsePnbhf+lwW0pE1UXyOLtGCw==";
      };
    }
    {
      name = "string_decoder___string_decoder_1.1.1.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz";
        sha512 = "n/ShnvDi6FHbbVfviro+WojiFzv+s8MPMHBczVePfUpDJLwoLT0ht1l4YwBCbi8pJAveEEdnkHyPyTP/mzRfwg==";
      };
    }
    {
      name = "summernote___summernote_0.8.20.tgz";
      path = fetchurl {
        name = "summernote___summernote_0.8.20.tgz";
        url  = "https://registry.yarnpkg.com/summernote/-/summernote-0.8.20.tgz";
        sha512 = "W9RhjQjsn+b1s9xiJQgJbCiYGJaDAc9CdEqXo+D13WuStG8lCdtKaO5AiNiSSMJsQJN2EfGSwbBQt+SFE2B8Kw==";
      };
    }
    {
      name = "supports_preserve_symlinks_flag___supports_preserve_symlinks_flag_1.0.0.tgz";
      path = fetchurl {
        name = "supports_preserve_symlinks_flag___supports_preserve_symlinks_flag_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz";
        sha512 = "ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==";
      };
    }
    {
      name = "sweetalert2___sweetalert2_11.7.2.tgz";
      path = fetchurl {
        name = "sweetalert2___sweetalert2_11.7.2.tgz";
        url  = "https://registry.yarnpkg.com/sweetalert2/-/sweetalert2-11.7.2.tgz";
        sha512 = "atPjDa3fv/4xwZpiAt7FZUgAhR5VAASiLP2hu7HUeVDXx+v4/9nD1W0u8xal1e9f2/qGh0DwTxPXPV9XoZIBvg==";
      };
    }
    {
      name = "tempusdominus_bootstrap_4___tempusdominus_bootstrap_4_5.39.2.tgz";
      path = fetchurl {
        name = "tempusdominus_bootstrap_4___tempusdominus_bootstrap_4_5.39.2.tgz";
        url  = "https://registry.yarnpkg.com/tempusdominus-bootstrap-4/-/tempusdominus-bootstrap-4-5.39.2.tgz";
        sha512 = "8Au4miSAsMGdsElPg87EUmsN7aGJFaRA5Y8Ale7dDTfhhnQL1Za53LclIJkq+t/7NO5+Ufr1jY7tmEPvWGHaVg==";
      };
    }
    {
      name = "through2___through2_2.0.5.tgz";
      path = fetchurl {
        name = "through2___through2_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz";
        sha512 = "/mrRod8xqpA+IHSLyGCQ2s8SPHiCDEeQJSep1jqLYeEUClOFG2Qsh+4FU6G9VeqpZnGW/Su8LQGc4YKni5rYSQ==";
      };
    }
    {
      name = "through___through_2.3.8.tgz";
      path = fetchurl {
        name = "through___through_2.3.8.tgz";
        url  = "https://registry.yarnpkg.com/through/-/through-2.3.8.tgz";
        sha512 = "w89qg7PI8wAdvX60bMDP+bFoD5Dvhm9oLheFp5O4a2QF0cSBGsBX4qZmadPMvVqlLJBBci+WqGGOAPvcDeNSVg==";
      };
    }
    {
      name = "tiny_inflate___tiny_inflate_1.0.3.tgz";
      path = fetchurl {
        name = "tiny_inflate___tiny_inflate_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/tiny-inflate/-/tiny-inflate-1.0.3.tgz";
        sha512 = "pkY1fj1cKHb2seWDy0B16HeWyczlJA9/WW3u3c4z/NiWDsO3DOU5D7nhTLE9CF0yXv/QZFY7sEJmj24dK+Rrqw==";
      };
    }
    {
      name = "toastr___toastr_2.1.4.tgz";
      path = fetchurl {
        name = "toastr___toastr_2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/toastr/-/toastr-2.1.4.tgz";
        sha512 = "LIy77F5n+sz4tefMmFOntcJ6HL0Fv3k1TDnNmFZ0bU/GcvIIfy6eG2v7zQmMiYgaalAiUv75ttFrPn5s0gyqlA==";
      };
    }
    {
      name = "type_check___type_check_0.3.2.tgz";
      path = fetchurl {
        name = "type_check___type_check_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz";
        sha512 = "ZCmOJdvOWDBYJlzAoFkC+Q0+bUyEOS1ltgp1MGU03fqHG+dbi9tBFU2Rd9QKiDZFAYrhPh2JUf7rZRIuHRKtOg==";
      };
    }
    {
      name = "type___type_1.2.0.tgz";
      path = fetchurl {
        name = "type___type_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/type/-/type-1.2.0.tgz";
        sha512 = "+5nt5AAniqsCnu2cEQQdpzCAh33kVx8n0VoFidKpB1dVVLAN/F+bgVOqOJqOnEnrhp222clB5p3vUlD+1QAnfg==";
      };
    }
    {
      name = "type___type_2.7.2.tgz";
      path = fetchurl {
        name = "type___type_2.7.2.tgz";
        url  = "https://registry.yarnpkg.com/type/-/type-2.7.2.tgz";
        sha512 = "dzlvlNlt6AXU7EBSfpAscydQ7gXB+pPGsPnfJnZpiNJBDj7IaJzQlBZYGdEi4R9HmPdBv2XmWJ6YUtoTa7lmCw==";
      };
    }
    {
      name = "typedarray___typedarray_0.0.6.tgz";
      path = fetchurl {
        name = "typedarray___typedarray_0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz";
        sha512 = "/aCDEGatGvZ2BIk+HmLf4ifCJFwvKFNb9/JeZPMulfgFracn9QFcAf5GO8B/mweUjSoblS5In0cWhqpfs/5PQA==";
      };
    }
    {
      name = "unicode_properties___unicode_properties_1.4.1.tgz";
      path = fetchurl {
        name = "unicode_properties___unicode_properties_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/unicode-properties/-/unicode-properties-1.4.1.tgz";
        sha512 = "CLjCCLQ6UuMxWnbIylkisbRj31qxHPAurvena/0iwSVbQ2G1VY5/HjV0IRabOEbDHlzZlRdCrD4NhB0JtU40Pg==";
      };
    }
    {
      name = "unicode_trie___unicode_trie_2.0.0.tgz";
      path = fetchurl {
        name = "unicode_trie___unicode_trie_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unicode-trie/-/unicode-trie-2.0.0.tgz";
        sha512 = "x7bc76x0bm4prf1VLg79uhAzKw8DVboClSN5VxJuQ+LKDOVEW9CdH+VY7SP+vX7xCYQqzzgQpFqz15zeLvAtZQ==";
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
      name = "uplot___uplot_1.6.24.tgz";
      path = fetchurl {
        name = "uplot___uplot_1.6.24.tgz";
        url  = "https://registry.yarnpkg.com/uplot/-/uplot-1.6.24.tgz";
        sha512 = "WpH2BsrFrqxkMu+4XBvc0eCDsRBhzoq9crttYeSI0bfxpzR5YoSVzZXOKFVWcVC7sp/aDXrdDPbDZGCtck2PVg==";
      };
    }
    {
      name = "util_deprecate___util_deprecate_1.0.2.tgz";
      path = fetchurl {
        name = "util_deprecate___util_deprecate_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha512 = "EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==";
      };
    }
    {
      name = "word_wrap___word_wrap_1.2.3.tgz";
      path = fetchurl {
        name = "word_wrap___word_wrap_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz";
        sha512 = "Hz/mrNwitNRh/HUAtM/VT/5VH+ygD6DV7mYKZAtHOrbs8U7lvPS6xf7EJKMF0uW1KJCl0H701g3ZGus+muE5vQ==";
      };
    }
    {
      name = "xmldoc___xmldoc_1.2.0.tgz";
      path = fetchurl {
        name = "xmldoc___xmldoc_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/xmldoc/-/xmldoc-1.2.0.tgz";
        sha512 = "2eN8QhjBsMW2uVj7JHLHkMytpvGHLHxKXBy4J3fAT/HujsEtM6yU84iGjpESYGHg6XwK0Vu4l+KgqQ2dv2cCqg==";
      };
    }
    {
      name = "xtend___xtend_4.0.2.tgz";
      path = fetchurl {
        name = "xtend___xtend_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz";
        sha512 = "LKYU1iAXJXUgAXn9URjiu+MWhyUXHsvfp7mcuYm9dSUKK0/CjtrUwFAxD82/mCWbtLsGjFIad0wIsod4zrTAEQ==";
      };
    }
  ];
}
