{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  xz,
  pcre,
  libX11,
  libICE,
  libSM,
  autoPatchelfHook,
  bintools,
  fixDarwinDylibNames,
  darwin,
  fontconfig,
  libgdiplus,
  libXrandr,
  glib,
  writeShellScriptBin,
  blender,
  openssl,
  libkrb5,
  icu,
}:
let

  # blenderfarm (client) will run from the current workdir.
  # It needs to create files there, so it cannot be in the nix store.
  # We also need to create some files there so it can work with its
  # server part.
  USERHOMEDIR = "~/.local/share/blenderfarm";
  blenderfarm-nix = writeShellScriptBin "blenderfarm-nix" ''
    if [[ -z $BLENDERFARM_HOME && ! -d ${USERHOMEDIR} ]]; then
      echo "Creating home for blenderfarm at ${USERHOMEDIR}"
      echo "You can change that by setting BLENDERFARM_HOME to another directory"
    fi
    if [[ -z $BLENDERFARM_HOME ]]; then
      BLENDERFARM_HOME=${USERHOMEDIR}
    fi
    mkdir -p $BLENDERFARM_HOME/BlenderData/nix-blender-linux64 > /dev/null 2>&1
    ln -s ${blender}/bin/blender $BLENDERFARM_HOME/BlenderData/nix-blender-linux64/blender > /dev/null 2>&1
    echo "nix-blender" > $BLENDERFARM_HOME/VersionCustom
    cd $BLENDERFARM_HOME
    exec -a "$0" @out@/bin/LogicReinc.BlendFarm  "$@"
  '';
in

buildDotnetModule rec {
  pname = "blenderfarm";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "LogicReinc";
    repo = "LogicReinc.BlendFarm";
    rev = "v${version}";
    hash = "sha256-2w2tdl5n0IFTuthY97NYMeyRe2r72jaKFfoNSjWQMM4=";
  };

  nativeBuildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      bintools
      fixDarwinDylibNames
      darwin.autoSignDarwinBinariesHook
    ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    openssl
    libkrb5
    icu
  ];

  runtimeDeps = [
    xz
    pcre
    libX11
    libICE
    libSM
    libgdiplus
    glib
    libXrandr
    fontconfig
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ blender ];

  # there is no "*.so.3" or "*.so.5" in nixpkgs. So ignore the warning
  # and add it later
  autoPatchelfIgnoreMissingDeps = [
    "libpcre.so.3"
    "liblzma.so.5"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  projectFile = [
    "LogicReinc.BlendFarm.Client/LogicReinc.BlendFarm.Client.csproj"
    "LogicReinc.BlendFarm.Server/LogicReinc.BlendFarm.Server.csproj"
    "LogicReinc.BlendFarm/LogicReinc.BlendFarm.csproj"
  ];
  nugetDeps = ./deps.nix;
  executables = [
    "LogicReinc.BlendFarm"
    "LogicReinc.BlendFarm.Server"
  ];

  # add libraries not found by autopatchelf
  libPath = lib.makeLibraryPath [
    pcre
    xz
  ];
  makeWrapperArgs = [ "--prefix LD_LIBRARY_PATH : ${libPath}" ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin
      cp -v ${blenderfarm-nix}/bin/blenderfarm-nix $out/bin
      substituteInPlace $out/bin/blenderfarm-nix --subst-var out
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s ${libgdiplus}/lib/libgdiplus.dylib $out/lib/blenderfarm/
    '';

  meta = with lib; {
    description = "A open-source, cross-platform, stand-alone, Network Renderer for Blender";
    homepage = "https://github.com/LogicReinc/LogicReinc.BlendFarm";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ gador ];
    mainProgram = "blenderfarm-nix";
    platforms = platforms.unix;
  };
}
