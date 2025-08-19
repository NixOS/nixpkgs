{
  stdenv,
  lib,
  fetchFromGitHub,
  gcc-arm-embedded-13,
  pkg-config,
  meson,
  ninja,
  hidapi,
  libftdi1,
  libusb1,
  libgpiod_1,
  versionCheckHook,
  udevCheckHook,
}:
let
  libopencm3Src = fetchFromGitHub {
    owner = "libopencm3";
    repo = "libopencm3";
    rev = "8a96a9d95a8e5c187a53652540b25a8f4d73a432";
    hash = "sha256-PylP95hpPeg3rqfelHW9qz+pi/qOP60RfvkurxbkWDs=";
  };

  ctxlinkWinc1500Src = fetchFromGitHub {
    owner = "sidprice";
    repo = "ctxlink_winc1500";
    rev = "debeab9516e33622439f727a68bddabcdf52c528";
    hash = "sha256-IWLIJu2XuwsnP8/2C9uj09EBU2VtwTke3XXbc3NyZt4=";
  };
in
stdenv.mkDerivation rec {
  pname = "blackmagic";
  version = "2.0.0";
  # `git describe --always`
  firmwareVersion = "v${version}";

  src = fetchFromGitHub {
    owner = "blackmagic-debug";
    repo = "blackmagic";
    rev = firmwareVersion;
    hash = "sha256-JbPeN0seSkxV2uZ8BvsvjDUBMOyJu2BxqMgNkhLOiFI=";
  };

  nativeBuildInputs = [
    gcc-arm-embedded-13 # fails to build with 14
    pkg-config
    meson
    ninja
    udevCheckHook
  ];

  buildInputs = [
    hidapi
    libftdi1
    libusb1
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libgpiod_1;

  strictDeps = true;

  postUnpack = ''
    mkdir -p $sourceRoot/deps/libopencm3
    cp -r ${libopencm3Src}/* $sourceRoot/deps/libopencm3/

    mkdir -p $sourceRoot/deps/winc1500
    cp -r ${ctxlinkWinc1500Src}/* $sourceRoot/deps/winc1500/
  '';

  buildPhase = ''
    runHook preBuild

    echo "Building host cli"
    meson compile -C .

    echo "Building probe firmware"
    pushd ..
    for cf in cross-file/*.ini; do
      target=$(basename "''${cf%.ini}")

      if [ "$target" = "arm-none-eabi" ]; then
        echo "Skipping arm-none-eabi target"
        continue
      fi

      echo "Building target: $target"
      mkdir -p "build/firmware/$target"
      meson setup "build/firmware/$target" --cross-file "$cf"
      meson compile -C "build/firmware/$target"
    done
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    echo "Installing host cli"
    install -Dm555 blackmagic $out/bin/blackmagic

    echo "Installing probe firmware"
    for targetDir in firmware/*; do
      target=$(basename "$targetDir")
      echo "Installing firmware for target: $target"
      for f in $targetDir/*.{bin,elf}; do
        install -Dm444 $f $out/firmware/$target/$(basename "$f")
      done
    done

    echo "Installing udev rules"
    install -Dm444 ../driver/99-blackmagic-plugdev.rules $out/lib/udev/rules.d/99-blackmagic-plugdev.rules

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";
  doInstallCheck = true;

  meta = with lib; {
    description = "In-application debugger for ARM Cortex microcontrollers";
    mainProgram = "blackmagic";
    longDescription = ''
      The Black Magic Probe is a modern, in-application debugging tool
      for embedded microprocessors. It allows you to see what is going
      on "inside" an application running on an embedded microprocessor
      while it executes.

      This package builds the firmware for all supported platforms,
      placing them in separate directories under the firmware
      directory.  It also places the FTDI version of the blackmagic
      executable in the bin directory.
    '';
    homepage = "https://github.com/blacksphere/blackmagic";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      pjones
      sorki
      carlossless
    ];
    platforms = platforms.unix;
  };
}
