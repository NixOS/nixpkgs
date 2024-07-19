{
  lib,
  fetchFromGitHub,
  fetchurl,
}:

{
  # A new source for compat headers: Projeto Pindorama!
  # They did a nice work of seeking the history of them, so let's use it
  musl-compat = {
    pname = "musl-compat";
    version = "0-unstable-2023-06-01";

    src = fetchFromGitHub {
      owner = "Projeto-Pindorama";
      repo = "musl-compat";
      rev = "15a3f6047b5efdeebf07ccdce8ced33692c1bd1c";
      hash = "sha256-hwlHOuVSX+54q47fbzmQFY1TPFn7Bp7S5y/vKa6cMHA=";
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
