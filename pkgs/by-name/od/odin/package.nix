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
stdenv.mkDerivation rec {
  pname = "odin";
  version = "dev-2024-07";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = version;
    hash = "sha256-FeiVTLwgP0x1EZqqiYkGbKALhZWC4xE6a/3PPcEElAc=";
  };

  postPatch =
    lib.optionalString stdenv.isDarwin ''
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

  buildInputs = lib.optionals stdenv.isDarwin [
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
      luc65r
      znaniye
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isMusl;
  };
}
