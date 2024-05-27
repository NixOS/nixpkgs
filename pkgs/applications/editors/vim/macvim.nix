{ lib
, stdenv
, fetchFromGitHub
, runCommand
, ncurses
, gettext
, pkg-config
, cscope
, ruby
, tcl
, perl
, luajit
, darwin
, libiconv
, python3
}:

let
  # Building requires a few system tools to be in PATH.
  # Some of these we could patch into the relevant source files (such as xcodebuild and
  # qlmanage) but some are used by Xcode itself and we have no choice but to put them in PATH.
  # Symlinking them in this way is better than just putting all of /usr/bin in there.
  buildSymlinks = runCommand "macvim-build-symlinks" {} ''
    mkdir -p $out/bin
    ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
  '';
in

stdenv.mkDerivation {
  pname = "macvim";

  version = "8.2.3455";

  src = fetchFromGitHub {
    owner = "macvim-dev";
    repo = "macvim";
    rev = "snapshot-172";
    sha256 = "sha256-LLLQ/V1vyKTuSXzHW3SOlOejZD5AV16NthEdMoTnfko=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config buildSymlinks ];
  buildInputs = [
    gettext ncurses cscope luajit ruby tcl perl python3
  ];

  patches = [ ./macvim.patch ];

  configureFlags = [
      "--enable-cscope"
      "--enable-fail-if-missing"
      "--with-features=huge"
      "--enable-gui=macvim"
      "--enable-multibyte"
      "--enable-nls"
      "--enable-luainterp=dynamic"
      "--enable-python3interp=dynamic"
      "--enable-perlinterp=dynamic"
      "--enable-rubyinterp=dynamic"
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

  # Remove references to Sparkle.framework from the project.
  # It's unused (we disabled it with --disable-sparkle) and this avoids
  # copying the unnecessary several-megabyte framework into the result.
  postPatch = ''
    echo "Patching file src/MacVim/MacVim.xcodeproj/project.pbxproj"
    sed -e '/Sparkle\.framework/d' -i src/MacVim/MacVim.xcodeproj/project.pbxproj
  '';

  # This is unfortunate, but we need to use the same compiler as Xcode,
  # but Xcode doesn't provide a way to configure the compiler.
  preConfigure = ''
    CC=/usr/bin/clang

    DEV_DIR=$(/usr/bin/xcode-select -print-path)/Platforms/MacOSX.platform/Developer
    configureFlagsArray+=(
      --with-developer-dir="$DEV_DIR"
      LDFLAGS="-L${ncurses}/lib"
      CPPFLAGS="-isystem ${ncurses.dev}/include"
      CFLAGS="-Wno-error=implicit-function-declaration"
    )
  ''
  # For some reason having LD defined causes PSMTabBarControl to fail at link-time as it
  # passes arguments to ld that it meant for clang.
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
  + ''
    configureFlagsArray+=(
      XCODEFLAGS="-scheme MacVim -derivedDataPath $NIX_BUILD_TOP/derivedData"
      --with-xcodecfg="Release"
    )
  ''
  ;

  # Because we're building with system clang, this means we're building against Xcode's SDK and
  # linking against system libraries. The configure script is picking up Nix Libsystem (via ruby)
  # so we need to patch that out or we'll get linker issues. The MacVim binary built by Xcode links
  # against the system anyway so it doesn't really matter that the Vim binary will too. If we
  # decide that matters, we can always patch it back to the Nix libsystem post-build.
  # It also picks up libiconv, libunwind, and objc4 from Nix. These seem relatively harmless but
  # let's strip them out too.
  #
  # Note: If we do add a post-build install_name_tool patch, we need to add the
  # "LDFLAGS=-headerpad_max_install_names" flag to configureFlags and either patch it into the
  # Xcode project or pass it as a flag to xcodebuild as well.
  postConfigure = ''
    substituteInPlace src/auto/config.mk \
      --replace "PERL_CFLAGS	=" "PERL_CFLAGS	= -I${darwin.libutil}/include" \
      --replace " -L${stdenv.cc.libc}/lib" "" \
      --replace " -L${darwin.libobjc}/lib" "" \
      --replace " -L${darwin.libunwind}/lib" "" \
      --replace " -L${libiconv}/lib" ""

    # All the libraries we stripped have -osx- in their name as of this time.
    # Assert now that this pattern no longer appears in config.mk.
    ( # scope variable
      while IFS="" read -r line; do
        if [[ "$line" == LDFLAGS*-osx-* ]]; then
          echo "WARNING: src/auto/config.mk contains reference to Nix osx library" >&2
        fi
      done <src/auto/config.mk
    )

    substituteInPlace src/MacVim/vimrc --subst-var-by CSCOPE ${cscope}/bin/cscope
  '';

  postInstall = ''
    mkdir -p $out/Applications
    cp -r src/MacVim/build/Release/MacVim.app $out/Applications
    rm -rf $out/MacVim.app

    rm $out/bin/*

    cp src/vimtutor $out/bin
    for prog in mvim ex vi vim vimdiff view rvim rvimdiff rview; do
      ln -s $out/Applications/MacVim.app/Contents/bin/mvim $out/bin/$prog
    done

    # Fix rpaths
    exe="$out/Applications/MacVim.app/Contents/MacOS/Vim"
    libperl=$(dirname $(find ${perl} -name "libperl.dylib"))
    install_name_tool -add_rpath ${luajit}/lib $exe
    install_name_tool -add_rpath ${tcl}/lib $exe
    install_name_tool -add_rpath ${python3}/lib $exe
    install_name_tool -add_rpath $libperl $exe
    install_name_tool -add_rpath ${ruby}/lib $exe

    # Remove manpages from tools we aren't providing
    find $out/share/man \( -name eVim.1 -or -name xxd.1 \) -delete
  '';

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
    homepage    = "https://github.com/macvim-dev/macvim";
    license = licenses.vim;
    maintainers = with maintainers; [ lilyball ];
    platforms   = platforms.darwin;
    hydraPlatforms = []; # hydra can't build this as long as we rely on Xcode and sandboxProfile
  };
}
