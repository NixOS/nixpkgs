{
  stdenv,
  fetchFromGitHub,
  cmake,
  flex,
  bison,
  libxml2,
  pythonSupport ? stdenv.hostPlatform.hasSharedLibraries,
  python3,
  libusb1,
  avahiSupport ? true,
  avahi,
  libaio,
  runtimeShell,
  lib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libiio";
  version = "0.26";

  outputs = [
    "out"
    "lib"
    "dev"
  ]
  ++ lib.optional pythonSupport "python";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libiio";
    tag = "v${version}";
    hash = "sha256-nrpGccj9Q3S9wYs0/dHC3YAy5ZvTiPiSUtPY6r5WlaE=";
  };

  # Revert after https://github.com/NixOS/nixpkgs/issues/125008 is
  # fixed properly
  patches = [
    ./cmake-fix-libxml2-find-package.patch
  ];

  nativeBuildInputs = [
    cmake
    flex
    bison
    pkg-config
  ]
  ++ lib.optionals pythonSupport (
    [
      python3
    ]
    ++ lib.optional python3.isPy3k python3.pkgs.setuptools
  );

  buildInputs = [
    libxml2
    libusb1
  ]
  ++ lib.optional avahiSupport avahi
  ++ lib.optional stdenv.hostPlatform.isLinux libaio;

  doInstallCheck = true;

  cmakeFlags = [
    "-DUDEV_RULES_INSTALL_DIR=${placeholder "out"}/lib/udev/rules.d"
    # osx framework is disabled,
    # the linux-like directory structure is used for proper output splitting
    "-DOSX_PACKAGE=off"
    "-DOSX_FRAMEWORK=off"
  ]
  ++ lib.optionals pythonSupport [
    "-DPython_EXECUTABLE=${python3.pythonOnBuildForHost.interpreter}"
    "-DPYTHON_BINDINGS=on"
  ]
  ++ lib.optionals (!avahiSupport) [
    "-DHAVE_DNS_SD=OFF"
  ];

  postPatch = ''
    patchShebangs libiio.rules.cmakein
  ''
  + lib.optionalString pythonSupport ''
    # Hardcode path to the shared library into the bindings.
    sed "s#@libiio@#$lib/lib/libiio${stdenv.hostPlatform.extensions.sharedLibrary}#g" ${./hardcode-library-path.patch} | patch -p1
  '';

  postInstall = lib.optionalString pythonSupport ''
    # Move Python bindings into a separate output.
    moveToOutput ${python3.sitePackages} "$python"
  '';

  nativeInstallCheckInputs = lib.optionals pythonSupport [
    python3.pkgs.pythonImportsCheckHook
  ];

  pythonImportsCheck = [ "iio" ];

  meta = {
    changelog = "https://github.com/analogdevicesinc/libiio/releases/tag/${src.tag}";
    description = "API for interfacing with the Linux Industrial I/O Subsystem";
    homepage = "https://github.com/analogdevicesinc/libiio";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
