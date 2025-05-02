{
  fetchFromGitHub,
  lib,
  libiconv,
  llvmPackages,
  MacOSX-SDK,
  makeBinaryWrapper,
  nix-update-script,
  Security,
  which,
  wgpu-native,
  useWgpu ? false,
}:

let
  inherit (llvmPackages) stdenv;
in
stdenv.mkDerivation {
  pname = "odin";
  version = "dev-2025-01";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = "dev-2025-01";
    hash = "sha256-GXea4+OIFyAhTqmDh2q+ewTUqI92ikOsa2s83UH2r58=";
  };

  postPatch =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/linker.cpp \
          --replace-fail '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk' ${MacOSX-SDK}
    ''
    + lib.optionalString useWgpu ''
      substituteInPlace vendor/wgpu/wgpu.odin \
          --replace-fail "BINDINGS_VERSION        :: [4]u8{22, 1, 0, 1}" "BINDINGS_VERSION        :: [4]u8{24, 0, 3, 1}" \
          --replace-fail "BINDINGS_VERSION_STRING :: \"22.1.0.1\"" "BINDINGS_VERSION_STRING :: \"24.0.3.1\"" \
          ${lib.optionalString (
            !stdenv.hostPlatform.isStatic
          ) "--replace-fail \"#config(WGPU_SHARED, false)\" \"#config(WGPU_SHARED, true)\""}
    ''
    + ''
      substituteInPlace build_odin.sh \
          --replace-fail '-framework System' '-lSystem'
      patchShebangs build_odin.sh
    '';

  LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

  dontConfigure = true;

  buildFlags = [ "release" ];

  nativeBuildInputs = [
    makeBinaryWrapper
    which
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Security
    ]
    ++ (if (useWgpu) then [ wgpu-native ] else [ ]);

  installPhase =
    let
      wgpuDirSysName =
        {
          # switch-case

          x86_64-linux = "linux-x86_64";
          aarch64-linux = "linux-aarch64";

          x86_64-darwin = "macos-x86_64";
          aarch64-darwin = "macos-aarch64";

          x86_64-windows = "windows-x86_64";
          aarch64-windows = "windows-aarch64";
        }
        .${stdenv.hostPlatform.system};

      wgpuInstallScript =
        {
          # switch-case

          x86_64-linux = ''
            mkdir $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
            ln -s ${wgpu-native}/lib/libwgpu_native.so $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
          '';
          aarch64-linux = ''
            mkdir $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
            ln -s ${wgpu-native}/lib/libwgpu_native.so $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
          '';

          x86_64-darwin = ''
            mkdir $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
            ln -s ${wgpu-native}/lib/libwgpu_native.dylib $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
          '';
          aarch64-darwin = ''
            mkdir $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
            ln -s ${wgpu-native}/lib/libwgpu_native.dylib $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
          '';


          x86_64-windows = ''
            mkdir -p $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
            cp ${wgpu-native}/lib/wgpu_native.dll $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
          '';
          aarch64-windows = ''
            mkdir -p $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
            cp ${wgpu-native}/lib/wgpu_native.dll $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
          '';

        }
        .${stdenv.hostPlatform.system};


    in
    ''
      runHook preInstall

      mkdir -p $out/bin
      cp odin $out/bin/odin

      mkdir -p $out/share
      cp -r {base,core,vendor,shared} $out/share

      ${lib.optionalString useWgpu ''
        mkdir $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
        ln -s ${wgpu-native}/lib/libwgpu_native.so $out/share/vendor/wgpu/lib/wgpu-${wgpuDirSysName}-release/
      ''}

      wrapProgram $out/bin/odin \
        --prefix PATH : ${
          lib.makeBinPath (
            with llvmPackages;
            [
              bintools
              llvm
              clang
              lld
            ]
          )
        } \
        --set-default ODIN_ROOT $out/share

      make -C "$out/share/vendor/cgltf/src/"
      make -C "$out/share/vendor/stb/src/"
      make -C "$out/share/vendor/miniaudio/src/"

      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, concise, readable, pragmatic and open sourced programming language";
    downloadPage = "https://github.com/odin-lang/Odin";
    homepage = "https://odin-lang.org/";
    license = lib.licenses.bsd3;
    mainProgram = "odin";
    maintainers = with lib.maintainers; [
      astavie
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isMusl;
  };
}
