{
  lib,
  stdenv,
  fetchpatch,
  fetchzip,
  writeText,
  conf ? null,
}:

let
  rev = "8c32909a159aaa9484c82b71f05b7a73321eb491";
  defaultUserConfig = writeText "config.def.h" conf;
in
stdenv.mkDerivation {
  pname = "abduco";
  version = "0.6.0-unstable-2020-04-30";

  src = fetchzip {
    urls = [
      "https://github.com/martanne/abduco/archive/${rev}.tar.gz"
      "https://git.sr.ht/~martanne/abduco/archive/${rev}.tar.gz"
    ];
    hash = "sha256-o7SPK/G31cW/rrLwV3UJOTq6EBHl6AEE/GdeKGlHdyg=";
  };

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "-D_DARWIN_C_SOURCE" ];

  preBuild = lib.optionalString (conf != null) "cp ${defaultUserConfig} config.def.h";

  installFlags = [ "install-completion" ];

  patches = [
    # https://github.com/martanne/abduco/pull/22
    (fetchpatch {
      name = "use-XDG-directory-scheme-by-default";
      url = "https://github.com/martanne/abduco/commit/0e9a00312ac9777edcb169122144762e3611287b.patch";
      hash = "sha256-4NkIflbRkUpS5XTM/fxBaELpvlZ4S5lecRa8jk0XC9g=";
    })

    # “fix bug where attaching to dead session won't give underlying exit code”
    # https://github.com/martanne/abduco/pull/45
    (fetchpatch {
      name = "exit-code-when-attaching-to-dead-session";
      url = "https://github.com/martanne/abduco/commit/972ca8ab949ee342569dbd66b47cc4a17b28247b.patch";
      hash = "sha256-8hios0iKYDOmt6Bi5NNM9elTflGudnG2xgPF1pSkHI0=";
    })

    # “report pixel sizes to child processes that use ioctl(0, TIOCGWINSZ, ...)”
    # used for kitty & other terminals that display images
    # https://github.com/martanne/abduco/pull/62
    (fetchpatch {
      name = "report-pixel-sizes-to-child-processes";
      url = "https://github.com/martanne/abduco/commit/a1e222308119b3251f00b42e1ddff74a385d4249.patch";
      hash = "sha256-eiF0A4IqJrrvXxjBYtltuVNpxQDv/iQPO+K7Y8hWBGg=";
    })
  ];

  meta = {
    homepage = "http://brain-dump.org/projects/abduco";
    license = lib.licenses.isc;
    description = "Allows programs to be run independently from its controlling terminal";
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.unix;
    mainProgram = "abduco";
  };
}
