{
  stdenv,
  lib,
  mkDerivation,
  fetchFromGitHub,
  cargo,
  extra-cmake-modules,
  rustc,
  rustPlatform,

  # common deps
  karchive,
  qtwebsockets,

  # client deps
  qtbase,
  qtkeychain,
  qtmultimedia,
  qtsvg,
  qttools,
  libsecret,

  # optional client deps
  giflib,
  kdnssd,
  libvpx,
  miniupnpc,

  # optional server deps
  libmicrohttpd,
  libsodium,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd ? null,

  # options
  buildClient ? true,
  buildServer ? true,
  buildServerGui ? true, # if false builds a headless server
  buildExtraTools ? false,
}:

assert lib.assertMsg (
  buildClient || buildServer || buildExtraTools
) "You must specify at least one of buildClient, buildServer, or buildExtraTools.";

let
  clientDeps = [
    qtbase
    qtkeychain
    qtmultimedia
    qtsvg
    qttools
    libsecret
    # optional:
    giflib # gif animation export support
    kdnssd # local server discovery with Zeroconf
    libvpx # WebM video export
    miniupnpc # automatic port forwarding
  ];

  serverDeps = [
    # optional:
    libmicrohttpd # HTTP admin api
    libsodium # ext-auth support
  ] ++ lib.optional withSystemd systemd;

in
mkDerivation rec {
  pname = "drawpile";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "drawpile";
    repo = "drawpile";
    rev = version;
    sha256 = "sha256-NS1aQlWpn3f+SW0oUjlYwHtOS9ZgbjFTrE9grjK5REM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-V36yiwraXK7qlJd1r8EtEA4ULxlgvMEmpn/ka3m9GjA=";
  };

  nativeBuildInputs = [
    cargo
    extra-cmake-modules
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs =
    [
      karchive
      qtwebsockets
    ]
    ++ lib.optionals buildClient clientDeps
    ++ lib.optionals buildServer serverDeps;

  cmakeFlags = [
    (lib.cmakeFeature "INITSYS" (lib.optionalString withSystemd "systemd"))
    (lib.cmakeBool "CLIENT" buildClient)
    (lib.cmakeBool "SERVER" buildServer)
    (lib.cmakeBool "SERVERGUI" buildServerGui)
    (lib.cmakeBool "TOOLS" buildExtraTools)
  ];

  meta =
    {
      description = "Collaborative drawing program that allows multiple users to sketch on the same canvas simultaneously";
      homepage = "https://drawpile.net/";
      downloadPage = "https://drawpile.net/download/";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ fgaz ];
      platforms = lib.platforms.unix;
      broken = stdenv.hostPlatform.isDarwin;
    }
    // lib.optionalAttrs buildServer {
      mainProgram = "drawpile-srv";
    }
    // lib.optionalAttrs buildClient {
      mainProgram = "drawpile";
    };
}
