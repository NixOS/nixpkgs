{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_14,
  ncurses,
  gettext,
  pkg-config,
  cscope,
  ruby_3_4,
  tcl,
  perl,
  luajit,
  python3,
  # Setting withXcodePath makes it use that instead of the system-default Xcode.
  # This can be set to one of the `darwin.xcode_*` packages as well.
  # If set, this should be a path to Xcode.app, e.g. `"/Applications/Xcode.app"`.
  withXcodePath ? null,
}:

# Try to match MacVim's documented script interface compatibility
let
  # Ruby 3.4
  ruby = ruby_3_4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "macvim";

  version = "182";

  src = fetchFromGitHub {
    owner = "macvim-dev";
    repo = "macvim";
    tag =
      let
        releaseType = if lib.hasInfix "." finalAttrs.version then "prerelease" else "release";
      in
      "${releaseType}-${finalAttrs.version}";
    hash = "sha256-JEb71wZcvFsz94vb3+gC83BhlEccjlPrpr9RCXDUEIo=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    # MacVim references up to MAC_OS_VERSION_14_0 in its source
    # Update this SDK if it adds APIs that use newer versions
    # (check both MAC_OS_VERSION_* and MAC_OS_X_VERSION_*)
    apple-sdk_14
    gettext
    ncurses
    cscope
    luajit
    ruby
    tcl
    perl
    python3
  ];

  patches = [
    ./macvim.patch
    # Xcode 26.0 sets *_DEPLOYMENT_TARGET env vars for all platforms in shell script build phases.
    # This breaks invocations of clang in those phases, as they target the wrong platform.
    # Note: The shell script build phase in question uses /bin/zsh.
    # This also adds --jobs=1 to the shell script build phase invocation of `make` as running in
    # parallel is causing the gvim.1 manpage to go missing.
    ./macvim-xcode26.patch
  ];

  # Fix clang version detection in configure script, it's getting tripped up
  # because the InstalledDir matches the same pattern
  postPatch = ''
    substituteInPlace src/auto/configure \
      --replace-fail /usr/bin/grep grep \
      --replace-fail '$CC --version 2>/dev/null |' '$CC --version 2>/dev/null | head -1 |'
  ''
  # Remove $(VIMTARGET) from the installrtbase rule deps. MacVim already comments out the usage of
  # this executable in this rule, and for some reason Xcode is deleting it after copying it into
  # MacVim.app/Contents/MacOS/, so this is getting rebuilt unnecessarily and causing issues.
  + ''
    substituteInPlace src/Makefile \
      --replace-fail \
        'installrtbase: $(HELPSOURCE)/vim.1 $(DEST_VIM) $(VIMTARGET) $(DEST_RT)' \
        'installrtbase: $(HELPSOURCE)/vim.1 $(DEST_VIM) $(DEST_RT)'
  ''
  # Patch in the xcode path we want
  + ''
    xcodebuildPath=${
      if withXcodePath == null then
        "$(DEVELOPER_DIR= /usr/bin/xcrun -find xcodebuild)"
      else
        lib.escapeShellArg "${withXcodePath}/Contents/Developer/usr/bin/xcodebuild"
    }
    substituteInPlace src/Makefile \
      --replace-fail xcodebuild "$xcodebuildPath"
  ''
  # QuickLookStephen calls `qlmanage -r` in a shell script phase
  + ''
    substituteInPlace src/MacVim/qlstephen/QuickLookStephen.xcodeproj/project.pbxproj \
      --replace-fail qlmanage /usr/bin/qlmanage
  '';

  configureFlags = [
    "--enable-cscope"
    "--enable-fail-if-missing"
    "--with-features=huge"
    "--enable-gui=macvim"
    "--enable-multibyte"
    "--enable-nls"
    "--enable-luainterp=yes"
    "--enable-python3interp=yes"
    "--enable-perlinterp=yes"
    "--enable-rubyinterp=yes"
    "--enable-tclinterp=yes"
    "--without-local-dir"
    "--with-luajit"
    "--with-lua-prefix=${luajit}"
    "--with-python3-command=${python3}/bin/python3"
    "--with-ruby-command=${ruby}/bin/ruby"
    "--with-tclsh=${tcl}/bin/tclsh"
    "--with-tlib=ncurses"
    "--with-compiledby=Nix"
    "--disable-sparkle"
  ];

  preConfigure = ''
    configureFlagsArray+=(
      --with-developer-dir="$DEVELOPER_DIR"
      CFLAGS="-Wno-error=implicit-function-declaration"
    )
  ''
  # Having `$LD` set causes Xcode to invoke `ld` instead of `clang` as the linker, but it still
  # passes flags intended for clang.
  + ''
    unset LD
  ''
  # When building with nix-daemon, we need to pass -derivedDataPath or else it tries to use
  # a folder rooted in /var/empty and fails. Unfortunately we can't just pass -derivedDataPath
  # by itself as this flag requires the use of -scheme or -xctestrun (not sure why), but MacVim
  # by default just runs `xcodebuild -project src/MacVim/MacVim.xcodeproj`, relying on the default
  # behavior to build the first target in the project. Experimentally, there seems to be a scheme
  # called MacVim, so we'll explicitly select that. We also need to specify the configuration too
  # as the scheme seems to have the wrong default.
  # Passing ENABLE_CODE_COVERAGE=NO because it's defaulting on for some reason.
  # Passing ONLY_ACTIVE_ARCH=YES because QuickLookStephen.xcodeproj is building Universal by default.
  + ''
    configureFlagsArray+=(
      XCODEFLAGS="-scheme MacVim -derivedDataPath $NIX_BUILD_TOP/derivedData ENABLE_CODE_COVERAGE=NO ONLY_ACTIVE_ARCH=YES"
      --with-xcodecfg="Release"
    )
  '';

  postConfigure = ''
    substituteInPlace src/MacVim/vimrc --subst-var-by CSCOPE ${cscope}/bin/cscope
  '';

  # Note that $out/MacVim.app has a misnamed set of binaries in the Contents/bin folder (the V is
  # capitalized) and is missing a bunch of them. This is why we're grabbing the version from the
  # build folder.
  postInstall = ''
    mkdir -p $out/Applications
    cp -r src/MacVim/build/Release/MacVim.app $out/Applications
    rm -rf $out/MacVim.app

    mkdir -p $out/bin
    for prog in ex vi {,g,m,r}vi{m,mdiff,ew}; do
      ln -s $out/Applications/MacVim.app/Contents/bin/mvim $out/bin/$prog
    done
    for prog in {,g}vimtutor xxd; do
      ln -s $out/Applications/MacVim.app/Contents/bin/$prog $out/bin/$prog
    done
    ln -s $out/Applications/MacVim.app/Contents/bin/gvimtutor $out/bin/mvimtutor

    mkdir -p $out/share
    ln -s $out/Applications/MacVim.app/Contents/man $out/share/man

    # Remove manpages from tools we aren't providing
    find $out/Applications/MacVim.app/Contents/man \( -name evim.1 -or -name eview.1 \) -delete
  '';

  # macvim obj-c log macro triggers -Wformat-security (seems like a bug? it's a string literal!)
  hardeningDisable = [ "format" ];
  # os_log also enables -Werror,-Wformat by default
  env.NIX_CFLAGS_COMPILE = "-DOS_LOG_FORMAT_WARNINGS";

  # We rely on the user's Xcode install to build. It may be located in an arbitrary place, and
  # it's not clear what system-level components it may require, so for now we'll just allow full
  # filesystem access. This way the package still can't access the network.
  sandboxProfile = ''
    (allow file-read* file-write* process-exec mach-lookup)
    ; block homebrew dependencies
    (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';

  meta = with lib; {
    description = "Vim - the text editor - for macOS";
    homepage = "https://macvim.org/";
    license = licenses.vim;
    maintainers = with maintainers; [ lilyball ];
    platforms = platforms.darwin;
    hydraPlatforms = [ ]; # hydra can't build this as long as we rely on Xcode and sandboxProfile
  };
})
