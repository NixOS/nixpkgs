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
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = "af9ae4897ad9e526d74489ddd12cfae179639ff3";
    hash = "sha256-ky3jiVk2KfOW4JjXqiCTdnbEu7bnmTVupw2r5fwyB00=";
  };

  postPatch =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/linker.cpp \
          --replace-fail '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk' ${MacOSX-SDK}
    ''
    + lib.optionalString useWgpu ''
      substituteInPlace vendor/wgpu/wgpu.odin \
          --replace-fail "BINDINGS_VERSION        :: [4]u8{22, 1, 0, 1}" "BINDINGS_VERSION        :: [4]u8{22, 1, 0, 5}" \
          --replace-fail "BINDINGS_VERSION_STRING :: \"22.1.0.1\"" "BINDINGS_VERSION_STRING :: \"22.1.0.5\"" \
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
      znaniye
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isMusl;
  };
}
