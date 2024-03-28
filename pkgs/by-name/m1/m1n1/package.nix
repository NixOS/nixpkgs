{ path
, stdenv
, buildPackages
, lib
, fetchFromGitHub
, python3
, dtc
, imagemagick
, isRelease ? false
, withTools ? true
, withChainloading ? true, rustc
, customLogo ? null
}:

let
  pyenv = python3.withPackages (p: with p; [
    construct
    pyserial
  ]);

  cross = import path {
    system = stdenv.buildPlatform.system;
    crossSystem = lib.systems.examples.aarch64-embedded // {
      rustc.config = "aarch64-unknown-none-softfloat";
    };
  };

in stdenv.mkDerivation rec {
  pname = "m1n1";
  version = "1.4.11";

  src = fetchFromGitHub {
    # tracking: https://src.fedoraproject.org/rpms/m1n1
    owner = "AsahiLinux";
    repo = "m1n1";
    rev = "v${version}";
    hash = "sha256-1lWI9tcOxgrcfaPfdSF+xRE9qofhNR3SQiA4h86VVeE=";
    fetchSubmodules = true;
  };

  makeFlags = [ "ARCH=${stdenv.cc.targetPrefix}" ]
    ++ lib.optional isRelease "RELEASE=1"
    ++ lib.optional withChainloading "CHAINLOADING=1";

  nativeBuildInputs = [
    dtc
    buildPackages.gcc
  ] ++ lib.optionals withChainloading [ cross.buildPackages.rustc cross.buildPackages.cargo ]
    ++ lib.optional (customLogo != null) imagemagick;

  postPatch = ''
    substituteInPlace proxyclient/m1n1/asm.py \
      --replace 'aarch64-linux-gnu-' 'aarch64-unknown-linux-gnu-' \
      --replace 'TOOLCHAIN = ""' 'TOOLCHAIN = "'$out'/toolchain-bin/"'
  '';

  preConfigure = lib.optionalString (customLogo != null) ''
    pushd data &>/dev/null
    ln -fs ${customLogo} bootlogo_256.png
    if [[ "$(magick identify bootlogo_256.png)" != 'bootlogo_256.png PNG 256x256'* ]]; then
      echo "Custom logo is not a 256x256 PNG"
      exit 1
    fi

    rm bootlogo_128.png
    convert bootlogo_256.png -resize 128x128 bootlogo_128.png
    patchShebangs --build ./makelogo.sh
    ./makelogo.sh
    popd &>/dev/null
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/build
    cp build/m1n1.bin $out/build
  '' + (lib.optionalString withTools ''
    mkdir -p $out/{bin,script,toolchain-bin}
    cp -r proxyclient $out/script
    cp -r tools $out/script

    for toolpath in $out/script/proxyclient/tools/*.py; do
      tool=$(basename $toolpath .py)
      script=$out/bin/m1n1-$tool
      cat > $script <<EOF
#!/bin/sh
${pyenv}/bin/python $toolpath "\$@"
EOF
      chmod +x $script
    done

    GCC=${buildPackages.gcc}
    BINUTILS=${buildPackages.binutils-unwrapped}

    ln -s $GCC/bin/${stdenv.cc.targetPrefix}gcc $out/toolchain-bin/
    ln -s $GCC/bin/${stdenv.cc.targetPrefix}ld $out/toolchain-bin/
    ln -s $BINUTILS/bin/${stdenv.cc.targetPrefix}objcopy $out/toolchain-bin/
    ln -s $BINUTILS/bin/${stdenv.cc.targetPrefix}objdump $out/toolchain-bin/
    ln -s $GCC/bin/${stdenv.cc.targetPrefix}nm $out/toolchain-bin/
  '') + ''
    runHook postInstall
  '';

  meta = with lib; {
    maintainers = with maintainers; [ yuka ];
    description = "A bootloader and experimentation playground for Apple Silicon";
    homepage = "https://github.com/AsahiLinux/m1n1";
    license = licenses.mit;
    platforms = [ "aarch64-linux" ];
  };
}
