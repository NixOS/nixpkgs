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

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    Security
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp odin $out/bin/odin

    mkdir -p $out/share
    cp -r {base,core,vendor,shared} $out/share

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
