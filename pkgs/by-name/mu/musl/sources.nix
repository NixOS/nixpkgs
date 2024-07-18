{
  lib,
  fetchurl,
}:

{
  # From Alpine, I suppose...
  cdefs_h = {
    pname = "sys-cdefs.h";
    version = "0-unstable-2023-01-21";

    src =  fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/main/libc-dev/sys-cdefs.h?id=7ca0ed62d4c0d713d9c7dd5b9a077fba78bce578";
      hash = "sha256-MLttfg4LYfzZXYMMN2yCmmFLzkaDwbl+BsIB7Cxug5o=";
    };
  };

  # From NetBSD - should we pick them from original sources?
  queue_h = {
    pname = "sys-queue.h";
    version = "0-unstable-2023-01-21";

    src = fetchurl {
      url = "http://git.alpinelinux.org/aports/plain/main/libc-dev/sys-queue.h?id=7ca0ed62d4c0d713d9c7dd5b9a077fba78bce578";
      hash = "sha256-wTQH7dDjO+c8rnJRTLI0+GEuHA5UQByUSNr/06JAFYs=";
    };
  };

  # From NetBSD - should we pick them from original sources?
  tree_h = {
    pname = "sys-tree.h";
    version = "0-unstable-2023-01-21";

    src = fetchurl {
      url = "http://git.alpinelinux.org/aports/plain/main/libc-dev/sys-tree.h?id=7ca0ed62d4c0d713d9c7dd5b9a077fba78bce578";
      hash = "sha256-4eSYp5vxYKV2b6Vg8rB7IG/on+IaYmAMd9cuAKaZL5I=";
    };
  };

  # From Alpine
  stack_chk_fail_local_c = {
    pname = "stack-chk-fail-local-c";
    version = "0-unstable-2013-09-24";

    src = fetchurl {
      name = "__stack_chk_fail_local.c";
      url = "https://git.alpinelinux.org/aports/plain/main/musl/__stack_chk_fail_local.c?id=9afbe3cbbf4c30ff23c733218c3c03d7e8c6461d";
      hash = "sha256-KZp9daCd4+LhHn+0rMMYLkoU6GgJPS8wk4/Om/z/E9o=";
    };
  };

  # iconv tool, implemented by musl author.
  # Original: http://git.etalabs.net/cgit/noxcuse/plain/src/iconv.c?id=02d288d89683e99fd18fe9f54d4e731a6c474a4f
  # We use the version from Alpine which fixes error messages.
  iconv_c = {
    pname = "iconv-c";
    version = "0-unstable-2014-06-06";

    src = fetchurl {
      name = "iconv.c";
      url = "https://git.alpinelinux.org/aports/plain/main/musl/iconv.c?id=a3d97e95f766c9c378194ee49361b375f093b26f";
      hash = "sha256-95opMKLluwYkMhWJ7fi4idHptgPgHmt64hRhZgWz/dc=";
    };
  };

  musl = let
    self = {
      pname = "musl";
      version = "1.2.3";

      src = fetchurl {
        url = "https://musl.libc.org/releases/musl-${self.version}.tar.gz";
        hash = "sha256-fVsLYGJSHkYn4JnkydyCSNMqMChelZt+7Kp4DPjP1KQ=";
      };
    };
  in
    self;
}
