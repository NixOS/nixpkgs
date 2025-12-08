{
  stdenv,
  fetchurl,
  lib,
  ncurses,
  openssl,
  cjson,
  enchant,
  gnutls,
  gettext,
  zlib,
  curl,
  pkg-config,
  libgcrypt,
  cmake,
  libresolv,
  libiconv,
  asciidoctor, # manpages
  enableTests ? !stdenv.hostPlatform.isDarwin,
  cpputest,
  guileSupport ? true,
  guile,
  luaSupport ? true,
  lua5_3,
  perlSupport ? true,
  perl,
  pythonSupport ? true,
  python3Packages,
  rubySupport ? true,
  ruby,
  tclSupport ? true,
  tcl,
  phpSupport ? !stdenv.hostPlatform.isDarwin,
  php,
  systemdLibs,
  libxml2,
  pcre2,
  libargon2,
  extraBuildInputs ? [ ],
  writeScript,
  versionCheckHook,
}:

let
  inherit (python3Packages) python;
  php-embed = php.override {
    embedSupport = true;
    apxs2Support = false;
  };
  plugins = [
    {
      name = "perl";
      enabled = perlSupport;
      cmakeFlag = "ENABLE_PERL";
      buildInputs = [ perl ];
    }
    {
      name = "tcl";
      enabled = tclSupport;
      cmakeFlag = "ENABLE_TCL";
      buildInputs = [ tcl ];
    }
    {
      name = "ruby";
      enabled = rubySupport;
      cmakeFlag = "ENABLE_RUBY";
      buildInputs = [ ruby ];
    }
    {
      name = "guile";
      enabled = guileSupport;
      cmakeFlag = "ENABLE_GUILE";
      buildInputs = [ guile ];
    }
    {
      name = "lua";
      enabled = luaSupport;
      cmakeFlag = "ENABLE_LUA";
      buildInputs = [ lua5_3 ];
    }
    {
      name = "python";
      enabled = pythonSupport;
      cmakeFlag = "ENABLE_PYTHON3";
      buildInputs = [ python ];
    }
    {
      name = "php";
      enabled = phpSupport;
      cmakeFlag = "ENABLE_PHP";
      buildInputs = [
        php-embed.unwrapped.dev
        libxml2
        pcre2
        libargon2
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ systemdLibs ];
    }
  ];
  enabledPlugins = builtins.filter (p: p.enabled) plugins;

in

assert lib.all (p: p.enabled -> !(builtins.elem null p.buildInputs)) plugins;

stdenv.mkDerivation rec {
  pname = "weechat";
  version = "4.8.1";

  src = fetchurl {
    url = "https://weechat.org/files/src/weechat-${version}.tar.xz";
    hash = "sha256-56wfvMcUWO1keq2odHmQkFy1v7k/2MzMvCqWlnOkKFo=";
  };

  # Why is this needed? https://github.com/weechat/weechat/issues/2031
  patches = lib.optionals gettext.gettextNeedsLdflags [
    ./gettext-intl.patch
  ];

  outputs = [
    "out"
    "man"
  ]
  ++ map (p: p.name) enabledPlugins;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_MAN" true)
    (lib.cmakeBool "ENABLE_DOC" true)
    (lib.cmakeBool "ENABLE_DOC_INCOMPLETE" true)
    (lib.cmakeBool "ENABLE_TESTS" enableTests)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "ICONV_LIBRARY" "${libiconv}/lib/libiconv.dylib")
  ]
  ++ map (p: lib.cmakeBool p.cmakeFlag p.enabled) plugins;

  nativeBuildInputs = [
    cmake
    pkg-config
    asciidoctor
  ]
  ++ lib.optionals enableTests [ cpputest ];

  buildInputs = [
    ncurses
    openssl
    cjson
    enchant
    gnutls
    gettext
    zlib
    curl
    libgcrypt
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libresolv
  ]
  ++ lib.concatMap (p: p.buildInputs) enabledPlugins
  ++ extraBuildInputs;

  env.NIX_CFLAGS_COMPILE =
    "-I${python}/include/${python.libPrefix}"
    # Fix '_res_9_init: undefined symbol' error
    + (lib.optionalString stdenv.hostPlatform.isDarwin "-DBIND_8_COMPAT=1 -lresolv");

  postInstall = ''
    for p in ${lib.concatMapStringsSep " " (p: p.name) enabledPlugins}; do
      from=$out/lib/weechat/plugins/$p.so
      to=''${!p}/lib/weechat/plugins/$p.so
      mkdir -p $(dirname $to)
      mv $from $to
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = writeScript "update-weechat" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p coreutils gawk git gnugrep common-updater-scripts
    set -eu -o pipefail

    version="$(git ls-remote --refs https://github.com/weechat/weechat | \
      awk '{ print $2 }' | \
      grep "refs/tags/v" | \
      sed -E -e 's,refs/tags/v(.*)$,\1,' | \
      sort --version-sort --reverse | \
      head -n1)"
    update-source-version weechat-unwrapped "$version"
  '';

  meta = {
    homepage = "https://weechat.org/";
    changelog = "https://github.com/weechat/weechat/releases/tag/v${version}";
    description = "Fast, light and extensible chat client";
    longDescription = ''
      You can find more documentation as to how to customize this package
      (e.g. adding python modules for scripts that would require them, etc.)
      on https://nixos.org/nixpkgs/manual/#sec-weechat .
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ncfavier ];
    mainProgram = "weechat";
    platforms = lib.platforms.unix;
  };
}
