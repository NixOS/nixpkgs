{fetchurl, linkFarm}: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [

    {
      name = "zip-obj-1.1.1.tgz";
      path = fetchurl {
        name = "zip-obj-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@f/zip-obj/-/zip-obj-1.1.1.tgz";
        sha1 = "efbdfd3e890db2ad9d63c772d1622665fe065743";
      };
    }

    {
      name = "5bf5336c4315a24b5ae9a6019c5ae642e719f6bb";
      path = fetchurl {
        name = "5bf5336c4315a24b5ae9a6019c5ae642e719f6bb";
        url  = "https://codeload.github.com/ssbc/paulcbetts-cld-prebuilt/tar.gz/5bf5336c4315a24b5ae9a6019c5ae642e719f6bb";
        sha1 = "c02c341304692332968c20bb6c1932c23d9b4d7c";
      };
    }

    {
      name = "d3215b81ae72d15983ad403615053e2efd734134";
      path = fetchurl {
        name = "d3215b81ae72d15983ad403615053e2efd734134";
        url  = "https://codeload.github.com/ssbc/paulcbetts-spellchecker-prebuilt/tar.gz/d3215b81ae72d15983ad403615053e2efd734134";
        sha1 = "37dd8d1fdbd90e6b7d32570167de96c92d9f8165";
      };
    }

    {
      name = "node-8.9.4.tgz";
      path = fetchurl {
        name = "node-8.9.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-8.9.4.tgz";
        sha1 = "dfd327582a06c114eb6e0441fa3d6fab35edad48";
      };
    }

    {
      name = "abbrev-1.1.1.tgz";
      path = fetchurl {
        name = "abbrev-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz";
        sha1 = "f8f2c887ad10bf67f634f005b6987fed3179aac8";
      };
    }

    {
      name = "abstract-leveldown-0.12.4.tgz";
      path = fetchurl {
        name = "abstract-leveldown-0.12.4.tgz";
        url  = "https://registry.yarnpkg.com/abstract-leveldown/-/abstract-leveldown-0.12.4.tgz";
        sha1 = "29e18e632e60e4e221d5810247852a63d7b2e410";
      };
    }

    {
      name = "abstract-leveldown-2.6.3.tgz";
      path = fetchurl {
        name = "abstract-leveldown-2.6.3.tgz";
        url  = "https://registry.yarnpkg.com/abstract-leveldown/-/abstract-leveldown-2.6.3.tgz";
        sha1 = "1c5e8c6a5ef965ae8c35dfb3a8770c476b82c4b8";
      };
    }

    {
      name = "acorn-5.4.1.tgz";
      path = fetchurl {
        name = "acorn-5.4.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-5.4.1.tgz";
        sha1 = "fdc58d9d17f4a4e98d102ded826a9b9759125102";
      };
    }

    {
      name = "ajv-4.11.8.tgz";
      path = fetchurl {
        name = "ajv-4.11.8.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-4.11.8.tgz";
        sha1 = "82ffb02b29e662ae53bdc20af15947706739c536";
      };
    }

    {
      name = "ajv-5.5.2.tgz";
      path = fetchurl {
        name = "ajv-5.5.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-5.5.2.tgz";
        sha1 = "73b5eeca3fab653e3d3f9422b341ad42205dc965";
      };
    }

    {
      name = "aligned-block-file-1.1.2.tgz";
      path = fetchurl {
        name = "aligned-block-file-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/aligned-block-file/-/aligned-block-file-1.1.2.tgz";
        sha1 = "4a9168d5fefe5e2f525949dc55a4aa09903b32d4";
      };
    }

    {
      name = "ambi-2.5.0.tgz";
      path = fetchurl {
        name = "ambi-2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/ambi/-/ambi-2.5.0.tgz";
        sha1 = "7c8e372be48891157e7cea01cb6f9143d1f74220";
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
      name = "anymatch-1.3.2.tgz";
      path = fetchurl {
        name = "anymatch-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-1.3.2.tgz";
        sha1 = "553dcb8f91e3c889845dfdba34c77721b90b9d7a";
      };
    }

    {
      name = "app-root-path-2.0.1.tgz";
      path = fetchurl {
        name = "app-root-path-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/app-root-path/-/app-root-path-2.0.1.tgz";
        sha1 = "cd62dcf8e4fd5a417efc664d2e5b10653c651b46";
      };
    }

    {
      name = "append-batch-0.0.1.tgz";
      path = fetchurl {
        name = "append-batch-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/append-batch/-/append-batch-0.0.1.tgz";
        sha1 = "9224858e556997ccc07f11f1ee9a128532aa0d25";
      };
    }

    {
      name = "aproba-1.2.0.tgz";
      path = fetchurl {
        name = "aproba-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz";
        sha1 = "6802e6264efd18c790a1b0d517f0f2627bf2c94a";
      };
    }

    {
      name = "are-we-there-yet-1.1.4.tgz";
      path = fetchurl {
        name = "are-we-there-yet-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.4.tgz";
        sha1 = "bb5dca382bb94f05e15194373d16fd3ba1ca110d";
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
      name = "arr-flatten-1.1.0.tgz";
      path = fetchurl {
        name = "arr-flatten-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz";
        sha1 = "36048bbff4e7b47e136644316c99669ea5ae91f1";
      };
    }

    {
      name = "array-find-index-1.0.2.tgz";
      path = fetchurl {
        name = "array-find-index-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/array-find-index/-/array-find-index-1.0.2.tgz";
        sha1 = "df010aa1287e164bbda6f9723b0a96a1ec4187a1";
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
      name = "arraybuffer-base64-1.0.0.tgz";
      path = fetchurl {
        name = "arraybuffer-base64-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/arraybuffer-base64/-/arraybuffer-base64-1.0.0.tgz";
        sha1 = "fd0217ba2ba8d48633663fa43a8093768029da30";
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
      name = "asn1-0.2.3.tgz";
      path = fetchurl {
        name = "asn1-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/asn1/-/asn1-0.2.3.tgz";
        sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
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
      name = "assert-plus-0.2.0.tgz";
      path = fetchurl {
        name = "assert-plus-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-0.2.0.tgz";
        sha1 = "d74e1b87e7affc0db8aadb7021f3fe48101ab234";
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
      name = "async-single-1.0.5.tgz";
      path = fetchurl {
        name = "async-single-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/async-single/-/async-single-1.0.5.tgz";
        sha1 = "125dd09de95d3ea30a378adbed021092179b03c9";
      };
    }

    {
      name = "async-write-2.1.0.tgz";
      path = fetchurl {
        name = "async-write-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/async-write/-/async-write-2.1.0.tgz";
        sha1 = "1e762817d849ce44bfac07925a42036787061b15";
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
      name = "asynckit-0.4.0.tgz";
      path = fetchurl {
        name = "asynckit-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz";
        sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
      };
    }

    {
      name = "atomic-file-0.0.1.tgz";
      path = fetchurl {
        name = "atomic-file-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/atomic-file/-/atomic-file-0.0.1.tgz";
        sha1 = "6c36658f6c4ece33fba3877731e7c25fc82999bb";
      };
    }

    {
      name = "atomic-file-1.1.4.tgz";
      path = fetchurl {
        name = "atomic-file-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/atomic-file/-/atomic-file-1.1.4.tgz";
        sha1 = "66152e39fce8b2b0c7e5f262e0a1a5d3ab3aab51";
      };
    }

    {
      name = "attach-ware-1.1.1.tgz";
      path = fetchurl {
        name = "attach-ware-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/attach-ware/-/attach-ware-1.1.1.tgz";
        sha1 = "28f51393dd8bb8bdaad972342519bf09621a35a3";
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
      name = "aws-sign2-0.7.0.tgz";
      path = fetchurl {
        name = "aws-sign2-0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.7.0.tgz";
        sha1 = "b46e890934a9591f2d2f6f86d7e6a9f1b3fe76a8";
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
      name = "babel-code-frame-6.26.0.tgz";
      path = fetchurl {
        name = "babel-code-frame-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-code-frame/-/babel-code-frame-6.26.0.tgz";
        sha1 = "63fd43f7dc1e3bb7ce35947db8fe369a3f58c74b";
      };
    }

    {
      name = "babel-core-6.26.0.tgz";
      path = fetchurl {
        name = "babel-core-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-core/-/babel-core-6.26.0.tgz";
        sha1 = "af32f78b31a6fcef119c87b0fd8d9753f03a0bb8";
      };
    }

    {
      name = "babel-generator-6.26.1.tgz";
      path = fetchurl {
        name = "babel-generator-6.26.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-generator/-/babel-generator-6.26.1.tgz";
        sha1 = "1844408d3b8f0d35a404ea7ac180f087a601bd90";
      };
    }

    {
      name = "babel-helper-call-delegate-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-call-delegate-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-call-delegate/-/babel-helper-call-delegate-6.24.1.tgz";
        sha1 = "ece6aacddc76e41c3461f88bfc575bd0daa2df8d";
      };
    }

    {
      name = "babel-helper-get-function-arity-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-get-function-arity-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-get-function-arity/-/babel-helper-get-function-arity-6.24.1.tgz";
        sha1 = "8f7782aa93407c41d3aa50908f89b031b1b6853d";
      };
    }

    {
      name = "babel-helper-hoist-variables-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-hoist-variables-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-hoist-variables/-/babel-helper-hoist-variables-6.24.1.tgz";
        sha1 = "1ecb27689c9d25513eadbc9914a73f5408be7a76";
      };
    }

    {
      name = "babel-helpers-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helpers-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helpers/-/babel-helpers-6.24.1.tgz";
        sha1 = "3471de9caec388e5c850e597e58a26ddf37602b2";
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
      name = "babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-arrow-functions/-/babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
        sha1 = "452692cb711d5f79dc7f85e440ce41b9f244d221";
      };
    }

    {
      name = "babel-plugin-transform-es2015-block-scoping-6.26.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-block-scoping-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-block-scoping/-/babel-plugin-transform-es2015-block-scoping-6.26.0.tgz";
        sha1 = "d70f5299c1308d05c12f463813b0a09e73b1895f";
      };
    }

    {
      name = "babel-plugin-transform-es2015-computed-properties-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-computed-properties-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-computed-properties/-/babel-plugin-transform-es2015-computed-properties-6.24.1.tgz";
        sha1 = "6fe2a8d16895d5634f4cd999b6d3480a308159b3";
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
      name = "babel-plugin-transform-es2015-parameters-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-parameters-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-parameters/-/babel-plugin-transform-es2015-parameters-6.24.1.tgz";
        sha1 = "57ac351ab49caf14a97cd13b09f66fdf0a625f2b";
      };
    }

    {
      name = "babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-shorthand-properties/-/babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz";
        sha1 = "24f875d6721c87661bbd99a4622e51f14de38aa0";
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
      name = "babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-template-literals/-/babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
        sha1 = "a84b3450f7e9f8f1f6839d6d687da84bb1236d8d";
      };
    }

    {
      name = "babel-preset-es2040-1.1.1.tgz";
      path = fetchurl {
        name = "babel-preset-es2040-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-es2040/-/babel-preset-es2040-1.1.1.tgz";
        sha1 = "408cc33724708205c780667b930fa78df5bc8f94";
      };
    }

    {
      name = "babel-register-6.26.0.tgz";
      path = fetchurl {
        name = "babel-register-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-register/-/babel-register-6.26.0.tgz";
        sha1 = "6ed021173e2fcb486d7acb45c6009a856f647071";
      };
    }

    {
      name = "babel-runtime-6.26.0.tgz";
      path = fetchurl {
        name = "babel-runtime-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.26.0.tgz";
        sha1 = "965c7058668e82b55d7bfe04ff2337bc8b5647fe";
      };
    }

    {
      name = "babel-template-6.26.0.tgz";
      path = fetchurl {
        name = "babel-template-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-template/-/babel-template-6.26.0.tgz";
        sha1 = "de03e2d16396b069f46dd9fff8521fb1a0e35e02";
      };
    }

    {
      name = "babel-traverse-6.26.0.tgz";
      path = fetchurl {
        name = "babel-traverse-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-traverse/-/babel-traverse-6.26.0.tgz";
        sha1 = "46a9cbd7edcc62c8e5c064e2d2d8d0f4035766ee";
      };
    }

    {
      name = "babel-types-6.26.0.tgz";
      path = fetchurl {
        name = "babel-types-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-types/-/babel-types-6.26.0.tgz";
        sha1 = "a3b073f94ab49eb6fa55cd65227a334380632497";
      };
    }

    {
      name = "babylon-6.18.0.tgz";
      path = fetchurl {
        name = "babylon-6.18.0.tgz";
        url  = "https://registry.yarnpkg.com/babylon/-/babylon-6.18.0.tgz";
        sha1 = "af2f3b88fa6f5c1e4c634d1a0f8eac4f55b395e3";
      };
    }

    {
      name = "bail-1.0.2.tgz";
      path = fetchurl {
        name = "bail-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/bail/-/bail-1.0.2.tgz";
        sha1 = "f7d6c1731630a9f9f0d4d35ed1f962e2074a1764";
      };
    }

    {
      name = "balanced-match-1.0.0.tgz";
      path = fetchurl {
        name = "balanced-match-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
      };
    }

    {
      name = "base64-url-1.3.3.tgz";
      path = fetchurl {
        name = "base64-url-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/base64-url/-/base64-url-1.3.3.tgz";
        sha1 = "f8b6c537f09a4fc58c99cb86e0b0e9c61461a20f";
      };
    }

    {
      name = "bash-color-0.0.4.tgz";
      path = fetchurl {
        name = "bash-color-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/bash-color/-/bash-color-0.0.4.tgz";
        sha1 = "e9be8ce33540cada4881768c59bd63865736e913";
      };
    }

    {
      name = "bcp47-1.1.2.tgz";
      path = fetchurl {
        name = "bcp47-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/bcp47/-/bcp47-1.1.2.tgz";
        sha1 = "354be3307ffd08433a78f5e1e2095845f89fc7fe";
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
      name = "binary-extensions-1.11.0.tgz";
      path = fetchurl {
        name = "binary-extensions-1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.11.0.tgz";
        sha1 = "46aa1751fb6a2f93ee5e689bb1087d4b14c6c205";
      };
    }

    {
      name = "binary-search-1.3.3.tgz";
      path = fetchurl {
        name = "binary-search-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/binary-search/-/binary-search-1.3.3.tgz";
        sha1 = "b5adb6fb279a197be51b1ee8b0fb76fcdc61b429";
      };
    }

    {
      name = "binary-xhr-0.0.2.tgz";
      path = fetchurl {
        name = "binary-xhr-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/binary-xhr/-/binary-xhr-0.0.2.tgz";
        sha1 = "210cb075ad177aa448a6efa288c10a899c3b3987";
      };
    }

    {
      name = "bindings-1.2.1.tgz";
      path = fetchurl {
        name = "bindings-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/bindings/-/bindings-1.2.1.tgz";
        sha1 = "14ad6113812d2d37d72e67b4cacb4bb726505f11";
      };
    }

    {
      name = "bl-1.2.1.tgz";
      path = fetchurl {
        name = "bl-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/bl/-/bl-1.2.1.tgz";
        sha1 = "cac328f7bee45730d404b692203fcb590e172d5e";
      };
    }

    {
      name = "bl-0.8.2.tgz";
      path = fetchurl {
        name = "bl-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/bl/-/bl-0.8.2.tgz";
        sha1 = "c9b6bca08d1bc2ea00fc8afb4f1a5fd1e1c66e4e";
      };
    }

    {
      name = "blake2s-1.0.1.tgz";
      path = fetchurl {
        name = "blake2s-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/blake2s/-/blake2s-1.0.1.tgz";
        sha1 = "1598822a320ece6aa401ba982954f82f61b0cd7b";
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
      name = "boom-2.10.1.tgz";
      path = fetchurl {
        name = "boom-2.10.1.tgz";
        url  = "https://registry.yarnpkg.com/boom/-/boom-2.10.1.tgz";
        sha1 = "39c8918ceff5799f83f9492a848f625add0c766f";
      };
    }

    {
      name = "boom-4.3.1.tgz";
      path = fetchurl {
        name = "boom-4.3.1.tgz";
        url  = "https://registry.yarnpkg.com/boom/-/boom-4.3.1.tgz";
        sha1 = "4f8a3005cb4a7e3889f749030fd25b96e01d2e31";
      };
    }

    {
      name = "boom-5.2.0.tgz";
      path = fetchurl {
        name = "boom-5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/boom/-/boom-5.2.0.tgz";
        sha1 = "5dd9da6ee3a5f302077436290cb717d3f4a54e02";
      };
    }

    {
      name = "brace-expansion-1.1.11.tgz";
      path = fetchurl {
        name = "brace-expansion-1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha1 = "3c7fcbf529d87226f3d2f52b966ff5271eb441dd";
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
      name = "broadcast-stream-0.2.2.tgz";
      path = fetchurl {
        name = "broadcast-stream-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/broadcast-stream/-/broadcast-stream-0.2.2.tgz";
        sha1 = "79e7bb14a9abba77f72ac9258220242a8fd3919d";
      };
    }

    {
      name = "browser-split-0.0.0.tgz";
      path = fetchurl {
        name = "browser-split-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/browser-split/-/browser-split-0.0.0.tgz";
        sha1 = "41419caef769755929dd518967d3eec0a6262771";
      };
    }

    {
      name = "browser-split-0.0.1.tgz";
      path = fetchurl {
        name = "browser-split-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browser-split/-/browser-split-0.0.1.tgz";
        sha1 = "7b097574f8e3ead606fb4664e64adfdda2981a93";
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
      name = "bulk-require-1.0.1.tgz";
      path = fetchurl {
        name = "bulk-require-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/bulk-require/-/bulk-require-1.0.1.tgz";
        sha1 = "cb3d039e698139a444fc574b261d6b3b2cf44c89";
      };
    }

    {
      name = "bulkify-1.4.2.tgz";
      path = fetchurl {
        name = "bulkify-1.4.2.tgz";
        url  = "https://registry.yarnpkg.com/bulkify/-/bulkify-1.4.2.tgz";
        sha1 = "7848f0f3ab97f12a41b923bf90e53e09eaafba4c";
      };
    }

    {
      name = "bytewise-core-1.2.3.tgz";
      path = fetchurl {
        name = "bytewise-core-1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/bytewise-core/-/bytewise-core-1.2.3.tgz";
        sha1 = "3fb410c7e91558eb1ab22a82834577aa6bd61d42";
      };
    }

    {
      name = "bytewise-1.1.0.tgz";
      path = fetchurl {
        name = "bytewise-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/bytewise/-/bytewise-1.1.0.tgz";
        sha1 = "1d13cbff717ae7158094aa881b35d081b387253e";
      };
    }

    {
      name = "camelcase-keys-2.1.0.tgz";
      path = fetchurl {
        name = "camelcase-keys-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-2.1.0.tgz";
        sha1 = "308beeaffdf28119051efa1d932213c91b8f92e7";
      };
    }

    {
      name = "camelcase-2.1.1.tgz";
      path = fetchurl {
        name = "camelcase-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-2.1.1.tgz";
        sha1 = "7c1d16d679a1bbe59ca02cacecfb011e201f5a1f";
      };
    }

    {
      name = "caseless-0.12.0.tgz";
      path = fetchurl {
        name = "caseless-0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz";
        sha1 = "1b681c21ff84033c826543090689420d187151dc";
      };
    }

    {
      name = "ccount-1.0.2.tgz";
      path = fetchurl {
        name = "ccount-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ccount/-/ccount-1.0.2.tgz";
        sha1 = "53b6a2f815bb77b9c2871f7b9a72c3a25f1d8e89";
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
      name = "character-entities-html4-1.1.1.tgz";
      path = fetchurl {
        name = "character-entities-html4-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/character-entities-html4/-/character-entities-html4-1.1.1.tgz";
        sha1 = "359a2a4a0f7e29d3dc2ac99bdbe21ee39438ea50";
      };
    }

    {
      name = "character-entities-legacy-1.1.1.tgz";
      path = fetchurl {
        name = "character-entities-legacy-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/character-entities-legacy/-/character-entities-legacy-1.1.1.tgz";
        sha1 = "f40779df1a101872bb510a3d295e1fccf147202f";
      };
    }

    {
      name = "character-entities-1.2.1.tgz";
      path = fetchurl {
        name = "character-entities-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/character-entities/-/character-entities-1.2.1.tgz";
        sha1 = "f76871be5ef66ddb7f8f8e3478ecc374c27d6dca";
      };
    }

    {
      name = "character-reference-invalid-1.1.1.tgz";
      path = fetchurl {
        name = "character-reference-invalid-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/character-reference-invalid/-/character-reference-invalid-1.1.1.tgz";
        sha1 = "942835f750e4ec61a308e60c2ef8cc1011202efc";
      };
    }

    {
      name = "chloride-test-1.2.2.tgz";
      path = fetchurl {
        name = "chloride-test-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/chloride-test/-/chloride-test-1.2.2.tgz";
        sha1 = "178686a85e9278045112e96e8c791793f9a10aea";
      };
    }

    {
      name = "chloride-2.2.8.tgz";
      path = fetchurl {
        name = "chloride-2.2.8.tgz";
        url  = "https://registry.yarnpkg.com/chloride/-/chloride-2.2.8.tgz";
        sha1 = "ebf9a8b3ca89a7447c360396dadf817c8a98d599";
      };
    }

    {
      name = "chokidar-1.7.0.tgz";
      path = fetchurl {
        name = "chokidar-1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/chokidar/-/chokidar-1.7.0.tgz";
        sha1 = "798e689778151c8076b4b360e5edd28cda2bb468";
      };
    }

    {
      name = "chownr-1.0.1.tgz";
      path = fetchurl {
        name = "chownr-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/chownr/-/chownr-1.0.1.tgz";
        sha1 = "e2a75042a9551908bebd25b8523d5f9769d79181";
      };
    }

    {
      name = "class-list-0.1.1.tgz";
      path = fetchurl {
        name = "class-list-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/class-list/-/class-list-0.1.1.tgz";
        sha1 = "9b9745192c4179b5da0a0d7633658e3c70d796cb";
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
      name = "clone-regexp-1.0.0.tgz";
      path = fetchurl {
        name = "clone-regexp-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/clone-regexp/-/clone-regexp-1.0.0.tgz";
        sha1 = "eae0a2413f55c0942f818c229fefce845d7f3b1c";
      };
    }

    {
      name = "co-3.1.0.tgz";
      path = fetchurl {
        name = "co-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/co/-/co-3.1.0.tgz";
        sha1 = "4ea54ea5a08938153185e15210c68d9092bc1b78";
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
      name = "code-point-at-1.1.0.tgz";
      path = fetchurl {
        name = "code-point-at-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz";
        sha1 = "0d070b4d043a5bea33a2f1a40e2edb3d9a4ccf77";
      };
    }

    {
      name = "coffee-script-1.12.7.tgz";
      path = fetchurl {
        name = "coffee-script-1.12.7.tgz";
        url  = "https://registry.yarnpkg.com/coffee-script/-/coffee-script-1.12.7.tgz";
        sha1 = "c05dae0cb79591d05b3070a8433a98c9a89ccc53";
      };
    }

    {
      name = "collapse-white-space-1.0.3.tgz";
      path = fetchurl {
        name = "collapse-white-space-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/collapse-white-space/-/collapse-white-space-1.0.3.tgz";
        sha1 = "4b906f670e5a963a87b76b0e1689643341b6023c";
      };
    }

    {
      name = "color-hash-1.0.3.tgz";
      path = fetchurl {
        name = "color-hash-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/color-hash/-/color-hash-1.0.3.tgz";
        sha1 = "c0e7952f06d022e548e65da239512bd67d3809ee";
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
      name = "combined-stream-1.0.6.tgz";
      path = fetchurl {
        name = "combined-stream-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.6.tgz";
        sha1 = "723e7df6e801ac5613113a7e445a9b69cb632818";
      };
    }

    {
      name = "commander-2.14.1.tgz";
      path = fetchurl {
        name = "commander-2.14.1.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.14.1.tgz";
        sha1 = "2235123e37af8ca3c65df45b026dbd357b01b9aa";
      };
    }

    {
      name = "compare-version-0.1.2.tgz";
      path = fetchurl {
        name = "compare-version-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/compare-version/-/compare-version-0.1.2.tgz";
        sha1 = "0162ec2d9351f5ddd59a9202cba935366a725080";
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
      name = "concat-stream-1.6.0.tgz";
      path = fetchurl {
        name = "concat-stream-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.0.tgz";
        sha1 = "0aac662fd52be78964d5532f694784e70110acf7";
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
      name = "cont-1.0.3.tgz";
      path = fetchurl {
        name = "cont-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/cont/-/cont-1.0.3.tgz";
        sha1 = "6874f1e935fca99d048caeaaad9a0aeb020bcce0";
      };
    }

    {
      name = "continuable-hash-0.1.4.tgz";
      path = fetchurl {
        name = "continuable-hash-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/continuable-hash/-/continuable-hash-0.1.4.tgz";
        sha1 = "81c74d41771d8c92783e1e00e5f11b34d6dfc78c";
      };
    }

    {
      name = "continuable-list-0.1.6.tgz";
      path = fetchurl {
        name = "continuable-list-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/continuable-list/-/continuable-list-0.1.6.tgz";
        sha1 = "87cf06ec580716e10dff95fb0b84c5f0e8acac5f";
      };
    }

    {
      name = "continuable-para-1.2.0.tgz";
      path = fetchurl {
        name = "continuable-para-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/continuable-para/-/continuable-para-1.2.0.tgz";
        sha1 = "445510f649459dd0fc35c872015146122731c583";
      };
    }

    {
      name = "continuable-series-1.2.0.tgz";
      path = fetchurl {
        name = "continuable-series-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/continuable-series/-/continuable-series-1.2.0.tgz";
        sha1 = "3243397ae93a71d655b3026834a51590b958b9e8";
      };
    }

    {
      name = "continuable-1.1.8.tgz";
      path = fetchurl {
        name = "continuable-1.1.8.tgz";
        url  = "https://registry.yarnpkg.com/continuable/-/continuable-1.1.8.tgz";
        sha1 = "dc877b474160870ae3bcde87336268ebe50597d5";
      };
    }

    {
      name = "continuable-1.2.0.tgz";
      path = fetchurl {
        name = "continuable-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/continuable/-/continuable-1.2.0.tgz";
        sha1 = "08277468d41136200074ccf87294308d169f25b6";
      };
    }

    {
      name = "convert-source-map-1.5.1.tgz";
      path = fetchurl {
        name = "convert-source-map-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.5.1.tgz";
        sha1 = "b8278097b9bc229365de5c62cf5fcaed8b5599e5";
      };
    }

    {
      name = "core-js-2.5.3.tgz";
      path = fetchurl {
        name = "core-js-2.5.3.tgz";
        url  = "https://registry.yarnpkg.com/core-js/-/core-js-2.5.3.tgz";
        sha1 = "8acc38345824f16d8365b7c9b4259168e8ed603e";
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
      name = "cross-script-1.0.5.tgz";
      path = fetchurl {
        name = "cross-script-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/cross-script/-/cross-script-1.0.5.tgz";
        sha1 = "a7bb257962d9ff926814b243cbc36bbbb0e91569";
      };
    }

    {
      name = "cross-spawn-4.0.2.tgz";
      path = fetchurl {
        name = "cross-spawn-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-4.0.2.tgz";
        sha1 = "7b9247621c23adfdd3856004a823cbe397424d41";
      };
    }

    {
      name = "cross-spawn-5.1.0.tgz";
      path = fetchurl {
        name = "cross-spawn-5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-5.1.0.tgz";
        sha1 = "e8bd0efee58fcff6f8f94510a0a554bbfa235449";
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
      name = "cryptiles-3.1.2.tgz";
      path = fetchurl {
        name = "cryptiles-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/cryptiles/-/cryptiles-3.1.2.tgz";
        sha1 = "a89fbb220f5ce25ec56e8c4aa8a4fd7b5b0d29fe";
      };
    }

    {
      name = "csextends-1.1.1.tgz";
      path = fetchurl {
        name = "csextends-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/csextends/-/csextends-1.1.1.tgz";
        sha1 = "cc53c1349faf7f0ae6cdf6f6c4a4d9156d3c4ec1";
      };
    }

    {
      name = "currently-unhandled-0.4.1.tgz";
      path = fetchurl {
        name = "currently-unhandled-0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/currently-unhandled/-/currently-unhandled-0.4.1.tgz";
        sha1 = "988df33feab191ef799a61369dd76c17adf957ea";
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
      name = "debug-3.1.0.tgz";
      path = fetchurl {
        name = "debug-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.1.0.tgz";
        sha1 = "5bb5a0672628b64149566ba16819e61518c67261";
      };
    }

    {
      name = "debug-2.6.9.tgz";
      path = fetchurl {
        name = "debug-2.6.9.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha1 = "5d128515df134ff327e90a4c93f4e077a536341f";
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
      name = "decompress-response-3.3.0.tgz";
      path = fetchurl {
        name = "decompress-response-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/decompress-response/-/decompress-response-3.3.0.tgz";
        sha1 = "80a4dd323748384bfa248083622aedec982adff3";
      };
    }

    {
      name = "deep-equal-1.0.1.tgz";
      path = fetchurl {
        name = "deep-equal-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/deep-equal/-/deep-equal-1.0.1.tgz";
        sha1 = "f5d260292b660e084eff4cdbc9f08ad3247448b5";
      };
    }

    {
      name = "deep-equal-0.2.2.tgz";
      path = fetchurl {
        name = "deep-equal-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/deep-equal/-/deep-equal-0.2.2.tgz";
        sha1 = "84b745896f34c684e98f2ce0e42abaf43bba017d";
      };
    }

    {
      name = "deep-extend-0.4.2.tgz";
      path = fetchurl {
        name = "deep-extend-0.4.2.tgz";
        url  = "https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.4.2.tgz";
        sha1 = "48b699c27e334bf89f10892be432f6e4c7d34a7f";
      };
    }

    {
      name = "deep-extend-0.2.11.tgz";
      path = fetchurl {
        name = "deep-extend-0.2.11.tgz";
        url  = "https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.2.11.tgz";
        sha1 = "7a16ba69729132340506170494bc83f7076fe08f";
      };
    }

    {
      name = "default-shell-1.0.1.tgz";
      path = fetchurl {
        name = "default-shell-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/default-shell/-/default-shell-1.0.1.tgz";
        sha1 = "752304bddc6174f49eb29cb988feea0b8813c8bc";
      };
    }

    {
      name = "deferred-leveldown-0.2.0.tgz";
      path = fetchurl {
        name = "deferred-leveldown-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/deferred-leveldown/-/deferred-leveldown-0.2.0.tgz";
        sha1 = "2cef1f111e1c57870d8bbb8af2650e587cd2f5b4";
      };
    }

    {
      name = "deferred-leveldown-1.2.2.tgz";
      path = fetchurl {
        name = "deferred-leveldown-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/deferred-leveldown/-/deferred-leveldown-1.2.2.tgz";
        sha1 = "3acd2e0b75d1669924bc0a4b642851131173e1eb";
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
      name = "delegates-1.0.0.tgz";
      path = fetchurl {
        name = "delegates-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz";
        sha1 = "84c6e159b81904fdca59a0ef44cd870d31250f9a";
      };
    }

    {
      name = "depject-4.1.1.tgz";
      path = fetchurl {
        name = "depject-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/depject/-/depject-4.1.1.tgz";
        sha1 = "ebf72208682c11fc7d051223c46eb6db78d56058";
      };
    }

    {
      name = "depnest-1.3.0.tgz";
      path = fetchurl {
        name = "depnest-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/depnest/-/depnest-1.3.0.tgz";
        sha1 = "14bd8a361df445d2d34f7ecb362d6c7457288959";
      };
    }

    {
      name = "detab-1.0.2.tgz";
      path = fetchurl {
        name = "detab-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/detab/-/detab-1.0.2.tgz";
        sha1 = "01bc2a4abe7bc7cc67c3039808edbae47049a0ee";
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
      name = "detect-libc-1.0.3.tgz";
      path = fetchurl {
        name = "detect-libc-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/detect-libc/-/detect-libc-1.0.3.tgz";
        sha1 = "fa137c4bd698edf55cd5cd02ac559f91a4c4ba9b";
      };
    }

    {
      name = "duplexer2-0.0.2.tgz";
      path = fetchurl {
        name = "duplexer2-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/duplexer2/-/duplexer2-0.0.2.tgz";
        sha1 = "c614dcf67e2fb14995a91711e5a617e8a60a31db";
      };
    }

    {
      name = "eachr-2.0.4.tgz";
      path = fetchurl {
        name = "eachr-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/eachr/-/eachr-2.0.4.tgz";
        sha1 = "466f7caa10708f610509e32c807aafe57fc122bf";
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
      name = "ed2curve-0.1.4.tgz";
      path = fetchurl {
        name = "ed2curve-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/ed2curve/-/ed2curve-0.1.4.tgz";
        sha1 = "94a44248bb87da35db0eff7af0aa576168117f59";
      };
    }

    {
      name = "editions-1.3.4.tgz";
      path = fetchurl {
        name = "editions-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/editions/-/editions-1.3.4.tgz";
        sha1 = "3662cb592347c3168eb8e498a0ff73271d67f50b";
      };
    }

    {
      name = "electron-default-menu-1.0.1.tgz";
      path = fetchurl {
        name = "electron-default-menu-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/electron-default-menu/-/electron-default-menu-1.0.1.tgz";
        sha1 = "3173c5018eb507404fec63bdf3b78c38eedba808";
      };
    }

    {
      name = "electron-download-3.3.0.tgz";
      path = fetchurl {
        name = "electron-download-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-download/-/electron-download-3.3.0.tgz";
        sha1 = "2cfd54d6966c019c4d49ad65fbe65cc9cdef68c8";
      };
    }

    {
      name = "electron-remote-1.2.0.tgz";
      path = fetchurl {
        name = "electron-remote-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/electron-remote/-/electron-remote-1.2.0.tgz";
        sha1 = "0f00c1d3803ce7651117f6fb6f274d26781ef9bd";
      };
    }

    {
      name = "9b48778b1649cefea397f3875ee59289466c80c2";
      path = fetchurl {
        name = "9b48778b1649cefea397f3875ee59289466c80c2";
        url  = "https://codeload.github.com/ssbc/electron-spellchecker-prebuilt/tar.gz/9b48778b1649cefea397f3875ee59289466c80c2";
        sha1 = "06c0a1938695a0572e7e5f23028667096e6dca85";
      };
    }

    {
      name = "electron-window-state-4.1.1.tgz";
      path = fetchurl {
        name = "electron-window-state-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/electron-window-state/-/electron-window-state-4.1.1.tgz";
        sha1 = "6b34fdc31b38514dfec8b7c8f7b5d4addb67632d";
      };
    }

    {
      name = "electron-1.8.2.tgz";
      path = fetchurl {
        name = "electron-1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/electron/-/electron-1.8.2.tgz";
        sha1 = "a817cd733c2972b3c7cc4f777caf6e424b88014d";
      };
    }

    {
      name = "elegant-spinner-1.0.1.tgz";
      path = fetchurl {
        name = "elegant-spinner-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/elegant-spinner/-/elegant-spinner-1.0.1.tgz";
        sha1 = "db043521c95d7e303fd8f345bedc3349cfb0729e";
      };
    }

    {
      name = "emoji-named-characters-1.0.2.tgz";
      path = fetchurl {
        name = "emoji-named-characters-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/emoji-named-characters/-/emoji-named-characters-1.0.2.tgz";
        sha1 = "cdeb36d0e66002c4b9d7bf1dfbc3a199fb7d409b";
      };
    }

    {
      name = "emoji-server-1.0.0.tgz";
      path = fetchurl {
        name = "emoji-server-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/emoji-server/-/emoji-server-1.0.0.tgz";
        sha1 = "d063cfee9af118cc5aeefbc2e9b3dd5085815c63";
      };
    }

    {
      name = "emojilib-2.2.12.tgz";
      path = fetchurl {
        name = "emojilib-2.2.12.tgz";
        url  = "https://registry.yarnpkg.com/emojilib/-/emojilib-2.2.12.tgz";
        sha1 = "29481fa5521ac5ed97a5cc0503901c3435d523fa";
      };
    }

    {
      name = "end-of-stream-1.4.1.tgz";
      path = fetchurl {
        name = "end-of-stream-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.1.tgz";
        sha1 = "ed29634d19baba463b6ce6b80a37213eab71ec43";
      };
    }

    {
      name = "errno-0.1.7.tgz";
      path = fetchurl {
        name = "errno-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/errno/-/errno-0.1.7.tgz";
        sha1 = "4684d71779ad39af177e3f007996f7c67c852618";
      };
    }

    {
      name = "error-ex-1.3.1.tgz";
      path = fetchurl {
        name = "error-ex-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.1.tgz";
        sha1 = "f855a86ce61adc4e8621c3cda21e7a7612c3a8dc";
      };
    }

    {
      name = "es2040-1.2.6.tgz";
      path = fetchurl {
        name = "es2040-1.2.6.tgz";
        url  = "https://registry.yarnpkg.com/es2040/-/es2040-1.2.6.tgz";
        sha1 = "c54e2ec370065b8c25060bd0062c73dcc6368e2d";
      };
    }

    {
      name = "es6-promise-4.2.4.tgz";
      path = fetchurl {
        name = "es6-promise-4.2.4.tgz";
        url  = "https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.2.4.tgz";
        sha1 = "dc4221c2b16518760bd8c39a52d8f356fc00ed29";
      };
    }

    {
      name = "es6-template-regex-1.0.0.tgz";
      path = fetchurl {
        name = "es6-template-regex-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/es6-template-regex/-/es6-template-regex-1.0.0.tgz";
        sha1 = "cebcc3177cb60bbe515e36aa17457b87330ea286";
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
      name = "escodegen-0.0.28.tgz";
      path = fetchurl {
        name = "escodegen-0.0.28.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-0.0.28.tgz";
        sha1 = "0e4ff1715f328775d6cab51ac44a406cd7abffd3";
      };
    }

    {
      name = "escodegen-1.3.3.tgz";
      path = fetchurl {
        name = "escodegen-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.3.3.tgz";
        sha1 = "f024016f5a88e046fd12005055e939802e6c5f23";
      };
    }

    {
      name = "esprima-1.0.4.tgz";
      path = fetchurl {
        name = "esprima-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      };
    }

    {
      name = "esprima-1.1.1.tgz";
      path = fetchurl {
        name = "esprima-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-1.1.1.tgz";
        sha1 = "5b6f1547f4d102e670e140c509be6771d6aeb549";
      };
    }

    {
      name = "estraverse-1.3.2.tgz";
      path = fetchurl {
        name = "estraverse-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-1.3.2.tgz";
        sha1 = "37c2b893ef13d723f276d878d60d8535152a6c42";
      };
    }

    {
      name = "estraverse-1.5.1.tgz";
      path = fetchurl {
        name = "estraverse-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-1.5.1.tgz";
        sha1 = "867a3e8e58a9f84618afb6c2ddbcd916b7cbaf71";
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
      name = "esutils-1.0.0.tgz";
      path = fetchurl {
        name = "esutils-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-1.0.0.tgz";
        sha1 = "8151d358e20c8acc7fb745e7472c0025fe496570";
      };
    }

    {
      name = "event-kit-2.4.0.tgz";
      path = fetchurl {
        name = "event-kit-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/event-kit/-/event-kit-2.4.0.tgz";
        sha1 = "718aaf22df76670024ad66922483e1bba0544f33";
      };
    }

    {
      name = "execa-0.5.1.tgz";
      path = fetchurl {
        name = "execa-0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-0.5.1.tgz";
        sha1 = "de3fb85cb8d6e91c85bcbceb164581785cb57b36";
      };
    }

    {
      name = "execall-1.0.0.tgz";
      path = fetchurl {
        name = "execall-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/execall/-/execall-1.0.0.tgz";
        sha1 = "73d0904e395b3cab0658b08d09ec25307f29bb73";
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
      name = "expand-brackets-0.1.5.tgz";
      path = fetchurl {
        name = "expand-brackets-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-0.1.5.tgz";
        sha1 = "df07284e342a807cd733ac5af72411e581d1177b";
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
      name = "expand-template-1.1.0.tgz";
      path = fetchurl {
        name = "expand-template-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/expand-template/-/expand-template-1.1.0.tgz";
        sha1 = "e09efba977bf98f9ee0ed25abd0c692e02aec3fc";
      };
    }

    {
      name = "explain-error-1.0.4.tgz";
      path = fetchurl {
        name = "explain-error-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/explain-error/-/explain-error-1.0.4.tgz";
        sha1 = "a793d3ac0cad4c6ab571e9968fbbab6cb2532929";
      };
    }

    {
      name = "extend.js-0.0.2.tgz";
      path = fetchurl {
        name = "extend.js-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/extend.js/-/extend.js-0.0.2.tgz";
        sha1 = "0f9c7a81a1f208b703eb0c3131fe5716ac6ecd15";
      };
    }

    {
      name = "extend-3.0.1.tgz";
      path = fetchurl {
        name = "extend-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/extend/-/extend-3.0.1.tgz";
        sha1 = "a755ea7bc1adfcc5a31ce7e762dbaadc5e636444";
      };
    }

    {
      name = "extendr-2.1.0.tgz";
      path = fetchurl {
        name = "extendr-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/extendr/-/extendr-2.1.0.tgz";
        sha1 = "301aa0bbea565f4d2dc8f570f2a22611a8527b56";
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
      name = "extract-opts-2.2.0.tgz";
      path = fetchurl {
        name = "extract-opts-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/extract-opts/-/extract-opts-2.2.0.tgz";
        sha1 = "1fa28eba7352c6db480f885ceb71a46810be6d7d";
      };
    }

    {
      name = "extract-zip-1.6.6.tgz";
      path = fetchurl {
        name = "extract-zip-1.6.6.tgz";
        url  = "https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.6.6.tgz";
        sha1 = "1290ede8d20d0872b429fd3f351ca128ec5ef85c";
      };
    }

    {
      name = "extsprintf-1.3.0.tgz";
      path = fetchurl {
        name = "extsprintf-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.3.0.tgz";
        sha1 = "96918440e3041a7a414f8c52e3c574eb3c3e1e05";
      };
    }

    {
      name = "extsprintf-1.4.0.tgz";
      path = fetchurl {
        name = "extsprintf-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.0.tgz";
        sha1 = "e2689f8f356fad62cca65a3a91c5df5f9551692f";
      };
    }

    {
      name = "falafel-2.1.0.tgz";
      path = fetchurl {
        name = "falafel-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/falafel/-/falafel-2.1.0.tgz";
        sha1 = "96bb17761daba94f46d001738b3cedf3a67fe06c";
      };
    }

    {
      name = "fast-deep-equal-1.0.0.tgz";
      path = fetchurl {
        name = "fast-deep-equal-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-1.0.0.tgz";
        sha1 = "96256a3bc975595eb36d82e9929d060d893439ff";
      };
    }

    {
      name = "fast-future-1.0.2.tgz";
      path = fetchurl {
        name = "fast-future-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/fast-future/-/fast-future-1.0.2.tgz";
        sha1 = "8435a9aaa02d79248d17d704e76259301d99280a";
      };
    }

    {
      name = "fast-json-stable-stringify-2.0.0.tgz";
      path = fetchurl {
        name = "fast-json-stable-stringify-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.0.0.tgz";
        sha1 = "d5142c0caee6b1189f87d3a76111064f86c8bbf2";
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
      name = "filename-regex-2.0.1.tgz";
      path = fetchurl {
        name = "filename-regex-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/filename-regex/-/filename-regex-2.0.1.tgz";
        sha1 = "c1c4b9bee3e09725ddb106b75c1e301fe2f18b26";
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
      name = "find-up-1.1.2.tgz";
      path = fetchurl {
        name = "find-up-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz";
        sha1 = "6b2e9822b1a2ce0a60ab64d610eccad53cb24d0f";
      };
    }

    {
      name = "fix-path-2.1.0.tgz";
      path = fetchurl {
        name = "fix-path-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fix-path/-/fix-path-2.1.0.tgz";
        sha1 = "72ece739de9af4bd63fd02da23e9a70c619b4c38";
      };
    }

    {
      name = "flat-4.0.0.tgz";
      path = fetchurl {
        name = "flat-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/flat/-/flat-4.0.0.tgz";
        sha1 = "3abc7f3b588e64ce77dc42fd59aa35806622fea8";
      };
    }

    {
      name = "flatpickr-3.1.5.tgz";
      path = fetchurl {
        name = "flatpickr-3.1.5.tgz";
        url  = "https://registry.yarnpkg.com/flatpickr/-/flatpickr-3.1.5.tgz";
        sha1 = "32b13ac2361c5f9d01484353a4f34cf5f079bc6e";
      };
    }

    {
      name = "flumecodec-0.0.0.tgz";
      path = fetchurl {
        name = "flumecodec-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/flumecodec/-/flumecodec-0.0.0.tgz";
        sha1 = "36ce06abe2e0e01c44dd69f2a165305a2320649b";
      };
    }

    {
      name = "flumecodec-0.0.1.tgz";
      path = fetchurl {
        name = "flumecodec-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/flumecodec/-/flumecodec-0.0.1.tgz";
        sha1 = "ae049a714386bb83e342657a82924b70364a90d6";
      };
    }

    {
      name = "flumedb-0.4.6.tgz";
      path = fetchurl {
        name = "flumedb-0.4.6.tgz";
        url  = "https://registry.yarnpkg.com/flumedb/-/flumedb-0.4.6.tgz";
        sha1 = "c1affa7295c3672e55174eb247952f9766917e8f";
      };
    }

    {
      name = "flumelog-offset-3.2.6.tgz";
      path = fetchurl {
        name = "flumelog-offset-3.2.6.tgz";
        url  = "https://registry.yarnpkg.com/flumelog-offset/-/flumelog-offset-3.2.6.tgz";
        sha1 = "4a97d5190a3581cc459e4278d5ace2daadcd7106";
      };
    }

    {
      name = "flumeview-hashtable-1.0.3.tgz";
      path = fetchurl {
        name = "flumeview-hashtable-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/flumeview-hashtable/-/flumeview-hashtable-1.0.3.tgz";
        sha1 = "d2a9fa1649f57ef68d1b89eb4c43bfb172437967";
      };
    }

    {
      name = "flumeview-level-2.1.1.tgz";
      path = fetchurl {
        name = "flumeview-level-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/flumeview-level/-/flumeview-level-2.1.1.tgz";
        sha1 = "2909124602b329d4f6a0eb8c9038a0c9116b3681";
      };
    }

    {
      name = "flumeview-query-3.0.7.tgz";
      path = fetchurl {
        name = "flumeview-query-3.0.7.tgz";
        url  = "https://registry.yarnpkg.com/flumeview-query/-/flumeview-query-3.0.7.tgz";
        sha1 = "e76c0d72ec45e62aebaa1a36c9461e1c76ce82a0";
      };
    }

    {
      name = "flumeview-query-4.0.1.tgz";
      path = fetchurl {
        name = "flumeview-query-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/flumeview-query/-/flumeview-query-4.0.1.tgz";
        sha1 = "1cd4dfd92f1a70128dd9d80ddeaa9d44956ecced";
      };
    }

    {
      name = "flumeview-reduce-1.3.13.tgz";
      path = fetchurl {
        name = "flumeview-reduce-1.3.13.tgz";
        url  = "https://registry.yarnpkg.com/flumeview-reduce/-/flumeview-reduce-1.3.13.tgz";
        sha1 = "074f8e5dd874e2ae3d774703d47333d5c4f6952e";
      };
    }

    {
      name = "for-in-1.0.2.tgz";
      path = fetchurl {
        name = "for-in-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz";
        sha1 = "81068d295a8142ec0ac726c6e2200c30fb6d5e80";
      };
    }

    {
      name = "for-own-0.1.5.tgz";
      path = fetchurl {
        name = "for-own-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/for-own/-/for-own-0.1.5.tgz";
        sha1 = "5265c681a4f294dabbf17c9509b6763aa84510ce";
      };
    }

    {
      name = "foreach-2.0.5.tgz";
      path = fetchurl {
        name = "foreach-2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/foreach/-/foreach-2.0.5.tgz";
        sha1 = "0bee005018aeb260d0a3af3ae658dd0136ec1b99";
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
      name = "form-data-2.1.4.tgz";
      path = fetchurl {
        name = "form-data-2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.1.4.tgz";
        sha1 = "33c183acf193276ecaa98143a69e94bfee1750d1";
      };
    }

    {
      name = "form-data-2.3.2.tgz";
      path = fetchurl {
        name = "form-data-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.3.2.tgz";
        sha1 = "4970498be604c20c005d4f5c23aecd21d6b49099";
      };
    }

    {
      name = "fs-extra-0.30.0.tgz";
      path = fetchurl {
        name = "fs-extra-0.30.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-0.30.0.tgz";
        sha1 = "f233ffcc08d4da7d432daa449776989db1df93f0";
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
      name = "fsevents-1.1.3.tgz";
      path = fetchurl {
        name = "fsevents-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-1.1.3.tgz";
        sha1 = "11f82318f5fe7bb2cd22965a108e9306208216d8";
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
      name = "fstream-1.0.11.tgz";
      path = fetchurl {
        name = "fstream-1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/fstream/-/fstream-1.0.11.tgz";
        sha1 = "5c1fb1f117477114f0632a0eb4b71b3cb0fd3171";
      };
    }

    {
      name = "function-bind-1.1.1.tgz";
      path = fetchurl {
        name = "function-bind-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
        sha1 = "a56899d3ea3c9bab874bb9773b7c5ede92f4895d";
      };
    }

    {
      name = "gauge-2.7.4.tgz";
      path = fetchurl {
        name = "gauge-2.7.4.tgz";
        url  = "https://registry.yarnpkg.com/gauge/-/gauge-2.7.4.tgz";
        sha1 = "2c03405c7538c39d7eb37b317022e325fb018bf7";
      };
    }

    {
      name = "get-stdin-4.0.1.tgz";
      path = fetchurl {
        name = "get-stdin-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/get-stdin/-/get-stdin-4.0.1.tgz";
        sha1 = "b968c6b0a04384324902e8bf1a5df32579a450fe";
      };
    }

    {
      name = "get-stream-2.3.1.tgz";
      path = fetchurl {
        name = "get-stream-2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-2.3.1.tgz";
        sha1 = "5f38f93f346009666ee0150a054167f91bdd95de";
      };
    }

    {
      name = "getpass-0.1.7.tgz";
      path = fetchurl {
        name = "getpass-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/getpass/-/getpass-0.1.7.tgz";
        sha1 = "5eff8e3e684d569ae4cb2b1282604e8ba62149fa";
      };
    }

    {
      name = "github-from-package-0.0.0.tgz";
      path = fetchurl {
        name = "github-from-package-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/github-from-package/-/github-from-package-0.0.0.tgz";
        sha1 = "97fb5d96bfde8973313f20e8288ef9a167fa64ce";
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
      name = "glob-6.0.4.tgz";
      path = fetchurl {
        name = "glob-6.0.4.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-6.0.4.tgz";
        sha1 = "0f08860f6a155127b2fadd4f9ce24b1aab6e4d22";
      };
    }

    {
      name = "glob-7.1.2.tgz";
      path = fetchurl {
        name = "glob-7.1.2.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.2.tgz";
        sha1 = "c19c9df9a028702d678612384a6552404c636d15";
      };
    }

    {
      name = "globals-9.18.0.tgz";
      path = fetchurl {
        name = "globals-9.18.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-9.18.0.tgz";
        sha1 = "aa3896b3e69b487f17e31ed2143d69a8e30c2d8a";
      };
    }

    {
      name = "globby-4.1.0.tgz";
      path = fetchurl {
        name = "globby-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/globby/-/globby-4.1.0.tgz";
        sha1 = "080f54549ec1b82a6c60e631fc82e1211dbe95f8";
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
      name = "graphreduce-3.0.4.tgz";
      path = fetchurl {
        name = "graphreduce-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/graphreduce/-/graphreduce-3.0.4.tgz";
        sha1 = "bf442d0a878e83901e5ef3e652d23ffb5b831ed7";
      };
    }

    {
      name = "har-schema-1.0.5.tgz";
      path = fetchurl {
        name = "har-schema-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/har-schema/-/har-schema-1.0.5.tgz";
        sha1 = "d263135f43307c02c602afc8fe95970c0151369e";
      };
    }

    {
      name = "har-schema-2.0.0.tgz";
      path = fetchurl {
        name = "har-schema-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/har-schema/-/har-schema-2.0.0.tgz";
        sha1 = "a94c2224ebcac04782a0d9035521f24735b7ec92";
      };
    }

    {
      name = "har-validator-4.2.1.tgz";
      path = fetchurl {
        name = "har-validator-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-4.2.1.tgz";
        sha1 = "33481d0f1bbff600dd203d75812a6a5fba002e2a";
      };
    }

    {
      name = "har-validator-5.0.3.tgz";
      path = fetchurl {
        name = "har-validator-5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-5.0.3.tgz";
        sha1 = "ba402c266194f15956ef15e0fcf242993f6a7dfd";
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
      name = "has-network-0.0.1.tgz";
      path = fetchurl {
        name = "has-network-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has-network/-/has-network-0.0.1.tgz";
        sha1 = "3eea7b44caa9601797124be8ba89d228c4101499";
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
      name = "hashids-1.1.4.tgz";
      path = fetchurl {
        name = "hashids-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/hashids/-/hashids-1.1.4.tgz";
        sha1 = "e4ff92ad66b684a3bd6aace7c17d66618ee5fa21";
      };
    }

    {
      name = "hashlru-2.2.1.tgz";
      path = fetchurl {
        name = "hashlru-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/hashlru/-/hashlru-2.2.1.tgz";
        sha1 = "10f2099a0d7c05a40f2beaf5c1d39cf2f7dabf36";
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
      name = "hawk-6.0.2.tgz";
      path = fetchurl {
        name = "hawk-6.0.2.tgz";
        url  = "https://registry.yarnpkg.com/hawk/-/hawk-6.0.2.tgz";
        sha1 = "af4d914eb065f9b5ce4d9d11c1cb2126eecc3038";
      };
    }

    {
      name = "he-0.5.0.tgz";
      path = fetchurl {
        name = "he-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/he/-/he-0.5.0.tgz";
        sha1 = "2c05ffaef90b68e860f3fd2b54ef580989277ee2";
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
      name = "hoek-4.2.1.tgz";
      path = fetchurl {
        name = "hoek-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/hoek/-/hoek-4.2.1.tgz";
        sha1 = "9634502aa12c445dd5a7c5734b572bb8738aacbb";
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
      name = "home-path-1.0.5.tgz";
      path = fetchurl {
        name = "home-path-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/home-path/-/home-path-1.0.5.tgz";
        sha1 = "788b29815b12d53bacf575648476e6f9041d133f";
      };
    }

    {
      name = "hoox-0.0.1.tgz";
      path = fetchurl {
        name = "hoox-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/hoox/-/hoox-0.0.1.tgz";
        sha1 = "08a74d9272a9cc83ae8e6bbe0303f0ee76432094";
      };
    }

    {
      name = "hosted-git-info-2.5.0.tgz";
      path = fetchurl {
        name = "hosted-git-info-2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.5.0.tgz";
        sha1 = "6d60e34b3abbc8313062c3b798ef8d901a07af3c";
      };
    }

    {
      name = "html-element-1.3.0.tgz";
      path = fetchurl {
        name = "html-element-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/html-element/-/html-element-1.3.0.tgz";
        sha1 = "d75ecb5dae874b1de60a0bf8794bbd1984d0f209";
      };
    }

    {
      name = "html-escape-2.0.0.tgz";
      path = fetchurl {
        name = "html-escape-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/html-escape/-/html-escape-2.0.0.tgz";
        sha1 = "60c8ddd465edf0cae02af9e99fdf5f883b09be49";
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
      name = "http-signature-1.2.0.tgz";
      path = fetchurl {
        name = "http-signature-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz";
        sha1 = "9aecd925114772f3d95b65a60abb8f7c18fbace1";
      };
    }

    {
      name = "human-time-0.0.1.tgz";
      path = fetchurl {
        name = "human-time-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/human-time/-/human-time-0.0.1.tgz";
        sha1 = "280d0336379199306b2e1518e3d5f6381cb8507d";
      };
    }

    {
      name = "hyperfile-1.1.1.tgz";
      path = fetchurl {
        name = "hyperfile-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/hyperfile/-/hyperfile-1.1.1.tgz";
        sha1 = "733bc6c668fb9a216008c4f336531f894dbc79f3";
      };
    }

    {
      name = "hyperprogress-0.1.1.tgz";
      path = fetchurl {
        name = "hyperprogress-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/hyperprogress/-/hyperprogress-0.1.1.tgz";
        sha1 = "e530c6163aa2b1283eac192192225a762f09c344";
      };
    }

    {
      name = "hyperscript-1.4.7.tgz";
      path = fetchurl {
        name = "hyperscript-1.4.7.tgz";
        url  = "https://registry.yarnpkg.com/hyperscript/-/hyperscript-1.4.7.tgz";
        sha1 = "1f23d880f8436caac25b91a7ac39747b89a72618";
      };
    }

    {
      name = "i18n-0.8.3.tgz";
      path = fetchurl {
        name = "i18n-0.8.3.tgz";
        url  = "https://registry.yarnpkg.com/i18n/-/i18n-0.8.3.tgz";
        sha1 = "2d8cf1c24722602c2041d01ba6ae5eaa51388f0e";
      };
    }

    {
      name = "ignorefs-1.2.0.tgz";
      path = fetchurl {
        name = "ignorefs-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ignorefs/-/ignorefs-1.2.0.tgz";
        sha1 = "da59fb858976e4a5e43702ccd1f282fdbc9e5756";
      };
    }

    {
      name = "ignorepatterns-1.1.0.tgz";
      path = fetchurl {
        name = "ignorepatterns-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ignorepatterns/-/ignorepatterns-1.1.0.tgz";
        sha1 = "ac8f436f2239b5dfb66d5f0d3a904a87ac67cc5e";
      };
    }

    {
      name = "increment-buffer-1.0.1.tgz";
      path = fetchurl {
        name = "increment-buffer-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/increment-buffer/-/increment-buffer-1.0.1.tgz";
        sha1 = "65076d75189d808b39ad13ab5b958e05216f9e0d";
      };
    }

    {
      name = "indent-string-2.1.0.tgz";
      path = fetchurl {
        name = "indent-string-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/indent-string/-/indent-string-2.1.0.tgz";
        sha1 = "8e2d48348742121b4a8218b7a137e9a52049dc80";
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
      name = "inflight-1.0.6.tgz";
      path = fetchurl {
        name = "inflight-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    }

    {
      name = "inherits-1.0.0.tgz";
      path = fetchurl {
        name = "inherits-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-1.0.0.tgz";
        sha1 = "38e1975285bf1f7ba9c84da102bb12771322ac48";
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
      name = "ini-1.3.5.tgz";
      path = fetchurl {
        name = "ini-1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/ini/-/ini-1.3.5.tgz";
        sha1 = "eee25f56db1c9ec6085e0c22778083f596abf927";
      };
    }

    {
      name = "int53-0.2.4.tgz";
      path = fetchurl {
        name = "int53-0.2.4.tgz";
        url  = "https://registry.yarnpkg.com/int53/-/int53-0.2.4.tgz";
        sha1 = "5ed8d7aad6c5c6567cae69aa7ffc4a109ee80f86";
      };
    }

    {
      name = "invariant-2.2.3.tgz";
      path = fetchurl {
        name = "invariant-2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/invariant/-/invariant-2.2.3.tgz";
        sha1 = "1a827dfde7dcbd7c323f0ca826be8fa7c5e9d688";
      };
    }

    {
      name = "ip-0.3.3.tgz";
      path = fetchurl {
        name = "ip-0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/ip/-/ip-0.3.3.tgz";
        sha1 = "8ee8309e92f0b040d287f72efaca1a21702d3fb4";
      };
    }

    {
      name = "ip-1.1.5.tgz";
      path = fetchurl {
        name = "ip-1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/ip/-/ip-1.1.5.tgz";
        sha1 = "bdded70114290828c0a039e72ef25f5aaec4354a";
      };
    }

    {
      name = "irregular-plurals-1.4.0.tgz";
      path = fetchurl {
        name = "irregular-plurals-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/irregular-plurals/-/irregular-plurals-1.4.0.tgz";
        sha1 = "2ca9b033651111855412f16be5d77c62a458a766";
      };
    }

    {
      name = "is-alphabetical-1.0.1.tgz";
      path = fetchurl {
        name = "is-alphabetical-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-alphabetical/-/is-alphabetical-1.0.1.tgz";
        sha1 = "c77079cc91d4efac775be1034bf2d243f95e6f08";
      };
    }

    {
      name = "is-alphanumerical-1.0.1.tgz";
      path = fetchurl {
        name = "is-alphanumerical-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-alphanumerical/-/is-alphanumerical-1.0.1.tgz";
        sha1 = "dfb4aa4d1085e33bdb61c2dee9c80e9c6c19f53b";
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
      name = "is-buffer-1.1.6.tgz";
      path = fetchurl {
        name = "is-buffer-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz";
        sha1 = "efaa2ea9daa0d7ab2ea13a97b2b8ad51fefbe8be";
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
      name = "is-decimal-1.0.1.tgz";
      path = fetchurl {
        name = "is-decimal-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-decimal/-/is-decimal-1.0.1.tgz";
        sha1 = "f5fb6a94996ad9e8e3761fbfbd091f1fca8c4e82";
      };
    }

    {
      name = "is-dotfile-1.0.3.tgz";
      path = fetchurl {
        name = "is-dotfile-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/is-dotfile/-/is-dotfile-1.0.3.tgz";
        sha1 = "a6a2f32ffd2dfb04f5ca25ecd0f6b83cf798a1e1";
      };
    }

    {
      name = "is-electron-2.1.0.tgz";
      path = fetchurl {
        name = "is-electron-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-electron/-/is-electron-2.1.0.tgz";
        sha1 = "37dd2e9e7167efa8bafce86c0c25762bc4b851fa";
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
      name = "is-glob-2.0.1.tgz";
      path = fetchurl {
        name = "is-glob-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-2.0.1.tgz";
        sha1 = "d096f926a3ded5600f3fdfd91198cb0888c2d863";
      };
    }

    {
      name = "is-hexadecimal-1.0.1.tgz";
      path = fetchurl {
        name = "is-hexadecimal-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-hexadecimal/-/is-hexadecimal-1.0.1.tgz";
        sha1 = "6e084bbc92061fbb0971ec58b6ce6d404e24da69";
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
      name = "is-number-3.0.0.tgz";
      path = fetchurl {
        name = "is-number-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz";
        sha1 = "24fd6201a4782cf50561c810276afc7d12d71195";
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
      name = "is-regexp-1.0.0.tgz";
      path = fetchurl {
        name = "is-regexp-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-regexp/-/is-regexp-1.0.0.tgz";
        sha1 = "fd2d883545c46bac5a633e7b9a09e87fa2cb5069";
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
      name = "is-supported-regexp-flag-1.0.0.tgz";
      path = fetchurl {
        name = "is-supported-regexp-flag-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-supported-regexp-flag/-/is-supported-regexp-flag-1.0.0.tgz";
        sha1 = "8b520c85fae7a253382d4b02652e045576e13bb8";
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
      name = "is-utf8-0.2.1.tgz";
      path = fetchurl {
        name = "is-utf8-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz";
        sha1 = "4b0da1442104d1b336340e80797e865cf39f7d72";
      };
    }

    {
      name = "is-valid-domain-0.0.5.tgz";
      path = fetchurl {
        name = "is-valid-domain-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/is-valid-domain/-/is-valid-domain-0.0.5.tgz";
        sha1 = "48e70319fcb43009236e96b37f9843889ce7b513";
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
      name = "isexe-2.0.0.tgz";
      path = fetchurl {
        name = "isexe-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
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
      name = "js-tokens-3.0.2.tgz";
      path = fetchurl {
        name = "js-tokens-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/js-tokens/-/js-tokens-3.0.2.tgz";
        sha1 = "9866df395102130e38f7f996bceb65443209c25b";
      };
    }

    {
      name = "jsbn-0.1.1.tgz";
      path = fetchurl {
        name = "jsbn-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.1.tgz";
        sha1 = "a5e654c2e5a2deb5f201d96cefbca80c0ef2f513";
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
      name = "json-buffer-2.0.11.tgz";
      path = fetchurl {
        name = "json-buffer-2.0.11.tgz";
        url  = "https://registry.yarnpkg.com/json-buffer/-/json-buffer-2.0.11.tgz";
        sha1 = "3e441fda3098be8d1e3171ad591bc62a33e2d55f";
      };
    }

    {
      name = "json-schema-traverse-0.3.1.tgz";
      path = fetchurl {
        name = "json-schema-traverse-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz";
        sha1 = "349a6d44c53a51de89b40805c5d5e59b417d3340";
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
      name = "jsprim-1.4.1.tgz";
      path = fetchurl {
        name = "jsprim-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/jsprim/-/jsprim-1.4.1.tgz";
        sha1 = "313e66bc1e5cc06e438bc1b7499c2e5c56acb6a2";
      };
    }

    {
      name = "5ac05a778c43a0f096c8eb20f6fa00ac0c30ae3c";
      path = fetchurl {
        name = "5ac05a778c43a0f096c8eb20f6fa00ac0c30ae3c";
        url  = "https://codeload.github.com/ssbc/keyboard-layout/tar.gz/5ac05a778c43a0f096c8eb20f6fa00ac0c30ae3c";
        sha1 = "9e6112095ded7a73c8fa5156c8929eb164f1d03c";
      };
    }

    {
      name = "kind-of-3.2.2.tgz";
      path = fetchurl {
        name = "kind-of-3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz";
        sha1 = "31ea21a734bab9bbb0f32466d893aea51e4a3c64";
      };
    }

    {
      name = "kind-of-4.0.0.tgz";
      path = fetchurl {
        name = "kind-of-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz";
        sha1 = "20813df3d712928b207378691a45066fae72dd57";
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
      name = "level-codec-6.2.0.tgz";
      path = fetchurl {
        name = "level-codec-6.2.0.tgz";
        url  = "https://registry.yarnpkg.com/level-codec/-/level-codec-6.2.0.tgz";
        sha1 = "a4b5244bb6a4c2f723d68a1d64e980c53627d9d4";
      };
    }

    {
      name = "level-codec-7.0.1.tgz";
      path = fetchurl {
        name = "level-codec-7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/level-codec/-/level-codec-7.0.1.tgz";
        sha1 = "341f22f907ce0f16763f24bddd681e395a0fb8a7";
      };
    }

    {
      name = "level-errors-1.1.2.tgz";
      path = fetchurl {
        name = "level-errors-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/level-errors/-/level-errors-1.1.2.tgz";
        sha1 = "4399c2f3d3ab87d0625f7e3676e2d807deff404d";
      };
    }

    {
      name = "level-errors-1.0.5.tgz";
      path = fetchurl {
        name = "level-errors-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/level-errors/-/level-errors-1.0.5.tgz";
        sha1 = "83dbfb12f0b8a2516bdc9a31c4876038e227b859";
      };
    }

    {
      name = "level-iterator-stream-1.3.1.tgz";
      path = fetchurl {
        name = "level-iterator-stream-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/level-iterator-stream/-/level-iterator-stream-1.3.1.tgz";
        sha1 = "e43b78b1a8143e6fa97a4f485eb8ea530352f2ed";
      };
    }

    {
      name = "level-live-stream-1.4.12.tgz";
      path = fetchurl {
        name = "level-live-stream-1.4.12.tgz";
        url  = "https://registry.yarnpkg.com/level-live-stream/-/level-live-stream-1.4.12.tgz";
        sha1 = "f3b8ca8f89fc11cfb2e0fdab64984ececd5a5211";
      };
    }

    {
      name = "level-memview-0.0.0.tgz";
      path = fetchurl {
        name = "level-memview-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/level-memview/-/level-memview-0.0.0.tgz";
        sha1 = "46d35373ae34e342cf4a574a5e3514a1d4753a20";
      };
    }

    {
      name = "level-packager-1.2.1.tgz";
      path = fetchurl {
        name = "level-packager-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/level-packager/-/level-packager-1.2.1.tgz";
        sha1 = "067fedfd072b7fe3c6bec6080c0cbd4a6b2e11f4";
      };
    }

    {
      name = "level-post-1.0.7.tgz";
      path = fetchurl {
        name = "level-post-1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/level-post/-/level-post-1.0.7.tgz";
        sha1 = "19ccca9441a7cc527879a0635000f06d5e8f27d0";
      };
    }

    {
      name = "level-sublevel-6.6.1.tgz";
      path = fetchurl {
        name = "level-sublevel-6.6.1.tgz";
        url  = "https://registry.yarnpkg.com/level-sublevel/-/level-sublevel-6.6.1.tgz";
        sha1 = "f9a77f7521ab70a8f8e92ed56f21a3c7886a4485";
      };
    }

    {
      name = "level-1.7.0.tgz";
      path = fetchurl {
        name = "level-1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/level/-/level-1.7.0.tgz";
        sha1 = "43464a3a8ba73b2f3de56a24292805146da213a1";
      };
    }

    {
      name = "leveldown-1.7.2.tgz";
      path = fetchurl {
        name = "leveldown-1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/leveldown/-/leveldown-1.7.2.tgz";
        sha1 = "5e3467bb27ee246a4a7b8dbd8fb2b16206a6eb8b";
      };
    }

    {
      name = "levelup-0.19.1.tgz";
      path = fetchurl {
        name = "levelup-0.19.1.tgz";
        url  = "https://registry.yarnpkg.com/levelup/-/levelup-0.19.1.tgz";
        sha1 = "f3a6a7205272c4b5f35e412ff004a03a0aedf50b";
      };
    }

    {
      name = "levelup-1.3.9.tgz";
      path = fetchurl {
        name = "levelup-1.3.9.tgz";
        url  = "https://registry.yarnpkg.com/levelup/-/levelup-1.3.9.tgz";
        sha1 = "2dbcae845b2bb2b6bea84df334c475533bbd82ab";
      };
    }

    {
      name = "libnested-1.2.1.tgz";
      path = fetchurl {
        name = "libnested-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/libnested/-/libnested-1.2.1.tgz";
        sha1 = "a70a369b1b0fa907742344f045f3a11f34aff51f";
      };
    }

    {
      name = "libsodium-wrappers-0.2.12.tgz";
      path = fetchurl {
        name = "libsodium-wrappers-0.2.12.tgz";
        url  = "https://registry.yarnpkg.com/libsodium-wrappers/-/libsodium-wrappers-0.2.12.tgz";
        sha1 = "51fb50774b8edc517927b307b812a46c3a467e1e";
      };
    }

    {
      name = "libsodium-0.2.12.tgz";
      path = fetchurl {
        name = "libsodium-0.2.12.tgz";
        url  = "https://registry.yarnpkg.com/libsodium/-/libsodium-0.2.12.tgz";
        sha1 = "83083564dcf089cb82a5035be92ba5d224a2ccde";
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
      name = "lodash.assign-4.2.0.tgz";
      path = fetchurl {
        name = "lodash.assign-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.assign/-/lodash.assign-4.2.0.tgz";
        sha1 = "0d99f3ccd7a6d261d19bdaeb9245005d285808e7";
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
      name = "lodash.merge-4.6.1.tgz";
      path = fetchurl {
        name = "lodash.merge-4.6.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.1.tgz";
        sha1 = "adc25d9cb99b9391c59624f379fbba60d7111d54";
      };
    }

    {
      name = "lodash.set-4.3.2.tgz";
      path = fetchurl {
        name = "lodash.set-4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.set/-/lodash.set-4.3.2.tgz";
        sha1 = "d8757b1da807dde24816b0d6a84bea1a76230b23";
      };
    }

    {
      name = "lodash-4.17.5.tgz";
      path = fetchurl {
        name = "lodash-4.17.5.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.5.tgz";
        sha1 = "99a92d65c0272debe8c96b6057bc8fbfa3bed511";
      };
    }

    {
      name = "log-symbols-1.0.2.tgz";
      path = fetchurl {
        name = "log-symbols-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/log-symbols/-/log-symbols-1.0.2.tgz";
        sha1 = "376ff7b58ea3086a0f09facc74617eca501e1a18";
      };
    }

    {
      name = "log-update-1.0.2.tgz";
      path = fetchurl {
        name = "log-update-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/log-update/-/log-update-1.0.2.tgz";
        sha1 = "19929f64c4093d2d2e7075a1dad8af59c296b8d1";
      };
    }

    {
      name = "longest-streak-1.0.0.tgz";
      path = fetchurl {
        name = "longest-streak-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/longest-streak/-/longest-streak-1.0.0.tgz";
        sha1 = "d06597c4d4c31b52ccb1f5d8f8fe7148eafd6965";
      };
    }

    {
      name = "looper-2.0.0.tgz";
      path = fetchurl {
        name = "looper-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/looper/-/looper-2.0.0.tgz";
        sha1 = "66cd0c774af3d4fedac53794f742db56da8f09ec";
      };
    }

    {
      name = "looper-3.0.0.tgz";
      path = fetchurl {
        name = "looper-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/looper/-/looper-3.0.0.tgz";
        sha1 = "2efa54c3b1cbaba9b94aee2e5914b0be57fbb749";
      };
    }

    {
      name = "looper-4.0.0.tgz";
      path = fetchurl {
        name = "looper-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/looper/-/looper-4.0.0.tgz";
        sha1 = "7706aded59a99edca06e6b54bb86c8ec19c95155";
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
      name = "loud-rejection-1.6.0.tgz";
      path = fetchurl {
        name = "loud-rejection-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/loud-rejection/-/loud-rejection-1.6.0.tgz";
        sha1 = "5b46f80147edee578870f086d04821cf998e551f";
      };
    }

    {
      name = "lru-cache-4.1.1.tgz";
      path = fetchurl {
        name = "lru-cache-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.1.tgz";
        sha1 = "622e32e82488b49279114a4f9ecf45e7cd6bba55";
      };
    }

    {
      name = "lrucache-1.0.3.tgz";
      path = fetchurl {
        name = "lrucache-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/lrucache/-/lrucache-1.0.3.tgz";
        sha1 = "3b1ded0d1ba82e188b9bdaba9eee6486f864a434";
      };
    }

    {
      name = "ltgt-2.2.0.tgz";
      path = fetchurl {
        name = "ltgt-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ltgt/-/ltgt-2.2.0.tgz";
        sha1 = "b65ba5fcb349a29924c8e333f7c6a5562f2e4842";
      };
    }

    {
      name = "ltgt-2.1.3.tgz";
      path = fetchurl {
        name = "ltgt-2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/ltgt/-/ltgt-2.1.3.tgz";
        sha1 = "10851a06d9964b971178441c23c9e52698eece34";
      };
    }

    {
      name = "make-plural-3.0.6.tgz";
      path = fetchurl {
        name = "make-plural-3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/make-plural/-/make-plural-3.0.6.tgz";
        sha1 = "2033a03bac290b8f3bb91258f65b9df7e8b01ca7";
      };
    }

    {
      name = "map-filter-reduce-2.2.1.tgz";
      path = fetchurl {
        name = "map-filter-reduce-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/map-filter-reduce/-/map-filter-reduce-2.2.1.tgz";
        sha1 = "632b127c3ae5d6ad9e21cfdd9691b63b8944fcd2";
      };
    }

    {
      name = "map-filter-reduce-3.0.3.tgz";
      path = fetchurl {
        name = "map-filter-reduce-3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/map-filter-reduce/-/map-filter-reduce-3.0.3.tgz";
        sha1 = "8a10b86e3465badd77601a9957dbde94b98d60aa";
      };
    }

    {
      name = "map-merge-1.1.0.tgz";
      path = fetchurl {
        name = "map-merge-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/map-merge/-/map-merge-1.1.0.tgz";
        sha1 = "6a6fc58c95d8aab46c2bdde44d515b6ee06fce34";
      };
    }

    {
      name = "map-obj-1.0.1.tgz";
      path = fetchurl {
        name = "map-obj-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/map-obj/-/map-obj-1.0.1.tgz";
        sha1 = "d933ceb9205d82bdcf4886f6742bdc2b4dea146d";
      };
    }

    {
      name = "markdown-table-0.4.0.tgz";
      path = fetchurl {
        name = "markdown-table-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/markdown-table/-/markdown-table-0.4.0.tgz";
        sha1 = "890c2c1b3bfe83fb00e4129b8e4cfe645270f9d1";
      };
    }

    {
      name = "math-interval-parser-1.1.0.tgz";
      path = fetchurl {
        name = "math-interval-parser-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/math-interval-parser/-/math-interval-parser-1.1.0.tgz";
        sha1 = "dbeda5b06b3249973c6df6170fde2386f0afd893";
      };
    }

    {
      name = "mdmanifest-1.0.8.tgz";
      path = fetchurl {
        name = "mdmanifest-1.0.8.tgz";
        url  = "https://registry.yarnpkg.com/mdmanifest/-/mdmanifest-1.0.8.tgz";
        sha1 = "c04891883c28c83602e1d06b05a11037e359b4c8";
      };
    }

    {
      name = "meow-3.7.0.tgz";
      path = fetchurl {
        name = "meow-3.7.0.tgz";
        url  = "https://registry.yarnpkg.com/meow/-/meow-3.7.0.tgz";
        sha1 = "72cb668b425228290abbfa856892587308a801fb";
      };
    }

    {
      name = "messageformat-0.3.1.tgz";
      path = fetchurl {
        name = "messageformat-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/messageformat/-/messageformat-0.3.1.tgz";
        sha1 = "e58fff8245e9b3971799e5b43db58b3e9417f5a2";
      };
    }

    {
      name = "micro-css-2.0.1.tgz";
      path = fetchurl {
        name = "micro-css-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/micro-css/-/micro-css-2.0.1.tgz";
        sha1 = "a84d7e2a6a4ab734696d85836b9d83ac79c68fb8";
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
      name = "mime-db-1.33.0.tgz";
      path = fetchurl {
        name = "mime-db-1.33.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.33.0.tgz";
        sha1 = "a3492050a5cb9b63450541e39d9788d2272783db";
      };
    }

    {
      name = "mime-types-2.1.18.tgz";
      path = fetchurl {
        name = "mime-types-2.1.18.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.18.tgz";
        sha1 = "6f323f60a83d11146f831ff11fd66e2fe5503bb8";
      };
    }

    {
      name = "mimic-response-1.0.0.tgz";
      path = fetchurl {
        name = "mimic-response-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.0.tgz";
        sha1 = "df3d3652a73fded6b9b0b24146e6fd052353458e";
      };
    }

    {
      name = "minimatch-3.0.4.tgz";
      path = fetchurl {
        name = "minimatch-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz";
        sha1 = "5166e286457f03306064be5497e8dbb0c3d32083";
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
      name = "minimist-0.0.10.tgz";
      path = fetchurl {
        name = "minimist-0.0.10.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-0.0.10.tgz";
        sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
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
      name = "moment-2.20.1.tgz";
      path = fetchurl {
        name = "moment-2.20.1.tgz";
        url  = "https://registry.yarnpkg.com/moment/-/moment-2.20.1.tgz";
        sha1 = "d6eb1a46cbcc14a2b2f9434112c1ff8907f313fd";
      };
    }

    {
      name = "monotonic-timestamp-0.0.9.tgz";
      path = fetchurl {
        name = "monotonic-timestamp-0.0.9.tgz";
        url  = "https://registry.yarnpkg.com/monotonic-timestamp/-/monotonic-timestamp-0.0.9.tgz";
        sha1 = "5ba5adc7aac85e1d7ce77be847161ed246b39603";
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
      name = "multiblob-http-0.2.1.tgz";
      path = fetchurl {
        name = "multiblob-http-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/multiblob-http/-/multiblob-http-0.2.1.tgz";
        sha1 = "37c0beaacc71d1836012c062dbcdad797d02229b";
      };
    }

    {
      name = "multiblob-1.13.0.tgz";
      path = fetchurl {
        name = "multiblob-1.13.0.tgz";
        url  = "https://registry.yarnpkg.com/multiblob/-/multiblob-1.13.0.tgz";
        sha1 = "e284d5e4a944e724bee2e3896cb3007f069a41bb";
      };
    }

    {
      name = "multicb-1.2.2.tgz";
      path = fetchurl {
        name = "multicb-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/multicb/-/multicb-1.2.2.tgz";
        sha1 = "90514ab0fa733c9b9f4e9870fab77180acdf3c34";
      };
    }

    {
      name = "multiserver-1.11.0.tgz";
      path = fetchurl {
        name = "multiserver-1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/multiserver/-/multiserver-1.11.0.tgz";
        sha1 = "e8e34c635a37908243b392543bf570b987d28cd0";
      };
    }

    {
      name = "mustache-2.3.0.tgz";
      path = fetchurl {
        name = "mustache-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/mustache/-/mustache-2.3.0.tgz";
        sha1 = "4028f7778b17708a489930a6e52ac3bca0da41d0";
      };
    }

    {
      name = "mutant-pull-reduce-1.1.0.tgz";
      path = fetchurl {
        name = "mutant-pull-reduce-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mutant-pull-reduce/-/mutant-pull-reduce-1.1.0.tgz";
        sha1 = "96f77027b400061364acbf2633be2e82d5440e6a";
      };
    }

    {
      name = "mutant-3.22.1.tgz";
      path = fetchurl {
        name = "mutant-3.22.1.tgz";
        url  = "https://registry.yarnpkg.com/mutant/-/mutant-3.22.1.tgz";
        sha1 = "90487546f700b3c28aa80a43d1cf7d338f307581";
      };
    }

    {
      name = "muxrpc-validation-2.0.1.tgz";
      path = fetchurl {
        name = "muxrpc-validation-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/muxrpc-validation/-/muxrpc-validation-2.0.1.tgz";
        sha1 = "cd650d172025fe9d064230aab38ca6328dd16f2f";
      };
    }

    {
      name = "muxrpc-6.4.0.tgz";
      path = fetchurl {
        name = "muxrpc-6.4.0.tgz";
        url  = "https://registry.yarnpkg.com/muxrpc/-/muxrpc-6.4.0.tgz";
        sha1 = "24f7da069bd4629b077e993b0577942b2688eae8";
      };
    }

    {
      name = "muxrpcli-1.1.0.tgz";
      path = fetchurl {
        name = "muxrpcli-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/muxrpcli/-/muxrpcli-1.1.0.tgz";
        sha1 = "4ae9ba986ab825c4a5c12fcb71c6daa81eab5158";
      };
    }

    {
      name = "mv-2.1.1.tgz";
      path = fetchurl {
        name = "mv-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/mv/-/mv-2.1.1.tgz";
        sha1 = "ae6ce0d6f6d5e0a4f7d893798d03c1ea9559b6a2";
      };
    }

    {
      name = "nan-2.8.0.tgz";
      path = fetchurl {
        name = "nan-2.8.0.tgz";
        url  = "https://registry.yarnpkg.com/nan/-/nan-2.8.0.tgz";
        sha1 = "ed715f3fe9de02b57a5e6252d90a96675e1f085a";
      };
    }

    {
      name = "nan-2.6.2.tgz";
      path = fetchurl {
        name = "nan-2.6.2.tgz";
        url  = "https://registry.yarnpkg.com/nan/-/nan-2.6.2.tgz";
        sha1 = "e4ff34e6c95fdfb5aecc08de6596f43605a7db45";
      };
    }

    {
      name = "ncp-2.0.0.tgz";
      path = fetchurl {
        name = "ncp-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ncp/-/ncp-2.0.0.tgz";
        sha1 = "195a21d6c46e361d2fb1281ba38b91e9df7bdbb3";
      };
    }

    {
      name = "node-abi-2.2.0.tgz";
      path = fetchurl {
        name = "node-abi-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/node-abi/-/node-abi-2.2.0.tgz";
        sha1 = "e802ac7a2408e2c0593fb3176ffdf8a99a9b4dec";
      };
    }

    {
      name = "node-gyp-build-3.2.2.tgz";
      path = fetchurl {
        name = "node-gyp-build-3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/node-gyp-build/-/node-gyp-build-3.2.2.tgz";
        sha1 = "f78a9f84834b1dbd293b0719fee48635d2789c27";
      };
    }

    {
      name = "node-gyp-3.6.2.tgz";
      path = fetchurl {
        name = "node-gyp-3.6.2.tgz";
        url  = "https://registry.yarnpkg.com/node-gyp/-/node-gyp-3.6.2.tgz";
        sha1 = "9bfbe54562286284838e750eac05295853fa1c60";
      };
    }

    {
      name = "node-pre-gyp-0.6.39.tgz";
      path = fetchurl {
        name = "node-pre-gyp-0.6.39.tgz";
        url  = "https://registry.yarnpkg.com/node-pre-gyp/-/node-pre-gyp-0.6.39.tgz";
        sha1 = "c00e96860b23c0e1420ac7befc5044e1d78d8649";
      };
    }

    {
      name = "non-private-ip-1.4.3.tgz";
      path = fetchurl {
        name = "non-private-ip-1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/non-private-ip/-/non-private-ip-1.4.3.tgz";
        sha1 = "52caf2b053b153abc22856ebde53ae0093c060a5";
      };
    }

    {
      name = "non-private-ip-1.1.0.tgz";
      path = fetchurl {
        name = "non-private-ip-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/non-private-ip/-/non-private-ip-1.1.0.tgz";
        sha1 = "46f45352d50f687340e4c011f7163ca6d1907403";
      };
    }

    {
      name = "noop-logger-0.1.1.tgz";
      path = fetchurl {
        name = "noop-logger-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/noop-logger/-/noop-logger-0.1.1.tgz";
        sha1 = "94a2b1633c4f1317553007d8966fd0e841b6a4c2";
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
      name = "nopt-4.0.1.tgz";
      path = fetchurl {
        name = "nopt-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/nopt/-/nopt-4.0.1.tgz";
        sha1 = "d0d4685afd5415193c8c7505602d0d17cd64474d";
      };
    }

    {
      name = "normalize-package-data-2.4.0.tgz";
      path = fetchurl {
        name = "normalize-package-data-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.4.0.tgz";
        sha1 = "12f95a307d58352075a04907b84ac8be98ac012f";
      };
    }

    {
      name = "normalize-path-2.1.1.tgz";
      path = fetchurl {
        name = "normalize-path-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz";
        sha1 = "1ab28b556e198363a8c1a6f7e6fa20137fe6aed9";
      };
    }

    {
      name = "normalize-uri-1.1.0.tgz";
      path = fetchurl {
        name = "normalize-uri-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-uri/-/normalize-uri-1.1.0.tgz";
        sha1 = "01fb440c7fd059b9d9be8645aac14341efd059dd";
      };
    }

    {
      name = "npm-prefix-1.2.0.tgz";
      path = fetchurl {
        name = "npm-prefix-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-prefix/-/npm-prefix-1.2.0.tgz";
        sha1 = "e619455f7074ba54cc66d6d0d37dd9f1be6bcbc0";
      };
    }

    {
      name = "npm-run-path-2.0.2.tgz";
      path = fetchurl {
        name = "npm-run-path-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz";
        sha1 = "35a9232dfa35d7067b4cb2ddf2357b1871536c5f";
      };
    }

    {
      name = "npmlog-4.1.2.tgz";
      path = fetchurl {
        name = "npmlog-4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/npmlog/-/npmlog-4.1.2.tgz";
        sha1 = "08a7f2a8bf734604779a9efa4ad5cc717abb954b";
      };
    }

    {
      name = "nugget-2.0.1.tgz";
      path = fetchurl {
        name = "nugget-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/nugget/-/nugget-2.0.1.tgz";
        sha1 = "201095a487e1ad36081b3432fa3cada4f8d071b0";
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
      name = "object-assign-4.1.1.tgz";
      path = fetchurl {
        name = "object-assign-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz";
        sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
      };
    }

    {
      name = "object-inspect-0.4.0.tgz";
      path = fetchurl {
        name = "object-inspect-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/object-inspect/-/object-inspect-0.4.0.tgz";
        sha1 = "f5157c116c1455b243b06ee97703392c5ad89fec";
      };
    }

    {
      name = "object-keys-1.0.11.tgz";
      path = fetchurl {
        name = "object-keys-1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.0.11.tgz";
        sha1 = "c54601778ad560f1142ce0e01bcca8b56d13426d";
      };
    }

    {
      name = "object-keys-0.4.0.tgz";
      path = fetchurl {
        name = "object-keys-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-0.4.0.tgz";
        sha1 = "28a6aae7428dd2c3a92f3d95f21335dd204e0336";
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
      name = "observ-debounce-1.1.1.tgz";
      path = fetchurl {
        name = "observ-debounce-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/observ-debounce/-/observ-debounce-1.1.1.tgz";
        sha1 = "304e97c85adda70ecd7f08da450678ef90f0b707";
      };
    }

    {
      name = "observ-0.2.0.tgz";
      path = fetchurl {
        name = "observ-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/observ/-/observ-0.2.0.tgz";
        sha1 = "0bc39b3e29faa5f9e6caa5906cb8392df400aa68";
      };
    }

    {
      name = "obv-0.0.0.tgz";
      path = fetchurl {
        name = "obv-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/obv/-/obv-0.0.0.tgz";
        sha1 = "edeab8468f91d4193362ed7f91d0b96dd39a79c1";
      };
    }

    {
      name = "obv-0.0.1.tgz";
      path = fetchurl {
        name = "obv-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/obv/-/obv-0.0.1.tgz";
        sha1 = "cb236106341536f0dac4815e06708221cad7fb5e";
      };
    }

    {
      name = "on-change-network-0.0.2.tgz";
      path = fetchurl {
        name = "on-change-network-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/on-change-network/-/on-change-network-0.0.2.tgz";
        sha1 = "d977249477f91726949d80e82346dab6ef45216b";
      };
    }

    {
      name = "on-wakeup-1.0.1.tgz";
      path = fetchurl {
        name = "on-wakeup-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/on-wakeup/-/on-wakeup-1.0.1.tgz";
        sha1 = "00d79d987dde7c8117bee74bb4903f6f6dafa52b";
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
      name = "onetime-1.1.0.tgz";
      path = fetchurl {
        name = "onetime-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/onetime/-/onetime-1.1.0.tgz";
        sha1 = "a1f7838f8314c516f05ecefcbc4ccfe04b4ed789";
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
      name = "options-0.0.6.tgz";
      path = fetchurl {
        name = "options-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/options/-/options-0.0.6.tgz";
        sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
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
      name = "os-tmpdir-1.0.2.tgz";
      path = fetchurl {
        name = "os-tmpdir-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz";
        sha1 = "bbe67406c79aa85c5cfec766fe5734555dfa1274";
      };
    }

    {
      name = "osenv-0.1.5.tgz";
      path = fetchurl {
        name = "osenv-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/osenv/-/osenv-0.1.5.tgz";
        sha1 = "85cdfafaeb28e8677f416e287592b5f3f49ea410";
      };
    }

    {
      name = "p-finally-1.0.0.tgz";
      path = fetchurl {
        name = "p-finally-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz";
        sha1 = "3fbcfb15b899a44123b34b6dcc18b724336a2cae";
      };
    }

    {
      name = "packet-stream-codec-1.1.2.tgz";
      path = fetchurl {
        name = "packet-stream-codec-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/packet-stream-codec/-/packet-stream-codec-1.1.2.tgz";
        sha1 = "79b302fc144cdfbb4ab6feba7040e6a5d99c79c7";
      };
    }

    {
      name = "packet-stream-2.0.4.tgz";
      path = fetchurl {
        name = "packet-stream-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/packet-stream/-/packet-stream-2.0.4.tgz";
        sha1 = "558a64fb274d6c5efd931aa10a3837d7209c94e3";
      };
    }

    {
      name = "parse-entities-1.1.1.tgz";
      path = fetchurl {
        name = "parse-entities-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/parse-entities/-/parse-entities-1.1.1.tgz";
        sha1 = "8112d88471319f27abae4d64964b122fe4e1b890";
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
      name = "patch-settings-1.1.0.tgz";
      path = fetchurl {
        name = "patch-settings-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/patch-settings/-/patch-settings-1.1.0.tgz";
        sha1 = "a5e51057622d4fd04a09ead065faf4b43454c011";
      };
    }

    {
      name = "patchcore-1.23.4.tgz";
      path = fetchurl {
        name = "patchcore-1.23.4.tgz";
        url  = "https://registry.yarnpkg.com/patchcore/-/patchcore-1.23.4.tgz";
        sha1 = "5c474884d10ff454ecc7aff79e191ca8effb2f9d";
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
      name = "path-is-absolute-1.0.1.tgz";
      path = fetchurl {
        name = "path-is-absolute-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    }

    {
      name = "path-key-2.0.1.tgz";
      path = fetchurl {
        name = "path-key-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz";
        sha1 = "411cadb574c5a140d3a4b1910d40d80cc9f40b40";
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
      name = "pend-1.2.0.tgz";
      path = fetchurl {
        name = "pend-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz";
        sha1 = "7a57eb550a6783f9115331fcf4663d5c8e007a50";
      };
    }

    {
      name = "performance-now-0.2.0.tgz";
      path = fetchurl {
        name = "performance-now-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/performance-now/-/performance-now-0.2.0.tgz";
        sha1 = "33ef30c5c77d4ea21c5a53869d91b56d8f2555e5";
      };
    }

    {
      name = "performance-now-2.1.0.tgz";
      path = fetchurl {
        name = "performance-now-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz";
        sha1 = "6309f4e0e5fa913ec1c69307ae364b4b377c9e7b";
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
      name = "plur-2.1.2.tgz";
      path = fetchurl {
        name = "plur-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/plur/-/plur-2.1.2.tgz";
        sha1 = "7482452c1a0f508e3e344eaec312c91c29dc655a";
      };
    }

    {
      name = "prebuild-install-2.5.1.tgz";
      path = fetchurl {
        name = "prebuild-install-2.5.1.tgz";
        url  = "https://registry.yarnpkg.com/prebuild-install/-/prebuild-install-2.5.1.tgz";
        sha1 = "0f234140a73760813657c413cdccdda58296b1da";
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
      name = "pretty-bytes-1.0.4.tgz";
      path = fetchurl {
        name = "pretty-bytes-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/pretty-bytes/-/pretty-bytes-1.0.4.tgz";
        sha1 = "0a22e8210609ad35542f8c8d5d2159aff0751c84";
      };
    }

    {
      name = "private-box-0.2.1.tgz";
      path = fetchurl {
        name = "private-box-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/private-box/-/private-box-0.2.1.tgz";
        sha1 = "1df061afca5b3039c7feaadd0daf0f56f07e3ec0";
      };
    }

    {
      name = "private-0.1.8.tgz";
      path = fetchurl {
        name = "private-0.1.8.tgz";
        url  = "https://registry.yarnpkg.com/private/-/private-0.1.8.tgz";
        sha1 = "2381edb3689f7a53d653190060fcf822d2f368ff";
      };
    }

    {
      name = "process-nextick-args-2.0.0.tgz";
      path = fetchurl {
        name = "process-nextick-args-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.0.tgz";
        sha1 = "a37d732f4271b4ab1ad070d35508e8290788ffaa";
      };
    }

    {
      name = "progress-stream-1.2.0.tgz";
      path = fetchurl {
        name = "progress-stream-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/progress-stream/-/progress-stream-1.2.0.tgz";
        sha1 = "2cd3cfea33ba3a89c9c121ec3347abe9ab125f77";
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
      name = "prr-1.0.1.tgz";
      path = fetchurl {
        name = "prr-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz";
        sha1 = "d3fc114ba06995a45ec6893f484ceb1d78f5f476";
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
      name = "pull-abortable-4.1.1.tgz";
      path = fetchurl {
        name = "pull-abortable-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/pull-abortable/-/pull-abortable-4.1.1.tgz";
        sha1 = "b3ad5aefb4116b25916d26db89393ac98d0dcea1";
      };
    }

    {
      name = "pull-abortable-4.0.0.tgz";
      path = fetchurl {
        name = "pull-abortable-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-abortable/-/pull-abortable-4.0.0.tgz";
        sha1 = "7017a984c3b834de77bac38c10b776f22dfc1843";
      };
    }

    {
      name = "pull-box-stream-1.0.13.tgz";
      path = fetchurl {
        name = "pull-box-stream-1.0.13.tgz";
        url  = "https://registry.yarnpkg.com/pull-box-stream/-/pull-box-stream-1.0.13.tgz";
        sha1 = "c3e240398eab3f5951b2ed1078c5988bf7a0a2b9";
      };
    }

    {
      name = "pull-cat-1.1.11.tgz";
      path = fetchurl {
        name = "pull-cat-1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/pull-cat/-/pull-cat-1.1.11.tgz";
        sha1 = "b642dd1255da376a706b6db4fa962f5fdb74c31b";
      };
    }

    {
      name = "pull-cont-0.0.0.tgz";
      path = fetchurl {
        name = "pull-cont-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-cont/-/pull-cont-0.0.0.tgz";
        sha1 = "3fac48b81ac97b75ba01332088b0ce7af8c1be0e";
      };
    }

    {
      name = "pull-cont-0.1.1.tgz";
      path = fetchurl {
        name = "pull-cont-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/pull-cont/-/pull-cont-0.1.1.tgz";
        sha1 = "df1d580e271757ba9acbaeba20de2421d660d618";
      };
    }

    {
      name = "pull-core-1.1.0.tgz";
      path = fetchurl {
        name = "pull-core-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-core/-/pull-core-1.1.0.tgz";
        sha1 = "3d8127d6dac1475705c9800961f59d66c8046c8a";
      };
    }

    {
      name = "pull-core-1.0.0.tgz";
      path = fetchurl {
        name = "pull-core-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-core/-/pull-core-1.0.0.tgz";
        sha1 = "e0eb93918dfa70963ed09e36f63daa15b76b38a4";
      };
    }

    {
      name = "pull-cursor-2.1.3.tgz";
      path = fetchurl {
        name = "pull-cursor-2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/pull-cursor/-/pull-cursor-2.1.3.tgz";
        sha1 = "021e97d7d23d78af66add6b8c1c17fd6fdb12b6c";
      };
    }

    {
      name = "pull-defer-0.2.2.tgz";
      path = fetchurl {
        name = "pull-defer-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-defer/-/pull-defer-0.2.2.tgz";
        sha1 = "0887b0ffb30af32a56dbecfa72c1672271f07b13";
      };
    }

    {
      name = "pull-file-0.5.0.tgz";
      path = fetchurl {
        name = "pull-file-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-file/-/pull-file-0.5.0.tgz";
        sha1 = "b3ca405306e082f9d4528288933badb2b656365b";
      };
    }

    {
      name = "pull-file-1.1.0.tgz";
      path = fetchurl {
        name = "pull-file-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-file/-/pull-file-1.1.0.tgz";
        sha1 = "1dd987605d6357a0d23c1e4b826f7915a215129c";
      };
    }

    {
      name = "pull-file-1.0.0.tgz";
      path = fetchurl {
        name = "pull-file-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-file/-/pull-file-1.0.0.tgz";
        sha1 = "5a0cb036d78ee10e3e0b4293dfcf6effa1036318";
      };
    }

    {
      name = "pull-flatmap-0.0.1.tgz";
      path = fetchurl {
        name = "pull-flatmap-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pull-flatmap/-/pull-flatmap-0.0.1.tgz";
        sha1 = "13d494453e8f6d478e7bbfade6f8fe0197fa6bb7";
      };
    }

    {
      name = "pull-fs-1.1.6.tgz";
      path = fetchurl {
        name = "pull-fs-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/pull-fs/-/pull-fs-1.1.6.tgz";
        sha1 = "f184f6a7728bb4d95641376bead69f6f66df47cd";
      };
    }

    {
      name = "pull-glob-1.0.6.tgz";
      path = fetchurl {
        name = "pull-glob-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/pull-glob/-/pull-glob-1.0.6.tgz";
        sha1 = "dea5ac5948ee15978dab24d777202927f68ae8a6";
      };
    }

    {
      name = "pull-goodbye-0.0.2.tgz";
      path = fetchurl {
        name = "pull-goodbye-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-goodbye/-/pull-goodbye-0.0.2.tgz";
        sha1 = "8d8357db55e22a710dfff0f16a8c90b45efe4171";
      };
    }

    {
      name = "pull-handshake-1.1.4.tgz";
      path = fetchurl {
        name = "pull-handshake-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-handshake/-/pull-handshake-1.1.4.tgz";
        sha1 = "6000a0fd018884cdfd737254f8cc60ab2a637791";
      };
    }

    {
      name = "pull-hash-1.0.0.tgz";
      path = fetchurl {
        name = "pull-hash-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-hash/-/pull-hash-1.0.0.tgz";
        sha1 = "fcad4d2507bf2c2b3231f653dc9bfb2db4f0d88c";
      };
    }

    {
      name = "pull-identify-filetype-1.1.0.tgz";
      path = fetchurl {
        name = "pull-identify-filetype-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-identify-filetype/-/pull-identify-filetype-1.1.0.tgz";
        sha1 = "5f99af15e8846d48ecf625edc248ec2cf57f6b0d";
      };
    }

    {
      name = "pull-inactivity-2.1.2.tgz";
      path = fetchurl {
        name = "pull-inactivity-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-inactivity/-/pull-inactivity-2.1.2.tgz";
        sha1 = "37a3d6ebbfac292cd435f5e481e5074c8c1fad75";
      };
    }

    {
      name = "pull-level-1.5.2.tgz";
      path = fetchurl {
        name = "pull-level-1.5.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-level/-/pull-level-1.5.2.tgz";
        sha1 = "2b4bdc8eab8d4f2e3708b49512350b14bb035b56";
      };
    }

    {
      name = "pull-level-2.0.4.tgz";
      path = fetchurl {
        name = "pull-level-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-level/-/pull-level-2.0.4.tgz";
        sha1 = "4822e61757c10bdcc7cf4a03af04c92734c9afac";
      };
    }

    {
      name = "pull-level-1.2.0.tgz";
      path = fetchurl {
        name = "pull-level-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-level/-/pull-level-1.2.0.tgz";
        sha1 = "53b32122650eb15d35b60e54321fba11cf5c6e66";
      };
    }

    {
      name = "pull-live-1.0.1.tgz";
      path = fetchurl {
        name = "pull-live-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pull-live/-/pull-live-1.0.1.tgz";
        sha1 = "a4ecee01e330155e9124bbbcf4761f21b38f51f5";
      };
    }

    {
      name = "pull-looper-1.0.0.tgz";
      path = fetchurl {
        name = "pull-looper-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-looper/-/pull-looper-1.0.0.tgz";
        sha1 = "d128b88ada3b16412c6242c4a9b429fa88e97e8e";
      };
    }

    {
      name = "pull-many-1.0.8.tgz";
      path = fetchurl {
        name = "pull-many-1.0.8.tgz";
        url  = "https://registry.yarnpkg.com/pull-many/-/pull-many-1.0.8.tgz";
        sha1 = "3dadd9b6d156c545721bda8d0003dd8eaa06293e";
      };
    }

    {
      name = "pull-next-1.0.1.tgz";
      path = fetchurl {
        name = "pull-next-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pull-next/-/pull-next-1.0.1.tgz";
        sha1 = "03f4d7d19872fc1114161e88db6ecf4c65e61e56";
      };
    }

    {
      name = "pull-notify-0.1.1.tgz";
      path = fetchurl {
        name = "pull-notify-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/pull-notify/-/pull-notify-0.1.1.tgz";
        sha1 = "6f86ff95d270b89c3ebf255b6031b7032dc99cca";
      };
    }

    {
      name = "pull-pair-1.1.0.tgz";
      path = fetchurl {
        name = "pull-pair-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-pair/-/pull-pair-1.1.0.tgz";
        sha1 = "7ee427263fdf4da825397ac0a05e1ab4b74bd76d";
      };
    }

    {
      name = "pull-paramap-1.2.2.tgz";
      path = fetchurl {
        name = "pull-paramap-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-paramap/-/pull-paramap-1.2.2.tgz";
        sha1 = "51a4193ce9c8d7215d95adad45e2bcdb8493b23a";
      };
    }

    {
      name = "pull-pause-0.0.0.tgz";
      path = fetchurl {
        name = "pull-pause-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-pause/-/pull-pause-0.0.0.tgz";
        sha1 = "101a628d717e19dfbf9800e9dec8f25d30461969";
      };
    }

    {
      name = "pull-pause-0.0.2.tgz";
      path = fetchurl {
        name = "pull-pause-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-pause/-/pull-pause-0.0.2.tgz";
        sha1 = "19d45be8faa615fa556f14a96fd733462c37fba3";
      };
    }

    {
      name = "pull-ping-2.0.2.tgz";
      path = fetchurl {
        name = "pull-ping-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-ping/-/pull-ping-2.0.2.tgz";
        sha1 = "7bc4a340167dad88f682a196c63485735c7a0894";
      };
    }

    {
      name = "pull-pushable-1.1.4.tgz";
      path = fetchurl {
        name = "pull-pushable-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-pushable/-/pull-pushable-1.1.4.tgz";
        sha1 = "7664d6741f72687ef5c89f533b78682f3de9a20e";
      };
    }

    {
      name = "pull-pushable-2.2.0.tgz";
      path = fetchurl {
        name = "pull-pushable-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-pushable/-/pull-pushable-2.2.0.tgz";
        sha1 = "5f2f3aed47ad86919f01b12a2e99d6f1bd776581";
      };
    }

    {
      name = "pull-rate-1.0.2.tgz";
      path = fetchurl {
        name = "pull-rate-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-rate/-/pull-rate-1.0.2.tgz";
        sha1 = "17b231ad5f359f675826670172b0e590c8964e8d";
      };
    }

    {
      name = "pull-reader-1.2.9.tgz";
      path = fetchurl {
        name = "pull-reader-1.2.9.tgz";
        url  = "https://registry.yarnpkg.com/pull-reader/-/pull-reader-1.2.9.tgz";
        sha1 = "d2e9ad00bcfb54e62aa66d42c2dbbcb5eb6843b0";
      };
    }

    {
      name = "pull-reconnect-0.0.3.tgz";
      path = fetchurl {
        name = "pull-reconnect-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/pull-reconnect/-/pull-reconnect-0.0.3.tgz";
        sha1 = "53dce9cd2f2b9b210e88895e19f2ffc67621dc9e";
      };
    }

    {
      name = "pull-sink-through-0.0.0.tgz";
      path = fetchurl {
        name = "pull-sink-through-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-sink-through/-/pull-sink-through-0.0.0.tgz";
        sha1 = "d3c0492f3a80b4ed204af67c4b4f935680fc5b1f";
      };
    }

    {
      name = "pull-stream-to-stream-1.2.6.tgz";
      path = fetchurl {
        name = "pull-stream-to-stream-1.2.6.tgz";
        url  = "https://registry.yarnpkg.com/pull-stream-to-stream/-/pull-stream-to-stream-1.2.6.tgz";
        sha1 = "dd9fa3732edb3d16e67cd1f224bca38a6d5748c7";
      };
    }

    {
      name = "pull-stream-to-stream-1.3.4.tgz";
      path = fetchurl {
        name = "pull-stream-to-stream-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-stream-to-stream/-/pull-stream-to-stream-1.3.4.tgz";
        sha1 = "3f81d8216bd18d2bfd1a198190471180e2738399";
      };
    }

    {
      name = "pull-stream-2.28.4.tgz";
      path = fetchurl {
        name = "pull-stream-2.28.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-stream/-/pull-stream-2.28.4.tgz";
        sha1 = "7ea97413c1619c20bc3bdf9e10e91347b03253e4";
      };
    }

    {
      name = "pull-stream-3.6.2.tgz";
      path = fetchurl {
        name = "pull-stream-3.6.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-stream/-/pull-stream-3.6.2.tgz";
        sha1 = "1ea14c6f13174e6ac4def0c2a4e76567b7cb0c5c";
      };
    }

    {
      name = "pull-stream-2.18.3.tgz";
      path = fetchurl {
        name = "pull-stream-2.18.3.tgz";
        url  = "https://registry.yarnpkg.com/pull-stream/-/pull-stream-2.18.3.tgz";
        sha1 = "7a07962234d7579c908860db8c27f7f34fd45000";
      };
    }

    {
      name = "pull-stream-2.26.1.tgz";
      path = fetchurl {
        name = "pull-stream-2.26.1.tgz";
        url  = "https://registry.yarnpkg.com/pull-stream/-/pull-stream-2.26.1.tgz";
        sha1 = "4bf2559de87b8af2f5b96b7190d2ee431ca1e519";
      };
    }

    {
      name = "pull-stream-3.5.0.tgz";
      path = fetchurl {
        name = "pull-stream-3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-stream/-/pull-stream-3.5.0.tgz";
        sha1 = "1ee5b6f76fd3b3a49a5afb6ded5c0320acb3cfc7";
      };
    }

    {
      name = "pull-stringify-1.2.2.tgz";
      path = fetchurl {
        name = "pull-stringify-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-stringify/-/pull-stringify-1.2.2.tgz";
        sha1 = "5a1c34e0075faf2f2f6d46004e36dccd33bd7c7c";
      };
    }

    {
      name = "pull-through-1.0.18.tgz";
      path = fetchurl {
        name = "pull-through-1.0.18.tgz";
        url  = "https://registry.yarnpkg.com/pull-through/-/pull-through-1.0.18.tgz";
        sha1 = "8dd62314263e59cf5096eafbb127a2b6ef310735";
      };
    }

    {
      name = "pull-traverse-1.0.3.tgz";
      path = fetchurl {
        name = "pull-traverse-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/pull-traverse/-/pull-traverse-1.0.3.tgz";
        sha1 = "74fb5d7be7fa6bd7a78e97933e199b7945866938";
      };
    }

    {
      name = "pull-utf8-decoder-1.0.2.tgz";
      path = fetchurl {
        name = "pull-utf8-decoder-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pull-utf8-decoder/-/pull-utf8-decoder-1.0.2.tgz";
        sha1 = "a7afa2384d1e6415a5d602054126cc8de3bcbce7";
      };
    }

    {
      name = "pull-window-2.1.4.tgz";
      path = fetchurl {
        name = "pull-window-2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-window/-/pull-window-2.1.4.tgz";
        sha1 = "fc3b86feebd1920c7ae297691e23f705f88552f0";
      };
    }

    {
      name = "pull-write-file-0.2.4.tgz";
      path = fetchurl {
        name = "pull-write-file-0.2.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-write-file/-/pull-write-file-0.2.4.tgz";
        sha1 = "437344aeb2189f65e678ed1af37f0f760a5453ef";
      };
    }

    {
      name = "pull-write-1.1.4.tgz";
      path = fetchurl {
        name = "pull-write-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/pull-write/-/pull-write-1.1.4.tgz";
        sha1 = "dddea31493b48f6768b84a281d01eb3b531fe0b8";
      };
    }

    {
      name = "pull-ws-3.3.0.tgz";
      path = fetchurl {
        name = "pull-ws-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/pull-ws/-/pull-ws-3.3.0.tgz";
        sha1 = "e1c43ef40332167dd8120ef59edf7e892bea4aae";
      };
    }

    {
      name = "pump-1.0.3.tgz";
      path = fetchurl {
        name = "pump-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-1.0.3.tgz";
        sha1 = "5dfe8311c33bbf6fc18261f9f34702c47c08a954";
      };
    }

    {
      name = "pump-2.0.1.tgz";
      path = fetchurl {
        name = "pump-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz";
        sha1 = "12399add6e4cf7526d973cbc8b5ce2e2908b3909";
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
      name = "qs-6.4.0.tgz";
      path = fetchurl {
        name = "qs-6.4.0.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.4.0.tgz";
        sha1 = "13e26d28ad6b0ffaa91312cd3bf708ed351e7233";
      };
    }

    {
      name = "qs-6.5.1.tgz";
      path = fetchurl {
        name = "qs-6.5.1.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.5.1.tgz";
        sha1 = "349cdf6eef89ec45c12d7d5eb3fc0c870343a6d8";
      };
    }

    {
      name = "quote-stream-0.0.0.tgz";
      path = fetchurl {
        name = "quote-stream-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/quote-stream/-/quote-stream-0.0.0.tgz";
        sha1 = "cde29e94c409b16e19dc7098b89b6658f9721d3b";
      };
    }

    {
      name = "randomatic-1.1.7.tgz";
      path = fetchurl {
        name = "randomatic-1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/randomatic/-/randomatic-1.1.7.tgz";
        sha1 = "c7abe9cc8b87c0baa876b19fde83fd464797e38c";
      };
    }

    {
      name = "rc-1.2.5.tgz";
      path = fetchurl {
        name = "rc-1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/rc/-/rc-1.2.5.tgz";
        sha1 = "275cd687f6e3b36cc756baa26dfee80a790301fd";
      };
    }

    {
      name = "rc-0.5.5.tgz";
      path = fetchurl {
        name = "rc-0.5.5.tgz";
        url  = "https://registry.yarnpkg.com/rc/-/rc-0.5.5.tgz";
        sha1 = "541cc3300f464b6dfe6432d756f0f2dd3e9eb199";
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
      name = "readable-stream-1.1.14.tgz";
      path = fetchurl {
        name = "readable-stream-1.1.14.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz";
        sha1 = "7cf4c54ef648e3813084c636dd2079e166c081d9";
      };
    }

    {
      name = "readable-stream-2.3.4.tgz";
      path = fetchurl {
        name = "readable-stream-2.3.4.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.4.tgz";
        sha1 = "c946c3f47fa7d8eabc0b6150f4a12f69a4574071";
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
      name = "readdirp-2.1.0.tgz";
      path = fetchurl {
        name = "readdirp-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/readdirp/-/readdirp-2.1.0.tgz";
        sha1 = "4ed0ad060df3073300c48440373f72d1cc642d78";
      };
    }

    {
      name = "redent-1.0.0.tgz";
      path = fetchurl {
        name = "redent-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/redent/-/redent-1.0.0.tgz";
        sha1 = "cf916ab1fd5f1f16dfb20822dd6ec7f730c2afde";
      };
    }

    {
      name = "regenerator-runtime-0.11.1.tgz";
      path = fetchurl {
        name = "regenerator-runtime-0.11.1.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz";
        sha1 = "be05ad7f9bf7d22e056f9726cee5017fbf19e2e9";
      };
    }

    {
      name = "regex-cache-0.4.4.tgz";
      path = fetchurl {
        name = "regex-cache-0.4.4.tgz";
        url  = "https://registry.yarnpkg.com/regex-cache/-/regex-cache-0.4.4.tgz";
        sha1 = "75bdc58a2a1496cec48a12835bc54c8d562336dd";
      };
    }

    {
      name = "relative-url-1.0.2.tgz";
      path = fetchurl {
        name = "relative-url-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/relative-url/-/relative-url-1.0.2.tgz";
        sha1 = "d21c52a72d6061018bcee9f9c9fc106bf7d65287";
      };
    }

    {
      name = "remark-html-2.0.2.tgz";
      path = fetchurl {
        name = "remark-html-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/remark-html/-/remark-html-2.0.2.tgz";
        sha1 = "592a347bdd3d5881f4f080c98b5b152fb1407a92";
      };
    }

    {
      name = "remark-3.2.3.tgz";
      path = fetchurl {
        name = "remark-3.2.3.tgz";
        url  = "https://registry.yarnpkg.com/remark/-/remark-3.2.3.tgz";
        sha1 = "802a38c3aa98c9e1e3ea015eeba211d27cb65e1f";
      };
    }

    {
      name = "remove-trailing-separator-1.1.0.tgz";
      path = fetchurl {
        name = "remove-trailing-separator-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz";
        sha1 = "c24bce2a283adad5bc3f58e0d48249b92379d8ef";
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
      name = "repeat-string-1.6.1.tgz";
      path = fetchurl {
        name = "repeat-string-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz";
        sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
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
      name = "request-2.83.0.tgz";
      path = fetchurl {
        name = "request-2.83.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.83.0.tgz";
        sha1 = "ca0b65da02ed62935887808e6f510381034e3356";
      };
    }

    {
      name = "request-2.81.0.tgz";
      path = fetchurl {
        name = "request-2.81.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.81.0.tgz";
        sha1 = "c6928946a0e06c5f8d6f8a9333469ffda46298a0";
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
      name = "rimraf-2.6.2.tgz";
      path = fetchurl {
        name = "rimraf-2.6.2.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.6.2.tgz";
        sha1 = "2ed8150d24a16ea8651e6d6ef0f47c4158ce7a36";
      };
    }

    {
      name = "rimraf-2.2.8.tgz";
      path = fetchurl {
        name = "rimraf-2.2.8.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      };
    }

    {
      name = "rimraf-2.4.5.tgz";
      path = fetchurl {
        name = "rimraf-2.4.5.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.4.5.tgz";
        sha1 = "ee710ce5d93a8fdb856fb5ea8ff0e2d75934b2da";
      };
    }

    {
      name = "rxjs-serial-subscription-0.1.1.tgz";
      path = fetchurl {
        name = "rxjs-serial-subscription-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/rxjs-serial-subscription/-/rxjs-serial-subscription-0.1.1.tgz";
        sha1 = "a42b1db0bf1094b09231191e2778ca3fcf9ed147";
      };
    }

    {
      name = "rxjs-5.5.6.tgz";
      path = fetchurl {
        name = "rxjs-5.5.6.tgz";
        url  = "https://registry.yarnpkg.com/rxjs/-/rxjs-5.5.6.tgz";
        sha1 = "e31fb96d6fd2ff1fd84bcea8ae9c02d007179c02";
      };
    }

    {
      name = "safe-buffer-5.1.1.tgz";
      path = fetchurl {
        name = "safe-buffer-5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.1.tgz";
        sha1 = "893312af69b2123def71f57889001671eeb2c853";
      };
    }

    {
      name = "safefs-3.2.2.tgz";
      path = fetchurl {
        name = "safefs-3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/safefs/-/safefs-3.2.2.tgz";
        sha1 = "8170c1444d7038e08caea05a374fae2fa349e15c";
      };
    }

    {
      name = "scandirectory-2.5.0.tgz";
      path = fetchurl {
        name = "scandirectory-2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/scandirectory/-/scandirectory-2.5.0.tgz";
        sha1 = "6ce03f54a090b668e3cbedbf20edf9e310593e72";
      };
    }

    {
      name = "22d894d03235a96f1cad8e836b55ca57eb25d17f";
      path = fetchurl {
        name = "22d894d03235a96f1cad8e836b55ca57eb25d17f";
        url  = "https://codeload.github.com/ssbc/scuttlebot/tar.gz/22d894d03235a96f1cad8e836b55ca57eb25d17f";
        sha1 = "22cef2cb732a3c8f746c7a5ae78889662ee675df";
      };
    }

    {
      name = "secret-handshake-1.1.12.tgz";
      path = fetchurl {
        name = "secret-handshake-1.1.12.tgz";
        url  = "https://registry.yarnpkg.com/secret-handshake/-/secret-handshake-1.1.12.tgz";
        sha1 = "933265deb0b298ddb22690f7354bfb88ebe8158c";
      };
    }

    {
      name = "secret-stack-4.0.1.tgz";
      path = fetchurl {
        name = "secret-stack-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/secret-stack/-/secret-stack-4.0.1.tgz";
        sha1 = "92fb9c07ecc8f851c7f7fe67c9b84301266dcd79";
      };
    }

    {
      name = "secret-stack-4.1.0.tgz";
      path = fetchurl {
        name = "secret-stack-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/secret-stack/-/secret-stack-4.1.0.tgz";
        sha1 = "474e19c6b5d7ebb95668ec40c1865a5e7b973542";
      };
    }

    {
      name = "secure-scuttlebutt-17.1.1.tgz";
      path = fetchurl {
        name = "secure-scuttlebutt-17.1.1.tgz";
        url  = "https://registry.yarnpkg.com/secure-scuttlebutt/-/secure-scuttlebutt-17.1.1.tgz";
        sha1 = "de3715783c40df34df6a3db99ade8637ba0f1cb2";
      };
    }

    {
      name = "semver-5.5.0.tgz";
      path = fetchurl {
        name = "semver-5.5.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.5.0.tgz";
        sha1 = "dc4bbc7a6ca9d916dee5d43516f0092b58f7b8ab";
      };
    }

    {
      name = "semver-5.1.1.tgz";
      path = fetchurl {
        name = "semver-5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.1.1.tgz";
        sha1 = "a3292a373e6f3e0798da0b20641b9a9c5bc47e19";
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
      name = "semver-5.4.1.tgz";
      path = fetchurl {
        name = "semver-5.4.1.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.4.1.tgz";
        sha1 = "e059c09d8571f0540823733433505d3a2f00b18e";
      };
    }

    {
      name = "separator-escape-0.0.0.tgz";
      path = fetchurl {
        name = "separator-escape-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/separator-escape/-/separator-escape-0.0.0.tgz";
        sha1 = "e433676932020454e3c14870c517ea1de56c2fa4";
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
      name = "sha.js-2.4.5.tgz";
      path = fetchurl {
        name = "sha.js-2.4.5.tgz";
        url  = "https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.5.tgz";
        sha1 = "27d171efcc82a118b99639ff581660242b506e7c";
      };
    }

    {
      name = "sha.js-2.4.10.tgz";
      path = fetchurl {
        name = "sha.js-2.4.10.tgz";
        url  = "https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.10.tgz";
        sha1 = "b1fde5cd7d11a5626638a07c604ab909cfa31f9b";
      };
    }

    {
      name = "shallow-copy-0.0.1.tgz";
      path = fetchurl {
        name = "shallow-copy-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/shallow-copy/-/shallow-copy-0.0.1.tgz";
        sha1 = "415f42702d73d810330292cc5ee86eae1a11a170";
      };
    }

    {
      name = "shebang-command-1.2.0.tgz";
      path = fetchurl {
        name = "shebang-command-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz";
        sha1 = "44aac65b695b03398968c39f363fee5deafdf1ea";
      };
    }

    {
      name = "shebang-regex-1.0.0.tgz";
      path = fetchurl {
        name = "shebang-regex-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz";
        sha1 = "da42f49740c0b42db2ca9728571cb190c98efea3";
      };
    }

    {
      name = "shell-env-0.3.0.tgz";
      path = fetchurl {
        name = "shell-env-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/shell-env/-/shell-env-0.3.0.tgz";
        sha1 = "2250339022989165bda4eb7bf383afeaaa92dc34";
      };
    }

    {
      name = "shell-path-2.1.0.tgz";
      path = fetchurl {
        name = "shell-path-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/shell-path/-/shell-path-2.1.0.tgz";
        sha1 = "ea7d06ae1070874a1bac5c65bb9bdd62e4f67a38";
      };
    }

    {
      name = "shellsubstitute-1.2.0.tgz";
      path = fetchurl {
        name = "shellsubstitute-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/shellsubstitute/-/shellsubstitute-1.2.0.tgz";
        sha1 = "e4f702a50c518b0f6fe98451890d705af29b6b70";
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
      name = "simple-concat-1.0.0.tgz";
      path = fetchurl {
        name = "simple-concat-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/simple-concat/-/simple-concat-1.0.0.tgz";
        sha1 = "7344cbb8b6e26fb27d66b2fc86f9f6d5997521c6";
      };
    }

    {
      name = "simple-get-2.7.0.tgz";
      path = fetchurl {
        name = "simple-get-2.7.0.tgz";
        url  = "https://registry.yarnpkg.com/simple-get/-/simple-get-2.7.0.tgz";
        sha1 = "ad37f926d08129237ff08c4f2edfd6f10e0380b5";
      };
    }

    {
      name = "simple-mime-0.1.0.tgz";
      path = fetchurl {
        name = "simple-mime-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/simple-mime/-/simple-mime-0.1.0.tgz";
        sha1 = "95f517c4f466d7cff561a71fc9dab2596ea9ef2e";
      };
    }

    {
      name = "single-line-log-1.1.2.tgz";
      path = fetchurl {
        name = "single-line-log-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/single-line-log/-/single-line-log-1.1.2.tgz";
        sha1 = "c2f83f273a3e1a16edb0995661da0ed5ef033364";
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
      name = "smart-buffer-1.1.15.tgz";
      path = fetchurl {
        name = "smart-buffer-1.1.15.tgz";
        url  = "https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-1.1.15.tgz";
        sha1 = "7f114b5b65fab3e2a35aa775bb12f0d1c649bf16";
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
      name = "sntp-2.1.0.tgz";
      path = fetchurl {
        name = "sntp-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sntp/-/sntp-2.1.0.tgz";
        sha1 = "2c6cec14fedc2222739caf9b5c3d85d1cc5a2cc8";
      };
    }

    {
      name = "socks-1.1.9.tgz";
      path = fetchurl {
        name = "socks-1.1.9.tgz";
        url  = "https://registry.yarnpkg.com/socks/-/socks-1.1.9.tgz";
        sha1 = "628d7e4d04912435445ac0b6e459376cb3e6d691";
      };
    }

    {
      name = "sodium-browserify-tweetnacl-0.2.3.tgz";
      path = fetchurl {
        name = "sodium-browserify-tweetnacl-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/sodium-browserify-tweetnacl/-/sodium-browserify-tweetnacl-0.2.3.tgz";
        sha1 = "b5537ffcbb9f74ebc443b8b6a211b291e8fcbc8e";
      };
    }

    {
      name = "sodium-browserify-1.2.1.tgz";
      path = fetchurl {
        name = "sodium-browserify-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/sodium-browserify/-/sodium-browserify-1.2.1.tgz";
        sha1 = "b0b559ca36981679085214855e26645df67aaf1c";
      };
    }

    {
      name = "sodium-chloride-1.1.0.tgz";
      path = fetchurl {
        name = "sodium-chloride-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sodium-chloride/-/sodium-chloride-1.1.0.tgz";
        sha1 = "247a234b88867f6dff51332b605f193a65bf6839";
      };
    }

    {
      name = "sodium-native-2.1.4.tgz";
      path = fetchurl {
        name = "sodium-native-2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/sodium-native/-/sodium-native-2.1.4.tgz";
        sha1 = "f31e20992695ce4295a4324e08f64ee203baf0c6";
      };
    }

    {
      name = "sorted-array-functions-1.1.0.tgz";
      path = fetchurl {
        name = "sorted-array-functions-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sorted-array-functions/-/sorted-array-functions-1.1.0.tgz";
        sha1 = "78fe5808ffa1beebac2ce9a22d76039dabc599ff";
      };
    }

    {
      name = "sorted-array-functions-1.0.0.tgz";
      path = fetchurl {
        name = "sorted-array-functions-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/sorted-array-functions/-/sorted-array-functions-1.0.0.tgz";
        sha1 = "c0b554d9e709affcbe56d34c1b2514197fd38279";
      };
    }

    {
      name = "source-map-support-0.4.18.tgz";
      path = fetchurl {
        name = "source-map-support-0.4.18.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.4.18.tgz";
        sha1 = "0286a6de8be42641338594e97ccea75f0a2c585f";
      };
    }

    {
      name = "source-map-0.7.1.tgz";
      path = fetchurl {
        name = "source-map-0.7.1.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.7.1.tgz";
        sha1 = "493620ba1692945d680b93862435bf0ed95a2aa4";
      };
    }

    {
      name = "source-map-0.5.7.tgz";
      path = fetchurl {
        name = "source-map-0.5.7.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz";
        sha1 = "8a039d2d1021d22d1ea14c80d8ea468ba2ef3fcc";
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
      name = "spacetime-1.3.3.tgz";
      path = fetchurl {
        name = "spacetime-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/spacetime/-/spacetime-1.3.3.tgz";
        sha1 = "a8555bb16aea9725a77d05c592500434226b773f";
      };
    }

    {
      name = "spawn-rx-2.0.12.tgz";
      path = fetchurl {
        name = "spawn-rx-2.0.12.tgz";
        url  = "https://registry.yarnpkg.com/spawn-rx/-/spawn-rx-2.0.12.tgz";
        sha1 = "b6285294499426089beea0c3c1ec32d7fc57a376";
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
      name = "speedometer-0.1.4.tgz";
      path = fetchurl {
        name = "speedometer-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/speedometer/-/speedometer-0.1.4.tgz";
        sha1 = "9876dbd2a169d3115402d48e6ea6329c8816a50d";
      };
    }

    {
      name = "split-buffer-1.0.0.tgz";
      path = fetchurl {
        name = "split-buffer-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/split-buffer/-/split-buffer-1.0.0.tgz";
        sha1 = "b7e8e0ab51345158b72c1f6dbef2406d51f1d027";
      };
    }

    {
      name = "sprintf-js-1.1.1.tgz";
      path = fetchurl {
        name = "sprintf-js-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.1.tgz";
        sha1 = "36be78320afe5801f6cea3ee78b6e5aab940ea0c";
      };
    }

    {
      name = "ssb-about-0.1.2.tgz";
      path = fetchurl {
        name = "ssb-about-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ssb-about/-/ssb-about-0.1.2.tgz";
        sha1 = "b1a1946065f7559528cebf1601957a183d4544c3";
      };
    }

    {
      name = "ssb-avatar-0.2.0.tgz";
      path = fetchurl {
        name = "ssb-avatar-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-avatar/-/ssb-avatar-0.2.0.tgz";
        sha1 = "06cd70795ee58d1462d100a45c660df3179d3b39";
      };
    }

    {
      name = "ssb-backlinks-0.6.1.tgz";
      path = fetchurl {
        name = "ssb-backlinks-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/ssb-backlinks/-/ssb-backlinks-0.6.1.tgz";
        sha1 = "2c97ea369e366ffb821775ac70a8d7f1f7d53085";
      };
    }

    {
      name = "ssb-blobs-1.1.4.tgz";
      path = fetchurl {
        name = "ssb-blobs-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/ssb-blobs/-/ssb-blobs-1.1.4.tgz";
        sha1 = "d93f2960b494e10657869ff3bb9f72df69715dc9";
      };
    }

    {
      name = "ssb-client-4.5.2.tgz";
      path = fetchurl {
        name = "ssb-client-4.5.2.tgz";
        url  = "https://registry.yarnpkg.com/ssb-client/-/ssb-client-4.5.2.tgz";
        sha1 = "6819f23f0ac1cff3ba31f3acaf4340cc6e92c19f";
      };
    }

    {
      name = "ssb-client-4.5.7.tgz";
      path = fetchurl {
        name = "ssb-client-4.5.7.tgz";
        url  = "https://registry.yarnpkg.com/ssb-client/-/ssb-client-4.5.7.tgz";
        sha1 = "89cf625a70ab8e17073e8971c9fb5b1c046bc8c1";
      };
    }

    {
      name = "ssb-config-2.2.0.tgz";
      path = fetchurl {
        name = "ssb-config-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-config/-/ssb-config-2.2.0.tgz";
        sha1 = "41cad038a8575af4062d3fd57d3b167be85b03bc";
      };
    }

    {
      name = "ssb-feed-2.3.0.tgz";
      path = fetchurl {
        name = "ssb-feed-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-feed/-/ssb-feed-2.3.0.tgz";
        sha1 = "b84e8e0297a0f5904c4cf5a202f76ba1e078d047";
      };
    }

    {
      name = "ssb-friends-2.4.0.tgz";
      path = fetchurl {
        name = "ssb-friends-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-friends/-/ssb-friends-2.4.0.tgz";
        sha1 = "0d40cd96a12f2339c9064a8ad1d5a713e91c57ae";
      };
    }

    {
      name = "ssb-keys-7.0.13.tgz";
      path = fetchurl {
        name = "ssb-keys-7.0.13.tgz";
        url  = "https://registry.yarnpkg.com/ssb-keys/-/ssb-keys-7.0.13.tgz";
        sha1 = "9d65271005876b07ceaa27b724808f0c6010bbc9";
      };
    }

    {
      name = "ssb-links-3.0.1.tgz";
      path = fetchurl {
        name = "ssb-links-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ssb-links/-/ssb-links-3.0.1.tgz";
        sha1 = "bf85334ef47f6ee848ba7c4c6f9e963a63736f6f";
      };
    }

    {
      name = "ssb-markdown-3.5.0.tgz";
      path = fetchurl {
        name = "ssb-markdown-3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-markdown/-/ssb-markdown-3.5.0.tgz";
        sha1 = "9d2c44ad15cfef67580b93f06e8dbf172872082b";
      };
    }

    {
      name = "ssb-marked-0.7.3.tgz";
      path = fetchurl {
        name = "ssb-marked-0.7.3.tgz";
        url  = "https://registry.yarnpkg.com/ssb-marked/-/ssb-marked-0.7.3.tgz";
        sha1 = "08ab6c5ad5400db029695e3d13edfd15ca88a96e";
      };
    }

    {
      name = "ssb-mentions-0.4.1.tgz";
      path = fetchurl {
        name = "ssb-mentions-0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/ssb-mentions/-/ssb-mentions-0.4.1.tgz";
        sha1 = "13571823b534f516f740fe813b9ef0eb14b1a5f2";
      };
    }

    {
      name = "ssb-msgs-5.2.0.tgz";
      path = fetchurl {
        name = "ssb-msgs-5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-msgs/-/ssb-msgs-5.2.0.tgz";
        sha1 = "c681da5cd70c574c922dca4f03c521538135c243";
      };
    }

    {
      name = "ssb-private-0.1.4.tgz";
      path = fetchurl {
        name = "ssb-private-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/ssb-private/-/ssb-private-0.1.4.tgz";
        sha1 = "a48cb007b41e06da06a26cb9b9de32a198fc23d3";
      };
    }

    {
      name = "ssb-query-1.0.2.tgz";
      path = fetchurl {
        name = "ssb-query-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ssb-query/-/ssb-query-1.0.2.tgz";
        sha1 = "b85647def486e757067a112aaf63ea1cfc747133";
      };
    }

    {
      name = "ssb-ref-2.9.1.tgz";
      path = fetchurl {
        name = "ssb-ref-2.9.1.tgz";
        url  = "https://registry.yarnpkg.com/ssb-ref/-/ssb-ref-2.9.1.tgz";
        sha1 = "60861713d80c111a9a52ae83099e331afcdbbf6b";
      };
    }

    {
      name = "ssb-sort-0.0.0.tgz";
      path = fetchurl {
        name = "ssb-sort-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-sort/-/ssb-sort-0.0.0.tgz";
        sha1 = "384c2eb3fa48cc46c5f11d596bf686619fa8979f";
      };
    }

    {
      name = "ssb-sort-1.0.0.tgz";
      path = fetchurl {
        name = "ssb-sort-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-sort/-/ssb-sort-1.0.0.tgz";
        sha1 = "8e9956f50752d2b158247b06e49c3f491c1cd27b";
      };
    }

    {
      name = "ssb-validate-3.0.0.tgz";
      path = fetchurl {
        name = "ssb-validate-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ssb-validate/-/ssb-validate-3.0.0.tgz";
        sha1 = "8c3b0b76119a6da4384cc07bf0d322631014b945";
      };
    }

    {
      name = "ssb-ws-1.0.3.tgz";
      path = fetchurl {
        name = "ssb-ws-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/ssb-ws/-/ssb-ws-1.0.3.tgz";
        sha1 = "fbaf0464e09668f4bb9516d2c41cdc03a9d681dc";
      };
    }

    {
      name = "sshpk-1.13.1.tgz";
      path = fetchurl {
        name = "sshpk-1.13.1.tgz";
        url  = "https://registry.yarnpkg.com/sshpk/-/sshpk-1.13.1.tgz";
        sha1 = "512df6da6287144316dc4c18fe1cf1d940739be3";
      };
    }

    {
      name = "stack-0.1.0.tgz";
      path = fetchurl {
        name = "stack-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/stack/-/stack-0.1.0.tgz";
        sha1 = "e923598a9be51e617682cb21cf1b2818a449ada2";
      };
    }

    {
      name = "static-eval-0.2.4.tgz";
      path = fetchurl {
        name = "static-eval-0.2.4.tgz";
        url  = "https://registry.yarnpkg.com/static-eval/-/static-eval-0.2.4.tgz";
        sha1 = "b7d34d838937b969f9641ca07d48f8ede263ea7b";
      };
    }

    {
      name = "static-module-1.5.0.tgz";
      path = fetchurl {
        name = "static-module-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/static-module/-/static-module-1.5.0.tgz";
        sha1 = "27da9883c41a8cd09236f842f0c1ebc6edf63d86";
      };
    }

    {
      name = "statistics-3.3.0.tgz";
      path = fetchurl {
        name = "statistics-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/statistics/-/statistics-3.3.0.tgz";
        sha1 = "ec7b4750ff03ab24a64dd9b357a78316bead78aa";
      };
    }

    {
      name = "stream-to-pull-stream-1.3.1.tgz";
      path = fetchurl {
        name = "stream-to-pull-stream-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/stream-to-pull-stream/-/stream-to-pull-stream-1.3.1.tgz";
        sha1 = "f5be9be0f1e94bb3d1ae668bff8e9251b85a6c6e";
      };
    }

    {
      name = "stream-to-pull-stream-1.7.2.tgz";
      path = fetchurl {
        name = "stream-to-pull-stream-1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/stream-to-pull-stream/-/stream-to-pull-stream-1.7.2.tgz";
        sha1 = "757609ae1cebd33c7432d4afbe31ff78650b9dde";
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
      name = "string_decoder-0.10.31.tgz";
      path = fetchurl {
        name = "string_decoder-0.10.31.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      };
    }

    {
      name = "string_decoder-1.0.3.tgz";
      path = fetchurl {
        name = "string_decoder-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.0.3.tgz";
        sha1 = "0fc67d7c141825de94282dd536bec6b9bce860ab";
      };
    }

    {
      name = "stringify-entities-1.3.1.tgz";
      path = fetchurl {
        name = "stringify-entities-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/stringify-entities/-/stringify-entities-1.3.1.tgz";
        sha1 = "b150ec2d72ac4c1b5f324b51fb6b28c9cdff058c";
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
      name = "strip-eof-1.0.0.tgz";
      path = fetchurl {
        name = "strip-eof-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz";
        sha1 = "bb43ff5598a6eb05d89b59fcd129c983313606bf";
      };
    }

    {
      name = "strip-indent-1.0.1.tgz";
      path = fetchurl {
        name = "strip-indent-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-indent/-/strip-indent-1.0.1.tgz";
        sha1 = "0c7962a6adefa7bbd4ac366460a638552ae1a0a2";
      };
    }

    {
      name = "strip-json-comments-0.1.3.tgz";
      path = fetchurl {
        name = "strip-json-comments-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-0.1.3.tgz";
        sha1 = "164c64e370a8a3cc00c9e01b539e569823f0ee54";
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
      name = "suggest-box-2.2.3.tgz";
      path = fetchurl {
        name = "suggest-box-2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/suggest-box/-/suggest-box-2.2.3.tgz";
        sha1 = "c06bf0e30517531fdf747ffe0c6ff5e52bff0e44";
      };
    }

    {
      name = "sumchecker-1.3.1.tgz";
      path = fetchurl {
        name = "sumchecker-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/sumchecker/-/sumchecker-1.3.1.tgz";
        sha1 = "79bb3b4456dd04f18ebdbc0d703a1d1daec5105d";
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
      name = "symbol-observable-1.0.1.tgz";
      path = fetchurl {
        name = "symbol-observable-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.0.1.tgz";
        sha1 = "8340fc4702c3122df5d22288f88283f513d3fdd4";
      };
    }

    {
      name = "tar-fs-1.16.0.tgz";
      path = fetchurl {
        name = "tar-fs-1.16.0.tgz";
        url  = "https://registry.yarnpkg.com/tar-fs/-/tar-fs-1.16.0.tgz";
        sha1 = "e877a25acbcc51d8c790da1c57c9cf439817b896";
      };
    }

    {
      name = "tar-pack-3.4.1.tgz";
      path = fetchurl {
        name = "tar-pack-3.4.1.tgz";
        url  = "https://registry.yarnpkg.com/tar-pack/-/tar-pack-3.4.1.tgz";
        sha1 = "e1dbc03a9b9d3ba07e896ad027317eb679a10a1f";
      };
    }

    {
      name = "tar-stream-1.5.5.tgz";
      path = fetchurl {
        name = "tar-stream-1.5.5.tgz";
        url  = "https://registry.yarnpkg.com/tar-stream/-/tar-stream-1.5.5.tgz";
        sha1 = "5cad84779f45c83b1f2508d96b09d88c7218af55";
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
      name = "taskgroup-4.3.1.tgz";
      path = fetchurl {
        name = "taskgroup-4.3.1.tgz";
        url  = "https://registry.yarnpkg.com/taskgroup/-/taskgroup-4.3.1.tgz";
        sha1 = "7de193febd768273c457730497024d512c27915a";
      };
    }

    {
      name = "text-node-searcher-1.1.1.tgz";
      path = fetchurl {
        name = "text-node-searcher-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/text-node-searcher/-/text-node-searcher-1.1.1.tgz";
        sha1 = "dca6bd752564a215a6f5fded0f19089f16173f4a";
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
      name = "textarea-caret-position-0.1.1.tgz";
      path = fetchurl {
        name = "textarea-caret-position-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/textarea-caret-position/-/textarea-caret-position-0.1.1.tgz";
        sha1 = "34372aa755008b1a8451b8a1bb8f07795270fd70";
      };
    }

    {
      name = "throttleit-0.0.2.tgz";
      path = fetchurl {
        name = "throttleit-0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/throttleit/-/throttleit-0.0.2.tgz";
        sha1 = "cfedf88e60c00dd9697b61fdd2a8343a9b680eaf";
      };
    }

    {
      name = "through2-2.0.3.tgz";
      path = fetchurl {
        name = "through2-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-2.0.3.tgz";
        sha1 = "0004569b37c7c74ba39c43f3ced78d1ad94140be";
      };
    }

    {
      name = "through2-0.2.3.tgz";
      path = fetchurl {
        name = "through2-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-0.2.3.tgz";
        sha1 = "eb3284da4ea311b6cc8ace3653748a52abf25a3f";
      };
    }

    {
      name = "through2-0.4.2.tgz";
      path = fetchurl {
        name = "through2-0.4.2.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-0.4.2.tgz";
        sha1 = "dbf5866031151ec8352bb6c4db64a2292a840b9b";
      };
    }

    {
      name = "to-fast-properties-1.0.3.tgz";
      path = fetchurl {
        name = "to-fast-properties-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-1.0.3.tgz";
        sha1 = "b83571fa4d8c25b82e231b06e3a3055de4ca1a47";
      };
    }

    {
      name = "to-vfile-1.0.0.tgz";
      path = fetchurl {
        name = "to-vfile-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/to-vfile/-/to-vfile-1.0.0.tgz";
        sha1 = "88defecd43adb2ef598625f0e3d59f7f342941ba";
      };
    }

    {
      name = "tough-cookie-2.3.3.tgz";
      path = fetchurl {
        name = "tough-cookie-2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.3.3.tgz";
        sha1 = "0b618a5565b6dea90bf3425d04d55edc475a7561";
      };
    }

    {
      name = "trim-lines-1.1.0.tgz";
      path = fetchurl {
        name = "trim-lines-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/trim-lines/-/trim-lines-1.1.0.tgz";
        sha1 = "9926d03ede13ba18f7d42222631fb04c79ff26fe";
      };
    }

    {
      name = "trim-newlines-1.0.0.tgz";
      path = fetchurl {
        name = "trim-newlines-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-1.0.0.tgz";
        sha1 = "5887966bb582a4503a41eb524f7d35011815a613";
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
      name = "trim-trailing-lines-1.1.0.tgz";
      path = fetchurl {
        name = "trim-trailing-lines-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/trim-trailing-lines/-/trim-trailing-lines-1.1.0.tgz";
        sha1 = "7aefbb7808df9d669f6da2e438cac8c46ada7684";
      };
    }

    {
      name = "trim-0.0.1.tgz";
      path = fetchurl {
        name = "trim-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/trim/-/trim-0.0.1.tgz";
        sha1 = "5858547f6b290757ee95cccc666fb50084c460dd";
      };
    }

    {
      name = "tunnel-agent-0.6.0.tgz";
      path = fetchurl {
        name = "tunnel-agent-0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz";
        sha1 = "27a5dea06b36b04a0a9966774b290868f0fc40fd";
      };
    }

    {
      name = "tweetnacl-auth-0.3.1.tgz";
      path = fetchurl {
        name = "tweetnacl-auth-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/tweetnacl-auth/-/tweetnacl-auth-0.3.1.tgz";
        sha1 = "b75bc2df15649bb84e8b9aa3c0669c6c4bce0d25";
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
      name = "typechecker-2.1.0.tgz";
      path = fetchurl {
        name = "typechecker-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/typechecker/-/typechecker-2.1.0.tgz";
        sha1 = "d1c2093a54ff8a19f58cff877eeaa54f2242d383";
      };
    }

    {
      name = "typechecker-4.5.0.tgz";
      path = fetchurl {
        name = "typechecker-4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/typechecker/-/typechecker-4.5.0.tgz";
        sha1 = "c382920097812364bbaf4595b0ab6588244117a6";
      };
    }

    {
      name = "typechecker-2.0.8.tgz";
      path = fetchurl {
        name = "typechecker-2.0.8.tgz";
        url  = "https://registry.yarnpkg.com/typechecker/-/typechecker-2.0.8.tgz";
        sha1 = "e83da84bb64c584ccb345838576c40b0337db82e";
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
      name = "typewise-core-1.2.0.tgz";
      path = fetchurl {
        name = "typewise-core-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/typewise-core/-/typewise-core-1.2.0.tgz";
        sha1 = "97eb91805c7f55d2f941748fa50d315d991ef195";
      };
    }

    {
      name = "typewise-1.0.3.tgz";
      path = fetchurl {
        name = "typewise-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/typewise/-/typewise-1.0.3.tgz";
        sha1 = "1067936540af97937cc5dcf9922486e9fa284651";
      };
    }

    {
      name = "typewiselite-1.0.0.tgz";
      path = fetchurl {
        name = "typewiselite-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/typewiselite/-/typewiselite-1.0.0.tgz";
        sha1 = "c8882fa1bb1092c06005a97f34ef5c8508e3664e";
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
      name = "uint48be-1.0.2.tgz";
      path = fetchurl {
        name = "uint48be-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/uint48be/-/uint48be-1.0.2.tgz";
        sha1 = "0bea5a642953b502cff8c3469d08ed5ab543c8f6";
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
      name = "underscore-1.8.3.tgz";
      path = fetchurl {
        name = "underscore-1.8.3.tgz";
        url  = "https://registry.yarnpkg.com/underscore/-/underscore-1.8.3.tgz";
        sha1 = "4f3fb53b106e6097fcf9cb4109f2a5e9bdfa5022";
      };
    }

    {
      name = "unherit-1.1.0.tgz";
      path = fetchurl {
        name = "unherit-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/unherit/-/unherit-1.1.0.tgz";
        sha1 = "6b9aaedfbf73df1756ad9e316dd981885840cd7d";
      };
    }

    {
      name = "unified-2.1.4.tgz";
      path = fetchurl {
        name = "unified-2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/unified/-/unified-2.1.4.tgz";
        sha1 = "14bc6cd40d98ffff75b405506bad873ecbbac3ba";
      };
    }

    {
      name = "unist-util-is-2.1.1.tgz";
      path = fetchurl {
        name = "unist-util-is-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/unist-util-is/-/unist-util-is-2.1.1.tgz";
        sha1 = "0c312629e3f960c66e931e812d3d80e77010947b";
      };
    }

    {
      name = "unist-util-visit-1.3.0.tgz";
      path = fetchurl {
        name = "unist-util-visit-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/unist-util-visit/-/unist-util-visit-1.3.0.tgz";
        sha1 = "41ca7c82981fd1ce6c762aac397fc24e35711444";
      };
    }

    {
      name = "untildify-2.1.0.tgz";
      path = fetchurl {
        name = "untildify-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/untildify/-/untildify-2.1.0.tgz";
        sha1 = "17eb2807987f76952e9c0485fc311d06a826a2e0";
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
      name = "util-deprecate-1.0.2.tgz";
      path = fetchurl {
        name = "util-deprecate-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    }

    {
      name = "uuid-3.2.1.tgz";
      path = fetchurl {
        name = "uuid-3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.2.1.tgz";
        sha1 = "12c528bb9d58d0b9265d9a2f6f0fe8be17ff1f14";
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
      name = "verror-1.10.0.tgz";
      path = fetchurl {
        name = "verror-1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/verror/-/verror-1.10.0.tgz";
        sha1 = "3a105ca17053af55d6e270c1f8288682e18da400";
      };
    }

    {
      name = "vfile-find-down-1.0.0.tgz";
      path = fetchurl {
        name = "vfile-find-down-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/vfile-find-down/-/vfile-find-down-1.0.0.tgz";
        sha1 = "84a4d66d03513f6140a84e0776ef0848d4f0ad95";
      };
    }

    {
      name = "vfile-find-up-1.0.0.tgz";
      path = fetchurl {
        name = "vfile-find-up-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/vfile-find-up/-/vfile-find-up-1.0.0.tgz";
        sha1 = "5604da6fe453b34350637984eb5fe4909e280390";
      };
    }

    {
      name = "vfile-reporter-1.5.0.tgz";
      path = fetchurl {
        name = "vfile-reporter-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/vfile-reporter/-/vfile-reporter-1.5.0.tgz";
        sha1 = "21a7009bfe55e24df8ff432aa5bf6f6efa74e418";
      };
    }

    {
      name = "vfile-sort-1.0.0.tgz";
      path = fetchurl {
        name = "vfile-sort-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/vfile-sort/-/vfile-sort-1.0.0.tgz";
        sha1 = "17ee491ba43e8951bb22913fcff32a7dc4d234d4";
      };
    }

    {
      name = "vfile-1.4.0.tgz";
      path = fetchurl {
        name = "vfile-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/vfile/-/vfile-1.4.0.tgz";
        sha1 = "c0fd6fa484f8debdb771f68c31ed75d88da97fe7";
      };
    }

    {
      name = "ware-1.3.0.tgz";
      path = fetchurl {
        name = "ware-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ware/-/ware-1.3.0.tgz";
        sha1 = "d1b14f39d2e2cb4ab8c4098f756fe4b164e473d4";
      };
    }

    {
      name = "watchr-2.4.13.tgz";
      path = fetchurl {
        name = "watchr-2.4.13.tgz";
        url  = "https://registry.yarnpkg.com/watchr/-/watchr-2.4.13.tgz";
        sha1 = "d74847bb4d6f90f61fe2c74f9f68662aa0e07601";
      };
    }

    {
      name = "web-bootloader-0.1.2.tgz";
      path = fetchurl {
        name = "web-bootloader-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/web-bootloader/-/web-bootloader-0.1.2.tgz";
        sha1 = "de18224ce986333ea988c38e376e8818f2902486";
      };
    }

    {
      name = "which-pm-runs-1.0.0.tgz";
      path = fetchurl {
        name = "which-pm-runs-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/which-pm-runs/-/which-pm-runs-1.0.0.tgz";
        sha1 = "670b3afbc552e0b55df6b7780ca74615f23ad1cb";
      };
    }

    {
      name = "which-1.3.0.tgz";
      path = fetchurl {
        name = "which-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-1.3.0.tgz";
        sha1 = "ff04bdfc010ee547d780bec38e1ac1c2777d253a";
      };
    }

    {
      name = "wide-align-1.1.2.tgz";
      path = fetchurl {
        name = "wide-align-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.2.tgz";
        sha1 = "571e0f1b0604636ebc0dfc21b0339bbe31341710";
      };
    }

    {
      name = "word-wrap-1.2.3.tgz";
      path = fetchurl {
        name = "word-wrap-1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz";
        sha1 = "610636f6b1f703891bd34771ccb17fb93b47079c";
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
      name = "wrap-fn-0.1.5.tgz";
      path = fetchurl {
        name = "wrap-fn-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/wrap-fn/-/wrap-fn-0.1.5.tgz";
        sha1 = "f21b6e41016ff4a7e31720dbc63a09016bdf9845";
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
      name = "ws-1.1.5.tgz";
      path = fetchurl {
        name = "ws-1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-1.1.5.tgz";
        sha1 = "cbd9e6e75e09fc5d2c90015f21f0c40875e0dd51";
      };
    }

    {
      name = "xmlhttprequest-1.8.0.tgz";
      path = fetchurl {
        name = "xmlhttprequest-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/xmlhttprequest/-/xmlhttprequest-1.8.0.tgz";
        sha1 = "67fe075c5c24fef39f9d65f5f7b7fe75171968fc";
      };
    }

    {
      name = "xregexp-2.0.0.tgz";
      path = fetchurl {
        name = "xregexp-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xregexp/-/xregexp-2.0.0.tgz";
        sha1 = "52a63e56ca0b84a7f3a5f3d61872f126ad7a5943";
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
      name = "xtend-2.1.2.tgz";
      path = fetchurl {
        name = "xtend-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-2.1.2.tgz";
        sha1 = "6efecc2a4dad8e6962c4901b337ce7ba87b5d28b";
      };
    }

    {
      name = "xtend-3.0.0.tgz";
      path = fetchurl {
        name = "xtend-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-3.0.0.tgz";
        sha1 = "5cce7407baf642cba7becda568111c493f59665a";
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
      name = "yauzl-2.4.1.tgz";
      path = fetchurl {
        name = "yauzl-2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/yauzl/-/yauzl-2.4.1.tgz";
        sha1 = "9528f442dab1b2284e58b4379bb194e22e0c4005";
      };
    }

    {
      name = "zerr-1.0.4.tgz";
      path = fetchurl {
        name = "zerr-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/zerr/-/zerr-1.0.4.tgz";
        sha1 = "62814dd799eff8361f2a228f41f705c5e19de4c9";
      };
    }
  ];
}
