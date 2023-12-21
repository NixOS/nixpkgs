{ clangStdenv
, lib
, runCommandWith
, writeShellScript
, fetchFromGitHub
, fetchpatch

, freetype
, libjpeg
, libpng
, libtiff
, giflib
, libX11
, libXext
, libXrandr
, libXcursor
, libxkbfile
, cairo
, libglvnd
, fontconfig
, dbus
, libGLU
, fuse
, ffmpeg
, pulseaudio

, makeWrapper
, python2
, python3
, cmake
, ninja
, pkg-config
, bison
, flex

, libbsd
, openssl

, xdg-user-dirs

, addOpenGLRunpath

# Whether to pre-compile Python 2 bytecode for performance.
, compilePy2Bytecode ? false
}:
let
  stdenv = clangStdenv;

  # The build system invokes clang to compile Darwin executables.
  # In this case, our cc-wrapper must not be used.
  ccWrapperBypass = runCommandWith {
    inherit stdenv;
    name = "cc-wrapper-bypass";
    runLocal = false;
    derivationArgs = {
      template = writeShellScript "template" ''
        for (( i=1; i<=$#; i++)); do
          j=$((i+1))
          if [[ "''${!i}" == "-target" && "''${!j}" == *"darwin"* ]]; then
            # their flags must take precedence
            exec @unwrapped@ "$@" $NIX_CFLAGS_COMPILE
          fi
        done
        exec @wrapped@ "$@"
      '';
    };
  } ''
    unwrapped_bin=${stdenv.cc.cc}/bin
    wrapped_bin=${stdenv.cc}/bin

    mkdir -p $out/bin

    unwrapped=$unwrapped_bin/$CC wrapped=$wrapped_bin/$CC \
      substituteAll $template $out/bin/$CC
    unwrapped=$unwrapped_bin/$CXX wrapped=$wrapped_bin/$CXX \
      substituteAll $template $out/bin/$CXX

    chmod +x $out/bin/$CC $out/bin/$CXX
  '';

  wrappedLibs = [
    # To find all of them: rg -w wrap_elf

    # src/native/CMakeLists.txt
    freetype
    libjpeg
    libpng
    libtiff
    giflib
    libX11
    libXext
    libXrandr
    libXcursor
    libxkbfile
    cairo
    libglvnd
    fontconfig
    dbus
    libGLU

    # src/external/darling-dmg/CMakeLists.txt
    fuse

    # src/CoreAudio/CMakeLists.txt
    ffmpeg
    pulseaudio
  ];
in stdenv.mkDerivation {
  pname = "darling";
  version = "unstable-2023-05-02";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling";
    rev = "557e7e9dece394a3f623825679474457e5b64fd0";
    fetchSubmodules = true;
    hash = "sha256-SOoLaV7wg33qRHPQXkdMvrY++CvoG85kwd6IU6DkYa0=";
  };

  outputs = [ "out" "sdk" ];

  postPatch = ''
    # We have to be careful - Patching everything indiscriminately
    # would affect Darwin scripts as well
    chmod +x src/external/bootstrap_cmds/migcom.tproj/mig.sh
    patchShebangs \
      src/external/bootstrap_cmds/migcom.tproj/mig.sh \
      src/external/darlingserver/scripts \
      src/external/openssl_certificates/scripts

    substituteInPlace src/startup/CMakeLists.txt --replace SETUID ""
    substituteInPlace src/external/basic_cmds/CMakeLists.txt --replace SETGID ""
  '';

  nativeBuildInputs = [
    bison
    ccWrapperBypass
    cmake
    flex
    makeWrapper
    ninja
    pkg-config
    python3
  ]
  ++ lib.optional compilePy2Bytecode python2;
  buildInputs = wrappedLibs ++ [
    libbsd
    openssl
    stdenv.cc.libc.linuxHeaders
  ];

  # Breaks valid paths like
  # Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include
  dontFixCmake = true;

  # src/external/objc4 forces OBJC_IS_DEBUG_BUILD=1, which conflicts with NDEBUG
  # TODO: Fix in a better way
  cmakeBuildType = " ";

  cmakeFlags = [
    "-DTARGET_i386=OFF"
    "-DCOMPILE_PY2_BYTECODE=${if compilePy2Bytecode then "ON" else "OFF"}"
    "-DDARLINGSERVER_XDG_USER_DIR_CMD=${xdg-user-dirs}/bin/xdg-user-dir"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-macro-redefined -Wno-unused-command-line-argument";

  # Linux .so's are dlopen'd by wrapgen during the build
  env.LD_LIBRARY_PATH = lib.makeLibraryPath wrappedLibs;

  # Breaks shebangs of Darwin scripts
  dontPatchShebangs = true;

  postInstall = ''
    # Install the SDK as a separate output
    mkdir -p $sdk

    sdkDir=$(readlink -f ../Developer)

    while read -r path; do
      dst="$sdk/Developer/''${path#$sdkDir}"

      if [[ -L "$path" ]]; then
        target=$(readlink -m "$path")
        if [[ -e "$target" && "$target" == "$NIX_BUILD_TOP"* && "$target" != "$sdkDir"* ]]; then
          # dereference
          cp -r -L "$path" "$dst"
        elif [[ -e "$target" ]]; then
          # preserve symlink
          cp -d "$path" "$dst"
        else
          # ignore symlink
          >&2 echo "Ignoring symlink $path -> $target"
        fi
      elif [[ -f $path ]]; then
        cp "$path" "$dst"
      elif [[ -d $path ]]; then
        mkdir -p "$dst"
      fi
    done < <(find $sdkDir)

    mkdir -p $sdk/bin
    cp src/external/cctools-port/cctools/ld64/src/*-ld $sdk/bin
    cp src/external/cctools-port/cctools/ar/*-{ar,ranlib} $sdk/bin
  '';

  postFixup = ''
    echo "Checking for references to $NIX_STORE in Darling root..."

    set +e
    grep -r --exclude=mldr "$NIX_STORE" $out/libexec/darling
    ret=$?
    set -e

    if [[ $ret == 0 ]]; then
      echo "Found references to $NIX_STORE in Darling root (see above)"
      exit 1
    fi

    patchelf --add-rpath "${lib.makeLibraryPath wrappedLibs}:${addOpenGLRunpath.driverLink}/lib" \
      $out/libexec/darling/usr/libexec/darling/mldr
  '';

  meta = with lib; {
    description = "Open-source Darwin/macOS emulation layer for Linux";
    homepage = "https://www.darlinghq.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "darling";
  };
}
