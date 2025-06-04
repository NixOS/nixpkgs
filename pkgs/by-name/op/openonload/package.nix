{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  libpcap,
  which,
  libcap,
  makeWrapper,
  nix-update-script,
  perl,
  libmnl,
}:

stdenv.mkDerivation rec {
  pname = "openonload";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "Xilinx-CNS";
    repo = "onload";
    rev = "v${version}";
    hash = "sha256-0vzEQ+y0P6cd0DNIMRTemtHm6gbm+RNKasQi01hkdnQ=";
  };

  buildInputs = [
    libcap.dev
    libpcap
    which
    makeWrapper
    # for tests
    perl
    libmnl
  ];

  configurePhase = ''
    export PATH="$PWD/scripts:$PATH"
    patchShebangs --build \
      scripts/ \
      src/driver/
    substituteInPlace \
      scripts/mmaketool \
      scripts/onload \
      scripts/onload_build \
      scripts/onload_install \
      scripts/shell-fns/fns \
      scripts/shell-fns/mmake-fns \
      --replace-fail "/bin/pwd" "${coreutils}/bin/pwd"
    substituteInPlace \
      scripts/mmaketool \
      scripts/onload_install \
      scripts/sfcaffinity_config \
      --replace-fail "/bin/ls" "${coreutils}/bin/ls"

    # Disable compiler checks that are disabled for Ubuntu
    substituteInPlace scripts/mmakebuildtree \
    --replace-fail 'W_NO_UNUSED_RESULT=
    ' ""
    export W_NO_UNUSED_RESULT=1 W_NO_IGNORED_ATTRIBUTES=1

    # Patch unit tests to be run during check phase
    substituteInPlace src/tests/onload/{oof,cplane_unit,cplane_sysunit,onload_remote_monitor/internal_tests}/mmake.mk \
      --replace-fail '/usr/bin/timeout' '${coreutils}/bin/timeout'

    # Honor NIX_BUILD_CORES in onload_build script
    substituteInPlace scripts/onload_build --replace-fail 'nproc' 'echo "$NIX_BUILD_CORES"'
  '';

  # This only builds the 64 bit libraries, not the kernel module.
  buildPhase = ''
    ./scripts/onload_build --user64
  '';

  doCheck = true;
  checkPhase = ''
    # Build all tests in parallel, the script does it in sequence
    make -C "$(mmaketool --toppath)/build/$(mmaketool --userbuild)" -j$NIX_BUILD_CORES
    scripts/run_unit_tests.sh
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  installPhase = ''
    mkdir -p $out
    i_prefix=$out scripts/onload_install --nobuild --userfiles --headers \
      --bindir=/bin \
      --sbindir=/bin \
      --usrsbindir=/bin \
      --libexecdir=/libexec \
      --includedir=/include \
      --lib64dir=/lib

    mkdir -p $dev/lib
    mv -v $out/include $dev
    mv -v $out/lib/*.a $dev/lib
    mkdir -p $lib
    mv -v $out/lib $lib

    substituteInPlace $out/bin/onload --replace-fail "/usr/libexec" "$out/libexec"
    # This tool looks for libonload.so in environment, point default to the actual library
    wrapProgram $out/bin/onload \
      --set-default ONLOAD_PRELOAD $out/lib/libonload.so

    # These scripts assume other binaries from this package are in PATH
    wrapProgram $out/bin/onload_tcpdump \
      --prefix PATH : $out/bin
    wrapProgram $out/bin/orm_webserver \
      --prefix PATH : $out/bin

    cp -v $(find build/gnu_x86_64/tools -type f -executable -print | grep -v '/debug/' | grep -v '.so$') $out/bin
    # Capture the test apps for validating performance/host set-up
    cp -v $(find build/gnu_x86_64/tests/ef_vi -type f -executable -print) $out/bin

    mkdir -p $dev/lib/pkgconfig/
    export dash_l="-lonload_ext"
    substituteAll ${./openonload.pc.in} $dev/lib/pkgconfig/openonload.pc
    export dash_l="-l:libonload_ext.a"
    substituteAll ${./openonload.pc.in} $dev/lib/pkgconfig/openonload-static.pc
  '';

  preFixup = ''
    # Help patchelf to remove build directory from RPATH
    rm -v build/gnu_x86_64/lib/cplane/*.so*
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "OpenOnLoad high performance network stack from Solarflare";
    homepage = "https://www.openonload.org";
    license = lib.licenses.gpl2;
    maintainers = with maintainers; [ YorikSar ];
    # ARM64 build fails, see https://github.com/Xilinx-CNS/onload/issues/253
    platforms = [ "x86_64-linux" ];
  };
}
