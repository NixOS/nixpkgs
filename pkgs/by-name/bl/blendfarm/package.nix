{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildDotnetModule,
  dotnetCorePackages,
  xz,
  pcre,
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

  # blendfarm (client) will run from the current workdir.
  # It needs to create files there, so it cannot be in the nix store.
  # We also need to create some files there so it can work with its
  # server part.
  USERHOMEDIR = "~/.local/share/blendfarm";
  blendfarm-nix = writeShellScriptBin "blendfarm-nix" ''
    if [[ -z $BLENDFARM_HOME && ! -d ${USERHOMEDIR} ]]; then
      echo "Creating home for blendfarm at ${USERHOMEDIR}"
      echo "You can change that by setting BLENDFARM_HOME to another directory"
    fi
    if [[ -z $BLENDFARM_HOME ]]; then
      BLENDFARM_HOME=${USERHOMEDIR}
    fi
    mkdir -p $BLENDFARM_HOME/BlenderData/nix-blender-linux64 > /dev/null 2>&1
    ln -s ${lib.getExe blender} $BLENDFARM_HOME/BlenderData/nix-blender-linux64/blender > /dev/null 2>&1
    echo "nix-blender" > $BLENDFARM_HOME/VersionCustom
    cd $BLENDFARM_HOME
    exec -a "$0" @out@/bin/LogicReinc.BlendFarm  "$@"
  '';
in

buildDotnetModule rec {
  pname = "blendfarm";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "LogicReinc";
    repo = "LogicReinc.BlendFarm";
    rev = "v${version}";
    hash = "sha256-2w2tdl5n0IFTuthY97NYMeyRe2r72jaKFfoNSjWQMM4=";
  };

  patches = [
    # https://github.com/LogicReinc/LogicReinc.BlendFarm/pull/121
    ./fix-nixos-crashing-on-runtime.patch
    # https://github.com/LogicReinc/LogicReinc.BlendFarm/pull/122
    ./rename-evee-to-eevee_next.patch
    # Fixes the error with net8 update:
    # "The referenced project is a non self-contained executable.
    # A non self-contained executable cannot be referenced by a self-contained executable"
    ./fix-references.patch
    # Update project files to net8
    ./net8.patch
  ];

  nativeBuildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      bintools
      fixDarwinDylibNames
      darwin.autoSignDarwinBinariesHook
    ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    fontconfig
    openssl
    libkrb5
    icu
  ];

  runtimeDeps = [
    xz
    pcre
    libgdiplus
    glib
    libXrandr
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ blender ];

  # there is no "*.so.3" or "*.so.5" in nixpkgs. So ignore the warning
  # and add it later
  autoPatchelfIgnoreMissingDeps = [
    "libpcre.so.3"
    "liblzma.so.5"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [
    "LogicReinc.BlendFarm.Client/LogicReinc.BlendFarm.Client.csproj"
    "LogicReinc.BlendFarm.Server/LogicReinc.BlendFarm.Server.csproj"
    "LogicReinc.BlendFarm/LogicReinc.BlendFarm.csproj"
  ];
  nugetDeps = ./deps.json;
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
      cp -v ${blendfarm-nix}/bin/blendfarm-nix $out/bin
      substituteInPlace $out/bin/blendfarm-nix --subst-var out
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s ${libgdiplus}/lib/libgdiplus.dylib $out/lib/blendfarm/
    '';

  meta = with lib; {
    description = "A open-source, cross-platform, stand-alone, Network Renderer for Blender";
    homepage = "https://github.com/LogicReinc/LogicReinc.BlendFarm";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ gador ];
    mainProgram = "blendfarm-nix";
    platforms = platforms.unix;
  };
}
