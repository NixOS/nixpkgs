{fetchurl, linkFarm}: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [

    {
      name = "abbrev-1.0.9.tgz";
      path = fetchurl {
        name = "abbrev-1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/abbrev/-/abbrev-1.0.9.tgz";
        sha1 = "91b4792588a7738c25f35dd6f63752a2f8776135";
      };
    }

    {
      name = "accepts-1.3.3.tgz";
      path = fetchurl {
        name = "accepts-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/accepts/-/accepts-1.3.3.tgz";
        sha1 = "c3ca7434938648c3e0d9c1e328dd68b622c284ca";
      };
    }

    {
      name = "acorn-dynamic-import-2.0.1.tgz";
      path = fetchurl {
        name = "acorn-dynamic-import-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn-dynamic-import/-/acorn-dynamic-import-2.0.1.tgz";
        sha1 = "23f671eb6e650dab277fef477c321b1178a8cca2";
      };
    }

    {
      name = "acorn-jsx-3.0.1.tgz";
      path = fetchurl {
        name = "acorn-jsx-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-3.0.1.tgz";
        sha1 = "afdf9488fb1ecefc8348f6fb22f464e32a58b36b";
      };
    }

    {
      name = "acorn-4.0.4.tgz";
      path = fetchurl {
        name = "acorn-4.0.4.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-4.0.4.tgz";
        sha1 = "17a8d6a7a6c4ef538b814ec9abac2779293bf30a";
      };
    }

    {
      name = "acorn-3.3.0.tgz";
      path = fetchurl {
        name = "acorn-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-3.3.0.tgz";
        sha1 = "45e37fb39e8da3f25baee3ff5369e2bb5f22017a";
      };
    }

    {
      name = "acorn-5.0.3.tgz";
      path = fetchurl {
        name = "acorn-5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-5.0.3.tgz";
        sha1 = "c460df08491463f028ccb82eab3730bf01087b3d";
      };
    }

    {
      name = "after-0.8.2.tgz";
      path = fetchurl {
        name = "after-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/after/-/after-0.8.2.tgz";
        sha1 = "fedb394f9f0e02aa9768e702bda23b505fae7e1f";
      };
    }

    {
      name = "ajv-keywords-1.5.1.tgz";
      path = fetchurl {
        name = "ajv-keywords-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-1.5.1.tgz";
        sha1 = "314dd0a4b3368fad3dfcdc54ede6171b886daf3c";
      };
    }

    {
      name = "ajv-4.11.2.tgz";
      path = fetchurl {
        name = "ajv-4.11.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-4.11.2.tgz";
        sha1 = "f166c3c11cbc6cb9dcc102a5bcfe5b72c95287e6";
      };
    }

    {
      name = "align-text-0.1.4.tgz";
      path = fetchurl {
        name = "align-text-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/align-text/-/align-text-0.1.4.tgz";
        sha1 = "0cd90a561093f35d0a99256c22b7069433fad117";
      };
    }

    {
      name = "alphanum-sort-1.0.2.tgz";
      path = fetchurl {
        name = "alphanum-sort-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/alphanum-sort/-/alphanum-sort-1.0.2.tgz";
        sha1 = "97a1119649b211ad33691d9f9f486a8ec9fbe0a3";
      };
    }

    {
      name = "amdefine-1.0.1.tgz";
      path = fetchurl {
        name = "amdefine-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/amdefine/-/amdefine-1.0.1.tgz";
        sha1 = "4a5282ac164729e93619bcfd3ad151f817ce91f5";
      };
    }

    {
      name = "ansi-escapes-1.4.0.tgz";
      path = fetchurl {
        name = "ansi-escapes-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-1.4.0.tgz";
        sha1 = "d3a8a83b319aa67793662b13e761c7911422306e";
      };
    }

    {
      name = "ansi-html-0.0.5.tgz";
      path = fetchurl {
        name = "ansi-html-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/ansi-html/-/ansi-html-0.0.5.tgz";
        sha1 = "0dcaa5a081206866bc240a3b773a184ea3b88b64";
      };
    }

    {
      name = "ansi-html-0.0.7.tgz";
      path = fetchurl {
        name = "ansi-html-0.0.7.tgz";
        url  = "https://registry.yarnpkg.com/ansi-html/-/ansi-html-0.0.7.tgz";
        sha1 = "813584021962a9e9e6fd039f940d12f56ca7859e";
      };
    }

    {
      name = "ansi-regex-2.1.1.tgz";
      path = fetchurl {
        name = "ansi-regex-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz";
        sha1 = "c3b33ab5ee360d86e0e628f0468ae7ef27d654df";
      };
    }

    {
      name = "ansi-styles-2.2.1.tgz";
      path = fetchurl {
        name = "ansi-styles-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz";
        sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
      };
    }

    {
      name = "anymatch-1.3.0.tgz";
      path = fetchurl {
        name = "anymatch-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-1.3.0.tgz";
        sha1 = "a3e52fa39168c825ff57b0248126ce5a8ff95507";
      };
    }

    {
      name = "append-transform-0.4.0.tgz";
      path = fetchurl {
        name = "append-transform-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/append-transform/-/append-transform-0.4.0.tgz";
        sha1 = "d76ebf8ca94d276e247a36bad44a4b74ab611991";
      };
    }

    {
      name = "aproba-1.1.0.tgz";
      path = fetchurl {
        name = "aproba-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/aproba/-/aproba-1.1.0.tgz";
        sha1 = "4d8f047a318604e18e3c06a0e52230d3d19f147b";
      };
    }

    {
      name = "are-we-there-yet-1.1.2.tgz";
      path = fetchurl {
        name = "are-we-there-yet-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.2.tgz";
        sha1 = "80e470e95a084794fe1899262c5667c6e88de1b3";
      };
    }

    {
      name = "argparse-1.0.9.tgz";
      path = fetchurl {
        name = "argparse-1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/argparse/-/argparse-1.0.9.tgz";
        sha1 = "73d83bc263f86e97f8cc4f6bae1b0e90a7d22c86";
      };
    }

    {
      name = "arr-diff-2.0.0.tgz";
      path = fetchurl {
        name = "arr-diff-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-diff/-/arr-diff-2.0.0.tgz";
        sha1 = "8f3b827f955a8bd669697e4a4256ac3ceae356cf";
      };
    }

    {
      name = "arr-flatten-1.0.1.tgz";
      path = fetchurl {
        name = "arr-flatten-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.0.1.tgz";
        sha1 = "e5ffe54d45e19f32f216e91eb99c8ce892bb604b";
      };
    }

    {
      name = "array-find-1.0.0.tgz";
      path = fetchurl {
        name = "array-find-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/array-find/-/array-find-1.0.0.tgz";
        sha1 = "6c8e286d11ed768327f8e62ecee87353ca3e78b8";
      };
    }

    {
      name = "array-flatten-1.1.1.tgz";
      path = fetchurl {
        name = "array-flatten-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/array-flatten/-/array-flatten-1.1.1.tgz";
        sha1 = "9a5f699051b1e7073328f2a008968b64ea2955d2";
      };
    }

    {
      name = "array-slice-0.2.3.tgz";
      path = fetchurl {
        name = "array-slice-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/array-slice/-/array-slice-0.2.3.tgz";
        sha1 = "dd3cfb80ed7973a75117cdac69b0b99ec86186f5";
      };
    }

    {
      name = "array-union-1.0.2.tgz";
      path = fetchurl {
        name = "array-union-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/array-union/-/array-union-1.0.2.tgz";
        sha1 = "9a34410e4f4e3da23dea375be5be70f24778ec39";
      };
    }

    {
      name = "array-uniq-1.0.3.tgz";
      path = fetchurl {
        name = "array-uniq-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz";
        sha1 = "af6ac877a25cc7f74e058894753858dfdb24fdb6";
      };
    }

    {
      name = "array-unique-0.2.1.tgz";
      path = fetchurl {
        name = "array-unique-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/array-unique/-/array-unique-0.2.1.tgz";
        sha1 = "a1d97ccafcbc2625cc70fadceb36a50c58b01a53";
      };
    }

    {
      name = "arraybuffer.slice-0.0.6.tgz";
      path = fetchurl {
        name = "arraybuffer.slice-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/arraybuffer.slice/-/arraybuffer.slice-0.0.6.tgz";
        sha1 = "f33b2159f0532a3f3107a272c0ccfbd1ad2979ca";
      };
    }

    {
      name = "arrify-1.0.1.tgz";
      path = fetchurl {
        name = "arrify-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz";
        sha1 = "898508da2226f380df904728456849c1501a4b0d";
      };
    }

    {
      name = "asn1.js-4.9.1.tgz";
      path = fetchurl {
        name = "asn1.js-4.9.1.tgz";
        url  = "https://registry.yarnpkg.com/asn1.js/-/asn1.js-4.9.1.tgz";
        sha1 = "48ba240b45a9280e94748990ba597d216617fd40";
      };
    }

    {
      name = "asn1-0.2.3.tgz";
      path = fetchurl {
        name = "asn1-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/asn1/-/asn1-0.2.3.tgz";
        sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
      };
    }

    {
      name = "assert-plus-0.2.0.tgz";
      path = fetchurl {
        name = "assert-plus-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-0.2.0.tgz";
        sha1 = "d74e1b87e7affc0db8aadb7021f3fe48101ab234";
      };
    }

    {
      name = "assert-plus-1.0.0.tgz";
      path = fetchurl {
        name = "assert-plus-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz";
        sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
      };
    }

    {
      name = "assert-1.4.1.tgz";
      path = fetchurl {
        name = "assert-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/assert/-/assert-1.4.1.tgz";
        sha1 = "99912d591836b5a6f5b345c0f07eefc08fc65d91";
      };
    }

    {
      name = "async-each-1.0.1.tgz";
      path = fetchurl {
        name = "async-each-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/async-each/-/async-each-1.0.1.tgz";
        sha1 = "19d386a1d9edc6e7c1c85d388aedbcc56d33602d";
      };
    }

    {
      name = "async-0.2.10.tgz";
      path = fetchurl {
        name = "async-0.2.10.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-0.2.10.tgz";
        sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
      };
    }

    {
      name = "async-1.5.2.tgz";
      path = fetchurl {
        name = "async-1.5.2.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-1.5.2.tgz";
        sha1 = "ec6a61ae56480c0c3cb241c95618e20892f9672a";
      };
    }

    {
      name = "async-2.1.4.tgz";
      path = fetchurl {
        name = "async-2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-2.1.4.tgz";
        sha1 = "2d2160c7788032e4dd6cbe2502f1f9a2c8f6cde4";
      };
    }

    {
      name = "async-0.9.2.tgz";
      path = fetchurl {
        name = "async-0.9.2.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-0.9.2.tgz";
        sha1 = "aea74d5e61c1f899613bf64bda66d4c78f2fd17d";
      };
    }

    {
      name = "asynckit-0.4.0.tgz";
      path = fetchurl {
        name = "asynckit-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz";
        sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
      };
    }

    {
      name = "autoprefixer-6.7.7.tgz";
      path = fetchurl {
        name = "autoprefixer-6.7.7.tgz";
        url  = "https://registry.yarnpkg.com/autoprefixer/-/autoprefixer-6.7.7.tgz";
        sha1 = "1dbd1c835658e35ce3f9984099db00585c782014";
      };
    }

    {
      name = "aws-sign2-0.6.0.tgz";
      path = fetchurl {
        name = "aws-sign2-0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.6.0.tgz";
        sha1 = "14342dd38dbcc94d0e5b87d763cd63612c0e794f";
      };
    }

    {
      name = "aws4-1.6.0.tgz";
      path = fetchurl {
        name = "aws4-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/aws4/-/aws4-1.6.0.tgz";
        sha1 = "83ef5ca860b2b32e4a0deedee8c771b9db57471e";
      };
    }

    {
      name = "babel-code-frame-6.22.0.tgz";
      path = fetchurl {
        name = "babel-code-frame-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-code-frame/-/babel-code-frame-6.22.0.tgz";
        sha1 = "027620bee567a88c32561574e7fd0801d33118e4";
      };
    }

    {
      name = "babel-core-6.23.1.tgz";
      path = fetchurl {
        name = "babel-core-6.23.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-core/-/babel-core-6.23.1.tgz";
        sha1 = "c143cb621bb2f621710c220c5d579d15b8a442df";
      };
    }

    {
      name = "babel-generator-6.23.0.tgz";
      path = fetchurl {
        name = "babel-generator-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-generator/-/babel-generator-6.23.0.tgz";
        sha1 = "6b8edab956ef3116f79d8c84c5a3c05f32a74bc5";
      };
    }

    {
      name = "babel-helper-bindify-decorators-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-bindify-decorators-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-bindify-decorators/-/babel-helper-bindify-decorators-6.22.0.tgz";
        sha1 = "d7f5bc261275941ac62acfc4e20dacfb8a3fe952";
      };
    }

    {
      name = "babel-helper-builder-binary-assignment-operator-visitor-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-builder-binary-assignment-operator-visitor-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-builder-binary-assignment-operator-visitor/-/babel-helper-builder-binary-assignment-operator-visitor-6.22.0.tgz";
        sha1 = "29df56be144d81bdeac08262bfa41d2c5e91cdcd";
      };
    }

    {
      name = "babel-helper-call-delegate-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-call-delegate-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-call-delegate/-/babel-helper-call-delegate-6.22.0.tgz";
        sha1 = "119921b56120f17e9dae3f74b4f5cc7bcc1b37ef";
      };
    }

    {
      name = "babel-helper-define-map-6.23.0.tgz";
      path = fetchurl {
        name = "babel-helper-define-map-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-define-map/-/babel-helper-define-map-6.23.0.tgz";
        sha1 = "1444f960c9691d69a2ced6a205315f8fd00804e7";
      };
    }

    {
      name = "babel-helper-explode-assignable-expression-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-explode-assignable-expression-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-explode-assignable-expression/-/babel-helper-explode-assignable-expression-6.22.0.tgz";
        sha1 = "c97bf76eed3e0bae4048121f2b9dae1a4e7d0478";
      };
    }

    {
      name = "babel-helper-explode-class-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-explode-class-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-explode-class/-/babel-helper-explode-class-6.22.0.tgz";
        sha1 = "646304924aa6388a516843ba7f1855ef8dfeb69b";
      };
    }

    {
      name = "babel-helper-function-name-6.23.0.tgz";
      path = fetchurl {
        name = "babel-helper-function-name-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-function-name/-/babel-helper-function-name-6.23.0.tgz";
        sha1 = "25742d67175c8903dbe4b6cb9d9e1fcb8dcf23a6";
      };
    }

    {
      name = "babel-helper-get-function-arity-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-get-function-arity-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-get-function-arity/-/babel-helper-get-function-arity-6.22.0.tgz";
        sha1 = "0beb464ad69dc7347410ac6ade9f03a50634f5ce";
      };
    }

    {
      name = "babel-helper-hoist-variables-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-hoist-variables-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-hoist-variables/-/babel-helper-hoist-variables-6.22.0.tgz";
        sha1 = "3eacbf731d80705845dd2e9718f600cfb9b4ba72";
      };
    }

    {
      name = "babel-helper-optimise-call-expression-6.23.0.tgz";
      path = fetchurl {
        name = "babel-helper-optimise-call-expression-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-optimise-call-expression/-/babel-helper-optimise-call-expression-6.23.0.tgz";
        sha1 = "f3ee7eed355b4282138b33d02b78369e470622f5";
      };
    }

    {
      name = "babel-helper-regex-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-regex-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-regex/-/babel-helper-regex-6.22.0.tgz";
        sha1 = "79f532be1647b1f0ee3474b5f5c3da58001d247d";
      };
    }

    {
      name = "babel-helper-remap-async-to-generator-6.22.0.tgz";
      path = fetchurl {
        name = "babel-helper-remap-async-to-generator-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-remap-async-to-generator/-/babel-helper-remap-async-to-generator-6.22.0.tgz";
        sha1 = "2186ae73278ed03b8b15ced089609da981053383";
      };
    }

    {
      name = "babel-helper-replace-supers-6.23.0.tgz";
      path = fetchurl {
        name = "babel-helper-replace-supers-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-replace-supers/-/babel-helper-replace-supers-6.23.0.tgz";
        sha1 = "eeaf8ad9b58ec4337ca94223bacdca1f8d9b4bfd";
      };
    }

    {
      name = "babel-helpers-6.23.0.tgz";
      path = fetchurl {
        name = "babel-helpers-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helpers/-/babel-helpers-6.23.0.tgz";
        sha1 = "4f8f2e092d0b6a8808a4bde79c27f1e2ecf0d992";
      };
    }

    {
      name = "babel-loader-6.2.10.tgz";
      path = fetchurl {
        name = "babel-loader-6.2.10.tgz";
        url  = "https://registry.yarnpkg.com/babel-loader/-/babel-loader-6.2.10.tgz";
        sha1 = "adefc2b242320cd5d15e65b31cea0e8b1b02d4b0";
      };
    }

    {
      name = "babel-messages-6.23.0.tgz";
      path = fetchurl {
        name = "babel-messages-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-messages/-/babel-messages-6.23.0.tgz";
        sha1 = "f3cdf4703858035b2a2951c6ec5edf6c62f2630e";
      };
    }

    {
      name = "babel-plugin-check-es2015-constants-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-check-es2015-constants-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-check-es2015-constants/-/babel-plugin-check-es2015-constants-6.22.0.tgz";
        sha1 = "35157b101426fd2ffd3da3f75c7d1e91835bbf8a";
      };
    }

    {
      name = "babel-plugin-istanbul-4.0.0.tgz";
      path = fetchurl {
        name = "babel-plugin-istanbul-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-istanbul/-/babel-plugin-istanbul-4.0.0.tgz";
        sha1 = "36bde8fbef4837e5ff0366531a2beabd7b1ffa10";
      };
    }

    {
      name = "babel-plugin-syntax-async-functions-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-async-functions-6.13.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-async-functions/-/babel-plugin-syntax-async-functions-6.13.0.tgz";
        sha1 = "cad9cad1191b5ad634bf30ae0872391e0647be95";
      };
    }

    {
      name = "babel-plugin-syntax-async-generators-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-async-generators-6.13.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-async-generators/-/babel-plugin-syntax-async-generators-6.13.0.tgz";
        sha1 = "6bc963ebb16eccbae6b92b596eb7f35c342a8b9a";
      };
    }

    {
      name = "babel-plugin-syntax-class-properties-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-class-properties-6.13.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-class-properties/-/babel-plugin-syntax-class-properties-6.13.0.tgz";
        sha1 = "d7eb23b79a317f8543962c505b827c7d6cac27de";
      };
    }

    {
      name = "babel-plugin-syntax-decorators-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-decorators-6.13.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-decorators/-/babel-plugin-syntax-decorators-6.13.0.tgz";
        sha1 = "312563b4dbde3cc806cee3e416cceeaddd11ac0b";
      };
    }

    {
      name = "babel-plugin-syntax-dynamic-import-6.18.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-dynamic-import-6.18.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-dynamic-import/-/babel-plugin-syntax-dynamic-import-6.18.0.tgz";
        sha1 = "8d6a26229c83745a9982a441051572caa179b1da";
      };
    }

    {
      name = "babel-plugin-syntax-exponentiation-operator-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-exponentiation-operator-6.13.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-exponentiation-operator/-/babel-plugin-syntax-exponentiation-operator-6.13.0.tgz";
        sha1 = "9ee7e8337290da95288201a6a57f4170317830de";
      };
    }

    {
      name = "babel-plugin-syntax-object-rest-spread-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-object-rest-spread-6.13.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-object-rest-spread/-/babel-plugin-syntax-object-rest-spread-6.13.0.tgz";
        sha1 = "fd6536f2bce13836ffa3a5458c4903a597bb3bf5";
      };
    }

    {
      name = "babel-plugin-syntax-trailing-function-commas-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-trailing-function-commas-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-trailing-function-commas/-/babel-plugin-syntax-trailing-function-commas-6.22.0.tgz";
        sha1 = "ba0360937f8d06e40180a43fe0d5616fff532cf3";
      };
    }

    {
      name = "babel-plugin-transform-async-generator-functions-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-async-generator-functions-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-async-generator-functions/-/babel-plugin-transform-async-generator-functions-6.22.0.tgz";
        sha1 = "a720a98153a7596f204099cd5409f4b3c05bab46";
      };
    }

    {
      name = "babel-plugin-transform-async-to-generator-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-async-to-generator-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-async-to-generator/-/babel-plugin-transform-async-to-generator-6.22.0.tgz";
        sha1 = "194b6938ec195ad36efc4c33a971acf00d8cd35e";
      };
    }

    {
      name = "babel-plugin-transform-class-properties-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-class-properties-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-class-properties/-/babel-plugin-transform-class-properties-6.23.0.tgz";
        sha1 = "187b747ee404399013563c993db038f34754ac3b";
      };
    }

    {
      name = "babel-plugin-transform-decorators-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-decorators-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-decorators/-/babel-plugin-transform-decorators-6.22.0.tgz";
        sha1 = "c03635b27a23b23b7224f49232c237a73988d27c";
      };
    }

    {
      name = "babel-plugin-transform-define-1.2.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-define-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-define/-/babel-plugin-transform-define-1.2.0.tgz";
        sha1 = "f036bda05162f29a542e434f585da1ccf1e7ec6a";
      };
    }

    {
      name = "babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-arrow-functions/-/babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
        sha1 = "452692cb711d5f79dc7f85e440ce41b9f244d221";
      };
    }

    {
      name = "babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-block-scoped-functions/-/babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz";
        sha1 = "bbc51b49f964d70cb8d8e0b94e820246ce3a6141";
      };
    }

    {
      name = "babel-plugin-transform-es2015-block-scoping-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-block-scoping-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-block-scoping/-/babel-plugin-transform-es2015-block-scoping-6.23.0.tgz";
        sha1 = "e48895cf0b375be148cd7c8879b422707a053b51";
      };
    }

    {
      name = "babel-plugin-transform-es2015-classes-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-classes-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-classes/-/babel-plugin-transform-es2015-classes-6.23.0.tgz";
        sha1 = "49b53f326202a2fd1b3bbaa5e2edd8a4f78643c1";
      };
    }

    {
      name = "babel-plugin-transform-es2015-computed-properties-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-computed-properties-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-computed-properties/-/babel-plugin-transform-es2015-computed-properties-6.22.0.tgz";
        sha1 = "7c383e9629bba4820c11b0425bdd6290f7f057e7";
      };
    }

    {
      name = "babel-plugin-transform-es2015-destructuring-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-destructuring-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-destructuring/-/babel-plugin-transform-es2015-destructuring-6.23.0.tgz";
        sha1 = "997bb1f1ab967f682d2b0876fe358d60e765c56d";
      };
    }

    {
      name = "babel-plugin-transform-es2015-duplicate-keys-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-duplicate-keys-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-duplicate-keys/-/babel-plugin-transform-es2015-duplicate-keys-6.22.0.tgz";
        sha1 = "672397031c21610d72dd2bbb0ba9fb6277e1c36b";
      };
    }

    {
      name = "babel-plugin-transform-es2015-for-of-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-for-of-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-for-of/-/babel-plugin-transform-es2015-for-of-6.23.0.tgz";
        sha1 = "f47c95b2b613df1d3ecc2fdb7573623c75248691";
      };
    }

    {
      name = "babel-plugin-transform-es2015-function-name-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-function-name-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-function-name/-/babel-plugin-transform-es2015-function-name-6.22.0.tgz";
        sha1 = "f5fcc8b09093f9a23c76ac3d9e392c3ec4b77104";
      };
    }

    {
      name = "babel-plugin-transform-es2015-literals-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-literals-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-literals/-/babel-plugin-transform-es2015-literals-6.22.0.tgz";
        sha1 = "4f54a02d6cd66cf915280019a31d31925377ca2e";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-amd-6.24.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-amd-6.24.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-amd/-/babel-plugin-transform-es2015-modules-amd-6.24.0.tgz";
        sha1 = "a1911fb9b7ec7e05a43a63c5995007557bcf6a2e";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-commonjs-6.24.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-commonjs-6.24.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.24.0.tgz";
        sha1 = "e921aefb72c2cc26cb03d107626156413222134f";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-systemjs-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-systemjs-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-systemjs/-/babel-plugin-transform-es2015-modules-systemjs-6.23.0.tgz";
        sha1 = "ae3469227ffac39b0310d90fec73bfdc4f6317b0";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-umd-6.24.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-umd-6.24.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-umd/-/babel-plugin-transform-es2015-modules-umd-6.24.0.tgz";
        sha1 = "fd5fa63521cae8d273927c3958afd7c067733450";
      };
    }

    {
      name = "babel-plugin-transform-es2015-object-super-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-object-super-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-object-super/-/babel-plugin-transform-es2015-object-super-6.22.0.tgz";
        sha1 = "daa60e114a042ea769dd53fe528fc82311eb98fc";
      };
    }

    {
      name = "babel-plugin-transform-es2015-parameters-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-parameters-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-parameters/-/babel-plugin-transform-es2015-parameters-6.23.0.tgz";
        sha1 = "3a2aabb70c8af945d5ce386f1a4250625a83ae3b";
      };
    }

    {
      name = "babel-plugin-transform-es2015-shorthand-properties-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-shorthand-properties-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-shorthand-properties/-/babel-plugin-transform-es2015-shorthand-properties-6.22.0.tgz";
        sha1 = "8ba776e0affaa60bff21e921403b8a652a2ff723";
      };
    }

    {
      name = "babel-plugin-transform-es2015-spread-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-spread-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-spread/-/babel-plugin-transform-es2015-spread-6.22.0.tgz";
        sha1 = "d6d68a99f89aedc4536c81a542e8dd9f1746f8d1";
      };
    }

    {
      name = "babel-plugin-transform-es2015-sticky-regex-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-sticky-regex-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-sticky-regex/-/babel-plugin-transform-es2015-sticky-regex-6.22.0.tgz";
        sha1 = "ab316829e866ee3f4b9eb96939757d19a5bc4593";
      };
    }

    {
      name = "babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-template-literals/-/babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
        sha1 = "a84b3450f7e9f8f1f6839d6d687da84bb1236d8d";
      };
    }

    {
      name = "babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-typeof-symbol/-/babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz";
        sha1 = "dec09f1cddff94b52ac73d505c84df59dcceb372";
      };
    }

    {
      name = "babel-plugin-transform-es2015-unicode-regex-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-unicode-regex-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-unicode-regex/-/babel-plugin-transform-es2015-unicode-regex-6.22.0.tgz";
        sha1 = "8d9cc27e7ee1decfe65454fb986452a04a613d20";
      };
    }

    {
      name = "babel-plugin-transform-exponentiation-operator-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-exponentiation-operator-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-exponentiation-operator/-/babel-plugin-transform-exponentiation-operator-6.22.0.tgz";
        sha1 = "d57c8335281918e54ef053118ce6eb108468084d";
      };
    }

    {
      name = "babel-plugin-transform-object-rest-spread-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-object-rest-spread-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-object-rest-spread/-/babel-plugin-transform-object-rest-spread-6.23.0.tgz";
        sha1 = "875d6bc9be761c58a2ae3feee5dc4895d8c7f921";
      };
    }

    {
      name = "babel-plugin-transform-regenerator-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-regenerator-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-regenerator/-/babel-plugin-transform-regenerator-6.22.0.tgz";
        sha1 = "65740593a319c44522157538d690b84094617ea6";
      };
    }

    {
      name = "babel-plugin-transform-strict-mode-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-strict-mode-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.22.0.tgz";
        sha1 = "e008df01340fdc87e959da65991b7e05970c8c7c";
      };
    }

    {
      name = "babel-preset-es2015-6.24.0.tgz";
      path = fetchurl {
        name = "babel-preset-es2015-6.24.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-es2015/-/babel-preset-es2015-6.24.0.tgz";
        sha1 = "c162d68b1932696e036cd3110dc1ccd303d2673a";
      };
    }

    {
      name = "babel-preset-es2016-6.22.0.tgz";
      path = fetchurl {
        name = "babel-preset-es2016-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-es2016/-/babel-preset-es2016-6.22.0.tgz";
        sha1 = "b061aaa3983d40c9fbacfa3743b5df37f336156c";
      };
    }

    {
      name = "babel-preset-es2017-6.22.0.tgz";
      path = fetchurl {
        name = "babel-preset-es2017-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-es2017/-/babel-preset-es2017-6.22.0.tgz";
        sha1 = "de2f9da5a30c50d293fb54a0ba15d6ddc573f0f2";
      };
    }

    {
      name = "babel-preset-latest-6.24.0.tgz";
      path = fetchurl {
        name = "babel-preset-latest-6.24.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-latest/-/babel-preset-latest-6.24.0.tgz";
        sha1 = "a68d20f509edcc5d7433a48dfaebf7e4f2cd4cb7";
      };
    }

    {
      name = "babel-preset-stage-2-6.22.0.tgz";
      path = fetchurl {
        name = "babel-preset-stage-2-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-stage-2/-/babel-preset-stage-2-6.22.0.tgz";
        sha1 = "ccd565f19c245cade394b21216df704a73b27c07";
      };
    }

    {
      name = "babel-preset-stage-3-6.22.0.tgz";
      path = fetchurl {
        name = "babel-preset-stage-3-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-stage-3/-/babel-preset-stage-3-6.22.0.tgz";
        sha1 = "a4e92bbace7456fafdf651d7a7657ee0bbca9c2e";
      };
    }

    {
      name = "babel-register-6.23.0.tgz";
      path = fetchurl {
        name = "babel-register-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-register/-/babel-register-6.23.0.tgz";
        sha1 = "c9aa3d4cca94b51da34826c4a0f9e08145d74ff3";
      };
    }

    {
      name = "babel-runtime-6.22.0.tgz";
      path = fetchurl {
        name = "babel-runtime-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.22.0.tgz";
        sha1 = "1cf8b4ac67c77a4ddb0db2ae1f74de52ac4ca611";
      };
    }

    {
      name = "babel-template-6.23.0.tgz";
      path = fetchurl {
        name = "babel-template-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-template/-/babel-template-6.23.0.tgz";
        sha1 = "04d4f270adbb3aa704a8143ae26faa529238e638";
      };
    }

    {
      name = "babel-traverse-6.23.1.tgz";
      path = fetchurl {
        name = "babel-traverse-6.23.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-traverse/-/babel-traverse-6.23.1.tgz";
        sha1 = "d3cb59010ecd06a97d81310065f966b699e14f48";
      };
    }

    {
      name = "babel-types-6.23.0.tgz";
      path = fetchurl {
        name = "babel-types-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-types/-/babel-types-6.23.0.tgz";
        sha1 = "bb17179d7538bad38cd0c9e115d340f77e7e9acf";
      };
    }

    {
      name = "babylon-6.15.0.tgz";
      path = fetchurl {
        name = "babylon-6.15.0.tgz";
        url  = "https://registry.yarnpkg.com/babylon/-/babylon-6.15.0.tgz";
        sha1 = "ba65cfa1a80e1759b0e89fb562e27dccae70348e";
      };
    }

    {
      name = "backo2-1.0.2.tgz";
      path = fetchurl {
        name = "backo2-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/backo2/-/backo2-1.0.2.tgz";
        sha1 = "31ab1ac8b129363463e35b3ebb69f4dfcfba7947";
      };
    }

    {
      name = "balanced-match-0.4.2.tgz";
      path = fetchurl {
        name = "balanced-match-0.4.2.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-0.4.2.tgz";
        sha1 = "cb3f3e3c732dc0f01ee70b403f302e61d7709838";
      };
    }

    {
      name = "base64-arraybuffer-0.1.5.tgz";
      path = fetchurl {
        name = "base64-arraybuffer-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/base64-arraybuffer/-/base64-arraybuffer-0.1.5.tgz";
        sha1 = "73926771923b5a19747ad666aa5cd4bf9c6e9ce8";
      };
    }

    {
      name = "base64-js-1.2.0.tgz";
      path = fetchurl {
        name = "base64-js-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/base64-js/-/base64-js-1.2.0.tgz";
        sha1 = "a39992d723584811982be5e290bb6a53d86700f1";
      };
    }

    {
      name = "base64id-1.0.0.tgz";
      path = fetchurl {
        name = "base64id-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/base64id/-/base64id-1.0.0.tgz";
        sha1 = "47688cb99bb6804f0e06d3e763b1c32e57d8e6b6";
      };
    }

    {
      name = "batch-0.5.3.tgz";
      path = fetchurl {
        name = "batch-0.5.3.tgz";
        url  = "https://registry.yarnpkg.com/batch/-/batch-0.5.3.tgz";
        sha1 = "3f3414f380321743bfc1042f9a83ff1d5824d464";
      };
    }

    {
      name = "bcrypt-pbkdf-1.0.1.tgz";
      path = fetchurl {
        name = "bcrypt-pbkdf-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz";
        sha1 = "63bc5dcb61331b92bc05fd528953c33462a06f8d";
      };
    }

    {
      name = "better-assert-1.0.2.tgz";
      path = fetchurl {
        name = "better-assert-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/better-assert/-/better-assert-1.0.2.tgz";
        sha1 = "40866b9e1b9e0b55b481894311e68faffaebc522";
      };
    }

    {
      name = "big.js-3.1.3.tgz";
      path = fetchurl {
        name = "big.js-3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/big.js/-/big.js-3.1.3.tgz";
        sha1 = "4cada2193652eb3ca9ec8e55c9015669c9806978";
      };
    }

    {
      name = "binary-extensions-1.8.0.tgz";
      path = fetchurl {
        name = "binary-extensions-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.8.0.tgz";
        sha1 = "48ec8d16df4377eae5fa5884682480af4d95c774";
      };
    }

    {
      name = "blob-0.0.4.tgz";
      path = fetchurl {
        name = "blob-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/blob/-/blob-0.0.4.tgz";
        sha1 = "bcf13052ca54463f30f9fc7e95b9a47630a94921";
      };
    }

    {
      name = "block-stream-0.0.9.tgz";
      path = fetchurl {
        name = "block-stream-0.0.9.tgz";
        url  = "https://registry.yarnpkg.com/block-stream/-/block-stream-0.0.9.tgz";
        sha1 = "13ebfe778a03205cfe03751481ebb4b3300c126a";
      };
    }

    {
      name = "bluebird-3.4.7.tgz";
      path = fetchurl {
        name = "bluebird-3.4.7.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-3.4.7.tgz";
        sha1 = "f72d760be09b7f76d08ed8fae98b289a8d05fab3";
      };
    }

    {
      name = "bn.js-4.11.6.tgz";
      path = fetchurl {
        name = "bn.js-4.11.6.tgz";
        url  = "https://registry.yarnpkg.com/bn.js/-/bn.js-4.11.6.tgz";
        sha1 = "53344adb14617a13f6e8dd2ce28905d1c0ba3215";
      };
    }

    {
      name = "body-parser-1.16.0.tgz";
      path = fetchurl {
        name = "body-parser-1.16.0.tgz";
        url  = "https://registry.yarnpkg.com/body-parser/-/body-parser-1.16.0.tgz";
        sha1 = "924a5e472c6229fb9d69b85a20d5f2532dec788b";
      };
    }

    {
      name = "boom-2.10.1.tgz";
      path = fetchurl {
        name = "boom-2.10.1.tgz";
        url  = "https://registry.yarnpkg.com/boom/-/boom-2.10.1.tgz";
        sha1 = "39c8918ceff5799f83f9492a848f625add0c766f";
      };
    }

    {
      name = "bootstrap-sass-3.3.6.tgz";
      path = fetchurl {
        name = "bootstrap-sass-3.3.6.tgz";
        url  = "https://registry.yarnpkg.com/bootstrap-sass/-/bootstrap-sass-3.3.6.tgz";
        sha1 = "363b0d300e868d3e70134c1a742bb17288444fd1";
      };
    }

    {
      name = "brace-expansion-1.1.6.tgz";
      path = fetchurl {
        name = "brace-expansion-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.6.tgz";
        sha1 = "7197d7eaa9b87e648390ea61fc66c84427420df9";
      };
    }

    {
      name = "braces-0.1.5.tgz";
      path = fetchurl {
        name = "braces-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-0.1.5.tgz";
        sha1 = "c085711085291d8b75fdd74eab0f8597280711e6";
      };
    }

    {
      name = "braces-1.8.5.tgz";
      path = fetchurl {
        name = "braces-1.8.5.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-1.8.5.tgz";
        sha1 = "ba77962e12dff969d6b76711e914b737857bf6a7";
      };
    }

    {
      name = "brorand-1.0.7.tgz";
      path = fetchurl {
        name = "brorand-1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/brorand/-/brorand-1.0.7.tgz";
        sha1 = "6677fa5e4901bdbf9c9ec2a748e28dca407a9bfc";
      };
    }

    {
      name = "browserify-aes-1.0.6.tgz";
      path = fetchurl {
        name = "browserify-aes-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/browserify-aes/-/browserify-aes-1.0.6.tgz";
        sha1 = "5e7725dbdef1fd5930d4ebab48567ce451c48a0a";
      };
    }

    {
      name = "browserify-cipher-1.0.0.tgz";
      path = fetchurl {
        name = "browserify-cipher-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/browserify-cipher/-/browserify-cipher-1.0.0.tgz";
        sha1 = "9988244874bf5ed4e28da95666dcd66ac8fc363a";
      };
    }

    {
      name = "browserify-des-1.0.0.tgz";
      path = fetchurl {
        name = "browserify-des-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/browserify-des/-/browserify-des-1.0.0.tgz";
        sha1 = "daa277717470922ed2fe18594118a175439721dd";
      };
    }

    {
      name = "browserify-rsa-4.0.1.tgz";
      path = fetchurl {
        name = "browserify-rsa-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-rsa/-/browserify-rsa-4.0.1.tgz";
        sha1 = "21e0abfaf6f2029cf2fafb133567a701d4135524";
      };
    }

    {
      name = "browserify-sign-4.0.0.tgz";
      path = fetchurl {
        name = "browserify-sign-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/browserify-sign/-/browserify-sign-4.0.0.tgz";
        sha1 = "10773910c3c206d5420a46aad8694f820b85968f";
      };
    }

    {
      name = "browserify-zlib-0.1.4.tgz";
      path = fetchurl {
        name = "browserify-zlib-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/browserify-zlib/-/browserify-zlib-0.1.4.tgz";
        sha1 = "bb35f8a519f600e0fa6b8485241c979d0141fb2d";
      };
    }

    {
      name = "browserslist-1.7.7.tgz";
      path = fetchurl {
        name = "browserslist-1.7.7.tgz";
        url  = "https://registry.yarnpkg.com/browserslist/-/browserslist-1.7.7.tgz";
        sha1 = "0bd76704258be829b2398bb50e4b62d1a166b0b9";
      };
    }

    {
      name = "buffer-shims-1.0.0.tgz";
      path = fetchurl {
        name = "buffer-shims-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-shims/-/buffer-shims-1.0.0.tgz";
        sha1 = "9978ce317388c649ad8793028c3477ef044a8b51";
      };
    }

    {
      name = "buffer-xor-1.0.3.tgz";
      path = fetchurl {
        name = "buffer-xor-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/buffer-xor/-/buffer-xor-1.0.3.tgz";
        sha1 = "26e61ed1422fb70dd42e6e36729ed51d855fe8d9";
      };
    }

    {
      name = "buffer-4.9.1.tgz";
      path = fetchurl {
        name = "buffer-4.9.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer/-/buffer-4.9.1.tgz";
        sha1 = "6d1bb601b07a4efced97094132093027c95bc298";
      };
    }

    {
      name = "builtin-modules-1.1.1.tgz";
      path = fetchurl {
        name = "builtin-modules-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-1.1.1.tgz";
        sha1 = "270f076c5a72c02f5b65a47df94c5fe3a278892f";
      };
    }

    {
      name = "builtin-status-codes-3.0.0.tgz";
      path = fetchurl {
        name = "builtin-status-codes-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz";
        sha1 = "85982878e21b98e1c66425e03d0174788f569ee8";
      };
    }

    {
      name = "bytes-2.3.0.tgz";
      path = fetchurl {
        name = "bytes-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/bytes/-/bytes-2.3.0.tgz";
        sha1 = "d5b680a165b6201739acb611542aabc2d8ceb070";
      };
    }

    {
      name = "bytes-2.4.0.tgz";
      path = fetchurl {
        name = "bytes-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/bytes/-/bytes-2.4.0.tgz";
        sha1 = "7d97196f9d5baf7f6935e25985549edd2a6c2339";
      };
    }

    {
      name = "caller-path-0.1.0.tgz";
      path = fetchurl {
        name = "caller-path-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/caller-path/-/caller-path-0.1.0.tgz";
        sha1 = "94085ef63581ecd3daa92444a8fe94e82577751f";
      };
    }

    {
      name = "callsite-1.0.0.tgz";
      path = fetchurl {
        name = "callsite-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/callsite/-/callsite-1.0.0.tgz";
        sha1 = "280398e5d664bd74038b6f0905153e6e8af1bc20";
      };
    }

    {
      name = "callsites-0.2.0.tgz";
      path = fetchurl {
        name = "callsites-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/callsites/-/callsites-0.2.0.tgz";
        sha1 = "afab96262910a7f33c19a5775825c69f34e350ca";
      };
    }

    {
      name = "camelcase-1.2.1.tgz";
      path = fetchurl {
        name = "camelcase-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-1.2.1.tgz";
        sha1 = "9bb5304d2e0b56698b2c758b08a3eaa9daa58a39";
      };
    }

    {
      name = "camelcase-3.0.0.tgz";
      path = fetchurl {
        name = "camelcase-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-3.0.0.tgz";
        sha1 = "32fc4b9fcdaf845fcdf7e73bb97cac2261f0ab0a";
      };
    }

    {
      name = "caniuse-api-1.6.1.tgz";
      path = fetchurl {
        name = "caniuse-api-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/caniuse-api/-/caniuse-api-1.6.1.tgz";
        sha1 = "b534e7c734c4f81ec5fbe8aca2ad24354b962c6c";
      };
    }

    {
      name = "caniuse-db-1.0.30000649.tgz";
      path = fetchurl {
        name = "caniuse-db-1.0.30000649.tgz";
        url  = "https://registry.yarnpkg.com/caniuse-db/-/caniuse-db-1.0.30000649.tgz";
        sha1 = "1ee1754a6df235450c8b7cd15e0ebf507221a86a";
      };
    }

    {
      name = "caseless-0.11.0.tgz";
      path = fetchurl {
        name = "caseless-0.11.0.tgz";
        url  = "https://registry.yarnpkg.com/caseless/-/caseless-0.11.0.tgz";
        sha1 = "715b96ea9841593cc33067923f5ec60ebda4f7d7";
      };
    }

    {
      name = "center-align-0.1.3.tgz";
      path = fetchurl {
        name = "center-align-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/center-align/-/center-align-0.1.3.tgz";
        sha1 = "aa0d32629b6ee972200411cbd4461c907bc2b7ad";
      };
    }

    {
      name = "chalk-1.1.3.tgz";
      path = fetchurl {
        name = "chalk-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz";
        sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
      };
    }

    {
      name = "chokidar-1.6.1.tgz";
      path = fetchurl {
        name = "chokidar-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/chokidar/-/chokidar-1.6.1.tgz";
        sha1 = "2f4447ab5e96e50fb3d789fd90d4c72e0e4c70c2";
      };
    }

    {
      name = "cipher-base-1.0.3.tgz";
      path = fetchurl {
        name = "cipher-base-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/cipher-base/-/cipher-base-1.0.3.tgz";
        sha1 = "eeabf194419ce900da3018c207d212f2a6df0a07";
      };
    }

    {
      name = "circular-json-0.3.1.tgz";
      path = fetchurl {
        name = "circular-json-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/circular-json/-/circular-json-0.3.1.tgz";
        sha1 = "be8b36aefccde8b3ca7aa2d6afc07a37242c0d2d";
      };
    }

    {
      name = "clap-1.1.3.tgz";
      path = fetchurl {
        name = "clap-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/clap/-/clap-1.1.3.tgz";
        sha1 = "b3bd36e93dd4cbfb395a3c26896352445265c05b";
      };
    }

    {
      name = "cli-cursor-1.0.2.tgz";
      path = fetchurl {
        name = "cli-cursor-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-1.0.2.tgz";
        sha1 = "64da3f7d56a54412e59794bd62dc35295e8f2987";
      };
    }

    {
      name = "cli-width-2.1.0.tgz";
      path = fetchurl {
        name = "cli-width-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-width/-/cli-width-2.1.0.tgz";
        sha1 = "b234ca209b29ef66fc518d9b98d5847b00edf00a";
      };
    }

    {
      name = "clipboard-1.6.1.tgz";
      path = fetchurl {
        name = "clipboard-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/clipboard/-/clipboard-1.6.1.tgz";
        sha1 = "65c5b654812466b0faab82dc6ba0f1d2f8e4be53";
      };
    }

    {
      name = "cliui-2.1.0.tgz";
      path = fetchurl {
        name = "cliui-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-2.1.0.tgz";
        sha1 = "4b475760ff80264c762c3a1719032e91c7fea0d1";
      };
    }

    {
      name = "cliui-3.2.0.tgz";
      path = fetchurl {
        name = "cliui-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-3.2.0.tgz";
        sha1 = "120601537a916d29940f934da3b48d585a39213d";
      };
    }

    {
      name = "clone-1.0.2.tgz";
      path = fetchurl {
        name = "clone-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/clone/-/clone-1.0.2.tgz";
        sha1 = "260b7a99ebb1edfe247538175f783243cb19d149";
      };
    }

    {
      name = "co-4.6.0.tgz";
      path = fetchurl {
        name = "co-4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/co/-/co-4.6.0.tgz";
        sha1 = "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184";
      };
    }

    {
      name = "coa-1.0.1.tgz";
      path = fetchurl {
        name = "coa-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/coa/-/coa-1.0.1.tgz";
        sha1 = "7f959346cfc8719e3f7233cd6852854a7c67d8a3";
      };
    }

    {
      name = "code-point-at-1.1.0.tgz";
      path = fetchurl {
        name = "code-point-at-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz";
        sha1 = "0d070b4d043a5bea33a2f1a40e2edb3d9a4ccf77";
      };
    }

    {
      name = "color-convert-1.9.0.tgz";
      path = fetchurl {
        name = "color-convert-1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.0.tgz";
        sha1 = "1accf97dd739b983bf994d56fec8f95853641b7a";
      };
    }

    {
      name = "color-name-1.1.2.tgz";
      path = fetchurl {
        name = "color-name-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.2.tgz";
        sha1 = "5c8ab72b64bd2215d617ae9559ebb148475cf98d";
      };
    }

    {
      name = "color-string-0.3.0.tgz";
      path = fetchurl {
        name = "color-string-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/color-string/-/color-string-0.3.0.tgz";
        sha1 = "27d46fb67025c5c2fa25993bfbf579e47841b991";
      };
    }

    {
      name = "color-0.11.4.tgz";
      path = fetchurl {
        name = "color-0.11.4.tgz";
        url  = "https://registry.yarnpkg.com/color/-/color-0.11.4.tgz";
        sha1 = "6d7b5c74fb65e841cd48792ad1ed5e07b904d764";
      };
    }

    {
      name = "colormin-1.1.2.tgz";
      path = fetchurl {
        name = "colormin-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/colormin/-/colormin-1.1.2.tgz";
        sha1 = "ea2f7420a72b96881a38aae59ec124a6f7298133";
      };
    }

    {
      name = "colors-1.1.2.tgz";
      path = fetchurl {
        name = "colors-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/colors/-/colors-1.1.2.tgz";
        sha1 = "168a4701756b6a7f51a12ce0c97bfa28c084ed63";
      };
    }

    {
      name = "combine-lists-1.0.1.tgz";
      path = fetchurl {
        name = "combine-lists-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/combine-lists/-/combine-lists-1.0.1.tgz";
        sha1 = "458c07e09e0d900fc28b70a3fec2dacd1d2cb7f6";
      };
    }

    {
      name = "combined-stream-1.0.5.tgz";
      path = fetchurl {
        name = "combined-stream-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.5.tgz";
        sha1 = "938370a57b4a51dea2c77c15d5c5fdf895164009";
      };
    }

    {
      name = "commander-2.9.0.tgz";
      path = fetchurl {
        name = "commander-2.9.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.9.0.tgz";
        sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
      };
    }

    {
      name = "commondir-1.0.1.tgz";
      path = fetchurl {
        name = "commondir-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz";
        sha1 = "ddd800da0c66127393cca5950ea968a3aaf1253b";
      };
    }

    {
      name = "component-bind-1.0.0.tgz";
      path = fetchurl {
        name = "component-bind-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/component-bind/-/component-bind-1.0.0.tgz";
        sha1 = "00c608ab7dcd93897c0009651b1d3a8e1e73bbd1";
      };
    }

    {
      name = "component-emitter-1.1.2.tgz";
      path = fetchurl {
        name = "component-emitter-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.1.2.tgz";
        sha1 = "296594f2753daa63996d2af08d15a95116c9aec3";
      };
    }

    {
      name = "component-emitter-1.2.1.tgz";
      path = fetchurl {
        name = "component-emitter-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.2.1.tgz";
        sha1 = "137918d6d78283f7df7a6b7c5a63e140e69425e6";
      };
    }

    {
      name = "component-inherit-0.0.3.tgz";
      path = fetchurl {
        name = "component-inherit-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/component-inherit/-/component-inherit-0.0.3.tgz";
        sha1 = "645fc4adf58b72b649d5cae65135619db26ff143";
      };
    }

    {
      name = "compressible-2.0.9.tgz";
      path = fetchurl {
        name = "compressible-2.0.9.tgz";
        url  = "https://registry.yarnpkg.com/compressible/-/compressible-2.0.9.tgz";
        sha1 = "6daab4e2b599c2770dd9e21e7a891b1c5a755425";
      };
    }

    {
      name = "compression-webpack-plugin-0.3.2.tgz";
      path = fetchurl {
        name = "compression-webpack-plugin-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/compression-webpack-plugin/-/compression-webpack-plugin-0.3.2.tgz";
        sha1 = "1edfb0e749d7366d3e701670c463359b2c0cf704";
      };
    }

    {
      name = "compression-1.6.2.tgz";
      path = fetchurl {
        name = "compression-1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/compression/-/compression-1.6.2.tgz";
        sha1 = "cceb121ecc9d09c52d7ad0c3350ea93ddd402bc3";
      };
    }

    {
      name = "concat-map-0.0.1.tgz";
      path = fetchurl {
        name = "concat-map-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    }

    {
      name = "concat-stream-1.5.0.tgz";
      path = fetchurl {
        name = "concat-stream-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.5.0.tgz";
        sha1 = "53f7d43c51c5e43f81c8fdd03321c631be68d611";
      };
    }

    {
      name = "concat-stream-1.6.0.tgz";
      path = fetchurl {
        name = "concat-stream-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.0.tgz";
        sha1 = "0aac662fd52be78964d5532f694784e70110acf7";
      };
    }

    {
      name = "config-chain-1.1.11.tgz";
      path = fetchurl {
        name = "config-chain-1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.11.tgz";
        sha1 = "aba09747dfbe4c3e70e766a6e41586e1859fc6f2";
      };
    }

    {
      name = "configstore-1.4.0.tgz";
      path = fetchurl {
        name = "configstore-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/configstore/-/configstore-1.4.0.tgz";
        sha1 = "c35781d0501d268c25c54b8b17f6240e8a4fb021";
      };
    }

    {
      name = "connect-history-api-fallback-1.3.0.tgz";
      path = fetchurl {
        name = "connect-history-api-fallback-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/connect-history-api-fallback/-/connect-history-api-fallback-1.3.0.tgz";
        sha1 = "e51d17f8f0ef0db90a64fdb47de3051556e9f169";
      };
    }

    {
      name = "connect-3.5.0.tgz";
      path = fetchurl {
        name = "connect-3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/connect/-/connect-3.5.0.tgz";
        sha1 = "b357525a0b4c1f50599cd983e1d9efeea9677198";
      };
    }

    {
      name = "console-browserify-1.1.0.tgz";
      path = fetchurl {
        name = "console-browserify-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/console-browserify/-/console-browserify-1.1.0.tgz";
        sha1 = "f0241c45730a9fc6323b206dbf38edc741d0bb10";
      };
    }

    {
      name = "console-control-strings-1.1.0.tgz";
      path = fetchurl {
        name = "console-control-strings-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz";
        sha1 = "3d7cf4464db6446ea644bf4b39507f9851008e8e";
      };
    }

    {
      name = "consolidate-0.14.5.tgz";
      path = fetchurl {
        name = "consolidate-0.14.5.tgz";
        url  = "https://registry.yarnpkg.com/consolidate/-/consolidate-0.14.5.tgz";
        sha1 = "5a25047bc76f73072667c8cb52c989888f494c63";
      };
    }

    {
      name = "constants-browserify-1.0.0.tgz";
      path = fetchurl {
        name = "constants-browserify-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/constants-browserify/-/constants-browserify-1.0.0.tgz";
        sha1 = "c20b96d8c617748aaf1c16021760cd27fcb8cb75";
      };
    }

    {
      name = "contains-path-0.1.0.tgz";
      path = fetchurl {
        name = "contains-path-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/contains-path/-/contains-path-0.1.0.tgz";
        sha1 = "fe8cf184ff6670b6baef01a9d4861a5cbec4120a";
      };
    }

    {
      name = "content-disposition-0.5.2.tgz";
      path = fetchurl {
        name = "content-disposition-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.2.tgz";
        sha1 = "0cf68bb9ddf5f2be7961c3a85178cb85dba78cb4";
      };
    }

    {
      name = "content-type-1.0.2.tgz";
      path = fetchurl {
        name = "content-type-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/content-type/-/content-type-1.0.2.tgz";
        sha1 = "b7d113aee7a8dd27bd21133c4dc2529df1721eed";
      };
    }

    {
      name = "convert-source-map-1.3.0.tgz";
      path = fetchurl {
        name = "convert-source-map-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.3.0.tgz";
        sha1 = "e9f3e9c6e2728efc2676696a70eb382f73106a67";
      };
    }

    {
      name = "cookie-signature-1.0.6.tgz";
      path = fetchurl {
        name = "cookie-signature-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/cookie-signature/-/cookie-signature-1.0.6.tgz";
        sha1 = "e303a882b342cc3ee8ca513a79999734dab3ae2c";
      };
    }

    {
      name = "cookie-0.3.1.tgz";
      path = fetchurl {
        name = "cookie-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/cookie/-/cookie-0.3.1.tgz";
        sha1 = "e7e0a1f9ef43b4c8ba925c5c5a96e806d16873bb";
      };
    }

    {
      name = "core-js-2.4.1.tgz";
      path = fetchurl {
        name = "core-js-2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/core-js/-/core-js-2.4.1.tgz";
        sha1 = "4de911e667b0eae9124e34254b53aea6fc618d3e";
      };
    }

    {
      name = "core-js-2.3.0.tgz";
      path = fetchurl {
        name = "core-js-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/core-js/-/core-js-2.3.0.tgz";
        sha1 = "fab83fbb0b2d8dc85fa636c4b9d34c75420c6d65";
      };
    }

    {
      name = "core-util-is-1.0.2.tgz";
      path = fetchurl {
        name = "core-util-is-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    }

    {
      name = "cosmiconfig-2.1.1.tgz";
      path = fetchurl {
        name = "cosmiconfig-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-2.1.1.tgz";
        sha1 = "817f2c2039347a1e9bf7d090c0923e53f749ca82";
      };
    }

    {
      name = "create-ecdh-4.0.0.tgz";
      path = fetchurl {
        name = "create-ecdh-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/create-ecdh/-/create-ecdh-4.0.0.tgz";
        sha1 = "888c723596cdf7612f6498233eebd7a35301737d";
      };
    }

    {
      name = "create-hash-1.1.2.tgz";
      path = fetchurl {
        name = "create-hash-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/create-hash/-/create-hash-1.1.2.tgz";
        sha1 = "51210062d7bb7479f6c65bb41a92208b1d61abad";
      };
    }

    {
      name = "create-hmac-1.1.4.tgz";
      path = fetchurl {
        name = "create-hmac-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/create-hmac/-/create-hmac-1.1.4.tgz";
        sha1 = "d3fb4ba253eb8b3f56e39ea2fbcb8af747bd3170";
      };
    }

    {
      name = "cryptiles-2.0.5.tgz";
      path = fetchurl {
        name = "cryptiles-2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/cryptiles/-/cryptiles-2.0.5.tgz";
        sha1 = "3bdfecdc608147c1c67202fa291e7dca59eaa3b8";
      };
    }

    {
      name = "crypto-browserify-3.11.0.tgz";
      path = fetchurl {
        name = "crypto-browserify-3.11.0.tgz";
        url  = "https://registry.yarnpkg.com/crypto-browserify/-/crypto-browserify-3.11.0.tgz";
        sha1 = "3652a0906ab9b2a7e0c3ce66a408e957a2485522";
      };
    }

    {
      name = "css-color-names-0.0.4.tgz";
      path = fetchurl {
        name = "css-color-names-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/css-color-names/-/css-color-names-0.0.4.tgz";
        sha1 = "808adc2e79cf84738069b646cb20ec27beb629e0";
      };
    }

    {
      name = "css-loader-0.28.0.tgz";
      path = fetchurl {
        name = "css-loader-0.28.0.tgz";
        url  = "https://registry.yarnpkg.com/css-loader/-/css-loader-0.28.0.tgz";
        sha1 = "417cfa9789f8cde59a30ccbf3e4da7a806889bad";
      };
    }

    {
      name = "css-selector-tokenizer-0.6.0.tgz";
      path = fetchurl {
        name = "css-selector-tokenizer-0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/css-selector-tokenizer/-/css-selector-tokenizer-0.6.0.tgz";
        sha1 = "6445f582c7930d241dcc5007a43d6fcb8f073152";
      };
    }

    {
      name = "css-selector-tokenizer-0.7.0.tgz";
      path = fetchurl {
        name = "css-selector-tokenizer-0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/css-selector-tokenizer/-/css-selector-tokenizer-0.7.0.tgz";
        sha1 = "e6988474ae8c953477bf5e7efecfceccd9cf4c86";
      };
    }

    {
      name = "cssesc-0.1.0.tgz";
      path = fetchurl {
        name = "cssesc-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cssesc/-/cssesc-0.1.0.tgz";
        sha1 = "c814903e45623371a0477b40109aaafbeeaddbb4";
      };
    }

    {
      name = "cssnano-3.10.0.tgz";
      path = fetchurl {
        name = "cssnano-3.10.0.tgz";
        url  = "https://registry.yarnpkg.com/cssnano/-/cssnano-3.10.0.tgz";
        sha1 = "4f38f6cea2b9b17fa01490f23f1dc68ea65c1c38";
      };
    }

    {
      name = "csso-2.3.2.tgz";
      path = fetchurl {
        name = "csso-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/csso/-/csso-2.3.2.tgz";
        sha1 = "ddd52c587033f49e94b71fc55569f252e8ff5f85";
      };
    }

    {
      name = "custom-event-1.0.1.tgz";
      path = fetchurl {
        name = "custom-event-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/custom-event/-/custom-event-1.0.1.tgz";
        sha1 = "5d02a46850adf1b4a317946a3928fccb5bfd0425";
      };
    }

    {
      name = "d3-3.5.11.tgz";
      path = fetchurl {
        name = "d3-3.5.11.tgz";
        url  = "https://registry.yarnpkg.com/d3/-/d3-3.5.11.tgz";
        sha1 = "d130750eed0554db70e8432102f920a12407b69c";
      };
    }

    {
      name = "d-0.1.1.tgz";
      path = fetchurl {
        name = "d-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/d/-/d-0.1.1.tgz";
        sha1 = "da184c535d18d8ee7ba2aa229b914009fae11309";
      };
    }

    {
      name = "dashdash-1.14.1.tgz";
      path = fetchurl {
        name = "dashdash-1.14.1.tgz";
        url  = "https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz";
        sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
      };
    }

    {
      name = "date-now-0.1.4.tgz";
      path = fetchurl {
        name = "date-now-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/date-now/-/date-now-0.1.4.tgz";
        sha1 = "eaf439fd4d4848ad74e5cc7dbef200672b9e345b";
      };
    }

    {
      name = "de-indent-1.0.2.tgz";
      path = fetchurl {
        name = "de-indent-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/de-indent/-/de-indent-1.0.2.tgz";
        sha1 = "b2038e846dc33baa5796128d0804b455b8c1e21d";
      };
    }

    {
      name = "debug-0.7.4.tgz";
      path = fetchurl {
        name = "debug-0.7.4.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-0.7.4.tgz";
        sha1 = "06e1ea8082c2cb14e39806e22e2f6f757f92af39";
      };
    }

    {
      name = "debug-2.2.0.tgz";
      path = fetchurl {
        name = "debug-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.2.0.tgz";
        sha1 = "f87057e995b1a1f6ae6a4960664137bc56f039da";
      };
    }

    {
      name = "debug-2.3.3.tgz";
      path = fetchurl {
        name = "debug-2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.3.3.tgz";
        sha1 = "40c453e67e6e13c901ddec317af8986cda9eff8c";
      };
    }

    {
      name = "debug-2.6.0.tgz";
      path = fetchurl {
        name = "debug-2.6.0.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.0.tgz";
        sha1 = "bc596bcabe7617f11d9fa15361eded5608b8499b";
      };
    }

    {
      name = "debug-2.6.7.tgz";
      path = fetchurl {
        name = "debug-2.6.7.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.7.tgz";
        sha1 = "92bad1f6d05bbb6bba22cca88bcd0ec894c2861e";
      };
    }

    {
      name = "decamelize-1.2.0.tgz";
      path = fetchurl {
        name = "decamelize-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz";
        sha1 = "f6534d15148269b20352e7bee26f501f9a191290";
      };
    }

    {
      name = "deckar01-task_list-2.0.0.tgz";
      path = fetchurl {
        name = "deckar01-task_list-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/deckar01-task_list/-/deckar01-task_list-2.0.0.tgz";
        sha1 = "7f7a595430d21b3036ed5dfbf97d6b65de18e2c9";
      };
    }

    {
      name = "deep-extend-0.4.1.tgz";
      path = fetchurl {
        name = "deep-extend-0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.4.1.tgz";
        sha1 = "efe4113d08085f4e6f9687759810f807469e2253";
      };
    }

    {
      name = "deep-is-0.1.3.tgz";
      path = fetchurl {
        name = "deep-is-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.3.tgz";
        sha1 = "b369d6fb5dbc13eecf524f91b070feedc357cf34";
      };
    }

    {
      name = "default-require-extensions-1.0.0.tgz";
      path = fetchurl {
        name = "default-require-extensions-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/default-require-extensions/-/default-require-extensions-1.0.0.tgz";
        sha1 = "f37ea15d3e13ffd9b437d33e1a75b5fb97874cb8";
      };
    }

    {
      name = "defaults-1.0.3.tgz";
      path = fetchurl {
        name = "defaults-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/defaults/-/defaults-1.0.3.tgz";
        sha1 = "c656051e9817d9ff08ed881477f3fe4019f3ef7d";
      };
    }

    {
      name = "defined-1.0.0.tgz";
      path = fetchurl {
        name = "defined-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/defined/-/defined-1.0.0.tgz";
        sha1 = "c98d9bcef75674188e110969151199e39b1fa693";
      };
    }

    {
      name = "del-2.2.2.tgz";
      path = fetchurl {
        name = "del-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/del/-/del-2.2.2.tgz";
        sha1 = "c12c981d067846c84bcaf862cff930d907ffd1a8";
      };
    }

    {
      name = "delayed-stream-1.0.0.tgz";
      path = fetchurl {
        name = "delayed-stream-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
    }

    {
      name = "delegate-3.1.2.tgz";
      path = fetchurl {
        name = "delegate-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/delegate/-/delegate-3.1.2.tgz";
        sha1 = "1e1bc6f5cadda6cb6cbf7e6d05d0bcdd5712aebe";
      };
    }

    {
      name = "delegates-1.0.0.tgz";
      path = fetchurl {
        name = "delegates-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz";
        sha1 = "84c6e159b81904fdca59a0ef44cd870d31250f9a";
      };
    }

    {
      name = "depd-1.1.0.tgz";
      path = fetchurl {
        name = "depd-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/depd/-/depd-1.1.0.tgz";
        sha1 = "e1bd82c6aab6ced965b97b88b17ed3e528ca18c3";
      };
    }

    {
      name = "des.js-1.0.0.tgz";
      path = fetchurl {
        name = "des.js-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/des.js/-/des.js-1.0.0.tgz";
        sha1 = "c074d2e2aa6a8a9a07dbd61f9a15c2cd83ec8ecc";
      };
    }

    {
      name = "destroy-1.0.4.tgz";
      path = fetchurl {
        name = "destroy-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/destroy/-/destroy-1.0.4.tgz";
        sha1 = "978857442c44749e4206613e37946205826abd80";
      };
    }

    {
      name = "detect-indent-4.0.0.tgz";
      path = fetchurl {
        name = "detect-indent-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-indent/-/detect-indent-4.0.0.tgz";
        sha1 = "f76d064352cdf43a1cb6ce619c4ee3a9475de208";
      };
    }

    {
      name = "di-0.0.1.tgz";
      path = fetchurl {
        name = "di-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/di/-/di-0.0.1.tgz";
        sha1 = "806649326ceaa7caa3306d75d985ea2748ba913c";
      };
    }

    {
      name = "diffie-hellman-5.0.2.tgz";
      path = fetchurl {
        name = "diffie-hellman-5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/diffie-hellman/-/diffie-hellman-5.0.2.tgz";
        sha1 = "b5835739270cfe26acf632099fded2a07f209e5e";
      };
    }

    {
      name = "doctrine-1.5.0.tgz";
      path = fetchurl {
        name = "doctrine-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/doctrine/-/doctrine-1.5.0.tgz";
        sha1 = "379dce730f6166f76cefa4e6707a159b02c5a6fa";
      };
    }

    {
      name = "document-register-element-1.3.0.tgz";
      path = fetchurl {
        name = "document-register-element-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/document-register-element/-/document-register-element-1.3.0.tgz";
        sha1 = "fb3babb523c74662be47be19c6bc33e71990d940";
      };
    }

    {
      name = "dom-serialize-2.2.1.tgz";
      path = fetchurl {
        name = "dom-serialize-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/dom-serialize/-/dom-serialize-2.2.1.tgz";
        sha1 = "562ae8999f44be5ea3076f5419dcd59eb43ac95b";
      };
    }

    {
      name = "dom-serializer-0.1.0.tgz";
      path = fetchurl {
        name = "dom-serializer-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-0.1.0.tgz";
        sha1 = "073c697546ce0780ce23be4a28e293e40bc30c82";
      };
    }

    {
      name = "domain-browser-1.1.7.tgz";
      path = fetchurl {
        name = "domain-browser-1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/domain-browser/-/domain-browser-1.1.7.tgz";
        sha1 = "867aa4b093faa05f1de08c06f4d7b21fdf8698bc";
      };
    }

    {
      name = "domelementtype-1.3.0.tgz";
      path = fetchurl {
        name = "domelementtype-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-1.3.0.tgz";
        sha1 = "b17aed82e8ab59e52dd9c19b1756e0fc187204c2";
      };
    }

    {
      name = "domelementtype-1.1.3.tgz";
      path = fetchurl {
        name = "domelementtype-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-1.1.3.tgz";
        sha1 = "bd28773e2642881aec51544924299c5cd822185b";
      };
    }

    {
      name = "domhandler-2.3.0.tgz";
      path = fetchurl {
        name = "domhandler-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/domhandler/-/domhandler-2.3.0.tgz";
        sha1 = "2de59a0822d5027fabff6f032c2b25a2a8abe738";
      };
    }

    {
      name = "domutils-1.5.1.tgz";
      path = fetchurl {
        name = "domutils-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/domutils/-/domutils-1.5.1.tgz";
        sha1 = "dcd8488a26f563d61079e48c9f7b7e32373682cf";
      };
    }

    {
      name = "dropzone-4.2.0.tgz";
      path = fetchurl {
        name = "dropzone-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dropzone/-/dropzone-4.2.0.tgz";
        sha1 = "fbe7acbb9918e0706489072ef663effeef8a79f3";
      };
    }

    {
      name = "duplexer-0.1.1.tgz";
      path = fetchurl {
        name = "duplexer-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/duplexer/-/duplexer-0.1.1.tgz";
        sha1 = "ace6ff808c1ce66b57d1ebf97977acb02334cfc1";
      };
    }

    {
      name = "duplexify-3.5.0.tgz";
      path = fetchurl {
        name = "duplexify-3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/duplexify/-/duplexify-3.5.0.tgz";
        sha1 = "1aa773002e1578457e9d9d4a50b0ccaaebcbd604";
      };
    }

    {
      name = "ecc-jsbn-0.1.1.tgz";
      path = fetchurl {
        name = "ecc-jsbn-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
        sha1 = "0fc73a9ed5f0d53c38193398523ef7e543777505";
      };
    }

    {
      name = "editorconfig-0.13.2.tgz";
      path = fetchurl {
        name = "editorconfig-0.13.2.tgz";
        url  = "https://registry.yarnpkg.com/editorconfig/-/editorconfig-0.13.2.tgz";
        sha1 = "8e57926d9ee69ab6cb999f027c2171467acceb35";
      };
    }

    {
      name = "ee-first-1.1.1.tgz";
      path = fetchurl {
        name = "ee-first-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz";
        sha1 = "590c61156b0ae2f4f0255732a158b266bc56b21d";
      };
    }

    {
      name = "ejs-2.5.6.tgz";
      path = fetchurl {
        name = "ejs-2.5.6.tgz";
        url  = "https://registry.yarnpkg.com/ejs/-/ejs-2.5.6.tgz";
        sha1 = "479636bfa3fe3b1debd52087f0acb204b4f19c88";
      };
    }

    {
      name = "electron-to-chromium-1.3.3.tgz";
      path = fetchurl {
        name = "electron-to-chromium-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.3.3.tgz";
        sha1 = "651eb63fe89f39db70ffc8dbd5d9b66958bc6a0e";
      };
    }

    {
      name = "elliptic-6.3.3.tgz";
      path = fetchurl {
        name = "elliptic-6.3.3.tgz";
        url  = "https://registry.yarnpkg.com/elliptic/-/elliptic-6.3.3.tgz";
        sha1 = "5482d9646d54bcb89fd7d994fc9e2e9568876e3f";
      };
    }

    {
      name = "emoji-unicode-version-0.2.1.tgz";
      path = fetchurl {
        name = "emoji-unicode-version-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/emoji-unicode-version/-/emoji-unicode-version-0.2.1.tgz";
        sha1 = "0ebf3666b5414097971d34994e299fce75cdbafc";
      };
    }

    {
      name = "emojis-list-2.1.0.tgz";
      path = fetchurl {
        name = "emojis-list-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/emojis-list/-/emojis-list-2.1.0.tgz";
        sha1 = "4daa4d9db00f9819880c79fa457ae5b09a1fd389";
      };
    }

    {
      name = "encodeurl-1.0.1.tgz";
      path = fetchurl {
        name = "encodeurl-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.1.tgz";
        sha1 = "79e3d58655346909fe6f0f45a5de68103b294d20";
      };
    }

    {
      name = "end-of-stream-1.0.0.tgz";
      path = fetchurl {
        name = "end-of-stream-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.0.0.tgz";
        sha1 = "d4596e702734a93e40e9af864319eabd99ff2f0e";
      };
    }

    {
      name = "engine.io-client-1.8.2.tgz";
      path = fetchurl {
        name = "engine.io-client-1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-client/-/engine.io-client-1.8.2.tgz";
        sha1 = "c38767547f2a7d184f5752f6f0ad501006703766";
      };
    }

    {
      name = "engine.io-parser-1.3.2.tgz";
      path = fetchurl {
        name = "engine.io-parser-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-parser/-/engine.io-parser-1.3.2.tgz";
        sha1 = "937b079f0007d0893ec56d46cb220b8cb435220a";
      };
    }

    {
      name = "engine.io-1.8.2.tgz";
      path = fetchurl {
        name = "engine.io-1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/engine.io/-/engine.io-1.8.2.tgz";
        sha1 = "6b59be730b348c0125b0a4589de1c355abcf7a7e";
      };
    }

    {
      name = "enhanced-resolve-3.1.0.tgz";
      path = fetchurl {
        name = "enhanced-resolve-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-3.1.0.tgz";
        sha1 = "9f4b626f577245edcf4b2ad83d86e17f4f421dec";
      };
    }

    {
      name = "enhanced-resolve-0.9.1.tgz";
      path = fetchurl {
        name = "enhanced-resolve-0.9.1.tgz";
        url  = "https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-0.9.1.tgz";
        sha1 = "4d6e689b3725f86090927ccc86cd9f1635b89e2e";
      };
    }

    {
      name = "ent-2.2.0.tgz";
      path = fetchurl {
        name = "ent-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ent/-/ent-2.2.0.tgz";
        sha1 = "e964219325a21d05f44466a2f686ed6ce5f5dd1d";
      };
    }

    {
      name = "entities-1.1.1.tgz";
      path = fetchurl {
        name = "entities-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/entities/-/entities-1.1.1.tgz";
        sha1 = "6e5c2d0a5621b5dadaecef80b90edfb5cd7772f0";
      };
    }

    {
      name = "errno-0.1.4.tgz";
      path = fetchurl {
        name = "errno-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/errno/-/errno-0.1.4.tgz";
        sha1 = "b896e23a9e5e8ba33871fc996abd3635fc9a1c7d";
      };
    }

    {
      name = "error-ex-1.3.0.tgz";
      path = fetchurl {
        name = "error-ex-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.0.tgz";
        sha1 = "e67b43f3e82c96ea3a584ffee0b9fc3325d802d9";
      };
    }

    {
      name = "es5-ext-0.10.12.tgz";
      path = fetchurl {
        name = "es5-ext-0.10.12.tgz";
        url  = "https://registry.yarnpkg.com/es5-ext/-/es5-ext-0.10.12.tgz";
        sha1 = "aa84641d4db76b62abba5e45fd805ecbab140047";
      };
    }

    {
      name = "es6-iterator-2.0.0.tgz";
      path = fetchurl {
        name = "es6-iterator-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/es6-iterator/-/es6-iterator-2.0.0.tgz";
        sha1 = "bd968567d61635e33c0b80727613c9cb4b096bac";
      };
    }

    {
      name = "es6-map-0.1.4.tgz";
      path = fetchurl {
        name = "es6-map-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/es6-map/-/es6-map-0.1.4.tgz";
        sha1 = "a34b147be224773a4d7da8072794cefa3632b897";
      };
    }

    {
      name = "es6-promise-3.0.2.tgz";
      path = fetchurl {
        name = "es6-promise-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/es6-promise/-/es6-promise-3.0.2.tgz";
        sha1 = "010d5858423a5f118979665f46486a95c6ee2bb6";
      };
    }

    {
      name = "es6-promise-4.0.5.tgz";
      path = fetchurl {
        name = "es6-promise-4.0.5.tgz";
        url  = "https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.0.5.tgz";
        sha1 = "7882f30adde5b240ccfa7f7d78c548330951ae42";
      };
    }

    {
      name = "es6-set-0.1.4.tgz";
      path = fetchurl {
        name = "es6-set-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/es6-set/-/es6-set-0.1.4.tgz";
        sha1 = "9516b6761c2964b92ff479456233a247dc707ce8";
      };
    }

    {
      name = "es6-symbol-3.1.0.tgz";
      path = fetchurl {
        name = "es6-symbol-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/es6-symbol/-/es6-symbol-3.1.0.tgz";
        sha1 = "94481c655e7a7cad82eba832d97d5433496d7ffa";
      };
    }

    {
      name = "es6-weak-map-2.0.1.tgz";
      path = fetchurl {
        name = "es6-weak-map-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/es6-weak-map/-/es6-weak-map-2.0.1.tgz";
        sha1 = "0d2bbd8827eb5fb4ba8f97fbfea50d43db21ea81";
      };
    }

    {
      name = "escape-html-1.0.3.tgz";
      path = fetchurl {
        name = "escape-html-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz";
        sha1 = "0258eae4d3d0c0974de1c169188ef0051d1d1988";
      };
    }

    {
      name = "escape-string-regexp-1.0.5.tgz";
      path = fetchurl {
        name = "escape-string-regexp-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    }

    {
      name = "escodegen-1.8.1.tgz";
      path = fetchurl {
        name = "escodegen-1.8.1.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.8.1.tgz";
        sha1 = "5a5b53af4693110bebb0867aa3430dd3b70a1018";
      };
    }

    {
      name = "escope-3.6.0.tgz";
      path = fetchurl {
        name = "escope-3.6.0.tgz";
        url  = "https://registry.yarnpkg.com/escope/-/escope-3.6.0.tgz";
        sha1 = "e01975e812781a163a6dadfdd80398dc64c889c3";
      };
    }

    {
      name = "eslint-config-airbnb-base-10.0.1.tgz";
      path = fetchurl {
        name = "eslint-config-airbnb-base-10.0.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-config-airbnb-base/-/eslint-config-airbnb-base-10.0.1.tgz";
        sha1 = "f17d4e52992c1d45d1b7713efbcd5ecd0e7e0506";
      };
    }

    {
      name = "eslint-import-resolver-node-0.2.3.tgz";
      path = fetchurl {
        name = "eslint-import-resolver-node-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.2.3.tgz";
        sha1 = "5add8106e8c928db2cba232bcd9efa846e3da16c";
      };
    }

    {
      name = "eslint-import-resolver-webpack-0.8.1.tgz";
      path = fetchurl {
        name = "eslint-import-resolver-webpack-0.8.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-import-resolver-webpack/-/eslint-import-resolver-webpack-0.8.1.tgz";
        sha1 = "c7f8b4d5bd3c5b489457e5728c5db1c4ffbac9aa";
      };
    }

    {
      name = "eslint-module-utils-2.0.0.tgz";
      path = fetchurl {
        name = "eslint-module-utils-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.0.0.tgz";
        sha1 = "a6f8c21d901358759cdc35dbac1982ae1ee58bce";
      };
    }

    {
      name = "eslint-plugin-filenames-1.1.0.tgz";
      path = fetchurl {
        name = "eslint-plugin-filenames-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-filenames/-/eslint-plugin-filenames-1.1.0.tgz";
        sha1 = "bb925218ab25b1aad1c622cfa9cb8f43cc03a4ff";
      };
    }

    {
      name = "eslint-plugin-html-2.0.1.tgz";
      path = fetchurl {
        name = "eslint-plugin-html-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-html/-/eslint-plugin-html-2.0.1.tgz";
        sha1 = "3a829510e82522f1e2e44d55d7661a176121fce1";
      };
    }

    {
      name = "eslint-plugin-import-2.2.0.tgz";
      path = fetchurl {
        name = "eslint-plugin-import-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.2.0.tgz";
        sha1 = "72ba306fad305d67c4816348a4699a4229ac8b4e";
      };
    }

    {
      name = "eslint-plugin-jasmine-2.2.0.tgz";
      path = fetchurl {
        name = "eslint-plugin-jasmine-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-jasmine/-/eslint-plugin-jasmine-2.2.0.tgz";
        sha1 = "7135879383c39a667c721d302b9f20f0389543de";
      };
    }

    {
      name = "eslint-plugin-promise-3.5.0.tgz";
      path = fetchurl {
        name = "eslint-plugin-promise-3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-promise/-/eslint-plugin-promise-3.5.0.tgz";
        sha1 = "78fbb6ffe047201627569e85a6c5373af2a68fca";
      };
    }

    {
      name = "eslint-3.15.0.tgz";
      path = fetchurl {
        name = "eslint-3.15.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint/-/eslint-3.15.0.tgz";
        sha1 = "bdcc6a6c5ffe08160e7b93c066695362a91e30f2";
      };
    }

    {
      name = "espree-3.4.0.tgz";
      path = fetchurl {
        name = "espree-3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/espree/-/espree-3.4.0.tgz";
        sha1 = "41656fa5628e042878025ef467e78f125cb86e1d";
      };
    }

    {
      name = "esprima-2.7.3.tgz";
      path = fetchurl {
        name = "esprima-2.7.3.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-2.7.3.tgz";
        sha1 = "96e3b70d5779f6ad49cd032673d1c312767ba581";
      };
    }

    {
      name = "esprima-3.1.3.tgz";
      path = fetchurl {
        name = "esprima-3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-3.1.3.tgz";
        sha1 = "fdca51cee6133895e3c88d535ce49dbff62a4633";
      };
    }

    {
      name = "esrecurse-4.1.0.tgz";
      path = fetchurl {
        name = "esrecurse-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.1.0.tgz";
        sha1 = "4713b6536adf7f2ac4f327d559e7756bff648220";
      };
    }

    {
      name = "estraverse-1.9.3.tgz";
      path = fetchurl {
        name = "estraverse-1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-1.9.3.tgz";
        sha1 = "af67f2dc922582415950926091a4005d29c9bb44";
      };
    }

    {
      name = "estraverse-4.2.0.tgz";
      path = fetchurl {
        name = "estraverse-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-4.2.0.tgz";
        sha1 = "0dee3fed31fcd469618ce7342099fc1afa0bdb13";
      };
    }

    {
      name = "estraverse-4.1.1.tgz";
      path = fetchurl {
        name = "estraverse-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-4.1.1.tgz";
        sha1 = "f6caca728933a850ef90661d0e17982ba47111a2";
      };
    }

    {
      name = "esutils-2.0.2.tgz";
      path = fetchurl {
        name = "esutils-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-2.0.2.tgz";
        sha1 = "0abf4f1caa5bcb1f7a9d8acc6dea4faaa04bac9b";
      };
    }

    {
      name = "etag-1.8.0.tgz";
      path = fetchurl {
        name = "etag-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/etag/-/etag-1.8.0.tgz";
        sha1 = "6f631aef336d6c46362b51764044ce216be3c051";
      };
    }

    {
      name = "eve-raphael-0.5.0.tgz";
      path = fetchurl {
        name = "eve-raphael-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/eve-raphael/-/eve-raphael-0.5.0.tgz";
        sha1 = "17c754b792beef3fa6684d79cf5a47c63c4cda30";
      };
    }

    {
      name = "event-emitter-0.3.4.tgz";
      path = fetchurl {
        name = "event-emitter-0.3.4.tgz";
        url  = "https://registry.yarnpkg.com/event-emitter/-/event-emitter-0.3.4.tgz";
        sha1 = "8d63ddfb4cfe1fae3b32ca265c4c720222080bb5";
      };
    }

    {
      name = "event-stream-3.3.4.tgz";
      path = fetchurl {
        name = "event-stream-3.3.4.tgz";
        url  = "https://registry.yarnpkg.com/event-stream/-/event-stream-3.3.4.tgz";
        sha1 = "4ab4c9a0f5a54db9338b4c34d86bfce8f4b35571";
      };
    }

    {
      name = "eventemitter3-1.2.0.tgz";
      path = fetchurl {
        name = "eventemitter3-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-1.2.0.tgz";
        sha1 = "1c86991d816ad1e504750e73874224ecf3bec508";
      };
    }

    {
      name = "events-1.1.1.tgz";
      path = fetchurl {
        name = "events-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/events/-/events-1.1.1.tgz";
        sha1 = "9ebdb7635ad099c70dcc4c2a1f5004288e8bd924";
      };
    }

    {
      name = "eventsource-0.1.6.tgz";
      path = fetchurl {
        name = "eventsource-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/eventsource/-/eventsource-0.1.6.tgz";
        sha1 = "0acede849ed7dd1ccc32c811bb11b944d4f29232";
      };
    }

    {
      name = "evp_bytestokey-1.0.0.tgz";
      path = fetchurl {
        name = "evp_bytestokey-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/evp_bytestokey/-/evp_bytestokey-1.0.0.tgz";
        sha1 = "497b66ad9fef65cd7c08a6180824ba1476b66e53";
      };
    }

    {
      name = "exit-hook-1.1.1.tgz";
      path = fetchurl {
        name = "exit-hook-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/exit-hook/-/exit-hook-1.1.1.tgz";
        sha1 = "f05ca233b48c05d54fff07765df8507e95c02ff8";
      };
    }

    {
      name = "expand-braces-0.1.2.tgz";
      path = fetchurl {
        name = "expand-braces-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/expand-braces/-/expand-braces-0.1.2.tgz";
        sha1 = "488b1d1d2451cb3d3a6b192cfc030f44c5855fea";
      };
    }

    {
      name = "expand-brackets-0.1.5.tgz";
      path = fetchurl {
        name = "expand-brackets-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-0.1.5.tgz";
        sha1 = "df07284e342a807cd733ac5af72411e581d1177b";
      };
    }

    {
      name = "expand-range-0.1.1.tgz";
      path = fetchurl {
        name = "expand-range-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/expand-range/-/expand-range-0.1.1.tgz";
        sha1 = "4cb8eda0993ca56fa4f41fc42f3cbb4ccadff044";
      };
    }

    {
      name = "expand-range-1.8.2.tgz";
      path = fetchurl {
        name = "expand-range-1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/expand-range/-/expand-range-1.8.2.tgz";
        sha1 = "a299effd335fe2721ebae8e257ec79644fc85337";
      };
    }

    {
      name = "exports-loader-0.6.4.tgz";
      path = fetchurl {
        name = "exports-loader-0.6.4.tgz";
        url  = "https://registry.yarnpkg.com/exports-loader/-/exports-loader-0.6.4.tgz";
        sha1 = "d70fc6121975b35fc12830cf52754be2740fc886";
      };
    }

    {
      name = "express-4.15.3.tgz";
      path = fetchurl {
        name = "express-4.15.3.tgz";
        url  = "https://registry.yarnpkg.com/express/-/express-4.15.3.tgz";
        sha1 = "bab65d0f03aa80c358408972fc700f916944b662";
      };
    }

    {
      name = "extend-3.0.0.tgz";
      path = fetchurl {
        name = "extend-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/extend/-/extend-3.0.0.tgz";
        sha1 = "5a474353b9f3353ddd8176dfd37b91c83a46f1d4";
      };
    }

    {
      name = "extglob-0.3.2.tgz";
      path = fetchurl {
        name = "extglob-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/extglob/-/extglob-0.3.2.tgz";
        sha1 = "2e18ff3d2f49ab2765cec9023f011daa8d8349a1";
      };
    }

    {
      name = "extract-zip-1.5.0.tgz";
      path = fetchurl {
        name = "extract-zip-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.5.0.tgz";
        sha1 = "92ccf6d81ef70a9fa4c1747114ccef6d8688a6c4";
      };
    }

    {
      name = "extsprintf-1.0.2.tgz";
      path = fetchurl {
        name = "extsprintf-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.0.2.tgz";
        sha1 = "e1080e0658e300b06294990cc70e1502235fd550";
      };
    }

    {
      name = "fast-levenshtein-2.0.6.tgz";
      path = fetchurl {
        name = "fast-levenshtein-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz";
        sha1 = "3d8a5c66883a16a30ca8643e851f19baa7797917";
      };
    }

    {
      name = "fastparse-1.1.1.tgz";
      path = fetchurl {
        name = "fastparse-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/fastparse/-/fastparse-1.1.1.tgz";
        sha1 = "d1e2643b38a94d7583b479060e6c4affc94071f8";
      };
    }

    {
      name = "faye-websocket-0.10.0.tgz";
      path = fetchurl {
        name = "faye-websocket-0.10.0.tgz";
        url  = "https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.10.0.tgz";
        sha1 = "4e492f8d04dfb6f89003507f6edbf2d501e7c6f4";
      };
    }

    {
      name = "faye-websocket-0.11.1.tgz";
      path = fetchurl {
        name = "faye-websocket-0.11.1.tgz";
        url  = "https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.11.1.tgz";
        sha1 = "f0efe18c4f56e4f40afc7e06c719fd5ee6188f38";
      };
    }

    {
      name = "faye-websocket-0.7.3.tgz";
      path = fetchurl {
        name = "faye-websocket-0.7.3.tgz";
        url  = "https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.7.3.tgz";
        sha1 = "cc4074c7f4a4dfd03af54dd65c354b135132ce11";
      };
    }

    {
      name = "fd-slicer-1.0.1.tgz";
      path = fetchurl {
        name = "fd-slicer-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.0.1.tgz";
        sha1 = "8b5bcbd9ec327c5041bf9ab023fd6750f1177e65";
      };
    }

    {
      name = "figures-1.7.0.tgz";
      path = fetchurl {
        name = "figures-1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/figures/-/figures-1.7.0.tgz";
        sha1 = "cbe1e3affcf1cd44b80cadfed28dc793a9701d2e";
      };
    }

    {
      name = "file-entry-cache-2.0.0.tgz";
      path = fetchurl {
        name = "file-entry-cache-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-2.0.0.tgz";
        sha1 = "c392990c3e684783d838b8c84a45d8a048458361";
      };
    }

    {
      name = "file-loader-0.11.1.tgz";
      path = fetchurl {
        name = "file-loader-0.11.1.tgz";
        url  = "https://registry.yarnpkg.com/file-loader/-/file-loader-0.11.1.tgz";
        sha1 = "6b328ee1234a729e4e47d36375dd6d35c0e1db84";
      };
    }

    {
      name = "filename-regex-2.0.0.tgz";
      path = fetchurl {
        name = "filename-regex-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/filename-regex/-/filename-regex-2.0.0.tgz";
        sha1 = "996e3e80479b98b9897f15a8a58b3d084e926775";
      };
    }

    {
      name = "fileset-2.0.3.tgz";
      path = fetchurl {
        name = "fileset-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/fileset/-/fileset-2.0.3.tgz";
        sha1 = "8e7548a96d3cc2327ee5e674168723a333bba2a0";
      };
    }

    {
      name = "filesize-3.3.0.tgz";
      path = fetchurl {
        name = "filesize-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/filesize/-/filesize-3.3.0.tgz";
        sha1 = "53149ea3460e3b2e024962a51648aa572cf98122";
      };
    }

    {
      name = "filesize-3.5.10.tgz";
      path = fetchurl {
        name = "filesize-3.5.10.tgz";
        url  = "https://registry.yarnpkg.com/filesize/-/filesize-3.5.10.tgz";
        sha1 = "fc8fa23ddb4ef9e5e0ab6e1e64f679a24a56761f";
      };
    }

    {
      name = "fill-range-2.2.3.tgz";
      path = fetchurl {
        name = "fill-range-2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/fill-range/-/fill-range-2.2.3.tgz";
        sha1 = "50b77dfd7e469bc7492470963699fe7a8485a723";
      };
    }

    {
      name = "finalhandler-0.5.0.tgz";
      path = fetchurl {
        name = "finalhandler-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/finalhandler/-/finalhandler-0.5.0.tgz";
        sha1 = "e9508abece9b6dba871a6942a1d7911b91911ac7";
      };
    }

    {
      name = "finalhandler-1.0.3.tgz";
      path = fetchurl {
        name = "finalhandler-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.0.3.tgz";
        sha1 = "ef47e77950e999780e86022a560e3217e0d0cc89";
      };
    }

    {
      name = "find-cache-dir-0.1.1.tgz";
      path = fetchurl {
        name = "find-cache-dir-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-0.1.1.tgz";
        sha1 = "c8defae57c8a52a8a784f9e31c57c742e993a0b9";
      };
    }

    {
      name = "find-root-0.1.2.tgz";
      path = fetchurl {
        name = "find-root-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/find-root/-/find-root-0.1.2.tgz";
        sha1 = "98d2267cff1916ccaf2743b3a0eea81d79d7dcd1";
      };
    }

    {
      name = "find-up-1.1.2.tgz";
      path = fetchurl {
        name = "find-up-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz";
        sha1 = "6b2e9822b1a2ce0a60ab64d610eccad53cb24d0f";
      };
    }

    {
      name = "find-up-2.1.0.tgz";
      path = fetchurl {
        name = "find-up-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz";
        sha1 = "45d1b7e506c717ddd482775a2b77920a3c0c57a7";
      };
    }

    {
      name = "flat-cache-1.2.2.tgz";
      path = fetchurl {
        name = "flat-cache-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/flat-cache/-/flat-cache-1.2.2.tgz";
        sha1 = "fa86714e72c21db88601761ecf2f555d1abc6b96";
      };
    }

    {
      name = "flatten-1.0.2.tgz";
      path = fetchurl {
        name = "flatten-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/flatten/-/flatten-1.0.2.tgz";
        sha1 = "dae46a9d78fbe25292258cc1e780a41d95c03782";
      };
    }

    {
      name = "for-in-0.1.6.tgz";
      path = fetchurl {
        name = "for-in-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/for-in/-/for-in-0.1.6.tgz";
        sha1 = "c9f96e89bfad18a545af5ec3ed352a1d9e5b4dc8";
      };
    }

    {
      name = "for-own-0.1.4.tgz";
      path = fetchurl {
        name = "for-own-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/for-own/-/for-own-0.1.4.tgz";
        sha1 = "0149b41a39088c7515f51ebe1c1386d45f935072";
      };
    }

    {
      name = "forever-agent-0.6.1.tgz";
      path = fetchurl {
        name = "forever-agent-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
    }

    {
      name = "form-data-2.1.2.tgz";
      path = fetchurl {
        name = "form-data-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.1.2.tgz";
        sha1 = "89c3534008b97eada4cbb157d58f6f5df025eae4";
      };
    }

    {
      name = "forwarded-0.1.0.tgz";
      path = fetchurl {
        name = "forwarded-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/forwarded/-/forwarded-0.1.0.tgz";
        sha1 = "19ef9874c4ae1c297bcf078fde63a09b66a84363";
      };
    }

    {
      name = "fresh-0.5.0.tgz";
      path = fetchurl {
        name = "fresh-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/fresh/-/fresh-0.5.0.tgz";
        sha1 = "f474ca5e6a9246d6fd8e0953cfa9b9c805afa78e";
      };
    }

    {
      name = "from-0.1.7.tgz";
      path = fetchurl {
        name = "from-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/from/-/from-0.1.7.tgz";
        sha1 = "83c60afc58b9c56997007ed1a768b3ab303a44fe";
      };
    }

    {
      name = "fs-extra-1.0.0.tgz";
      path = fetchurl {
        name = "fs-extra-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-1.0.0.tgz";
        sha1 = "cd3ce5f7e7cb6145883fcae3191e9877f8587950";
      };
    }

    {
      name = "fs.realpath-1.0.0.tgz";
      path = fetchurl {
        name = "fs.realpath-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
      };
    }

    {
      name = "fsevents-1.0.17.tgz";
      path = fetchurl {
        name = "fsevents-1.0.17.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-1.0.17.tgz";
        sha1 = "8537f3f12272678765b4fd6528c0f1f66f8f4558";
      };
    }

    {
      name = "fstream-ignore-1.0.5.tgz";
      path = fetchurl {
        name = "fstream-ignore-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/fstream-ignore/-/fstream-ignore-1.0.5.tgz";
        sha1 = "9c31dae34767018fe1d249b24dada67d092da105";
      };
    }

    {
      name = "fstream-1.0.10.tgz";
      path = fetchurl {
        name = "fstream-1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/fstream/-/fstream-1.0.10.tgz";
        sha1 = "604e8a92fe26ffd9f6fae30399d4984e1ab22822";
      };
    }

    {
      name = "function-bind-1.1.0.tgz";
      path = fetchurl {
        name = "function-bind-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.0.tgz";
        sha1 = "16176714c801798e4e8f2cf7f7529467bb4a5771";
      };
    }

    {
      name = "gauge-2.7.2.tgz";
      path = fetchurl {
        name = "gauge-2.7.2.tgz";
        url  = "https://registry.yarnpkg.com/gauge/-/gauge-2.7.2.tgz";
        sha1 = "15cecc31b02d05345a5d6b0e171cdb3ad2307774";
      };
    }

    {
      name = "generate-function-2.0.0.tgz";
      path = fetchurl {
        name = "generate-function-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/generate-function/-/generate-function-2.0.0.tgz";
        sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
      };
    }

    {
      name = "generate-object-property-1.2.0.tgz";
      path = fetchurl {
        name = "generate-object-property-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/generate-object-property/-/generate-object-property-1.2.0.tgz";
        sha1 = "9c0e1c40308ce804f4783618b937fa88f99d50d0";
      };
    }

    {
      name = "get-caller-file-1.0.2.tgz";
      path = fetchurl {
        name = "get-caller-file-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-1.0.2.tgz";
        sha1 = "f702e63127e7e231c160a80c1554acb70d5047e5";
      };
    }

    {
      name = "getpass-0.1.6.tgz";
      path = fetchurl {
        name = "getpass-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/getpass/-/getpass-0.1.6.tgz";
        sha1 = "283ffd9fc1256840875311c1b60e8c40187110e6";
      };
    }

    {
      name = "glob-base-0.3.0.tgz";
      path = fetchurl {
        name = "glob-base-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/glob-base/-/glob-base-0.3.0.tgz";
        sha1 = "dbb164f6221b1c0b1ccf82aea328b497df0ea3c4";
      };
    }

    {
      name = "glob-parent-2.0.0.tgz";
      path = fetchurl {
        name = "glob-parent-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-2.0.0.tgz";
        sha1 = "81383d72db054fcccf5336daa902f182f6edbb28";
      };
    }

    {
      name = "glob-5.0.15.tgz";
      path = fetchurl {
        name = "glob-5.0.15.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-5.0.15.tgz";
        sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
      };
    }

    {
      name = "glob-7.1.1.tgz";
      path = fetchurl {
        name = "glob-7.1.1.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.1.tgz";
        sha1 = "805211df04faaf1c63a3600306cdf5ade50b2ec8";
      };
    }

    {
      name = "globals-9.14.0.tgz";
      path = fetchurl {
        name = "globals-9.14.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-9.14.0.tgz";
        sha1 = "8859936af0038741263053b39d0e76ca241e4034";
      };
    }

    {
      name = "globby-5.0.0.tgz";
      path = fetchurl {
        name = "globby-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/globby/-/globby-5.0.0.tgz";
        sha1 = "ebd84667ca0dbb330b99bcfc68eac2bc54370e0d";
      };
    }

    {
      name = "good-listener-1.2.2.tgz";
      path = fetchurl {
        name = "good-listener-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/good-listener/-/good-listener-1.2.2.tgz";
        sha1 = "d53b30cdf9313dffb7dc9a0d477096aa6d145c50";
      };
    }

    {
      name = "got-3.3.1.tgz";
      path = fetchurl {
        name = "got-3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/got/-/got-3.3.1.tgz";
        sha1 = "e5d0ed4af55fc3eef4d56007769d98192bcb2eca";
      };
    }

    {
      name = "graceful-fs-4.1.11.tgz";
      path = fetchurl {
        name = "graceful-fs-4.1.11.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.1.11.tgz";
        sha1 = "0e8bdfe4d1ddb8854d64e04ea7c00e2a026e5658";
      };
    }

    {
      name = "graceful-readlink-1.0.1.tgz";
      path = fetchurl {
        name = "graceful-readlink-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      };
    }

    {
      name = "gzip-size-3.0.0.tgz";
      path = fetchurl {
        name = "gzip-size-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/gzip-size/-/gzip-size-3.0.0.tgz";
        sha1 = "546188e9bdc337f673772f81660464b389dce520";
      };
    }

    {
      name = "handle-thing-1.2.5.tgz";
      path = fetchurl {
        name = "handle-thing-1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/handle-thing/-/handle-thing-1.2.5.tgz";
        sha1 = "fd7aad726bf1a5fd16dfc29b2f7a6601d27139c4";
      };
    }

    {
      name = "handlebars-4.0.6.tgz";
      path = fetchurl {
        name = "handlebars-4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/handlebars/-/handlebars-4.0.6.tgz";
        sha1 = "2ce4484850537f9c97a8026d5399b935c4ed4ed7";
      };
    }

    {
      name = "har-validator-2.0.6.tgz";
      path = fetchurl {
        name = "har-validator-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-2.0.6.tgz";
        sha1 = "cdcbc08188265ad119b6a5a7c8ab70eecfb5d27d";
      };
    }

    {
      name = "has-ansi-2.0.0.tgz";
      path = fetchurl {
        name = "has-ansi-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
    }

    {
      name = "has-binary-0.1.7.tgz";
      path = fetchurl {
        name = "has-binary-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/has-binary/-/has-binary-0.1.7.tgz";
        sha1 = "68e61eb16210c9545a0a5cce06a873912fe1e68c";
      };
    }

    {
      name = "has-cors-1.1.0.tgz";
      path = fetchurl {
        name = "has-cors-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/has-cors/-/has-cors-1.1.0.tgz";
        sha1 = "5e474793f7ea9843d1bb99c23eef49ff126fff39";
      };
    }

    {
      name = "has-flag-1.0.0.tgz";
      path = fetchurl {
        name = "has-flag-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-1.0.0.tgz";
        sha1 = "9d9e793165ce017a00f00418c43f942a7b1d11fa";
      };
    }

    {
      name = "has-unicode-2.0.1.tgz";
      path = fetchurl {
        name = "has-unicode-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz";
        sha1 = "e0e6fe6a28cf51138855e086d1691e771de2a8b9";
      };
    }

    {
      name = "has-1.0.1.tgz";
      path = fetchurl {
        name = "has-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has/-/has-1.0.1.tgz";
        sha1 = "8461733f538b0837c9361e39a9ab9e9704dc2f28";
      };
    }

    {
      name = "hash-sum-1.0.2.tgz";
      path = fetchurl {
        name = "hash-sum-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/hash-sum/-/hash-sum-1.0.2.tgz";
        sha1 = "33b40777754c6432573c120cc3808bbd10d47f04";
      };
    }

    {
      name = "hash.js-1.0.3.tgz";
      path = fetchurl {
        name = "hash.js-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/hash.js/-/hash.js-1.0.3.tgz";
        sha1 = "1332ff00156c0a0ffdd8236013d07b77a0451573";
      };
    }

    {
      name = "hasha-2.2.0.tgz";
      path = fetchurl {
        name = "hasha-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/hasha/-/hasha-2.2.0.tgz";
        sha1 = "78d7cbfc1e6d66303fe79837365984517b2f6ee1";
      };
    }

    {
      name = "hawk-3.1.3.tgz";
      path = fetchurl {
        name = "hawk-3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/hawk/-/hawk-3.1.3.tgz";
        sha1 = "078444bd7c1640b0fe540d2c9b73d59678e8e1c4";
      };
    }

    {
      name = "he-1.1.1.tgz";
      path = fetchurl {
        name = "he-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/he/-/he-1.1.1.tgz";
        sha1 = "93410fd21b009735151f8868c2f271f3427e23fd";
      };
    }

    {
      name = "hoek-2.16.3.tgz";
      path = fetchurl {
        name = "hoek-2.16.3.tgz";
        url  = "https://registry.yarnpkg.com/hoek/-/hoek-2.16.3.tgz";
        sha1 = "20bb7403d3cea398e91dc4710a8ff1b8274a25ed";
      };
    }

    {
      name = "home-or-tmp-2.0.0.tgz";
      path = fetchurl {
        name = "home-or-tmp-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/home-or-tmp/-/home-or-tmp-2.0.0.tgz";
        sha1 = "e36c3f2d2cae7d746a857e38d18d5f32a7882db8";
      };
    }

    {
      name = "hosted-git-info-2.2.0.tgz";
      path = fetchurl {
        name = "hosted-git-info-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.2.0.tgz";
        sha1 = "7a0d097863d886c0fabbdcd37bf1758d8becf8a5";
      };
    }

    {
      name = "hpack.js-2.1.6.tgz";
      path = fetchurl {
        name = "hpack.js-2.1.6.tgz";
        url  = "https://registry.yarnpkg.com/hpack.js/-/hpack.js-2.1.6.tgz";
        sha1 = "87774c0949e513f42e84575b3c45681fade2a0b2";
      };
    }

    {
      name = "html-comment-regex-1.1.1.tgz";
      path = fetchurl {
        name = "html-comment-regex-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/html-comment-regex/-/html-comment-regex-1.1.1.tgz";
        sha1 = "668b93776eaae55ebde8f3ad464b307a4963625e";
      };
    }

    {
      name = "html-entities-1.2.0.tgz";
      path = fetchurl {
        name = "html-entities-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/html-entities/-/html-entities-1.2.0.tgz";
        sha1 = "41948caf85ce82fed36e4e6a0ed371a6664379e2";
      };
    }

    {
      name = "htmlparser2-3.9.2.tgz";
      path = fetchurl {
        name = "htmlparser2-3.9.2.tgz";
        url  = "https://registry.yarnpkg.com/htmlparser2/-/htmlparser2-3.9.2.tgz";
        sha1 = "1bdf87acca0f3f9e53fa4fcceb0f4b4cbb00b338";
      };
    }

    {
      name = "http-deceiver-1.2.7.tgz";
      path = fetchurl {
        name = "http-deceiver-1.2.7.tgz";
        url  = "https://registry.yarnpkg.com/http-deceiver/-/http-deceiver-1.2.7.tgz";
        sha1 = "fa7168944ab9a519d337cb0bec7284dc3e723d87";
      };
    }

    {
      name = "http-errors-1.5.1.tgz";
      path = fetchurl {
        name = "http-errors-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/http-errors/-/http-errors-1.5.1.tgz";
        sha1 = "788c0d2c1de2c81b9e6e8c01843b6b97eb920750";
      };
    }

    {
      name = "http-errors-1.6.1.tgz";
      path = fetchurl {
        name = "http-errors-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/http-errors/-/http-errors-1.6.1.tgz";
        sha1 = "5f8b8ed98aca545656bf572997387f904a722257";
      };
    }

    {
      name = "http-proxy-middleware-0.17.4.tgz";
      path = fetchurl {
        name = "http-proxy-middleware-0.17.4.tgz";
        url  = "https://registry.yarnpkg.com/http-proxy-middleware/-/http-proxy-middleware-0.17.4.tgz";
        sha1 = "642e8848851d66f09d4f124912846dbaeb41b833";
      };
    }

    {
      name = "http-proxy-1.16.2.tgz";
      path = fetchurl {
        name = "http-proxy-1.16.2.tgz";
        url  = "https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.16.2.tgz";
        sha1 = "06dff292952bf64dbe8471fa9df73066d4f37742";
      };
    }

    {
      name = "http-signature-1.1.1.tgz";
      path = fetchurl {
        name = "http-signature-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/http-signature/-/http-signature-1.1.1.tgz";
        sha1 = "df72e267066cd0ac67fb76adf8e134a8fbcf91bf";
      };
    }

    {
      name = "https-browserify-0.0.1.tgz";
      path = fetchurl {
        name = "https-browserify-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/https-browserify/-/https-browserify-0.0.1.tgz";
        sha1 = "3f91365cabe60b77ed0ebba24b454e3e09d95a82";
      };
    }

    {
      name = "iconv-lite-0.4.15.tgz";
      path = fetchurl {
        name = "iconv-lite-0.4.15.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.15.tgz";
        sha1 = "fe265a218ac6a57cfe854927e9d04c19825eddeb";
      };
    }

    {
      name = "icss-replace-symbols-1.0.2.tgz";
      path = fetchurl {
        name = "icss-replace-symbols-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/icss-replace-symbols/-/icss-replace-symbols-1.0.2.tgz";
        sha1 = "cb0b6054eb3af6edc9ab1d62d01933e2d4c8bfa5";
      };
    }

    {
      name = "ieee754-1.1.8.tgz";
      path = fetchurl {
        name = "ieee754-1.1.8.tgz";
        url  = "https://registry.yarnpkg.com/ieee754/-/ieee754-1.1.8.tgz";
        sha1 = "be33d40ac10ef1926701f6f08a2d86fbfd1ad3e4";
      };
    }

    {
      name = "ignore-by-default-1.0.1.tgz";
      path = fetchurl {
        name = "ignore-by-default-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ignore-by-default/-/ignore-by-default-1.0.1.tgz";
        sha1 = "48ca6d72f6c6a3af00a9ad4ae6876be3889e2b09";
      };
    }

    {
      name = "ignore-3.2.2.tgz";
      path = fetchurl {
        name = "ignore-3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/ignore/-/ignore-3.2.2.tgz";
        sha1 = "1c51e1ef53bab6ddc15db4d9ac4ec139eceb3410";
      };
    }

    {
      name = "immediate-3.0.6.tgz";
      path = fetchurl {
        name = "immediate-3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/immediate/-/immediate-3.0.6.tgz";
        sha1 = "9db1dbd0faf8de6fbe0f5dd5e56bb606280de69b";
      };
    }

    {
      name = "imurmurhash-0.1.4.tgz";
      path = fetchurl {
        name = "imurmurhash-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz";
        sha1 = "9218b9b2b928a238b13dc4fb6b6d576f231453ea";
      };
    }

    {
      name = "indexes-of-1.0.1.tgz";
      path = fetchurl {
        name = "indexes-of-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/indexes-of/-/indexes-of-1.0.1.tgz";
        sha1 = "f30f716c8e2bd346c7b67d3df3915566a7c05607";
      };
    }

    {
      name = "indexof-0.0.1.tgz";
      path = fetchurl {
        name = "indexof-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/indexof/-/indexof-0.0.1.tgz";
        sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
      };
    }

    {
      name = "infinity-agent-2.0.3.tgz";
      path = fetchurl {
        name = "infinity-agent-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/infinity-agent/-/infinity-agent-2.0.3.tgz";
        sha1 = "45e0e2ff7a9eb030b27d62b74b3744b7a7ac4216";
      };
    }

    {
      name = "inflight-1.0.6.tgz";
      path = fetchurl {
        name = "inflight-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    }

    {
      name = "inherits-2.0.3.tgz";
      path = fetchurl {
        name = "inherits-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz";
        sha1 = "633c2c83e3da42a502f52466022480f4208261de";
      };
    }

    {
      name = "inherits-2.0.1.tgz";
      path = fetchurl {
        name = "inherits-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      };
    }

    {
      name = "ini-1.3.4.tgz";
      path = fetchurl {
        name = "ini-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/ini/-/ini-1.3.4.tgz";
        sha1 = "0537cb79daf59b59a1a517dff706c86ec039162e";
      };
    }

    {
      name = "inquirer-0.12.0.tgz";
      path = fetchurl {
        name = "inquirer-0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/inquirer/-/inquirer-0.12.0.tgz";
        sha1 = "1ef2bfd63504df0bc75785fff8c2c41df12f077e";
      };
    }

    {
      name = "interpret-1.0.1.tgz";
      path = fetchurl {
        name = "interpret-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/interpret/-/interpret-1.0.1.tgz";
        sha1 = "d579fb7f693b858004947af39fa0db49f795602c";
      };
    }

    {
      name = "invariant-2.2.2.tgz";
      path = fetchurl {
        name = "invariant-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/invariant/-/invariant-2.2.2.tgz";
        sha1 = "9e1f56ac0acdb6bf303306f338be3b204ae60360";
      };
    }

    {
      name = "invert-kv-1.0.0.tgz";
      path = fetchurl {
        name = "invert-kv-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/invert-kv/-/invert-kv-1.0.0.tgz";
        sha1 = "104a8e4aaca6d3d8cd157a8ef8bfab2d7a3ffdb6";
      };
    }

    {
      name = "ipaddr.js-1.3.0.tgz";
      path = fetchurl {
        name = "ipaddr.js-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.3.0.tgz";
        sha1 = "1e03a52fdad83a8bbb2b25cbf4998b4cffcd3dec";
      };
    }

    {
      name = "is-absolute-url-2.1.0.tgz";
      path = fetchurl {
        name = "is-absolute-url-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-absolute-url/-/is-absolute-url-2.1.0.tgz";
        sha1 = "50530dfb84fcc9aa7dbe7852e83a37b93b9f2aa6";
      };
    }

    {
      name = "is-absolute-0.2.6.tgz";
      path = fetchurl {
        name = "is-absolute-0.2.6.tgz";
        url  = "https://registry.yarnpkg.com/is-absolute/-/is-absolute-0.2.6.tgz";
        sha1 = "20de69f3db942ef2d87b9c2da36f172235b1b5eb";
      };
    }

    {
      name = "is-arrayish-0.2.1.tgz";
      path = fetchurl {
        name = "is-arrayish-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz";
        sha1 = "77c99840527aa8ecb1a8ba697b80645a7a926a9d";
      };
    }

    {
      name = "is-binary-path-1.0.1.tgz";
      path = fetchurl {
        name = "is-binary-path-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz";
        sha1 = "75f16642b480f187a711c814161fd3a4a7655898";
      };
    }

    {
      name = "is-buffer-1.1.4.tgz";
      path = fetchurl {
        name = "is-buffer-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.4.tgz";
        sha1 = "cfc86ccd5dc5a52fa80489111c6920c457e2d98b";
      };
    }

    {
      name = "is-builtin-module-1.0.0.tgz";
      path = fetchurl {
        name = "is-builtin-module-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-builtin-module/-/is-builtin-module-1.0.0.tgz";
        sha1 = "540572d34f7ac3119f8f76c30cbc1b1e037affbe";
      };
    }

    {
      name = "is-dotfile-1.0.2.tgz";
      path = fetchurl {
        name = "is-dotfile-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-dotfile/-/is-dotfile-1.0.2.tgz";
        sha1 = "2c132383f39199f8edc268ca01b9b007d205cc4d";
      };
    }

    {
      name = "is-equal-shallow-0.1.3.tgz";
      path = fetchurl {
        name = "is-equal-shallow-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz";
        sha1 = "2238098fc221de0bcfa5d9eac4c45d638aa1c534";
      };
    }

    {
      name = "is-extendable-0.1.1.tgz";
      path = fetchurl {
        name = "is-extendable-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz";
        sha1 = "62b110e289a471418e3ec36a617d472e301dfc89";
      };
    }

    {
      name = "is-extglob-1.0.0.tgz";
      path = fetchurl {
        name = "is-extglob-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-1.0.0.tgz";
        sha1 = "ac468177c4943405a092fc8f29760c6ffc6206c0";
      };
    }

    {
      name = "is-extglob-2.1.1.tgz";
      path = fetchurl {
        name = "is-extglob-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz";
        sha1 = "a88c02535791f02ed37c76a1b9ea9773c833f8c2";
      };
    }

    {
      name = "is-finite-1.0.2.tgz";
      path = fetchurl {
        name = "is-finite-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-finite/-/is-finite-1.0.2.tgz";
        sha1 = "cc6677695602be550ef11e8b4aa6305342b6d0aa";
      };
    }

    {
      name = "is-fullwidth-code-point-1.0.0.tgz";
      path = fetchurl {
        name = "is-fullwidth-code-point-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz";
        sha1 = "ef9e31386f031a7f0d643af82fde50c457ef00cb";
      };
    }

    {
      name = "is-fullwidth-code-point-2.0.0.tgz";
      path = fetchurl {
        name = "is-fullwidth-code-point-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz";
        sha1 = "a3b30a5c4f199183167aaab93beefae3ddfb654f";
      };
    }

    {
      name = "is-glob-2.0.1.tgz";
      path = fetchurl {
        name = "is-glob-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-2.0.1.tgz";
        sha1 = "d096f926a3ded5600f3fdfd91198cb0888c2d863";
      };
    }

    {
      name = "is-glob-3.1.0.tgz";
      path = fetchurl {
        name = "is-glob-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz";
        sha1 = "7ba5ae24217804ac70707b96922567486cc3e84a";
      };
    }

    {
      name = "is-my-json-valid-2.15.0.tgz";
      path = fetchurl {
        name = "is-my-json-valid-2.15.0.tgz";
        url  = "https://registry.yarnpkg.com/is-my-json-valid/-/is-my-json-valid-2.15.0.tgz";
        sha1 = "936edda3ca3c211fd98f3b2d3e08da43f7b2915b";
      };
    }

    {
      name = "is-npm-1.0.0.tgz";
      path = fetchurl {
        name = "is-npm-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-npm/-/is-npm-1.0.0.tgz";
        sha1 = "f2fb63a65e4905b406c86072765a1a4dc793b9f4";
      };
    }

    {
      name = "is-number-0.1.1.tgz";
      path = fetchurl {
        name = "is-number-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-0.1.1.tgz";
        sha1 = "69a7af116963d47206ec9bd9b48a14216f1e3806";
      };
    }

    {
      name = "is-number-2.1.0.tgz";
      path = fetchurl {
        name = "is-number-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-2.1.0.tgz";
        sha1 = "01fcbbb393463a548f2f466cce16dece49db908f";
      };
    }

    {
      name = "is-path-cwd-1.0.0.tgz";
      path = fetchurl {
        name = "is-path-cwd-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-1.0.0.tgz";
        sha1 = "d225ec23132e89edd38fda767472e62e65f1106d";
      };
    }

    {
      name = "is-path-in-cwd-1.0.0.tgz";
      path = fetchurl {
        name = "is-path-in-cwd-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-path-in-cwd/-/is-path-in-cwd-1.0.0.tgz";
        sha1 = "6477582b8214d602346094567003be8a9eac04dc";
      };
    }

    {
      name = "is-path-inside-1.0.0.tgz";
      path = fetchurl {
        name = "is-path-inside-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-1.0.0.tgz";
        sha1 = "fc06e5a1683fbda13de667aff717bbc10a48f37f";
      };
    }

    {
      name = "is-plain-obj-1.1.0.tgz";
      path = fetchurl {
        name = "is-plain-obj-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz";
        sha1 = "71a50c8429dfca773c92a390a4a03b39fcd51d3e";
      };
    }

    {
      name = "is-posix-bracket-0.1.1.tgz";
      path = fetchurl {
        name = "is-posix-bracket-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz";
        sha1 = "3334dc79774368e92f016e6fbc0a88f5cd6e6bc4";
      };
    }

    {
      name = "is-primitive-2.0.0.tgz";
      path = fetchurl {
        name = "is-primitive-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-primitive/-/is-primitive-2.0.0.tgz";
        sha1 = "207bab91638499c07b2adf240a41a87210034575";
      };
    }

    {
      name = "is-property-1.0.2.tgz";
      path = fetchurl {
        name = "is-property-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-property/-/is-property-1.0.2.tgz";
        sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
      };
    }

    {
      name = "is-redirect-1.0.0.tgz";
      path = fetchurl {
        name = "is-redirect-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-redirect/-/is-redirect-1.0.0.tgz";
        sha1 = "1d03dded53bd8db0f30c26e4f95d36fc7c87dc24";
      };
    }

    {
      name = "is-relative-0.2.1.tgz";
      path = fetchurl {
        name = "is-relative-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-relative/-/is-relative-0.2.1.tgz";
        sha1 = "d27f4c7d516d175fb610db84bbeef23c3bc97aa5";
      };
    }

    {
      name = "is-resolvable-1.0.0.tgz";
      path = fetchurl {
        name = "is-resolvable-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-resolvable/-/is-resolvable-1.0.0.tgz";
        sha1 = "8df57c61ea2e3c501408d100fb013cf8d6e0cc62";
      };
    }

    {
      name = "is-stream-1.1.0.tgz";
      path = fetchurl {
        name = "is-stream-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz";
        sha1 = "12d4a3dd4e68e0b79ceb8dbc84173ae80d91ca44";
      };
    }

    {
      name = "is-svg-2.1.0.tgz";
      path = fetchurl {
        name = "is-svg-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-svg/-/is-svg-2.1.0.tgz";
        sha1 = "cf61090da0d9efbcab8722deba6f032208dbb0e9";
      };
    }

    {
      name = "is-typedarray-1.0.0.tgz";
      path = fetchurl {
        name = "is-typedarray-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz";
        sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
      };
    }

    {
      name = "is-unc-path-0.1.2.tgz";
      path = fetchurl {
        name = "is-unc-path-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/is-unc-path/-/is-unc-path-0.1.2.tgz";
        sha1 = "6ab053a72573c10250ff416a3814c35178af39b9";
      };
    }

    {
      name = "is-utf8-0.2.1.tgz";
      path = fetchurl {
        name = "is-utf8-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz";
        sha1 = "4b0da1442104d1b336340e80797e865cf39f7d72";
      };
    }

    {
      name = "is-windows-0.2.0.tgz";
      path = fetchurl {
        name = "is-windows-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/is-windows/-/is-windows-0.2.0.tgz";
        sha1 = "de1aa6d63ea29dd248737b69f1ff8b8002d2108c";
      };
    }

    {
      name = "isarray-0.0.1.tgz";
      path = fetchurl {
        name = "isarray-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      };
    }

    {
      name = "isarray-1.0.0.tgz";
      path = fetchurl {
        name = "isarray-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    }

    {
      name = "isbinaryfile-3.0.2.tgz";
      path = fetchurl {
        name = "isbinaryfile-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-3.0.2.tgz";
        sha1 = "4a3e974ec0cba9004d3fc6cde7209ea69368a621";
      };
    }

    {
      name = "isexe-1.1.2.tgz";
      path = fetchurl {
        name = "isexe-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-1.1.2.tgz";
        sha1 = "36f3e22e60750920f5e7241a476a8c6a42275ad0";
      };
    }

    {
      name = "isobject-2.1.0.tgz";
      path = fetchurl {
        name = "isobject-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz";
        sha1 = "f065561096a3f1da2ef46272f815c840d87e0c89";
      };
    }

    {
      name = "isstream-0.1.2.tgz";
      path = fetchurl {
        name = "isstream-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
    }

    {
      name = "istanbul-api-1.1.1.tgz";
      path = fetchurl {
        name = "istanbul-api-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-api/-/istanbul-api-1.1.1.tgz";
        sha1 = "d36e2f1560d1a43ce304c4ff7338182de61c8f73";
      };
    }

    {
      name = "istanbul-lib-coverage-1.0.1.tgz";
      path = fetchurl {
        name = "istanbul-lib-coverage-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-1.0.1.tgz";
        sha1 = "f263efb519c051c5f1f3343034fc40e7b43ff212";
      };
    }

    {
      name = "istanbul-lib-hook-1.0.0.tgz";
      path = fetchurl {
        name = "istanbul-lib-hook-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-hook/-/istanbul-lib-hook-1.0.0.tgz";
        sha1 = "fc5367ee27f59268e8f060b0c7aaf051d9c425c5";
      };
    }

    {
      name = "istanbul-lib-instrument-1.4.2.tgz";
      path = fetchurl {
        name = "istanbul-lib-instrument-1.4.2.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-instrument/-/istanbul-lib-instrument-1.4.2.tgz";
        sha1 = "0e2fdfac93c1dabf2e31578637dc78a19089f43e";
      };
    }

    {
      name = "istanbul-lib-report-1.0.0-alpha.3.tgz";
      path = fetchurl {
        name = "istanbul-lib-report-1.0.0-alpha.3.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-1.0.0-alpha.3.tgz";
        sha1 = "32d5f6ec7f33ca3a602209e278b2e6ff143498af";
      };
    }

    {
      name = "istanbul-lib-source-maps-1.1.0.tgz";
      path = fetchurl {
        name = "istanbul-lib-source-maps-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-lib-source-maps/-/istanbul-lib-source-maps-1.1.0.tgz";
        sha1 = "9d429218f35b823560ea300a96ff0c3bbdab785f";
      };
    }

    {
      name = "istanbul-reports-1.0.1.tgz";
      path = fetchurl {
        name = "istanbul-reports-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-1.0.1.tgz";
        sha1 = "9a17176bc4a6cbebdae52b2f15961d52fa623fbc";
      };
    }

    {
      name = "istanbul-0.4.5.tgz";
      path = fetchurl {
        name = "istanbul-0.4.5.tgz";
        url  = "https://registry.yarnpkg.com/istanbul/-/istanbul-0.4.5.tgz";
        sha1 = "65c7d73d4c4da84d4f3ac310b918fb0b8033733b";
      };
    }

    {
      name = "jasmine-core-2.5.2.tgz";
      path = fetchurl {
        name = "jasmine-core-2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/jasmine-core/-/jasmine-core-2.5.2.tgz";
        sha1 = "6f61bd79061e27f43e6f9355e44b3c6cab6ff297";
      };
    }

    {
      name = "jasmine-jquery-2.1.1.tgz";
      path = fetchurl {
        name = "jasmine-jquery-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/jasmine-jquery/-/jasmine-jquery-2.1.1.tgz";
        sha1 = "d4095e646944a26763235769ab018d9f30f0d47b";
      };
    }

    {
      name = "jed-1.1.1.tgz";
      path = fetchurl {
        name = "jed-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/jed/-/jed-1.1.1.tgz";
        sha1 = "7a549bbd9ffe1585b0cd0a191e203055bee574b4";
      };
    }

    {
      name = "jodid25519-1.0.2.tgz";
      path = fetchurl {
        name = "jodid25519-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/jodid25519/-/jodid25519-1.0.2.tgz";
        sha1 = "06d4912255093419477d425633606e0e90782967";
      };
    }

    {
      name = "jquery-ujs-1.2.1.tgz";
      path = fetchurl {
        name = "jquery-ujs-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/jquery-ujs/-/jquery-ujs-1.2.1.tgz";
        sha1 = "6ee75b1ef4e9ac95e7124f8d71f7d351f5548e92";
      };
    }

    {
      name = "jquery-2.2.1.tgz";
      path = fetchurl {
        name = "jquery-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/jquery/-/jquery-2.2.1.tgz";
        sha1 = "3c3e16854ad3d2ac44ac65021b17426d22ad803f";
      };
    }

    {
      name = "js-base64-2.1.9.tgz";
      path = fetchurl {
        name = "js-base64-2.1.9.tgz";
        url  = "https://registry.yarnpkg.com/js-base64/-/js-base64-2.1.9.tgz";
        sha1 = "f0e80ae039a4bd654b5f281fc93f04a914a7fcce";
      };
    }

    {
      name = "js-beautify-1.6.12.tgz";
      path = fetchurl {
        name = "js-beautify-1.6.12.tgz";
        url  = "https://registry.yarnpkg.com/js-beautify/-/js-beautify-1.6.12.tgz";
        sha1 = "78b75933505d376da6e5a28e9b7887e0094db8b5";
      };
    }

    {
      name = "js-cookie-2.1.3.tgz";
      path = fetchurl {
        name = "js-cookie-2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/js-cookie/-/js-cookie-2.1.3.tgz";
        sha1 = "48071625217ac9ecfab8c343a13d42ec09ff0526";
      };
    }

    {
      name = "js-tokens-3.0.1.tgz";
      path = fetchurl {
        name = "js-tokens-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/js-tokens/-/js-tokens-3.0.1.tgz";
        sha1 = "08e9f132484a2c45a30907e9dc4d5567b7f114d7";
      };
    }

    {
      name = "js-yaml-3.8.1.tgz";
      path = fetchurl {
        name = "js-yaml-3.8.1.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.8.1.tgz";
        sha1 = "782ba50200be7b9e5a8537001b7804db3ad02628";
      };
    }

    {
      name = "js-yaml-3.7.0.tgz";
      path = fetchurl {
        name = "js-yaml-3.7.0.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.7.0.tgz";
        sha1 = "5c967ddd837a9bfdca5f2de84253abe8a1c03b80";
      };
    }

    {
      name = "jsbn-0.1.0.tgz";
      path = fetchurl {
        name = "jsbn-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.0.tgz";
        sha1 = "650987da0dd74f4ebf5a11377a2aa2d273e97dfd";
      };
    }

    {
      name = "jsesc-1.3.0.tgz";
      path = fetchurl {
        name = "jsesc-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-1.3.0.tgz";
        sha1 = "46c3fec8c1892b12b0833db9bc7622176dbab34b";
      };
    }

    {
      name = "jsesc-0.5.0.tgz";
      path = fetchurl {
        name = "jsesc-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz";
        sha1 = "e7dee66e35d6fc16f710fe91d5cf69f70f08911d";
      };
    }

    {
      name = "json-loader-0.5.4.tgz";
      path = fetchurl {
        name = "json-loader-0.5.4.tgz";
        url  = "https://registry.yarnpkg.com/json-loader/-/json-loader-0.5.4.tgz";
        sha1 = "8baa1365a632f58a3c46d20175fc6002c96e37de";
      };
    }

    {
      name = "json-schema-0.2.3.tgz";
      path = fetchurl {
        name = "json-schema-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/json-schema/-/json-schema-0.2.3.tgz";
        sha1 = "b480c892e59a2f05954ce727bd3f2a4e882f9e13";
      };
    }

    {
      name = "json-stable-stringify-1.0.1.tgz";
      path = fetchurl {
        name = "json-stable-stringify-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stable-stringify/-/json-stable-stringify-1.0.1.tgz";
        sha1 = "9a759d39c5f2ff503fd5300646ed445f88c4f9af";
      };
    }

    {
      name = "json-stringify-safe-5.0.1.tgz";
      path = fetchurl {
        name = "json-stringify-safe-5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    }

    {
      name = "json3-3.3.2.tgz";
      path = fetchurl {
        name = "json3-3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/json3/-/json3-3.3.2.tgz";
        sha1 = "3c0434743df93e2f5c42aee7b19bcb483575f4e1";
      };
    }

    {
      name = "json5-0.5.1.tgz";
      path = fetchurl {
        name = "json5-0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-0.5.1.tgz";
        sha1 = "1eade7acc012034ad84e2396767ead9fa5495821";
      };
    }

    {
      name = "jsonfile-2.4.0.tgz";
      path = fetchurl {
        name = "jsonfile-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-2.4.0.tgz";
        sha1 = "3736a2b428b87bbda0cc83b53fa3d633a35c2ae8";
      };
    }

    {
      name = "jsonify-0.0.0.tgz";
      path = fetchurl {
        name = "jsonify-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonify/-/jsonify-0.0.0.tgz";
        sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
      };
    }

    {
      name = "jsonpointer-4.0.1.tgz";
      path = fetchurl {
        name = "jsonpointer-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/jsonpointer/-/jsonpointer-4.0.1.tgz";
        sha1 = "4fd92cb34e0e9db3c89c8622ecf51f9b978c6cb9";
      };
    }

    {
      name = "jsprim-1.3.1.tgz";
      path = fetchurl {
        name = "jsprim-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/jsprim/-/jsprim-1.3.1.tgz";
        sha1 = "2a7256f70412a29ee3670aaca625994c4dcff252";
      };
    }

    {
      name = "jszip-utils-0.0.2.tgz";
      path = fetchurl {
        name = "jszip-utils-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/jszip-utils/-/jszip-utils-0.0.2.tgz";
        sha1 = "457d5cbca60a1c2e0706e9da2b544e8e7bc50bf8";
      };
    }

    {
      name = "jszip-3.1.3.tgz";
      path = fetchurl {
        name = "jszip-3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/jszip/-/jszip-3.1.3.tgz";
        sha1 = "8a920403b2b1651c0fc126be90192d9080957c37";
      };
    }

    {
      name = "karma-coverage-istanbul-reporter-0.2.0.tgz";
      path = fetchurl {
        name = "karma-coverage-istanbul-reporter-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/karma-coverage-istanbul-reporter/-/karma-coverage-istanbul-reporter-0.2.0.tgz";
        sha1 = "5766263338adeb0026f7e4ac7a89a5f056c5642c";
      };
    }

    {
      name = "karma-jasmine-1.1.0.tgz";
      path = fetchurl {
        name = "karma-jasmine-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/karma-jasmine/-/karma-jasmine-1.1.0.tgz";
        sha1 = "22e4c06bf9a182e5294d1f705e3733811b810acf";
      };
    }

    {
      name = "karma-mocha-reporter-2.2.2.tgz";
      path = fetchurl {
        name = "karma-mocha-reporter-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/karma-mocha-reporter/-/karma-mocha-reporter-2.2.2.tgz";
        sha1 = "876de9a287244e54a608591732a98e66611f6abe";
      };
    }

    {
      name = "karma-phantomjs-launcher-1.0.2.tgz";
      path = fetchurl {
        name = "karma-phantomjs-launcher-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/karma-phantomjs-launcher/-/karma-phantomjs-launcher-1.0.2.tgz";
        sha1 = "19e1041498fd75563ed86730a22c1fe579fa8fb1";
      };
    }

    {
      name = "karma-sourcemap-loader-0.3.7.tgz";
      path = fetchurl {
        name = "karma-sourcemap-loader-0.3.7.tgz";
        url  = "https://registry.yarnpkg.com/karma-sourcemap-loader/-/karma-sourcemap-loader-0.3.7.tgz";
        sha1 = "91322c77f8f13d46fed062b042e1009d4c4505d8";
      };
    }

    {
      name = "karma-webpack-2.0.2.tgz";
      path = fetchurl {
        name = "karma-webpack-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/karma-webpack/-/karma-webpack-2.0.2.tgz";
        sha1 = "bd38350af5645c9644090770939ebe7ce726f864";
      };
    }

    {
      name = "karma-1.4.1.tgz";
      path = fetchurl {
        name = "karma-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/karma/-/karma-1.4.1.tgz";
        sha1 = "41981a71d54237606b0a3ea8c58c90773f41650e";
      };
    }

    {
      name = "kew-0.7.0.tgz";
      path = fetchurl {
        name = "kew-0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/kew/-/kew-0.7.0.tgz";
        sha1 = "79d93d2d33363d6fdd2970b335d9141ad591d79b";
      };
    }

    {
      name = "kind-of-3.1.0.tgz";
      path = fetchurl {
        name = "kind-of-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-3.1.0.tgz";
        sha1 = "475d698a5e49ff5e53d14e3e732429dc8bf4cf47";
      };
    }

    {
      name = "klaw-1.3.1.tgz";
      path = fetchurl {
        name = "klaw-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/klaw/-/klaw-1.3.1.tgz";
        sha1 = "4088433b46b3b1ba259d78785d8e96f73ba02439";
      };
    }

    {
      name = "latest-version-1.0.1.tgz";
      path = fetchurl {
        name = "latest-version-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/latest-version/-/latest-version-1.0.1.tgz";
        sha1 = "72cfc46e3e8d1be651e1ebb54ea9f6ea96f374bb";
      };
    }

    {
      name = "lazy-cache-1.0.4.tgz";
      path = fetchurl {
        name = "lazy-cache-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/lazy-cache/-/lazy-cache-1.0.4.tgz";
        sha1 = "a1d78fc3a50474cb80845d3b3b6e1da49a446e8e";
      };
    }

    {
      name = "lcid-1.0.0.tgz";
      path = fetchurl {
        name = "lcid-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lcid/-/lcid-1.0.0.tgz";
        sha1 = "308accafa0bc483a3867b4b6f2b9506251d1b835";
      };
    }

    {
      name = "levn-0.3.0.tgz";
      path = fetchurl {
        name = "levn-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz";
        sha1 = "3b09924edf9f083c0490fdd4c0bc4421e04764ee";
      };
    }

    {
      name = "lie-3.1.1.tgz";
      path = fetchurl {
        name = "lie-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lie/-/lie-3.1.1.tgz";
        sha1 = "9a436b2cc7746ca59de7a41fa469b3efb76bd87e";
      };
    }

    {
      name = "load-json-file-1.1.0.tgz";
      path = fetchurl {
        name = "load-json-file-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/load-json-file/-/load-json-file-1.1.0.tgz";
        sha1 = "956905708d58b4bab4c2261b04f59f31c99374c0";
      };
    }

    {
      name = "loader-runner-2.3.0.tgz";
      path = fetchurl {
        name = "loader-runner-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/loader-runner/-/loader-runner-2.3.0.tgz";
        sha1 = "f482aea82d543e07921700d5a46ef26fdac6b8a2";
      };
    }

    {
      name = "loader-utils-0.2.16.tgz";
      path = fetchurl {
        name = "loader-utils-0.2.16.tgz";
        url  = "https://registry.yarnpkg.com/loader-utils/-/loader-utils-0.2.16.tgz";
        sha1 = "f08632066ed8282835dff88dfb52704765adee6d";
      };
    }

    {
      name = "loader-utils-1.1.0.tgz";
      path = fetchurl {
        name = "loader-utils-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.1.0.tgz";
        sha1 = "c98aef488bcceda2ffb5e2de646d6a754429f5cd";
      };
    }

    {
      name = "locate-path-2.0.0.tgz";
      path = fetchurl {
        name = "locate-path-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz";
        sha1 = "2b568b265eec944c6d9c0de9c3dbbbca0354cd8e";
      };
    }

    {
      name = "lodash._baseassign-3.2.0.tgz";
      path = fetchurl {
        name = "lodash._baseassign-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._baseassign/-/lodash._baseassign-3.2.0.tgz";
        sha1 = "8c38a099500f215ad09e59f1722fd0c52bfe0a4e";
      };
    }

    {
      name = "lodash._basecopy-3.0.1.tgz";
      path = fetchurl {
        name = "lodash._basecopy-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basecopy/-/lodash._basecopy-3.0.1.tgz";
        sha1 = "8da0e6a876cf344c0ad8a54882111dd3c5c7ca36";
      };
    }

    {
      name = "lodash._baseget-3.7.2.tgz";
      path = fetchurl {
        name = "lodash._baseget-3.7.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash._baseget/-/lodash._baseget-3.7.2.tgz";
        sha1 = "1b6ae1d5facf3c25532350a13c1197cb8bb674f4";
      };
    }

    {
      name = "lodash._bindcallback-3.0.1.tgz";
      path = fetchurl {
        name = "lodash._bindcallback-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._bindcallback/-/lodash._bindcallback-3.0.1.tgz";
        sha1 = "e531c27644cf8b57a99e17ed95b35c748789392e";
      };
    }

    {
      name = "lodash._createassigner-3.1.1.tgz";
      path = fetchurl {
        name = "lodash._createassigner-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._createassigner/-/lodash._createassigner-3.1.1.tgz";
        sha1 = "838a5bae2fdaca63ac22dee8e19fa4e6d6970b11";
      };
    }

    {
      name = "lodash._getnative-3.9.1.tgz";
      path = fetchurl {
        name = "lodash._getnative-3.9.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._getnative/-/lodash._getnative-3.9.1.tgz";
        sha1 = "570bc7dede46d61cdcde687d65d3eecbaa3aaff5";
      };
    }

    {
      name = "lodash._isiterateecall-3.0.9.tgz";
      path = fetchurl {
        name = "lodash._isiterateecall-3.0.9.tgz";
        url  = "https://registry.yarnpkg.com/lodash._isiterateecall/-/lodash._isiterateecall-3.0.9.tgz";
        sha1 = "5203ad7ba425fae842460e696db9cf3e6aac057c";
      };
    }

    {
      name = "lodash._topath-3.8.1.tgz";
      path = fetchurl {
        name = "lodash._topath-3.8.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._topath/-/lodash._topath-3.8.1.tgz";
        sha1 = "3ec5e2606014f4cb97f755fe6914edd8bfc00eac";
      };
    }

    {
      name = "lodash.assign-3.2.0.tgz";
      path = fetchurl {
        name = "lodash.assign-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.assign/-/lodash.assign-3.2.0.tgz";
        sha1 = "3ce9f0234b4b2223e296b8fa0ac1fee8ebca64fa";
      };
    }

    {
      name = "lodash.camelcase-4.1.1.tgz";
      path = fetchurl {
        name = "lodash.camelcase-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.camelcase/-/lodash.camelcase-4.1.1.tgz";
        sha1 = "065b3ff08f0b7662f389934c46a5504c90e0b2d8";
      };
    }

    {
      name = "lodash.camelcase-4.3.0.tgz";
      path = fetchurl {
        name = "lodash.camelcase-4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.camelcase/-/lodash.camelcase-4.3.0.tgz";
        sha1 = "b28aa6288a2b9fc651035c7711f65ab6190331a6";
      };
    }

    {
      name = "lodash.capitalize-4.2.1.tgz";
      path = fetchurl {
        name = "lodash.capitalize-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.capitalize/-/lodash.capitalize-4.2.1.tgz";
        sha1 = "f826c9b4e2a8511d84e3aca29db05e1a4f3b72a9";
      };
    }

    {
      name = "lodash.cond-4.5.2.tgz";
      path = fetchurl {
        name = "lodash.cond-4.5.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.cond/-/lodash.cond-4.5.2.tgz";
        sha1 = "f471a1da486be60f6ab955d17115523dd1d255d5";
      };
    }

    {
      name = "lodash.deburr-4.1.0.tgz";
      path = fetchurl {
        name = "lodash.deburr-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.deburr/-/lodash.deburr-4.1.0.tgz";
        sha1 = "ddb1bbb3ef07458c0177ba07de14422cb033ff9b";
      };
    }

    {
      name = "lodash.defaults-3.1.2.tgz";
      path = fetchurl {
        name = "lodash.defaults-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.defaults/-/lodash.defaults-3.1.2.tgz";
        sha1 = "c7308b18dbf8bc9372d701a73493c61192bd2e2c";
      };
    }

    {
      name = "lodash.get-4.4.2.tgz";
      path = fetchurl {
        name = "lodash.get-4.4.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz";
        sha1 = "2d177f652fa31e939b4438d5341499dfa3825e99";
      };
    }

    {
      name = "lodash.get-3.7.0.tgz";
      path = fetchurl {
        name = "lodash.get-3.7.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.get/-/lodash.get-3.7.0.tgz";
        sha1 = "3ce68ae2c91683b281cc5394128303cbf75e691f";
      };
    }

    {
      name = "lodash.isarguments-3.1.0.tgz";
      path = fetchurl {
        name = "lodash.isarguments-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isarguments/-/lodash.isarguments-3.1.0.tgz";
        sha1 = "2f573d85c6a24289ff00663b491c1d338ff3458a";
      };
    }

    {
      name = "lodash.isarray-3.0.4.tgz";
      path = fetchurl {
        name = "lodash.isarray-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isarray/-/lodash.isarray-3.0.4.tgz";
        sha1 = "79e4eb88c36a8122af86f844aa9bcd851b5fbb55";
      };
    }

    {
      name = "lodash.kebabcase-4.0.1.tgz";
      path = fetchurl {
        name = "lodash.kebabcase-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.kebabcase/-/lodash.kebabcase-4.0.1.tgz";
        sha1 = "5e63bc9aa2a5562ff3b97ca7af2f803de1bcb90e";
      };
    }

    {
      name = "lodash.keys-3.1.2.tgz";
      path = fetchurl {
        name = "lodash.keys-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.keys/-/lodash.keys-3.1.2.tgz";
        sha1 = "4dbc0472b156be50a0b286855d1bd0b0c656098a";
      };
    }

    {
      name = "lodash.memoize-4.1.2.tgz";
      path = fetchurl {
        name = "lodash.memoize-4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.memoize/-/lodash.memoize-4.1.2.tgz";
        sha1 = "bcc6c49a42a2840ed997f323eada5ecd182e0bfe";
      };
    }

    {
      name = "lodash.restparam-3.6.1.tgz";
      path = fetchurl {
        name = "lodash.restparam-3.6.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.restparam/-/lodash.restparam-3.6.1.tgz";
        sha1 = "936a4e309ef330a7645ed4145986c85ae5b20805";
      };
    }

    {
      name = "lodash.snakecase-4.0.1.tgz";
      path = fetchurl {
        name = "lodash.snakecase-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.snakecase/-/lodash.snakecase-4.0.1.tgz";
        sha1 = "bd012e5d2f93f7b58b9303e9a7fbfd5db13d6281";
      };
    }

    {
      name = "lodash.uniq-4.5.0.tgz";
      path = fetchurl {
        name = "lodash.uniq-4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.uniq/-/lodash.uniq-4.5.0.tgz";
        sha1 = "d0225373aeb652adc1bc82e4945339a842754773";
      };
    }

    {
      name = "lodash.words-4.2.0.tgz";
      path = fetchurl {
        name = "lodash.words-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.words/-/lodash.words-4.2.0.tgz";
        sha1 = "5ecfeaf8ecf8acaa8e0c8386295f1993c9cf4036";
      };
    }

    {
      name = "lodash-3.10.1.tgz";
      path = fetchurl {
        name = "lodash-3.10.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-3.10.1.tgz";
        sha1 = "5bf45e8e49ba4189e17d482789dfd15bd140b7b6";
      };
    }

    {
      name = "lodash-4.17.4.tgz";
      path = fetchurl {
        name = "lodash-4.17.4.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.4.tgz";
        sha1 = "78203a4d1c328ae1d86dca6460e369b57f4055ae";
      };
    }

    {
      name = "log4js-0.6.38.tgz";
      path = fetchurl {
        name = "log4js-0.6.38.tgz";
        url  = "https://registry.yarnpkg.com/log4js/-/log4js-0.6.38.tgz";
        sha1 = "2c494116695d6fb25480943d3fc872e662a522fd";
      };
    }

    {
      name = "longest-1.0.1.tgz";
      path = fetchurl {
        name = "longest-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/longest/-/longest-1.0.1.tgz";
        sha1 = "30a0b2da38f73770e8294a0d22e6625ed77d0097";
      };
    }

    {
      name = "loose-envify-1.3.1.tgz";
      path = fetchurl {
        name = "loose-envify-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.3.1.tgz";
        sha1 = "d1a8ad33fa9ce0e713d65fdd0ac8b748d478c848";
      };
    }

    {
      name = "lowercase-keys-1.0.0.tgz";
      path = fetchurl {
        name = "lowercase-keys-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.0.tgz";
        sha1 = "4e3366b39e7f5457e35f1324bdf6f88d0bfc7306";
      };
    }

    {
      name = "lru-cache-2.2.4.tgz";
      path = fetchurl {
        name = "lru-cache-2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-2.2.4.tgz";
        sha1 = "6c658619becf14031d0d0b594b16042ce4dc063d";
      };
    }

    {
      name = "lru-cache-3.2.0.tgz";
      path = fetchurl {
        name = "lru-cache-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-3.2.0.tgz";
        sha1 = "71789b3b7f5399bec8565dda38aa30d2a097efee";
      };
    }

    {
      name = "lru-cache-4.0.2.tgz";
      path = fetchurl {
        name = "lru-cache-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.0.2.tgz";
        sha1 = "1d17679c069cda5d040991a09dbc2c0db377e55e";
      };
    }

    {
      name = "macaddress-0.2.8.tgz";
      path = fetchurl {
        name = "macaddress-0.2.8.tgz";
        url  = "https://registry.yarnpkg.com/macaddress/-/macaddress-0.2.8.tgz";
        sha1 = "5904dc537c39ec6dbefeae902327135fa8511f12";
      };
    }

    {
      name = "map-stream-0.1.0.tgz";
      path = fetchurl {
        name = "map-stream-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/map-stream/-/map-stream-0.1.0.tgz";
        sha1 = "e56aa94c4c8055a16404a0674b78f215f7c8e194";
      };
    }

    {
      name = "marked-0.3.6.tgz";
      path = fetchurl {
        name = "marked-0.3.6.tgz";
        url  = "https://registry.yarnpkg.com/marked/-/marked-0.3.6.tgz";
        sha1 = "b2c6c618fccece4ef86c4fc6cb8a7cbf5aeda8d7";
      };
    }

    {
      name = "math-expression-evaluator-1.2.16.tgz";
      path = fetchurl {
        name = "math-expression-evaluator-1.2.16.tgz";
        url  = "https://registry.yarnpkg.com/math-expression-evaluator/-/math-expression-evaluator-1.2.16.tgz";
        sha1 = "b357fa1ca9faefb8e48d10c14ef2bcb2d9f0a7c9";
      };
    }

    {
      name = "media-typer-0.3.0.tgz";
      path = fetchurl {
        name = "media-typer-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz";
        sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
      };
    }

    {
      name = "memory-fs-0.2.0.tgz";
      path = fetchurl {
        name = "memory-fs-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.2.0.tgz";
        sha1 = "f2bb25368bc121e391c2520de92969caee0a0290";
      };
    }

    {
      name = "memory-fs-0.4.1.tgz";
      path = fetchurl {
        name = "memory-fs-0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.4.1.tgz";
        sha1 = "3a9a20b8462523e447cfbc7e8bb80ed667bfc552";
      };
    }

    {
      name = "merge-descriptors-1.0.1.tgz";
      path = fetchurl {
        name = "merge-descriptors-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/merge-descriptors/-/merge-descriptors-1.0.1.tgz";
        sha1 = "b00aaa556dd8b44568150ec9d1b953f3f90cbb61";
      };
    }

    {
      name = "methods-1.1.2.tgz";
      path = fetchurl {
        name = "methods-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/methods/-/methods-1.1.2.tgz";
        sha1 = "5529a4d67654134edcc5266656835b0f851afcee";
      };
    }

    {
      name = "micromatch-2.3.11.tgz";
      path = fetchurl {
        name = "micromatch-2.3.11.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-2.3.11.tgz";
        sha1 = "86677c97d1720b363431d04d0d15293bd38c1565";
      };
    }

    {
      name = "miller-rabin-4.0.0.tgz";
      path = fetchurl {
        name = "miller-rabin-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/miller-rabin/-/miller-rabin-4.0.0.tgz";
        sha1 = "4a62fb1d42933c05583982f4c716f6fb9e6c6d3d";
      };
    }

    {
      name = "mime-db-1.26.0.tgz";
      path = fetchurl {
        name = "mime-db-1.26.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.26.0.tgz";
        sha1 = "eaffcd0e4fc6935cf8134da246e2e6c35305adff";
      };
    }

    {
      name = "mime-db-1.27.0.tgz";
      path = fetchurl {
        name = "mime-db-1.27.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.27.0.tgz";
        sha1 = "820f572296bbd20ec25ed55e5b5de869e5436eb1";
      };
    }

    {
      name = "mime-types-2.1.15.tgz";
      path = fetchurl {
        name = "mime-types-2.1.15.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.15.tgz";
        sha1 = "a4ebf5064094569237b8cf70046776d09fc92aed";
      };
    }

    {
      name = "mime-types-2.1.14.tgz";
      path = fetchurl {
        name = "mime-types-2.1.14.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.14.tgz";
        sha1 = "f7ef7d97583fcaf3b7d282b6f8b5679dab1e94ee";
      };
    }

    {
      name = "mime-1.3.4.tgz";
      path = fetchurl {
        name = "mime-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-1.3.4.tgz";
        sha1 = "115f9e3b6b3daf2959983cb38f149a2d40eb5d53";
      };
    }

    {
      name = "minimalistic-assert-1.0.0.tgz";
      path = fetchurl {
        name = "minimalistic-assert-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/minimalistic-assert/-/minimalistic-assert-1.0.0.tgz";
        sha1 = "702be2dda6b37f4836bcb3f5db56641b64a1d3d3";
      };
    }

    {
      name = "minimatch-3.0.3.tgz";
      path = fetchurl {
        name = "minimatch-3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.3.tgz";
        sha1 = "2a4e4090b96b2db06a9d7df01055a62a77c9b774";
      };
    }

    {
      name = "minimist-0.0.8.tgz";
      path = fetchurl {
        name = "minimist-0.0.8.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
    }

    {
      name = "minimist-1.2.0.tgz";
      path = fetchurl {
        name = "minimist-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.0.tgz";
        sha1 = "a35008b20f41383eec1fb914f4cd5df79a264284";
      };
    }

    {
      name = "mkdirp-0.5.0.tgz";
      path = fetchurl {
        name = "mkdirp-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.0.tgz";
        sha1 = "1d73076a6df986cd9344e15e71fcc05a4c9abf12";
      };
    }

    {
      name = "mkdirp-0.5.1.tgz";
      path = fetchurl {
        name = "mkdirp-0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
      };
    }

    {
      name = "moment-2.17.1.tgz";
      path = fetchurl {
        name = "moment-2.17.1.tgz";
        url  = "https://registry.yarnpkg.com/moment/-/moment-2.17.1.tgz";
        sha1 = "fed9506063f36b10f066c8b59a144d7faebe1d82";
      };
    }

    {
      name = "mousetrap-1.4.6.tgz";
      path = fetchurl {
        name = "mousetrap-1.4.6.tgz";
        url  = "https://registry.yarnpkg.com/mousetrap/-/mousetrap-1.4.6.tgz";
        sha1 = "eaca72e22e56d5b769b7555873b688c3332e390a";
      };
    }

    {
      name = "ms-0.7.1.tgz";
      path = fetchurl {
        name = "ms-0.7.1.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-0.7.1.tgz";
        sha1 = "9cd13c03adbff25b65effde7ce864ee952017098";
      };
    }

    {
      name = "ms-0.7.2.tgz";
      path = fetchurl {
        name = "ms-0.7.2.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-0.7.2.tgz";
        sha1 = "ae25cf2512b3885a1d95d7f037868d8431124765";
      };
    }

    {
      name = "ms-2.0.0.tgz";
      path = fetchurl {
        name = "ms-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    }

    {
      name = "mute-stream-0.0.5.tgz";
      path = fetchurl {
        name = "mute-stream-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.5.tgz";
        sha1 = "8fbfabb0a98a253d3184331f9e8deb7372fac6c0";
      };
    }

    {
      name = "name-all-modules-plugin-1.0.1.tgz";
      path = fetchurl {
        name = "name-all-modules-plugin-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/name-all-modules-plugin/-/name-all-modules-plugin-1.0.1.tgz";
        sha1 = "0abfb6ad835718b9fb4def0674e06657a954375c";
      };
    }

    {
      name = "nan-2.5.1.tgz";
      path = fetchurl {
        name = "nan-2.5.1.tgz";
        url  = "https://registry.yarnpkg.com/nan/-/nan-2.5.1.tgz";
        sha1 = "d5b01691253326a97a2bbee9e61c55d8d60351e2";
      };
    }

    {
      name = "natural-compare-1.4.0.tgz";
      path = fetchurl {
        name = "natural-compare-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz";
        sha1 = "4abebfeed7541f2c27acfb29bdbbd15c8d5ba4f7";
      };
    }

    {
      name = "negotiator-0.6.1.tgz";
      path = fetchurl {
        name = "negotiator-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.1.tgz";
        sha1 = "2b327184e8992101177b28563fb5e7102acd0ca9";
      };
    }

    {
      name = "nested-error-stacks-1.0.2.tgz";
      path = fetchurl {
        name = "nested-error-stacks-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/nested-error-stacks/-/nested-error-stacks-1.0.2.tgz";
        sha1 = "19f619591519f096769a5ba9a86e6eeec823c3cf";
      };
    }

    {
      name = "node-ensure-0.0.0.tgz";
      path = fetchurl {
        name = "node-ensure-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/node-ensure/-/node-ensure-0.0.0.tgz";
        sha1 = "ecae764150de99861ec5c810fd5d096b183932a7";
      };
    }

    {
      name = "node-libs-browser-1.1.1.tgz";
      path = fetchurl {
        name = "node-libs-browser-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/node-libs-browser/-/node-libs-browser-1.1.1.tgz";
        sha1 = "2a38243abedd7dffcd07a97c9aca5668975a6fea";
      };
    }

    {
      name = "node-libs-browser-2.0.0.tgz";
      path = fetchurl {
        name = "node-libs-browser-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/node-libs-browser/-/node-libs-browser-2.0.0.tgz";
        sha1 = "a3a59ec97024985b46e958379646f96c4b616646";
      };
    }

    {
      name = "node-pre-gyp-0.6.33.tgz";
      path = fetchurl {
        name = "node-pre-gyp-0.6.33.tgz";
        url  = "https://registry.yarnpkg.com/node-pre-gyp/-/node-pre-gyp-0.6.33.tgz";
        sha1 = "640ac55198f6a925972e0c16c4ac26a034d5ecc9";
      };
    }

    {
      name = "node-zopfli-2.0.2.tgz";
      path = fetchurl {
        name = "node-zopfli-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/node-zopfli/-/node-zopfli-2.0.2.tgz";
        sha1 = "a7a473ae92aaea85d4c68d45bbf2c944c46116b8";
      };
    }

    {
      name = "nodemon-1.11.0.tgz";
      path = fetchurl {
        name = "nodemon-1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/nodemon/-/nodemon-1.11.0.tgz";
        sha1 = "226c562bd2a7b13d3d7518b49ad4828a3623d06c";
      };
    }

    {
      name = "nopt-3.0.6.tgz";
      path = fetchurl {
        name = "nopt-3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/nopt/-/nopt-3.0.6.tgz";
        sha1 = "c6465dbf08abcd4db359317f79ac68a646b28ff9";
      };
    }

    {
      name = "nopt-1.0.10.tgz";
      path = fetchurl {
        name = "nopt-1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/nopt/-/nopt-1.0.10.tgz";
        sha1 = "6ddd21bd2a31417b92727dd585f8a6f37608ebee";
      };
    }

    {
      name = "normalize-package-data-2.3.5.tgz";
      path = fetchurl {
        name = "normalize-package-data-2.3.5.tgz";
        url  = "https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.3.5.tgz";
        sha1 = "8d924f142960e1777e7ffe170543631cc7cb02df";
      };
    }

    {
      name = "normalize-path-2.0.1.tgz";
      path = fetchurl {
        name = "normalize-path-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.0.1.tgz";
        sha1 = "47886ac1662760d4261b7d979d241709d3ce3f7a";
      };
    }

    {
      name = "normalize-range-0.1.2.tgz";
      path = fetchurl {
        name = "normalize-range-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/normalize-range/-/normalize-range-0.1.2.tgz";
        sha1 = "2d10c06bdfd312ea9777695a4d28439456b75942";
      };
    }

    {
      name = "normalize-url-1.9.1.tgz";
      path = fetchurl {
        name = "normalize-url-1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/normalize-url/-/normalize-url-1.9.1.tgz";
        sha1 = "2cc0d66b31ea23036458436e3620d85954c66c3c";
      };
    }

    {
      name = "npmlog-4.0.2.tgz";
      path = fetchurl {
        name = "npmlog-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/npmlog/-/npmlog-4.0.2.tgz";
        sha1 = "d03950e0e78ce1527ba26d2a7592e9348ac3e75f";
      };
    }

    {
      name = "num2fraction-1.2.2.tgz";
      path = fetchurl {
        name = "num2fraction-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/num2fraction/-/num2fraction-1.2.2.tgz";
        sha1 = "6f682b6a027a4e9ddfa4564cd2589d1d4e669ede";
      };
    }

    {
      name = "number-is-nan-1.0.1.tgz";
      path = fetchurl {
        name = "number-is-nan-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz";
        sha1 = "097b602b53422a522c1afb8790318336941a011d";
      };
    }

    {
      name = "oauth-sign-0.8.2.tgz";
      path = fetchurl {
        name = "oauth-sign-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.8.2.tgz";
        sha1 = "46a6ab7f0aead8deae9ec0565780b7d4efeb9d43";
      };
    }

    {
      name = "object-assign-4.1.0.tgz";
      path = fetchurl {
        name = "object-assign-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.0.tgz";
        sha1 = "7a3b3d0e98063d43f4c03f2e8ae6cd51a86883a0";
      };
    }

    {
      name = "object-assign-3.0.0.tgz";
      path = fetchurl {
        name = "object-assign-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-3.0.0.tgz";
        sha1 = "9bedd5ca0897949bca47e7ff408062d549f587f2";
      };
    }

    {
      name = "object-assign-4.1.1.tgz";
      path = fetchurl {
        name = "object-assign-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz";
        sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
      };
    }

    {
      name = "object-component-0.0.3.tgz";
      path = fetchurl {
        name = "object-component-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/object-component/-/object-component-0.0.3.tgz";
        sha1 = "f0c69aa50efc95b866c186f400a33769cb2f1291";
      };
    }

    {
      name = "object.omit-2.0.1.tgz";
      path = fetchurl {
        name = "object.omit-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/object.omit/-/object.omit-2.0.1.tgz";
        sha1 = "1a9c744829f39dbb858c76ca3579ae2a54ebd1fa";
      };
    }

    {
      name = "obuf-1.1.1.tgz";
      path = fetchurl {
        name = "obuf-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/obuf/-/obuf-1.1.1.tgz";
        sha1 = "104124b6c602c6796881a042541d36db43a5264e";
      };
    }

    {
      name = "on-finished-2.3.0.tgz";
      path = fetchurl {
        name = "on-finished-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/on-finished/-/on-finished-2.3.0.tgz";
        sha1 = "20f1336481b083cd75337992a16971aa2d906947";
      };
    }

    {
      name = "on-headers-1.0.1.tgz";
      path = fetchurl {
        name = "on-headers-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/on-headers/-/on-headers-1.0.1.tgz";
        sha1 = "928f5d0f470d49342651ea6794b0857c100693f7";
      };
    }

    {
      name = "once-1.4.0.tgz";
      path = fetchurl {
        name = "once-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    }

    {
      name = "once-1.3.3.tgz";
      path = fetchurl {
        name = "once-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.3.3.tgz";
        sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
      };
    }

    {
      name = "onetime-1.1.0.tgz";
      path = fetchurl {
        name = "onetime-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/onetime/-/onetime-1.1.0.tgz";
        sha1 = "a1f7838f8314c516f05ecefcbc4ccfe04b4ed789";
      };
    }

    {
      name = "opener-1.4.3.tgz";
      path = fetchurl {
        name = "opener-1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/opener/-/opener-1.4.3.tgz";
        sha1 = "5c6da2c5d7e5831e8ffa3964950f8d6674ac90b8";
      };
    }

    {
      name = "opn-4.0.2.tgz";
      path = fetchurl {
        name = "opn-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/opn/-/opn-4.0.2.tgz";
        sha1 = "7abc22e644dff63b0a96d5ab7f2790c0f01abc95";
      };
    }

    {
      name = "optimist-0.6.1.tgz";
      path = fetchurl {
        name = "optimist-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/optimist/-/optimist-0.6.1.tgz";
        sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
      };
    }

    {
      name = "optionator-0.8.2.tgz";
      path = fetchurl {
        name = "optionator-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/optionator/-/optionator-0.8.2.tgz";
        sha1 = "364c5e409d3f4d6301d6c0b4c05bba50180aeb64";
      };
    }

    {
      name = "options-0.0.6.tgz";
      path = fetchurl {
        name = "options-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/options/-/options-0.0.6.tgz";
        sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
      };
    }

    {
      name = "original-1.0.0.tgz";
      path = fetchurl {
        name = "original-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/original/-/original-1.0.0.tgz";
        sha1 = "9147f93fa1696d04be61e01bd50baeaca656bd3b";
      };
    }

    {
      name = "os-browserify-0.2.1.tgz";
      path = fetchurl {
        name = "os-browserify-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/os-browserify/-/os-browserify-0.2.1.tgz";
        sha1 = "63fc4ccee5d2d7763d26bbf8601078e6c2e0044f";
      };
    }

    {
      name = "os-homedir-1.0.2.tgz";
      path = fetchurl {
        name = "os-homedir-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz";
        sha1 = "ffbc4988336e0e833de0c168c7ef152121aa7fb3";
      };
    }

    {
      name = "os-locale-1.4.0.tgz";
      path = fetchurl {
        name = "os-locale-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/os-locale/-/os-locale-1.4.0.tgz";
        sha1 = "20f9f17ae29ed345e8bde583b13d2009803c14d9";
      };
    }

    {
      name = "os-tmpdir-1.0.2.tgz";
      path = fetchurl {
        name = "os-tmpdir-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz";
        sha1 = "bbe67406c79aa85c5cfec766fe5734555dfa1274";
      };
    }

    {
      name = "osenv-0.1.4.tgz";
      path = fetchurl {
        name = "osenv-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/osenv/-/osenv-0.1.4.tgz";
        sha1 = "42fe6d5953df06c8064be6f176c3d05aaaa34644";
      };
    }

    {
      name = "p-limit-1.1.0.tgz";
      path = fetchurl {
        name = "p-limit-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-1.1.0.tgz";
        sha1 = "b07ff2d9a5d88bec806035895a2bab66a27988bc";
      };
    }

    {
      name = "p-locate-2.0.0.tgz";
      path = fetchurl {
        name = "p-locate-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz";
        sha1 = "20a0103b222a70c8fd39cc2e580680f3dde5ec43";
      };
    }

    {
      name = "package-json-1.2.0.tgz";
      path = fetchurl {
        name = "package-json-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/package-json/-/package-json-1.2.0.tgz";
        sha1 = "c8ecac094227cdf76a316874ed05e27cc939a0e0";
      };
    }

    {
      name = "pako-0.2.9.tgz";
      path = fetchurl {
        name = "pako-0.2.9.tgz";
        url  = "https://registry.yarnpkg.com/pako/-/pako-0.2.9.tgz";
        sha1 = "f3f7522f4ef782348da8161bad9ecfd51bf83a75";
      };
    }

    {
      name = "pako-1.0.5.tgz";
      path = fetchurl {
        name = "pako-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/pako/-/pako-1.0.5.tgz";
        sha1 = "d2205dfe5b9da8af797e7c163db4d1f84e4600bc";
      };
    }

    {
      name = "parse-asn1-5.0.0.tgz";
      path = fetchurl {
        name = "parse-asn1-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-asn1/-/parse-asn1-5.0.0.tgz";
        sha1 = "35060f6d5015d37628c770f4e091a0b5a278bc23";
      };
    }

    {
      name = "parse-glob-3.0.4.tgz";
      path = fetchurl {
        name = "parse-glob-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/parse-glob/-/parse-glob-3.0.4.tgz";
        sha1 = "b2c376cfb11f35513badd173ef0bb6e3a388391c";
      };
    }

    {
      name = "parse-json-2.2.0.tgz";
      path = fetchurl {
        name = "parse-json-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz";
        sha1 = "f480f40434ef80741f8469099f8dea18f55a4dc9";
      };
    }

    {
      name = "parsejson-0.0.3.tgz";
      path = fetchurl {
        name = "parsejson-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/parsejson/-/parsejson-0.0.3.tgz";
        sha1 = "ab7e3759f209ece99437973f7d0f1f64ae0e64ab";
      };
    }

    {
      name = "parseqs-0.0.5.tgz";
      path = fetchurl {
        name = "parseqs-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/parseqs/-/parseqs-0.0.5.tgz";
        sha1 = "d5208a3738e46766e291ba2ea173684921a8b89d";
      };
    }

    {
      name = "parseuri-0.0.5.tgz";
      path = fetchurl {
        name = "parseuri-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/parseuri/-/parseuri-0.0.5.tgz";
        sha1 = "80204a50d4dbb779bfdc6ebe2778d90e4bce320a";
      };
    }

    {
      name = "parseurl-1.3.1.tgz";
      path = fetchurl {
        name = "parseurl-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.1.tgz";
        sha1 = "c8ab8c9223ba34888aa64a297b28853bec18da56";
      };
    }

    {
      name = "path-browserify-0.0.0.tgz";
      path = fetchurl {
        name = "path-browserify-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-browserify/-/path-browserify-0.0.0.tgz";
        sha1 = "a0b870729aae214005b7d5032ec2cbbb0fb4451a";
      };
    }

    {
      name = "path-exists-2.1.0.tgz";
      path = fetchurl {
        name = "path-exists-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-2.1.0.tgz";
        sha1 = "0feb6c64f0fc518d9a754dd5efb62c7022761f4b";
      };
    }

    {
      name = "path-exists-3.0.0.tgz";
      path = fetchurl {
        name = "path-exists-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz";
        sha1 = "ce0ebeaa5f78cb18925ea7d810d7b59b010fd515";
      };
    }

    {
      name = "path-is-absolute-1.0.1.tgz";
      path = fetchurl {
        name = "path-is-absolute-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    }

    {
      name = "path-is-inside-1.0.2.tgz";
      path = fetchurl {
        name = "path-is-inside-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/path-is-inside/-/path-is-inside-1.0.2.tgz";
        sha1 = "365417dede44430d1c11af61027facf074bdfc53";
      };
    }

    {
      name = "path-parse-1.0.5.tgz";
      path = fetchurl {
        name = "path-parse-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.5.tgz";
        sha1 = "3c1adf871ea9cd6c9431b6ea2bd74a0ff055c4c1";
      };
    }

    {
      name = "path-to-regexp-0.1.7.tgz";
      path = fetchurl {
        name = "path-to-regexp-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-0.1.7.tgz";
        sha1 = "df604178005f522f15eb4490e7247a1bfaa67f8c";
      };
    }

    {
      name = "path-type-1.1.0.tgz";
      path = fetchurl {
        name = "path-type-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/path-type/-/path-type-1.1.0.tgz";
        sha1 = "59c44f7ee491da704da415da5a4070ba4f8fe441";
      };
    }

    {
      name = "pause-stream-0.0.11.tgz";
      path = fetchurl {
        name = "pause-stream-0.0.11.tgz";
        url  = "https://registry.yarnpkg.com/pause-stream/-/pause-stream-0.0.11.tgz";
        sha1 = "fe5a34b0cbce12b5aa6a2b403ee2e73b602f1445";
      };
    }

    {
      name = "pbkdf2-3.0.9.tgz";
      path = fetchurl {
        name = "pbkdf2-3.0.9.tgz";
        url  = "https://registry.yarnpkg.com/pbkdf2/-/pbkdf2-3.0.9.tgz";
        sha1 = "f2c4b25a600058b3c3773c086c37dbbee1ffe693";
      };
    }

    {
      name = "pdfjs-dist-1.8.252.tgz";
      path = fetchurl {
        name = "pdfjs-dist-1.8.252.tgz";
        url  = "https://registry.yarnpkg.com/pdfjs-dist/-/pdfjs-dist-1.8.252.tgz";
        sha1 = "2477245695341f7fe096824dacf327bc324c0f52";
      };
    }

    {
      name = "pend-1.2.0.tgz";
      path = fetchurl {
        name = "pend-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz";
        sha1 = "7a57eb550a6783f9115331fcf4663d5c8e007a50";
      };
    }

    {
      name = "phantomjs-prebuilt-2.1.14.tgz";
      path = fetchurl {
        name = "phantomjs-prebuilt-2.1.14.tgz";
        url  = "https://registry.yarnpkg.com/phantomjs-prebuilt/-/phantomjs-prebuilt-2.1.14.tgz";
        sha1 = "d53d311fcfb7d1d08ddb24014558f1188c516da0";
      };
    }

    {
      name = "pify-2.3.0.tgz";
      path = fetchurl {
        name = "pify-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz";
        sha1 = "ed141a6ac043a849ea588498e7dca8b15330e90c";
      };
    }

    {
      name = "pikaday-1.5.1.tgz";
      path = fetchurl {
        name = "pikaday-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/pikaday/-/pikaday-1.5.1.tgz";
        sha1 = "0a48549bc1a14ea1d08c44074d761bc2f2bfcfd3";
      };
    }

    {
      name = "pinkie-promise-2.0.1.tgz";
      path = fetchurl {
        name = "pinkie-promise-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz";
        sha1 = "2135d6dfa7a358c069ac9b178776288228450ffa";
      };
    }

    {
      name = "pinkie-2.0.4.tgz";
      path = fetchurl {
        name = "pinkie-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz";
        sha1 = "72556b80cfa0d48a974e80e77248e80ed4f7f870";
      };
    }

    {
      name = "pkg-dir-1.0.0.tgz";
      path = fetchurl {
        name = "pkg-dir-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-1.0.0.tgz";
        sha1 = "7a4b508a8d5bb2d629d447056ff4e9c9314cf3d4";
      };
    }

    {
      name = "pkg-up-1.0.0.tgz";
      path = fetchurl {
        name = "pkg-up-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-up/-/pkg-up-1.0.0.tgz";
        sha1 = "3e08fb461525c4421624a33b9f7e6d0af5b05a26";
      };
    }

    {
      name = "pluralize-1.2.1.tgz";
      path = fetchurl {
        name = "pluralize-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/pluralize/-/pluralize-1.2.1.tgz";
        sha1 = "d1a21483fd22bb41e58a12fa3421823140897c45";
      };
    }

    {
      name = "portfinder-1.0.13.tgz";
      path = fetchurl {
        name = "portfinder-1.0.13.tgz";
        url  = "https://registry.yarnpkg.com/portfinder/-/portfinder-1.0.13.tgz";
        sha1 = "bb32ecd87c27104ae6ee44b5a3ccbf0ebb1aede9";
      };
    }

    {
      name = "postcss-calc-5.3.1.tgz";
      path = fetchurl {
        name = "postcss-calc-5.3.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-calc/-/postcss-calc-5.3.1.tgz";
        sha1 = "77bae7ca928ad85716e2fda42f261bf7c1d65b5e";
      };
    }

    {
      name = "postcss-colormin-2.2.2.tgz";
      path = fetchurl {
        name = "postcss-colormin-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-colormin/-/postcss-colormin-2.2.2.tgz";
        sha1 = "6631417d5f0e909a3d7ec26b24c8a8d1e4f96e4b";
      };
    }

    {
      name = "postcss-convert-values-2.6.1.tgz";
      path = fetchurl {
        name = "postcss-convert-values-2.6.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-convert-values/-/postcss-convert-values-2.6.1.tgz";
        sha1 = "bbd8593c5c1fd2e3d1c322bb925dcae8dae4d62d";
      };
    }

    {
      name = "postcss-discard-comments-2.0.4.tgz";
      path = fetchurl {
        name = "postcss-discard-comments-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-comments/-/postcss-discard-comments-2.0.4.tgz";
        sha1 = "befe89fafd5b3dace5ccce51b76b81514be00e3d";
      };
    }

    {
      name = "postcss-discard-duplicates-2.1.0.tgz";
      path = fetchurl {
        name = "postcss-discard-duplicates-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-duplicates/-/postcss-discard-duplicates-2.1.0.tgz";
        sha1 = "b9abf27b88ac188158a5eb12abcae20263b91932";
      };
    }

    {
      name = "postcss-discard-empty-2.1.0.tgz";
      path = fetchurl {
        name = "postcss-discard-empty-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-empty/-/postcss-discard-empty-2.1.0.tgz";
        sha1 = "d2b4bd9d5ced5ebd8dcade7640c7d7cd7f4f92b5";
      };
    }

    {
      name = "postcss-discard-overridden-0.1.1.tgz";
      path = fetchurl {
        name = "postcss-discard-overridden-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-overridden/-/postcss-discard-overridden-0.1.1.tgz";
        sha1 = "8b1eaf554f686fb288cd874c55667b0aa3668d58";
      };
    }

    {
      name = "postcss-discard-unused-2.2.3.tgz";
      path = fetchurl {
        name = "postcss-discard-unused-2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-unused/-/postcss-discard-unused-2.2.3.tgz";
        sha1 = "bce30b2cc591ffc634322b5fb3464b6d934f4433";
      };
    }

    {
      name = "postcss-filter-plugins-2.0.2.tgz";
      path = fetchurl {
        name = "postcss-filter-plugins-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-filter-plugins/-/postcss-filter-plugins-2.0.2.tgz";
        sha1 = "6d85862534d735ac420e4a85806e1f5d4286d84c";
      };
    }

    {
      name = "postcss-load-config-1.2.0.tgz";
      path = fetchurl {
        name = "postcss-load-config-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-load-config/-/postcss-load-config-1.2.0.tgz";
        sha1 = "539e9afc9ddc8620121ebf9d8c3673e0ce50d28a";
      };
    }

    {
      name = "postcss-load-options-1.2.0.tgz";
      path = fetchurl {
        name = "postcss-load-options-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-load-options/-/postcss-load-options-1.2.0.tgz";
        sha1 = "b098b1559ddac2df04bc0bb375f99a5cfe2b6d8c";
      };
    }

    {
      name = "postcss-load-plugins-2.3.0.tgz";
      path = fetchurl {
        name = "postcss-load-plugins-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-load-plugins/-/postcss-load-plugins-2.3.0.tgz";
        sha1 = "745768116599aca2f009fad426b00175049d8d92";
      };
    }

    {
      name = "postcss-merge-idents-2.1.7.tgz";
      path = fetchurl {
        name = "postcss-merge-idents-2.1.7.tgz";
        url  = "https://registry.yarnpkg.com/postcss-merge-idents/-/postcss-merge-idents-2.1.7.tgz";
        sha1 = "4c5530313c08e1d5b3bbf3d2bbc747e278eea270";
      };
    }

    {
      name = "postcss-merge-longhand-2.0.2.tgz";
      path = fetchurl {
        name = "postcss-merge-longhand-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-merge-longhand/-/postcss-merge-longhand-2.0.2.tgz";
        sha1 = "23d90cd127b0a77994915332739034a1a4f3d658";
      };
    }

    {
      name = "postcss-merge-rules-2.1.2.tgz";
      path = fetchurl {
        name = "postcss-merge-rules-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-merge-rules/-/postcss-merge-rules-2.1.2.tgz";
        sha1 = "d1df5dfaa7b1acc3be553f0e9e10e87c61b5f721";
      };
    }

    {
      name = "postcss-message-helpers-2.0.0.tgz";
      path = fetchurl {
        name = "postcss-message-helpers-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-message-helpers/-/postcss-message-helpers-2.0.0.tgz";
        sha1 = "a4f2f4fab6e4fe002f0aed000478cdf52f9ba60e";
      };
    }

    {
      name = "postcss-minify-font-values-1.0.5.tgz";
      path = fetchurl {
        name = "postcss-minify-font-values-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-font-values/-/postcss-minify-font-values-1.0.5.tgz";
        sha1 = "4b58edb56641eba7c8474ab3526cafd7bbdecb69";
      };
    }

    {
      name = "postcss-minify-gradients-1.0.5.tgz";
      path = fetchurl {
        name = "postcss-minify-gradients-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-gradients/-/postcss-minify-gradients-1.0.5.tgz";
        sha1 = "5dbda11373703f83cfb4a3ea3881d8d75ff5e6e1";
      };
    }

    {
      name = "postcss-minify-params-1.2.2.tgz";
      path = fetchurl {
        name = "postcss-minify-params-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-params/-/postcss-minify-params-1.2.2.tgz";
        sha1 = "ad2ce071373b943b3d930a3fa59a358c28d6f1f3";
      };
    }

    {
      name = "postcss-minify-selectors-2.1.1.tgz";
      path = fetchurl {
        name = "postcss-minify-selectors-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-selectors/-/postcss-minify-selectors-2.1.1.tgz";
        sha1 = "b2c6a98c0072cf91b932d1a496508114311735bf";
      };
    }

    {
      name = "postcss-modules-extract-imports-1.0.1.tgz";
      path = fetchurl {
        name = "postcss-modules-extract-imports-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-extract-imports/-/postcss-modules-extract-imports-1.0.1.tgz";
        sha1 = "8fb3fef9a6dd0420d3f6d4353cf1ff73f2b2a341";
      };
    }

    {
      name = "postcss-modules-local-by-default-1.1.1.tgz";
      path = fetchurl {
        name = "postcss-modules-local-by-default-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-local-by-default/-/postcss-modules-local-by-default-1.1.1.tgz";
        sha1 = "29a10673fa37d19251265ca2ba3150d9040eb4ce";
      };
    }

    {
      name = "postcss-modules-scope-1.0.2.tgz";
      path = fetchurl {
        name = "postcss-modules-scope-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-scope/-/postcss-modules-scope-1.0.2.tgz";
        sha1 = "ff977395e5e06202d7362290b88b1e8cd049de29";
      };
    }

    {
      name = "postcss-modules-values-1.2.2.tgz";
      path = fetchurl {
        name = "postcss-modules-values-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-values/-/postcss-modules-values-1.2.2.tgz";
        sha1 = "f0e7d476fe1ed88c5e4c7f97533a3e772ad94ca1";
      };
    }

    {
      name = "postcss-normalize-charset-1.1.1.tgz";
      path = fetchurl {
        name = "postcss-normalize-charset-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-charset/-/postcss-normalize-charset-1.1.1.tgz";
        sha1 = "ef9ee71212d7fe759c78ed162f61ed62b5cb93f1";
      };
    }

    {
      name = "postcss-normalize-url-3.0.8.tgz";
      path = fetchurl {
        name = "postcss-normalize-url-3.0.8.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-url/-/postcss-normalize-url-3.0.8.tgz";
        sha1 = "108f74b3f2fcdaf891a2ffa3ea4592279fc78222";
      };
    }

    {
      name = "postcss-ordered-values-2.2.3.tgz";
      path = fetchurl {
        name = "postcss-ordered-values-2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-ordered-values/-/postcss-ordered-values-2.2.3.tgz";
        sha1 = "eec6c2a67b6c412a8db2042e77fe8da43f95c11d";
      };
    }

    {
      name = "postcss-reduce-idents-2.4.0.tgz";
      path = fetchurl {
        name = "postcss-reduce-idents-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-reduce-idents/-/postcss-reduce-idents-2.4.0.tgz";
        sha1 = "c2c6d20cc958284f6abfbe63f7609bf409059ad3";
      };
    }

    {
      name = "postcss-reduce-initial-1.0.1.tgz";
      path = fetchurl {
        name = "postcss-reduce-initial-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-reduce-initial/-/postcss-reduce-initial-1.0.1.tgz";
        sha1 = "68f80695f045d08263a879ad240df8dd64f644ea";
      };
    }

    {
      name = "postcss-reduce-transforms-1.0.4.tgz";
      path = fetchurl {
        name = "postcss-reduce-transforms-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-reduce-transforms/-/postcss-reduce-transforms-1.0.4.tgz";
        sha1 = "ff76f4d8212437b31c298a42d2e1444025771ae1";
      };
    }

    {
      name = "postcss-selector-parser-2.2.3.tgz";
      path = fetchurl {
        name = "postcss-selector-parser-2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-2.2.3.tgz";
        sha1 = "f9437788606c3c9acee16ffe8d8b16297f27bb90";
      };
    }

    {
      name = "postcss-svgo-2.1.6.tgz";
      path = fetchurl {
        name = "postcss-svgo-2.1.6.tgz";
        url  = "https://registry.yarnpkg.com/postcss-svgo/-/postcss-svgo-2.1.6.tgz";
        sha1 = "b6df18aa613b666e133f08adb5219c2684ac108d";
      };
    }

    {
      name = "postcss-unique-selectors-2.0.2.tgz";
      path = fetchurl {
        name = "postcss-unique-selectors-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-unique-selectors/-/postcss-unique-selectors-2.0.2.tgz";
        sha1 = "981d57d29ddcb33e7b1dfe1fd43b8649f933ca1d";
      };
    }

    {
      name = "postcss-value-parser-3.3.0.tgz";
      path = fetchurl {
        name = "postcss-value-parser-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-3.3.0.tgz";
        sha1 = "87f38f9f18f774a4ab4c8a232f5c5ce8872a9d15";
      };
    }

    {
      name = "postcss-zindex-2.2.0.tgz";
      path = fetchurl {
        name = "postcss-zindex-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-zindex/-/postcss-zindex-2.2.0.tgz";
        sha1 = "d2109ddc055b91af67fc4cb3b025946639d2af22";
      };
    }

    {
      name = "postcss-5.2.16.tgz";
      path = fetchurl {
        name = "postcss-5.2.16.tgz";
        url  = "https://registry.yarnpkg.com/postcss/-/postcss-5.2.16.tgz";
        sha1 = "732b3100000f9ff8379a48a53839ed097376ad57";
      };
    }

    {
      name = "prelude-ls-1.1.2.tgz";
      path = fetchurl {
        name = "prelude-ls-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz";
        sha1 = "21932a549f5e52ffd9a827f570e04be62a97da54";
      };
    }

    {
      name = "prepend-http-1.0.4.tgz";
      path = fetchurl {
        name = "prepend-http-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/prepend-http/-/prepend-http-1.0.4.tgz";
        sha1 = "d4f4562b0ce3696e41ac52d0e002e57a635dc6dc";
      };
    }

    {
      name = "preserve-0.2.0.tgz";
      path = fetchurl {
        name = "preserve-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/preserve/-/preserve-0.2.0.tgz";
        sha1 = "815ed1f6ebc65926f865b310c0713bcb3315ce4b";
      };
    }

    {
      name = "prismjs-1.6.0.tgz";
      path = fetchurl {
        name = "prismjs-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/prismjs/-/prismjs-1.6.0.tgz";
        sha1 = "118d95fb7a66dba2272e343b345f5236659db365";
      };
    }

    {
      name = "private-0.1.7.tgz";
      path = fetchurl {
        name = "private-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/private/-/private-0.1.7.tgz";
        sha1 = "68ce5e8a1ef0a23bb570cc28537b5332aba63ef1";
      };
    }

    {
      name = "process-nextick-args-1.0.7.tgz";
      path = fetchurl {
        name = "process-nextick-args-1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-1.0.7.tgz";
        sha1 = "150e20b756590ad3f91093f25a4f2ad8bff30ba3";
      };
    }

    {
      name = "process-0.11.9.tgz";
      path = fetchurl {
        name = "process-0.11.9.tgz";
        url  = "https://registry.yarnpkg.com/process/-/process-0.11.9.tgz";
        sha1 = "7bd5ad21aa6253e7da8682264f1e11d11c0318c1";
      };
    }

    {
      name = "progress-1.1.8.tgz";
      path = fetchurl {
        name = "progress-1.1.8.tgz";
        url  = "https://registry.yarnpkg.com/progress/-/progress-1.1.8.tgz";
        sha1 = "e260c78f6161cdd9b0e56cc3e0a85de17c7a57be";
      };
    }

    {
      name = "proto-list-1.2.4.tgz";
      path = fetchurl {
        name = "proto-list-1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/proto-list/-/proto-list-1.2.4.tgz";
        sha1 = "212d5bfe1318306a420f6402b8e26ff39647a849";
      };
    }

    {
      name = "proxy-addr-1.1.4.tgz";
      path = fetchurl {
        name = "proxy-addr-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-1.1.4.tgz";
        sha1 = "27e545f6960a44a627d9b44467e35c1b6b4ce2f3";
      };
    }

    {
      name = "prr-0.0.0.tgz";
      path = fetchurl {
        name = "prr-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/prr/-/prr-0.0.0.tgz";
        sha1 = "1a84b85908325501411853d0081ee3fa86e2926a";
      };
    }

    {
      name = "ps-tree-1.1.0.tgz";
      path = fetchurl {
        name = "ps-tree-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ps-tree/-/ps-tree-1.1.0.tgz";
        sha1 = "b421b24140d6203f1ed3c76996b4427b08e8c014";
      };
    }

    {
      name = "pseudomap-1.0.2.tgz";
      path = fetchurl {
        name = "pseudomap-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz";
        sha1 = "f052a28da70e618917ef0a8ac34c1ae5a68286b3";
      };
    }

    {
      name = "public-encrypt-4.0.0.tgz";
      path = fetchurl {
        name = "public-encrypt-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/public-encrypt/-/public-encrypt-4.0.0.tgz";
        sha1 = "39f699f3a46560dd5ebacbca693caf7c65c18cc6";
      };
    }

    {
      name = "punycode-1.3.2.tgz";
      path = fetchurl {
        name = "punycode-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-1.3.2.tgz";
        sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
      };
    }

    {
      name = "punycode-1.4.1.tgz";
      path = fetchurl {
        name = "punycode-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz";
        sha1 = "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e";
      };
    }

    {
      name = "q-1.5.0.tgz";
      path = fetchurl {
        name = "q-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/q/-/q-1.5.0.tgz";
        sha1 = "dd01bac9d06d30e6f219aecb8253ee9ebdc308f1";
      };
    }

    {
      name = "qjobs-1.1.5.tgz";
      path = fetchurl {
        name = "qjobs-1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/qjobs/-/qjobs-1.1.5.tgz";
        sha1 = "659de9f2cf8dcc27a1481276f205377272382e73";
      };
    }

    {
      name = "qs-6.2.1.tgz";
      path = fetchurl {
        name = "qs-6.2.1.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.2.1.tgz";
        sha1 = "ce03c5ff0935bc1d9d69a9f14cbd18e568d67625";
      };
    }

    {
      name = "qs-6.4.0.tgz";
      path = fetchurl {
        name = "qs-6.4.0.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.4.0.tgz";
        sha1 = "13e26d28ad6b0ffaa91312cd3bf708ed351e7233";
      };
    }

    {
      name = "qs-6.3.0.tgz";
      path = fetchurl {
        name = "qs-6.3.0.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.3.0.tgz";
        sha1 = "f403b264f23bc01228c74131b407f18d5ea5d442";
      };
    }

    {
      name = "query-string-4.3.2.tgz";
      path = fetchurl {
        name = "query-string-4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/query-string/-/query-string-4.3.2.tgz";
        sha1 = "ec0fd765f58a50031a3968c2431386f8947a5cdd";
      };
    }

    {
      name = "querystring-es3-0.2.1.tgz";
      path = fetchurl {
        name = "querystring-es3-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/querystring-es3/-/querystring-es3-0.2.1.tgz";
        sha1 = "9ec61f79049875707d69414596fd907a4d711e73";
      };
    }

    {
      name = "querystring-0.2.0.tgz";
      path = fetchurl {
        name = "querystring-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/querystring/-/querystring-0.2.0.tgz";
        sha1 = "b209849203bb25df820da756e747005878521620";
      };
    }

    {
      name = "querystringify-0.0.4.tgz";
      path = fetchurl {
        name = "querystringify-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/querystringify/-/querystringify-0.0.4.tgz";
        sha1 = "0cf7f84f9463ff0ae51c4c4b142d95be37724d9c";
      };
    }

    {
      name = "randomatic-1.1.6.tgz";
      path = fetchurl {
        name = "randomatic-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/randomatic/-/randomatic-1.1.6.tgz";
        sha1 = "110dcabff397e9dcff7c0789ccc0a49adf1ec5bb";
      };
    }

    {
      name = "randombytes-2.0.3.tgz";
      path = fetchurl {
        name = "randombytes-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/randombytes/-/randombytes-2.0.3.tgz";
        sha1 = "674c99760901c3c4112771a31e521dc349cc09ec";
      };
    }

    {
      name = "range-parser-1.2.0.tgz";
      path = fetchurl {
        name = "range-parser-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.0.tgz";
        sha1 = "f49be6b487894ddc40dcc94a322f611092e00d5e";
      };
    }

    {
      name = "raphael-2.2.7.tgz";
      path = fetchurl {
        name = "raphael-2.2.7.tgz";
        url  = "https://registry.yarnpkg.com/raphael/-/raphael-2.2.7.tgz";
        sha1 = "231b19141f8d086986d8faceb66f8b562ee2c810";
      };
    }

    {
      name = "raven-js-3.14.0.tgz";
      path = fetchurl {
        name = "raven-js-3.14.0.tgz";
        url  = "https://registry.yarnpkg.com/raven-js/-/raven-js-3.14.0.tgz";
        sha1 = "94dda81d975fdc4a42f193db437cf70021d654e0";
      };
    }

    {
      name = "raw-body-2.2.0.tgz";
      path = fetchurl {
        name = "raw-body-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/raw-body/-/raw-body-2.2.0.tgz";
        sha1 = "994976cf6a5096a41162840492f0bdc5d6e7fb96";
      };
    }

    {
      name = "raw-loader-0.5.1.tgz";
      path = fetchurl {
        name = "raw-loader-0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/raw-loader/-/raw-loader-0.5.1.tgz";
        sha1 = "0c3d0beaed8a01c966d9787bf778281252a979aa";
      };
    }

    {
      name = "rc-1.1.6.tgz";
      path = fetchurl {
        name = "rc-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/rc/-/rc-1.1.6.tgz";
        sha1 = "43651b76b6ae53b5c802f1151fa3fc3b059969c9";
      };
    }

    {
      name = "react-dev-utils-0.5.2.tgz";
      path = fetchurl {
        name = "react-dev-utils-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/react-dev-utils/-/react-dev-utils-0.5.2.tgz";
        sha1 = "50d0b962d3a94b6c2e8f2011ed6468e4124bc410";
      };
    }

    {
      name = "read-all-stream-3.1.0.tgz";
      path = fetchurl {
        name = "read-all-stream-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/read-all-stream/-/read-all-stream-3.1.0.tgz";
        sha1 = "35c3e177f2078ef789ee4bfafa4373074eaef4fa";
      };
    }

    {
      name = "read-pkg-up-1.0.1.tgz";
      path = fetchurl {
        name = "read-pkg-up-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-1.0.1.tgz";
        sha1 = "9d63c13276c065918d57f002a57f40a1b643fb02";
      };
    }

    {
      name = "read-pkg-1.1.0.tgz";
      path = fetchurl {
        name = "read-pkg-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg/-/read-pkg-1.1.0.tgz";
        sha1 = "f5ffaa5ecd29cb31c0474bca7d756b6bb29e3f28";
      };
    }

    {
      name = "readable-stream-2.2.2.tgz";
      path = fetchurl {
        name = "readable-stream-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.2.2.tgz";
        sha1 = "a9e6fec3c7dda85f8bb1b3ba7028604556fc825e";
      };
    }

    {
      name = "readable-stream-2.0.6.tgz";
      path = fetchurl {
        name = "readable-stream-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.0.6.tgz";
        sha1 = "8f90341e68a53ccc928788dacfcd11b36eb9b78e";
      };
    }

    {
      name = "readable-stream-1.0.34.tgz";
      path = fetchurl {
        name = "readable-stream-1.0.34.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.0.34.tgz";
        sha1 = "125820e34bc842d2f2aaafafe4c2916ee32c157c";
      };
    }

    {
      name = "readable-stream-2.1.5.tgz";
      path = fetchurl {
        name = "readable-stream-2.1.5.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.1.5.tgz";
        sha1 = "66fa8b720e1438b364681f2ad1a63c618448c9d0";
      };
    }

    {
      name = "readdirp-2.1.0.tgz";
      path = fetchurl {
        name = "readdirp-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/readdirp/-/readdirp-2.1.0.tgz";
        sha1 = "4ed0ad060df3073300c48440373f72d1cc642d78";
      };
    }

    {
      name = "readline2-1.0.1.tgz";
      path = fetchurl {
        name = "readline2-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/readline2/-/readline2-1.0.1.tgz";
        sha1 = "41059608ffc154757b715d9989d199ffbf372e35";
      };
    }

    {
      name = "rechoir-0.6.2.tgz";
      path = fetchurl {
        name = "rechoir-0.6.2.tgz";
        url  = "https://registry.yarnpkg.com/rechoir/-/rechoir-0.6.2.tgz";
        sha1 = "85204b54dba82d5742e28c96756ef43af50e3384";
      };
    }

    {
      name = "recursive-readdir-2.1.1.tgz";
      path = fetchurl {
        name = "recursive-readdir-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/recursive-readdir/-/recursive-readdir-2.1.1.tgz";
        sha1 = "a01cfc7f7f38a53ec096a096f63a50489c3e297c";
      };
    }

    {
      name = "reduce-css-calc-1.3.0.tgz";
      path = fetchurl {
        name = "reduce-css-calc-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/reduce-css-calc/-/reduce-css-calc-1.3.0.tgz";
        sha1 = "747c914e049614a4c9cfbba629871ad1d2927716";
      };
    }

    {
      name = "reduce-function-call-1.0.2.tgz";
      path = fetchurl {
        name = "reduce-function-call-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/reduce-function-call/-/reduce-function-call-1.0.2.tgz";
        sha1 = "5a200bf92e0e37751752fe45b0ab330fd4b6be99";
      };
    }

    {
      name = "regenerate-1.3.2.tgz";
      path = fetchurl {
        name = "regenerate-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/regenerate/-/regenerate-1.3.2.tgz";
        sha1 = "d1941c67bad437e1be76433add5b385f95b19260";
      };
    }

    {
      name = "regenerator-runtime-0.10.1.tgz";
      path = fetchurl {
        name = "regenerator-runtime-0.10.1.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.10.1.tgz";
        sha1 = "257f41961ce44558b18f7814af48c17559f9faeb";
      };
    }

    {
      name = "regenerator-transform-0.9.8.tgz";
      path = fetchurl {
        name = "regenerator-transform-0.9.8.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.9.8.tgz";
        sha1 = "0f88bb2bc03932ddb7b6b7312e68078f01026d6c";
      };
    }

    {
      name = "regex-cache-0.4.3.tgz";
      path = fetchurl {
        name = "regex-cache-0.4.3.tgz";
        url  = "https://registry.yarnpkg.com/regex-cache/-/regex-cache-0.4.3.tgz";
        sha1 = "9b1a6c35d4d0dfcef5711ae651e8e9d3d7114145";
      };
    }

    {
      name = "regexpu-core-1.0.0.tgz";
      path = fetchurl {
        name = "regexpu-core-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-1.0.0.tgz";
        sha1 = "86a763f58ee4d7c2f6b102e4764050de7ed90c6b";
      };
    }

    {
      name = "regexpu-core-2.0.0.tgz";
      path = fetchurl {
        name = "regexpu-core-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-2.0.0.tgz";
        sha1 = "49d038837b8dcf8bfa5b9a42139938e6ea2ae240";
      };
    }

    {
      name = "registry-url-3.1.0.tgz";
      path = fetchurl {
        name = "registry-url-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/registry-url/-/registry-url-3.1.0.tgz";
        sha1 = "3d4ef870f73dde1d77f0cf9a381432444e174942";
      };
    }

    {
      name = "regjsgen-0.2.0.tgz";
      path = fetchurl {
        name = "regjsgen-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/regjsgen/-/regjsgen-0.2.0.tgz";
        sha1 = "6c016adeac554f75823fe37ac05b92d5a4edb1f7";
      };
    }

    {
      name = "regjsparser-0.1.5.tgz";
      path = fetchurl {
        name = "regjsparser-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.1.5.tgz";
        sha1 = "7ee8f84dc6fa792d3fd0ae228d24bd949ead205c";
      };
    }

    {
      name = "repeat-element-1.1.2.tgz";
      path = fetchurl {
        name = "repeat-element-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.2.tgz";
        sha1 = "ef089a178d1483baae4d93eb98b4f9e4e11d990a";
      };
    }

    {
      name = "repeat-string-0.2.2.tgz";
      path = fetchurl {
        name = "repeat-string-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/repeat-string/-/repeat-string-0.2.2.tgz";
        sha1 = "c7a8d3236068362059a7e4651fc6884e8b1fb4ae";
      };
    }

    {
      name = "repeat-string-1.6.1.tgz";
      path = fetchurl {
        name = "repeat-string-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz";
        sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
      };
    }

    {
      name = "repeating-1.1.3.tgz";
      path = fetchurl {
        name = "repeating-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/repeating/-/repeating-1.1.3.tgz";
        sha1 = "3d4114218877537494f97f77f9785fab810fa4ac";
      };
    }

    {
      name = "repeating-2.0.1.tgz";
      path = fetchurl {
        name = "repeating-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/repeating/-/repeating-2.0.1.tgz";
        sha1 = "5214c53a926d3552707527fbab415dbc08d06dda";
      };
    }

    {
      name = "request-progress-2.0.1.tgz";
      path = fetchurl {
        name = "request-progress-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/request-progress/-/request-progress-2.0.1.tgz";
        sha1 = "5d36bb57961c673aa5b788dbc8141fdf23b44e08";
      };
    }

    {
      name = "request-2.79.0.tgz";
      path = fetchurl {
        name = "request-2.79.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.79.0.tgz";
        sha1 = "4dfe5bf6be8b8cdc37fcf93e04b65577722710de";
      };
    }

    {
      name = "require-directory-2.1.1.tgz";
      path = fetchurl {
        name = "require-directory-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz";
        sha1 = "8c64ad5fd30dab1c976e2344ffe7f792a6a6df42";
      };
    }

    {
      name = "require-from-string-1.2.1.tgz";
      path = fetchurl {
        name = "require-from-string-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/require-from-string/-/require-from-string-1.2.1.tgz";
        sha1 = "529c9ccef27380adfec9a2f965b649bbee636418";
      };
    }

    {
      name = "require-main-filename-1.0.1.tgz";
      path = fetchurl {
        name = "require-main-filename-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-1.0.1.tgz";
        sha1 = "97f717b69d48784f5f526a6c5aa8ffdda055a4d1";
      };
    }

    {
      name = "require-uncached-1.0.3.tgz";
      path = fetchurl {
        name = "require-uncached-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/require-uncached/-/require-uncached-1.0.3.tgz";
        sha1 = "4e0d56d6c9662fd31e43011c4b95aa49955421d3";
      };
    }

    {
      name = "requires-port-1.0.0.tgz";
      path = fetchurl {
        name = "requires-port-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz";
        sha1 = "925d2601d39ac485e091cf0da5c6e694dc3dcaff";
      };
    }

    {
      name = "resolve-from-1.0.1.tgz";
      path = fetchurl {
        name = "resolve-from-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-1.0.1.tgz";
        sha1 = "26cbfe935d1aeeeabb29bc3fe5aeb01e93d44226";
      };
    }

    {
      name = "resolve-1.1.7.tgz";
      path = fetchurl {
        name = "resolve-1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.1.7.tgz";
        sha1 = "203114d82ad2c5ed9e8e0411b3932875e889e97b";
      };
    }

    {
      name = "resolve-1.2.0.tgz";
      path = fetchurl {
        name = "resolve-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.2.0.tgz";
        sha1 = "9589c3f2f6149d1417a40becc1663db6ec6bc26c";
      };
    }

    {
      name = "restore-cursor-1.0.1.tgz";
      path = fetchurl {
        name = "restore-cursor-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-1.0.1.tgz";
        sha1 = "34661f46886327fed2991479152252df92daa541";
      };
    }

    {
      name = "right-align-0.1.3.tgz";
      path = fetchurl {
        name = "right-align-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/right-align/-/right-align-0.1.3.tgz";
        sha1 = "61339b722fe6a3515689210d24e14c96148613ef";
      };
    }

    {
      name = "rimraf-2.5.4.tgz";
      path = fetchurl {
        name = "rimraf-2.5.4.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.5.4.tgz";
        sha1 = "96800093cbf1a0c86bd95b4625467535c29dfa04";
      };
    }

    {
      name = "ripemd160-1.0.1.tgz";
      path = fetchurl {
        name = "ripemd160-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ripemd160/-/ripemd160-1.0.1.tgz";
        sha1 = "93a4bbd4942bc574b69a8fa57c71de10ecca7d6e";
      };
    }

    {
      name = "run-async-0.1.0.tgz";
      path = fetchurl {
        name = "run-async-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/run-async/-/run-async-0.1.0.tgz";
        sha1 = "c8ad4a5e110661e402a7d21b530e009f25f8e389";
      };
    }

    {
      name = "rx-lite-3.1.2.tgz";
      path = fetchurl {
        name = "rx-lite-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/rx-lite/-/rx-lite-3.1.2.tgz";
        sha1 = "19ce502ca572665f3b647b10939f97fd1615f102";
      };
    }

    {
      name = "safe-buffer-5.0.1.tgz";
      path = fetchurl {
        name = "safe-buffer-5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.0.1.tgz";
        sha1 = "d263ca54696cd8a306b5ca6551e92de57918fbe7";
      };
    }

    {
      name = "sax-1.2.2.tgz";
      path = fetchurl {
        name = "sax-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/sax/-/sax-1.2.2.tgz";
        sha1 = "fd8631a23bc7826bef5d871bdb87378c95647828";
      };
    }

    {
      name = "select-hose-2.0.0.tgz";
      path = fetchurl {
        name = "select-hose-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/select-hose/-/select-hose-2.0.0.tgz";
        sha1 = "625d8658f865af43ec962bfc376a37359a4994ca";
      };
    }

    {
      name = "select2-3.5.2-browserify.tgz";
      path = fetchurl {
        name = "select2-3.5.2-browserify.tgz";
        url  = "https://registry.yarnpkg.com/select2/-/select2-3.5.2-browserify.tgz";
        sha1 = "dc4dafda38d67a734e8a97a46f0d3529ae05391d";
      };
    }

    {
      name = "select-1.1.2.tgz";
      path = fetchurl {
        name = "select-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/select/-/select-1.1.2.tgz";
        sha1 = "0e7350acdec80b1108528786ec1d4418d11b396d";
      };
    }

    {
      name = "semver-diff-2.1.0.tgz";
      path = fetchurl {
        name = "semver-diff-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/semver-diff/-/semver-diff-2.1.0.tgz";
        sha1 = "4bbb8437c8d37e4b0cf1a68fd726ec6d645d6d36";
      };
    }

    {
      name = "semver-5.3.0.tgz";
      path = fetchurl {
        name = "semver-5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.3.0.tgz";
        sha1 = "9b2ce5d3de02d17c6012ad326aa6b4d0cf54f94f";
      };
    }

    {
      name = "semver-4.3.6.tgz";
      path = fetchurl {
        name = "semver-4.3.6.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-4.3.6.tgz";
        sha1 = "300bc6e0e86374f7ba61068b5b1ecd57fc6532da";
      };
    }

    {
      name = "send-0.15.3.tgz";
      path = fetchurl {
        name = "send-0.15.3.tgz";
        url  = "https://registry.yarnpkg.com/send/-/send-0.15.3.tgz";
        sha1 = "5013f9f99023df50d1bd9892c19e3defd1d53309";
      };
    }

    {
      name = "serve-index-1.8.0.tgz";
      path = fetchurl {
        name = "serve-index-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/serve-index/-/serve-index-1.8.0.tgz";
        sha1 = "7c5d96c13fb131101f93c1c5774f8516a1e78d3b";
      };
    }

    {
      name = "serve-static-1.12.3.tgz";
      path = fetchurl {
        name = "serve-static-1.12.3.tgz";
        url  = "https://registry.yarnpkg.com/serve-static/-/serve-static-1.12.3.tgz";
        sha1 = "9f4ba19e2f3030c547f8af99107838ec38d5b1e2";
      };
    }

    {
      name = "set-blocking-2.0.0.tgz";
      path = fetchurl {
        name = "set-blocking-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz";
        sha1 = "045f9782d011ae9a6803ddd382b24392b3d890f7";
      };
    }

    {
      name = "set-immediate-shim-1.0.1.tgz";
      path = fetchurl {
        name = "set-immediate-shim-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/set-immediate-shim/-/set-immediate-shim-1.0.1.tgz";
        sha1 = "4b2b1b27eb808a9f8dcc481a58e5e56f599f3f61";
      };
    }

    {
      name = "setimmediate-1.0.5.tgz";
      path = fetchurl {
        name = "setimmediate-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz";
        sha1 = "290cbb232e306942d7d7ea9b83732ab7856f8285";
      };
    }

    {
      name = "setprototypeof-1.0.2.tgz";
      path = fetchurl {
        name = "setprototypeof-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.0.2.tgz";
        sha1 = "81a552141ec104b88e89ce383103ad5c66564d08";
      };
    }

    {
      name = "setprototypeof-1.0.3.tgz";
      path = fetchurl {
        name = "setprototypeof-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.0.3.tgz";
        sha1 = "66567e37043eeb4f04d91bd658c0cbefb55b8e04";
      };
    }

    {
      name = "sha.js-2.4.8.tgz";
      path = fetchurl {
        name = "sha.js-2.4.8.tgz";
        url  = "https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.8.tgz";
        sha1 = "37068c2c476b6baf402d14a49c67f597921f634f";
      };
    }

    {
      name = "shelljs-0.7.6.tgz";
      path = fetchurl {
        name = "shelljs-0.7.6.tgz";
        url  = "https://registry.yarnpkg.com/shelljs/-/shelljs-0.7.6.tgz";
        sha1 = "379cccfb56b91c8601e4793356eb5382924de9ad";
      };
    }

    {
      name = "sigmund-1.0.1.tgz";
      path = fetchurl {
        name = "sigmund-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sigmund/-/sigmund-1.0.1.tgz";
        sha1 = "3ff21f198cad2175f9f3b781853fd94d0d19b590";
      };
    }

    {
      name = "signal-exit-3.0.2.tgz";
      path = fetchurl {
        name = "signal-exit-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.2.tgz";
        sha1 = "b5fdc08f1287ea1178628e415e25132b73646c6d";
      };
    }

    {
      name = "slash-1.0.0.tgz";
      path = fetchurl {
        name = "slash-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slash/-/slash-1.0.0.tgz";
        sha1 = "c41f2f6c39fc16d1cd17ad4b5d896114ae470d55";
      };
    }

    {
      name = "slice-ansi-0.0.4.tgz";
      path = fetchurl {
        name = "slice-ansi-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-0.0.4.tgz";
        sha1 = "edbf8903f66f7ce2f8eafd6ceed65e264c831b35";
      };
    }

    {
      name = "slide-1.1.6.tgz";
      path = fetchurl {
        name = "slide-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/slide/-/slide-1.1.6.tgz";
        sha1 = "56eb027d65b4d2dce6cb2e2d32c4d4afc9e1d707";
      };
    }

    {
      name = "sntp-1.0.9.tgz";
      path = fetchurl {
        name = "sntp-1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/sntp/-/sntp-1.0.9.tgz";
        sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
      };
    }

    {
      name = "socket.io-adapter-0.5.0.tgz";
      path = fetchurl {
        name = "socket.io-adapter-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-adapter/-/socket.io-adapter-0.5.0.tgz";
        sha1 = "cb6d4bb8bec81e1078b99677f9ced0046066bb8b";
      };
    }

    {
      name = "socket.io-client-1.7.2.tgz";
      path = fetchurl {
        name = "socket.io-client-1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-1.7.2.tgz";
        sha1 = "39fdb0c3dd450e321b7e40cfd83612ec533dd644";
      };
    }

    {
      name = "socket.io-parser-2.3.1.tgz";
      path = fetchurl {
        name = "socket.io-parser-2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-2.3.1.tgz";
        sha1 = "dd532025103ce429697326befd64005fcfe5b4a0";
      };
    }

    {
      name = "socket.io-1.7.2.tgz";
      path = fetchurl {
        name = "socket.io-1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/socket.io/-/socket.io-1.7.2.tgz";
        sha1 = "83bbbdf2e79263b378900da403e7843e05dc3b71";
      };
    }

    {
      name = "sockjs-client-1.0.1.tgz";
      path = fetchurl {
        name = "sockjs-client-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sockjs-client/-/sockjs-client-1.0.1.tgz";
        sha1 = "8943ae05b46547bc2054816c409002cf5e2fe026";
      };
    }

    {
      name = "sockjs-client-1.1.2.tgz";
      path = fetchurl {
        name = "sockjs-client-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/sockjs-client/-/sockjs-client-1.1.2.tgz";
        sha1 = "f0212a8550e4c9468c8cceaeefd2e3493c033ad5";
      };
    }

    {
      name = "sockjs-0.3.18.tgz";
      path = fetchurl {
        name = "sockjs-0.3.18.tgz";
        url  = "https://registry.yarnpkg.com/sockjs/-/sockjs-0.3.18.tgz";
        sha1 = "d9b289316ca7df77595ef299e075f0f937eb4207";
      };
    }

    {
      name = "sort-keys-1.1.2.tgz";
      path = fetchurl {
        name = "sort-keys-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/sort-keys/-/sort-keys-1.1.2.tgz";
        sha1 = "441b6d4d346798f1b4e49e8920adfba0e543f9ad";
      };
    }

    {
      name = "source-list-map-0.1.8.tgz";
      path = fetchurl {
        name = "source-list-map-0.1.8.tgz";
        url  = "https://registry.yarnpkg.com/source-list-map/-/source-list-map-0.1.8.tgz";
        sha1 = "c550b2ab5427f6b3f21f5afead88c4f5587b2106";
      };
    }

    {
      name = "source-list-map-1.1.1.tgz";
      path = fetchurl {
        name = "source-list-map-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/source-list-map/-/source-list-map-1.1.1.tgz";
        sha1 = "1a33ac210ca144d1e561f906ebccab5669ff4cb4";
      };
    }

    {
      name = "source-map-support-0.4.11.tgz";
      path = fetchurl {
        name = "source-map-support-0.4.11.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.4.11.tgz";
        sha1 = "647f939978b38535909530885303daf23279f322";
      };
    }

    {
      name = "source-map-0.5.6.tgz";
      path = fetchurl {
        name = "source-map-0.5.6.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.5.6.tgz";
        sha1 = "75ce38f52bf0733c5a7f0c118d81334a2bb5f412";
      };
    }

    {
      name = "source-map-0.1.43.tgz";
      path = fetchurl {
        name = "source-map-0.1.43.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.1.43.tgz";
        sha1 = "c24bc146ca517c1471f5dacbe2571b2b7f9e3346";
      };
    }

    {
      name = "source-map-0.4.4.tgz";
      path = fetchurl {
        name = "source-map-0.4.4.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.4.4.tgz";
        sha1 = "eba4f5da9c0dc999de68032d8b4f76173652036b";
      };
    }

    {
      name = "source-map-0.2.0.tgz";
      path = fetchurl {
        name = "source-map-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.2.0.tgz";
        sha1 = "dab73fbcfc2ba819b4de03bd6f6eaa48164b3f9d";
      };
    }

    {
      name = "spdx-correct-1.0.2.tgz";
      path = fetchurl {
        name = "spdx-correct-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-1.0.2.tgz";
        sha1 = "4b3073d933ff51f3912f03ac5519498a4150db40";
      };
    }

    {
      name = "spdx-expression-parse-1.0.4.tgz";
      path = fetchurl {
        name = "spdx-expression-parse-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-1.0.4.tgz";
        sha1 = "9bdf2f20e1f40ed447fbe273266191fced51626c";
      };
    }

    {
      name = "spdx-license-ids-1.2.2.tgz";
      path = fetchurl {
        name = "spdx-license-ids-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-1.2.2.tgz";
        sha1 = "c9df7a3424594ade6bd11900d596696dc06bac57";
      };
    }

    {
      name = "spdy-transport-2.0.18.tgz";
      path = fetchurl {
        name = "spdy-transport-2.0.18.tgz";
        url  = "https://registry.yarnpkg.com/spdy-transport/-/spdy-transport-2.0.18.tgz";
        sha1 = "43fc9c56be2cccc12bb3e2754aa971154e836ea6";
      };
    }

    {
      name = "spdy-3.4.4.tgz";
      path = fetchurl {
        name = "spdy-3.4.4.tgz";
        url  = "https://registry.yarnpkg.com/spdy/-/spdy-3.4.4.tgz";
        sha1 = "e0406407ca90ff01b553eb013505442649f5a819";
      };
    }

    {
      name = "split-0.3.3.tgz";
      path = fetchurl {
        name = "split-0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/split/-/split-0.3.3.tgz";
        sha1 = "cd0eea5e63a211dfff7eb0f091c4133e2d0dd28f";
      };
    }

    {
      name = "sprintf-js-1.0.3.tgz";
      path = fetchurl {
        name = "sprintf-js-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz";
        sha1 = "04e6926f662895354f3dd015203633b857297e2c";
      };
    }

    {
      name = "sql.js-0.4.0.tgz";
      path = fetchurl {
        name = "sql.js-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/sql.js/-/sql.js-0.4.0.tgz";
        sha1 = "23be9635520eb0ff43a741e7e830397266e88445";
      };
    }

    {
      name = "sshpk-1.10.2.tgz";
      path = fetchurl {
        name = "sshpk-1.10.2.tgz";
        url  = "https://registry.yarnpkg.com/sshpk/-/sshpk-1.10.2.tgz";
        sha1 = "d5a804ce22695515638e798dbe23273de070a5fa";
      };
    }

    {
      name = "stats-webpack-plugin-0.4.3.tgz";
      path = fetchurl {
        name = "stats-webpack-plugin-0.4.3.tgz";
        url  = "https://registry.yarnpkg.com/stats-webpack-plugin/-/stats-webpack-plugin-0.4.3.tgz";
        sha1 = "b2f618202f28dd04ab47d7ecf54ab846137b7aea";
      };
    }

    {
      name = "statuses-1.3.1.tgz";
      path = fetchurl {
        name = "statuses-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/statuses/-/statuses-1.3.1.tgz";
        sha1 = "faf51b9eb74aaef3b3acf4ad5f61abf24cb7b93e";
      };
    }

    {
      name = "stream-browserify-2.0.1.tgz";
      path = fetchurl {
        name = "stream-browserify-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/stream-browserify/-/stream-browserify-2.0.1.tgz";
        sha1 = "66266ee5f9bdb9940a4e4514cafb43bb71e5c9db";
      };
    }

    {
      name = "stream-combiner-0.0.4.tgz";
      path = fetchurl {
        name = "stream-combiner-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/stream-combiner/-/stream-combiner-0.0.4.tgz";
        sha1 = "4d5e433c185261dde623ca3f44c586bcf5c4ad14";
      };
    }

    {
      name = "stream-http-2.6.3.tgz";
      path = fetchurl {
        name = "stream-http-2.6.3.tgz";
        url  = "https://registry.yarnpkg.com/stream-http/-/stream-http-2.6.3.tgz";
        sha1 = "4c3ddbf9635968ea2cfd4e48d43de5def2625ac3";
      };
    }

    {
      name = "stream-shift-1.0.0.tgz";
      path = fetchurl {
        name = "stream-shift-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.0.tgz";
        sha1 = "d5c752825e5367e786f78e18e445ea223a155952";
      };
    }

    {
      name = "strict-uri-encode-1.1.0.tgz";
      path = fetchurl {
        name = "strict-uri-encode-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/strict-uri-encode/-/strict-uri-encode-1.1.0.tgz";
        sha1 = "279b225df1d582b1f54e65addd4352e18faa0713";
      };
    }

    {
      name = "string-length-1.0.1.tgz";
      path = fetchurl {
        name = "string-length-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/string-length/-/string-length-1.0.1.tgz";
        sha1 = "56970fb1c38558e9e70b728bf3de269ac45adfac";
      };
    }

    {
      name = "string-width-1.0.2.tgz";
      path = fetchurl {
        name = "string-width-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz";
        sha1 = "118bdf5b8cdc51a2a7e70d211e07e2b0b9b107d3";
      };
    }

    {
      name = "string-width-2.0.0.tgz";
      path = fetchurl {
        name = "string-width-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-2.0.0.tgz";
        sha1 = "635c5436cc72a6e0c387ceca278d4e2eec52687e";
      };
    }

    {
      name = "string_decoder-0.10.31.tgz";
      path = fetchurl {
        name = "string_decoder-0.10.31.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      };
    }

    {
      name = "stringstream-0.0.5.tgz";
      path = fetchurl {
        name = "stringstream-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/stringstream/-/stringstream-0.0.5.tgz";
        sha1 = "4e484cd4de5a0bbbee18e46307710a8a81621878";
      };
    }

    {
      name = "strip-ansi-3.0.1.tgz";
      path = fetchurl {
        name = "strip-ansi-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz";
        sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
      };
    }

    {
      name = "strip-bom-2.0.0.tgz";
      path = fetchurl {
        name = "strip-bom-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz";
        sha1 = "6219a85616520491f35788bdbf1447a99c7e6b0e";
      };
    }

    {
      name = "strip-bom-3.0.0.tgz";
      path = fetchurl {
        name = "strip-bom-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz";
        sha1 = "2334c18e9c759f7bdd56fdef7e9ae3d588e68ed3";
      };
    }

    {
      name = "strip-json-comments-1.0.4.tgz";
      path = fetchurl {
        name = "strip-json-comments-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-1.0.4.tgz";
        sha1 = "1e15fbcac97d3ee99bf2d73b4c656b082bbafb91";
      };
    }

    {
      name = "strip-json-comments-2.0.1.tgz";
      path = fetchurl {
        name = "strip-json-comments-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz";
        sha1 = "3c531942e908c2697c0ec344858c286c7ca0a60a";
      };
    }

    {
      name = "supports-color-0.2.0.tgz";
      path = fetchurl {
        name = "supports-color-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-0.2.0.tgz";
        sha1 = "d92de2694eb3f67323973d7ae3d8b55b4c22190a";
      };
    }

    {
      name = "supports-color-2.0.0.tgz";
      path = fetchurl {
        name = "supports-color-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
    }

    {
      name = "supports-color-3.2.3.tgz";
      path = fetchurl {
        name = "supports-color-3.2.3.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-3.2.3.tgz";
        sha1 = "65ac0504b3954171d8a64946b2ae3cbb8a5f54f6";
      };
    }

    {
      name = "svgo-0.7.2.tgz";
      path = fetchurl {
        name = "svgo-0.7.2.tgz";
        url  = "https://registry.yarnpkg.com/svgo/-/svgo-0.7.2.tgz";
        sha1 = "9f5772413952135c6fefbf40afe6a4faa88b4bb5";
      };
    }

    {
      name = "table-3.8.3.tgz";
      path = fetchurl {
        name = "table-3.8.3.tgz";
        url  = "https://registry.yarnpkg.com/table/-/table-3.8.3.tgz";
        sha1 = "2bbc542f0fda9861a755d3947fefd8b3f513855f";
      };
    }

    {
      name = "tapable-0.1.10.tgz";
      path = fetchurl {
        name = "tapable-0.1.10.tgz";
        url  = "https://registry.yarnpkg.com/tapable/-/tapable-0.1.10.tgz";
        sha1 = "29c35707c2b70e50d07482b5d202e8ed446dafd4";
      };
    }

    {
      name = "tapable-0.2.6.tgz";
      path = fetchurl {
        name = "tapable-0.2.6.tgz";
        url  = "https://registry.yarnpkg.com/tapable/-/tapable-0.2.6.tgz";
        sha1 = "206be8e188860b514425375e6f1ae89bfb01fd8d";
      };
    }

    {
      name = "tar-pack-3.3.0.tgz";
      path = fetchurl {
        name = "tar-pack-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/tar-pack/-/tar-pack-3.3.0.tgz";
        sha1 = "30931816418f55afc4d21775afdd6720cee45dae";
      };
    }

    {
      name = "tar-2.2.1.tgz";
      path = fetchurl {
        name = "tar-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/tar/-/tar-2.2.1.tgz";
        sha1 = "8e4d2a256c0e2185c6b18ad694aec968b83cb1d1";
      };
    }

    {
      name = "test-exclude-4.0.0.tgz";
      path = fetchurl {
        name = "test-exclude-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/test-exclude/-/test-exclude-4.0.0.tgz";
        sha1 = "0ddc0100b8ae7e88b34eb4fd98a907e961991900";
      };
    }

    {
      name = "text-table-0.2.0.tgz";
      path = fetchurl {
        name = "text-table-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz";
        sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
      };
    }

    {
      name = "three-orbit-controls-82.1.0.tgz";
      path = fetchurl {
        name = "three-orbit-controls-82.1.0.tgz";
        url  = "https://registry.yarnpkg.com/three-orbit-controls/-/three-orbit-controls-82.1.0.tgz";
        sha1 = "11a7f33d0a20ecec98f098b37780f6537374fab4";
      };
    }

    {
      name = "three-stl-loader-1.0.4.tgz";
      path = fetchurl {
        name = "three-stl-loader-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/three-stl-loader/-/three-stl-loader-1.0.4.tgz";
        sha1 = "6b3319a31e3b910aab1883d19b00c81a663c3e03";
      };
    }

    {
      name = "three-0.84.0.tgz";
      path = fetchurl {
        name = "three-0.84.0.tgz";
        url  = "https://registry.yarnpkg.com/three/-/three-0.84.0.tgz";
        sha1 = "95be85a55a0fa002aa625ed559130957dcffd918";
      };
    }

    {
      name = "throttleit-1.0.0.tgz";
      path = fetchurl {
        name = "throttleit-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/throttleit/-/throttleit-1.0.0.tgz";
        sha1 = "9e785836daf46743145a5984b6268d828528ac6c";
      };
    }

    {
      name = "through-2.3.8.tgz";
      path = fetchurl {
        name = "through-2.3.8.tgz";
        url  = "https://registry.yarnpkg.com/through/-/through-2.3.8.tgz";
        sha1 = "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5";
      };
    }

    {
      name = "timeago.js-2.0.5.tgz";
      path = fetchurl {
        name = "timeago.js-2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/timeago.js/-/timeago.js-2.0.5.tgz";
        sha1 = "730c74fbdb0b0917a553675a4460e3a7f80db86c";
      };
    }

    {
      name = "timed-out-2.0.0.tgz";
      path = fetchurl {
        name = "timed-out-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/timed-out/-/timed-out-2.0.0.tgz";
        sha1 = "f38b0ae81d3747d628001f41dafc652ace671c0a";
      };
    }

    {
      name = "timers-browserify-1.4.2.tgz";
      path = fetchurl {
        name = "timers-browserify-1.4.2.tgz";
        url  = "https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-1.4.2.tgz";
        sha1 = "c9c58b575be8407375cb5e2462dacee74359f41d";
      };
    }

    {
      name = "timers-browserify-2.0.2.tgz";
      path = fetchurl {
        name = "timers-browserify-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-2.0.2.tgz";
        sha1 = "ab4883cf597dcd50af211349a00fbca56ac86b86";
      };
    }

    {
      name = "tiny-emitter-1.1.0.tgz";
      path = fetchurl {
        name = "tiny-emitter-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/tiny-emitter/-/tiny-emitter-1.1.0.tgz";
        sha1 = "ab405a21ffed814a76c19739648093d70654fecb";
      };
    }

    {
      name = "tmp-0.0.28.tgz";
      path = fetchurl {
        name = "tmp-0.0.28.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.0.28.tgz";
        sha1 = "172735b7f614ea7af39664fa84cf0de4e515d120";
      };
    }

    {
      name = "to-array-0.1.4.tgz";
      path = fetchurl {
        name = "to-array-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/to-array/-/to-array-0.1.4.tgz";
        sha1 = "17e6c11f73dd4f3d74cda7a4ff3238e9ad9bf890";
      };
    }

    {
      name = "to-arraybuffer-1.0.1.tgz";
      path = fetchurl {
        name = "to-arraybuffer-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz";
        sha1 = "7d229b1fcc637e466ca081180836a7aabff83f43";
      };
    }

    {
      name = "to-fast-properties-1.0.2.tgz";
      path = fetchurl {
        name = "to-fast-properties-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-1.0.2.tgz";
        sha1 = "f3f5c0c3ba7299a7ef99427e44633257ade43320";
      };
    }

    {
      name = "touch-1.0.0.tgz";
      path = fetchurl {
        name = "touch-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/touch/-/touch-1.0.0.tgz";
        sha1 = "449cbe2dbae5a8c8038e30d71fa0ff464947c4de";
      };
    }

    {
      name = "tough-cookie-2.3.2.tgz";
      path = fetchurl {
        name = "tough-cookie-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.3.2.tgz";
        sha1 = "f081f76e4c85720e6c37a5faced737150d84072a";
      };
    }

    {
      name = "traverse-0.6.6.tgz";
      path = fetchurl {
        name = "traverse-0.6.6.tgz";
        url  = "https://registry.yarnpkg.com/traverse/-/traverse-0.6.6.tgz";
        sha1 = "cbdf560fd7b9af632502fed40f918c157ea97137";
      };
    }

    {
      name = "trim-right-1.0.1.tgz";
      path = fetchurl {
        name = "trim-right-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/trim-right/-/trim-right-1.0.1.tgz";
        sha1 = "cb2e1203067e0c8de1f614094b9fe45704ea6003";
      };
    }

    {
      name = "tryit-1.0.3.tgz";
      path = fetchurl {
        name = "tryit-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/tryit/-/tryit-1.0.3.tgz";
        sha1 = "393be730a9446fd1ead6da59a014308f36c289cb";
      };
    }

    {
      name = "tty-browserify-0.0.0.tgz";
      path = fetchurl {
        name = "tty-browserify-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/tty-browserify/-/tty-browserify-0.0.0.tgz";
        sha1 = "a157ba402da24e9bf957f9aa69d524eed42901a6";
      };
    }

    {
      name = "tunnel-agent-0.4.3.tgz";
      path = fetchurl {
        name = "tunnel-agent-0.4.3.tgz";
        url  = "https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.4.3.tgz";
        sha1 = "6373db76909fe570e08d73583365ed828a74eeeb";
      };
    }

    {
      name = "tweetnacl-0.14.5.tgz";
      path = fetchurl {
        name = "tweetnacl-0.14.5.tgz";
        url  = "https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz";
        sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
      };
    }

    {
      name = "type-check-0.3.2.tgz";
      path = fetchurl {
        name = "type-check-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz";
        sha1 = "5884cab512cf1d355e3fb784f30804b2b520db72";
      };
    }

    {
      name = "type-is-1.6.15.tgz";
      path = fetchurl {
        name = "type-is-1.6.15.tgz";
        url  = "https://registry.yarnpkg.com/type-is/-/type-is-1.6.15.tgz";
        sha1 = "cab10fb4909e441c82842eafe1ad646c81804410";
      };
    }

    {
      name = "typedarray-0.0.6.tgz";
      path = fetchurl {
        name = "typedarray-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz";
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      };
    }

    {
      name = "uglify-js-2.8.27.tgz";
      path = fetchurl {
        name = "uglify-js-2.8.27.tgz";
        url  = "https://registry.yarnpkg.com/uglify-js/-/uglify-js-2.8.27.tgz";
        sha1 = "47787f912b0f242e5b984343be8e35e95f694c9c";
      };
    }

    {
      name = "uglify-to-browserify-1.0.2.tgz";
      path = fetchurl {
        name = "uglify-to-browserify-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
        sha1 = "6e0924d6bda6b5afe349e39a6d632850a0f882b7";
      };
    }

    {
      name = "uid-number-0.0.6.tgz";
      path = fetchurl {
        name = "uid-number-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/uid-number/-/uid-number-0.0.6.tgz";
        sha1 = "0ea10e8035e8eb5b8e4449f06da1c730663baa81";
      };
    }

    {
      name = "ultron-1.0.2.tgz";
      path = fetchurl {
        name = "ultron-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ultron/-/ultron-1.0.2.tgz";
        sha1 = "ace116ab557cd197386a4e88f4685378c8b2e4fa";
      };
    }

    {
      name = "ultron-1.1.0.tgz";
      path = fetchurl {
        name = "ultron-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ultron/-/ultron-1.1.0.tgz";
        sha1 = "b07a2e6a541a815fc6a34ccd4533baec307ca864";
      };
    }

    {
      name = "unc-path-regex-0.1.2.tgz";
      path = fetchurl {
        name = "unc-path-regex-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/unc-path-regex/-/unc-path-regex-0.1.2.tgz";
        sha1 = "e73dd3d7b0d7c5ed86fbac6b0ae7d8c6a69d50fa";
      };
    }

    {
      name = "undefsafe-0.0.3.tgz";
      path = fetchurl {
        name = "undefsafe-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/undefsafe/-/undefsafe-0.0.3.tgz";
        sha1 = "ecca3a03e56b9af17385baac812ac83b994a962f";
      };
    }

    {
      name = "underscore-1.8.3.tgz";
      path = fetchurl {
        name = "underscore-1.8.3.tgz";
        url  = "https://registry.yarnpkg.com/underscore/-/underscore-1.8.3.tgz";
        sha1 = "4f3fb53b106e6097fcf9cb4109f2a5e9bdfa5022";
      };
    }

    {
      name = "uniq-1.0.1.tgz";
      path = fetchurl {
        name = "uniq-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/uniq/-/uniq-1.0.1.tgz";
        sha1 = "b31c5ae8254844a3a8281541ce2b04b865a734ff";
      };
    }

    {
      name = "uniqid-4.1.1.tgz";
      path = fetchurl {
        name = "uniqid-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/uniqid/-/uniqid-4.1.1.tgz";
        sha1 = "89220ddf6b751ae52b5f72484863528596bb84c1";
      };
    }

    {
      name = "uniqs-2.0.0.tgz";
      path = fetchurl {
        name = "uniqs-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/uniqs/-/uniqs-2.0.0.tgz";
        sha1 = "ffede4b36b25290696e6e165d4a59edb998e6b02";
      };
    }

    {
      name = "unpipe-1.0.0.tgz";
      path = fetchurl {
        name = "unpipe-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz";
        sha1 = "b2bf4ee8514aae6165b4817829d21b2ef49904ec";
      };
    }

    {
      name = "update-notifier-0.5.0.tgz";
      path = fetchurl {
        name = "update-notifier-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/update-notifier/-/update-notifier-0.5.0.tgz";
        sha1 = "07b5dc2066b3627ab3b4f530130f7eddda07a4cc";
      };
    }

    {
      name = "url-loader-0.5.8.tgz";
      path = fetchurl {
        name = "url-loader-0.5.8.tgz";
        url  = "https://registry.yarnpkg.com/url-loader/-/url-loader-0.5.8.tgz";
        sha1 = "b9183b1801e0f847718673673040bc9dc1c715c5";
      };
    }

    {
      name = "url-parse-1.0.5.tgz";
      path = fetchurl {
        name = "url-parse-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/url-parse/-/url-parse-1.0.5.tgz";
        sha1 = "0854860422afdcfefeb6c965c662d4800169927b";
      };
    }

    {
      name = "url-parse-1.1.7.tgz";
      path = fetchurl {
        name = "url-parse-1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/url-parse/-/url-parse-1.1.7.tgz";
        sha1 = "025cff999653a459ab34232147d89514cc87d74a";
      };
    }

    {
      name = "url-0.11.0.tgz";
      path = fetchurl {
        name = "url-0.11.0.tgz";
        url  = "https://registry.yarnpkg.com/url/-/url-0.11.0.tgz";
        sha1 = "3838e97cfc60521eb73c525a8e55bfdd9e2e28f1";
      };
    }

    {
      name = "user-home-2.0.0.tgz";
      path = fetchurl {
        name = "user-home-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/user-home/-/user-home-2.0.0.tgz";
        sha1 = "9c70bfd8169bc1dcbf48604e0f04b8b49cde9e9f";
      };
    }

    {
      name = "useragent-2.1.12.tgz";
      path = fetchurl {
        name = "useragent-2.1.12.tgz";
        url  = "https://registry.yarnpkg.com/useragent/-/useragent-2.1.12.tgz";
        sha1 = "aa7da6cdc48bdc37ba86790871a7321d64edbaa2";
      };
    }

    {
      name = "util-deprecate-1.0.2.tgz";
      path = fetchurl {
        name = "util-deprecate-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    }

    {
      name = "util-0.10.3.tgz";
      path = fetchurl {
        name = "util-0.10.3.tgz";
        url  = "https://registry.yarnpkg.com/util/-/util-0.10.3.tgz";
        sha1 = "7afb1afe50805246489e3db7fe0ed379336ac0f9";
      };
    }

    {
      name = "utils-merge-1.0.0.tgz";
      path = fetchurl {
        name = "utils-merge-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.0.tgz";
        sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
      };
    }

    {
      name = "uuid-2.0.3.tgz";
      path = fetchurl {
        name = "uuid-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-2.0.3.tgz";
        sha1 = "67e2e863797215530dff318e5bf9dcebfd47b21a";
      };
    }

    {
      name = "uuid-3.0.1.tgz";
      path = fetchurl {
        name = "uuid-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.0.1.tgz";
        sha1 = "6544bba2dfda8c1cf17e629a3a305e2bb1fee6c1";
      };
    }

    {
      name = "validate-npm-package-license-3.0.1.tgz";
      path = fetchurl {
        name = "validate-npm-package-license-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.1.tgz";
        sha1 = "2804babe712ad3379459acfbe24746ab2c303fbc";
      };
    }

    {
      name = "vary-1.1.1.tgz";
      path = fetchurl {
        name = "vary-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/vary/-/vary-1.1.1.tgz";
        sha1 = "67535ebb694c1d52257457984665323f587e8d37";
      };
    }

    {
      name = "vendors-1.0.1.tgz";
      path = fetchurl {
        name = "vendors-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/vendors/-/vendors-1.0.1.tgz";
        sha1 = "37ad73c8ee417fb3d580e785312307d274847f22";
      };
    }

    {
      name = "verror-1.3.6.tgz";
      path = fetchurl {
        name = "verror-1.3.6.tgz";
        url  = "https://registry.yarnpkg.com/verror/-/verror-1.3.6.tgz";
        sha1 = "cff5df12946d297d2baaefaa2689e25be01c005c";
      };
    }

    {
      name = "visibilityjs-1.2.4.tgz";
      path = fetchurl {
        name = "visibilityjs-1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/visibilityjs/-/visibilityjs-1.2.4.tgz";
        sha1 = "bff8663da62c8c10ad4ee5ae6a1ae6fac4259d63";
      };
    }

    {
      name = "vm-browserify-0.0.4.tgz";
      path = fetchurl {
        name = "vm-browserify-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/vm-browserify/-/vm-browserify-0.0.4.tgz";
        sha1 = "5d7ea45bbef9e4a6ff65f95438e0a87c357d5a73";
      };
    }

    {
      name = "void-elements-2.0.1.tgz";
      path = fetchurl {
        name = "void-elements-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/void-elements/-/void-elements-2.0.1.tgz";
        sha1 = "c066afb582bb1cb4128d60ea92392e94d5e9dbec";
      };
    }

    {
      name = "vue-hot-reload-api-2.0.11.tgz";
      path = fetchurl {
        name = "vue-hot-reload-api-2.0.11.tgz";
        url  = "https://registry.yarnpkg.com/vue-hot-reload-api/-/vue-hot-reload-api-2.0.11.tgz";
        sha1 = "bf26374fb73366ce03f799e65ef5dfd0e28a1568";
      };
    }

    {
      name = "vue-loader-11.3.4.tgz";
      path = fetchurl {
        name = "vue-loader-11.3.4.tgz";
        url  = "https://registry.yarnpkg.com/vue-loader/-/vue-loader-11.3.4.tgz";
        sha1 = "65e10a44ce092d906e14bbc72981dec99eb090d2";
      };
    }

    {
      name = "vue-resource-0.9.3.tgz";
      path = fetchurl {
        name = "vue-resource-0.9.3.tgz";
        url  = "https://registry.yarnpkg.com/vue-resource/-/vue-resource-0.9.3.tgz";
        sha1 = "ab46e1c44ea219142dcc28ae4043b3b04c80959d";
      };
    }

    {
      name = "vue-style-loader-2.0.5.tgz";
      path = fetchurl {
        name = "vue-style-loader-2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/vue-style-loader/-/vue-style-loader-2.0.5.tgz";
        sha1 = "f0efac992febe3f12e493e334edb13cd235a3d22";
      };
    }

    {
      name = "vue-template-compiler-2.2.6.tgz";
      path = fetchurl {
        name = "vue-template-compiler-2.2.6.tgz";
        url  = "https://registry.yarnpkg.com/vue-template-compiler/-/vue-template-compiler-2.2.6.tgz";
        sha1 = "2e2928daf0cd0feca9dfc35a9729adeae173ec68";
      };
    }

    {
      name = "vue-template-es2015-compiler-1.5.1.tgz";
      path = fetchurl {
        name = "vue-template-es2015-compiler-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/vue-template-es2015-compiler/-/vue-template-es2015-compiler-1.5.1.tgz";
        sha1 = "0c36cc57aa3a9ec13e846342cb14a72fcac8bd93";
      };
    }

    {
      name = "vue-2.2.6.tgz";
      path = fetchurl {
        name = "vue-2.2.6.tgz";
        url  = "https://registry.yarnpkg.com/vue/-/vue-2.2.6.tgz";
        sha1 = "451714b394dd6d4eae7b773c40c2034a59621aed";
      };
    }

    {
      name = "watchpack-1.3.1.tgz";
      path = fetchurl {
        name = "watchpack-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/watchpack/-/watchpack-1.3.1.tgz";
        sha1 = "7d8693907b28ce6013e7f3610aa2a1acf07dad87";
      };
    }

    {
      name = "wbuf-1.7.2.tgz";
      path = fetchurl {
        name = "wbuf-1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/wbuf/-/wbuf-1.7.2.tgz";
        sha1 = "d697b99f1f59512df2751be42769c1580b5801fe";
      };
    }

    {
      name = "webpack-bundle-analyzer-2.8.2.tgz";
      path = fetchurl {
        name = "webpack-bundle-analyzer-2.8.2.tgz";
        url  = "https://registry.yarnpkg.com/webpack-bundle-analyzer/-/webpack-bundle-analyzer-2.8.2.tgz";
        sha1 = "8b6240c29a9d63bc72f09d920fb050adbcce9fe8";
      };
    }

    {
      name = "webpack-dev-middleware-1.10.0.tgz";
      path = fetchurl {
        name = "webpack-dev-middleware-1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/webpack-dev-middleware/-/webpack-dev-middleware-1.10.0.tgz";
        sha1 = "7d5be2651e692fddfafd8aaed177c16ff51f0eb8";
      };
    }

    {
      name = "webpack-dev-server-2.4.2.tgz";
      path = fetchurl {
        name = "webpack-dev-server-2.4.2.tgz";
        url  = "https://registry.yarnpkg.com/webpack-dev-server/-/webpack-dev-server-2.4.2.tgz";
        sha1 = "cf595d6b40878452b6d2ad7229056b686f8a16be";
      };
    }

    {
      name = "webpack-sources-0.1.4.tgz";
      path = fetchurl {
        name = "webpack-sources-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-0.1.4.tgz";
        sha1 = "ccc2c817e08e5fa393239412690bb481821393cd";
      };
    }

    {
      name = "webpack-sources-0.2.3.tgz";
      path = fetchurl {
        name = "webpack-sources-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-0.2.3.tgz";
        sha1 = "17c62bfaf13c707f9d02c479e0dcdde8380697fb";
      };
    }

    {
      name = "webpack-2.6.1.tgz";
      path = fetchurl {
        name = "webpack-2.6.1.tgz";
        url  = "https://registry.yarnpkg.com/webpack/-/webpack-2.6.1.tgz";
        sha1 = "2e0457f0abb1ac5df3ab106c69c672f236785f07";
      };
    }

    {
      name = "websocket-driver-0.6.5.tgz";
      path = fetchurl {
        name = "websocket-driver-0.6.5.tgz";
        url  = "https://registry.yarnpkg.com/websocket-driver/-/websocket-driver-0.6.5.tgz";
        sha1 = "5cb2556ceb85f4373c6d8238aa691c8454e13a36";
      };
    }

    {
      name = "websocket-extensions-0.1.1.tgz";
      path = fetchurl {
        name = "websocket-extensions-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/websocket-extensions/-/websocket-extensions-0.1.1.tgz";
        sha1 = "76899499c184b6ef754377c2dbb0cd6cb55d29e7";
      };
    }

    {
      name = "whet.extend-0.9.9.tgz";
      path = fetchurl {
        name = "whet.extend-0.9.9.tgz";
        url  = "https://registry.yarnpkg.com/whet.extend/-/whet.extend-0.9.9.tgz";
        sha1 = "f877d5bf648c97e5aa542fadc16d6a259b9c11a1";
      };
    }

    {
      name = "which-module-1.0.0.tgz";
      path = fetchurl {
        name = "which-module-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/which-module/-/which-module-1.0.0.tgz";
        sha1 = "bba63ca861948994ff307736089e3b96026c2a4f";
      };
    }

    {
      name = "which-1.2.12.tgz";
      path = fetchurl {
        name = "which-1.2.12.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-1.2.12.tgz";
        sha1 = "de67b5e450269f194909ef23ece4ebe416fa1192";
      };
    }

    {
      name = "wide-align-1.1.0.tgz";
      path = fetchurl {
        name = "wide-align-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.0.tgz";
        sha1 = "40edde802a71fea1f070da3e62dcda2e7add96ad";
      };
    }

    {
      name = "window-size-0.1.0.tgz";
      path = fetchurl {
        name = "window-size-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/window-size/-/window-size-0.1.0.tgz";
        sha1 = "5438cd2ea93b202efa3a19fe8887aee7c94f9c9d";
      };
    }

    {
      name = "wordwrap-0.0.2.tgz";
      path = fetchurl {
        name = "wordwrap-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wordwrap/-/wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      };
    }

    {
      name = "wordwrap-1.0.0.tgz";
      path = fetchurl {
        name = "wordwrap-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/wordwrap/-/wordwrap-1.0.0.tgz";
        sha1 = "27584810891456a4171c8d0226441ade90cbcaeb";
      };
    }

    {
      name = "wordwrap-0.0.3.tgz";
      path = fetchurl {
        name = "wordwrap-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/wordwrap/-/wordwrap-0.0.3.tgz";
        sha1 = "a3d5da6cd5c0bc0008d37234bbaf1bed63059107";
      };
    }

    {
      name = "worker-loader-0.8.0.tgz";
      path = fetchurl {
        name = "worker-loader-0.8.0.tgz";
        url  = "https://registry.yarnpkg.com/worker-loader/-/worker-loader-0.8.0.tgz";
        sha1 = "13582960dcd7d700dc829d3fd252a7561696167e";
      };
    }

    {
      name = "wrap-ansi-2.1.0.tgz";
      path = fetchurl {
        name = "wrap-ansi-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-2.1.0.tgz";
        sha1 = "d8fc3d284dd05794fe84973caecdd1cf824fdd85";
      };
    }

    {
      name = "wrappy-1.0.2.tgz";
      path = fetchurl {
        name = "wrappy-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    }

    {
      name = "write-file-atomic-1.3.1.tgz";
      path = fetchurl {
        name = "write-file-atomic-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-1.3.1.tgz";
        sha1 = "7d45ba32316328dd1ec7d90f60ebc0d845bb759a";
      };
    }

    {
      name = "write-0.2.1.tgz";
      path = fetchurl {
        name = "write-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/write/-/write-0.2.1.tgz";
        sha1 = "5fc03828e264cea3fe91455476f7a3c566cb0757";
      };
    }

    {
      name = "ws-1.1.1.tgz";
      path = fetchurl {
        name = "ws-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-1.1.1.tgz";
        sha1 = "082ddb6c641e85d4bb451f03d52f06eabdb1f018";
      };
    }

    {
      name = "ws-2.3.1.tgz";
      path = fetchurl {
        name = "ws-2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-2.3.1.tgz";
        sha1 = "6b94b3e447cb6a363f785eaf94af6359e8e81c80";
      };
    }

    {
      name = "wtf-8-1.0.0.tgz";
      path = fetchurl {
        name = "wtf-8-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/wtf-8/-/wtf-8-1.0.0.tgz";
        sha1 = "392d8ba2d0f1c34d1ee2d630f15d0efb68e1048a";
      };
    }

    {
      name = "xdg-basedir-2.0.0.tgz";
      path = fetchurl {
        name = "xdg-basedir-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-2.0.0.tgz";
        sha1 = "edbc903cc385fc04523d966a335504b5504d1bd2";
      };
    }

    {
      name = "xmlhttprequest-ssl-1.5.3.tgz";
      path = fetchurl {
        name = "xmlhttprequest-ssl-1.5.3.tgz";
        url  = "https://registry.yarnpkg.com/xmlhttprequest-ssl/-/xmlhttprequest-ssl-1.5.3.tgz";
        sha1 = "185a888c04eca46c3e4070d99f7b49de3528992d";
      };
    }

    {
      name = "xtend-4.0.1.tgz";
      path = fetchurl {
        name = "xtend-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.1.tgz";
        sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
      };
    }

    {
      name = "y18n-3.2.1.tgz";
      path = fetchurl {
        name = "y18n-3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-3.2.1.tgz";
        sha1 = "6d15fba884c08679c0d77e88e7759e811e07fa41";
      };
    }

    {
      name = "yallist-2.1.2.tgz";
      path = fetchurl {
        name = "yallist-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz";
        sha1 = "1c11f9218f076089a47dd512f93c6699a6a81d52";
      };
    }

    {
      name = "yargs-parser-4.2.1.tgz";
      path = fetchurl {
        name = "yargs-parser-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-4.2.1.tgz";
        sha1 = "29cceac0dc4f03c6c87b4a9f217dd18c9f74871c";
      };
    }

    {
      name = "yargs-6.6.0.tgz";
      path = fetchurl {
        name = "yargs-6.6.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-6.6.0.tgz";
        sha1 = "782ec21ef403345f830a808ca3d513af56065208";
      };
    }

    {
      name = "yargs-3.10.0.tgz";
      path = fetchurl {
        name = "yargs-3.10.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-3.10.0.tgz";
        sha1 = "f7ee7bd857dd7c1d2d38c0e74efbd681d1431fd1";
      };
    }

    {
      name = "yauzl-2.4.1.tgz";
      path = fetchurl {
        name = "yauzl-2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/yauzl/-/yauzl-2.4.1.tgz";
        sha1 = "9528f442dab1b2284e58b4379bb194e22e0c4005";
      };
    }

    {
      name = "yeast-0.1.2.tgz";
      path = fetchurl {
        name = "yeast-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/yeast/-/yeast-0.1.2.tgz";
        sha1 = "008e06d8094320c372dbc2f8ed76a0ca6c8ac419";
      };
    }
  ];
}
