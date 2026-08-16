{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  replaceVars,
  tradcpp,
  xorg-cf-files,
  pkg-config,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "imake";
  version = "1.0.11";

  src = fetchurl {
    url = "mirror://xorg/individual/util/imake-${finalAttrs.version}.tar.xz";
    hash = "sha256-VZVVJ+rr6UYz5Ag9T+XyFgpl/kxtr97ki4n+pfHKing=";
  };

  patches = [
    # Disable imake autodetection for:
    # - LinuxDistribution to avoid injection of /usr paths
    # - gcc to avoid use uf /usr/bin/gcc
    # https://github.com/NixOS/nixpkgs/issues/135337
    ./disable-autodetection.patch
    # uberhack to workaround broken 'gcc -x c'
    #
    # Our cc-wrapper is broken whenever the '-x' flag is used:
    # 'gcc -x c foo.c -o bar' doesn't work the same way as 'gcc foo.c -o bar'
    # does. (Try both with NIX_DEBUG=1.)
    #
    # What happens is that passing '-x' causes linker-related flags (such as
    # -Wl,-dynamic-linker) not to be added, just like if '-c' is passed.
    # The bug happens outside the multiple-outputs branch as well, but it
    # doesn't break imake there. It only breaks in multiple-outputs because
    # linking without -Wl,-dynamic-linker produces a binary with an invalid
    # ELF interpreter path. (Which arguably, is a bug in its own.)
    # (copied from the commit message on 0100b270694ecab8aaa13fa5f3d30639b50d7777)
    ./cc-wrapper-uberhack.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ xorgproto ];

  configureFlags = [
    "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp"
  ];

  env.CFLAGS = "-DIMAKE_COMPILETIME_CPP='\"${
    if stdenv.hostPlatform.isDarwin then "${tradcpp}/bin/cpp" else "gcc"
  }\"'";

  preInstall = ''
    mkdir -p $out/lib/X11/config
    ln -s ${xorg-cf-files}/lib/X11/config/* $out/lib/X11/config
  '';

  setupHook = replaceVars ./setup-hook.sh {
    inherit tradcpp;
  };

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/util/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Obsolete C preprocessor interface to the make utility";
    homepage = "https://gitlab.freedesktop.org/xorg/util/imake";
    license = with lib.licenses; [
      mitOpenGroup
      x11
    ];
    mainProgram = "imake";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
