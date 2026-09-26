{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsi686Linux,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  dbus,
  inih,
  systemd,
  appstream,
  findutils,
  gawk,
  procps,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gamemode";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = "gamemode";
    tag = finalAttrs.version;
    hash = "sha256-V0rewbSVOGFqJqXyCz4jXpuDM0EfjdkpGPl+WdDwI5I=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  patches = [
    # Add @libraryPath@ template variable to fix loading the PRELOAD library
    ./preload-nix-workaround.patch
  ];

  postPatch = ''
    substituteInPlace data/gamemoderun \
      --subst-var-by libraryPath ${
        lib.makeLibraryPath (
          [
            (placeholder "lib")
          ]
          ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
            # Support wrapping 32bit applications on a 64bit linux system
            pkgsi686Linux.gamemode.lib
          ]
        )
      }
  '';

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    inih
    systemd
  ];

  mesonFlags = [
    "-Dwith-pam-limits-dir=etc/security/limits.d"
    "-Dwith-systemd-user-unit-dir=lib/systemd/user"
    "-Dwith-systemd-group-dir=lib/sysusers.d"

    # The meson builder installs internal executables to $lib/lib by
    # default, but they should be installed to "$out". It's also more
    # appropriate to install these executables under a libexec
    # directory instead of lib.
    "--libexecdir=libexec"
  ];

  doCheck = true;
  nativeCheckInputs = [
    appstream
  ];

  postFixup = ''
    # Add $lib/lib to gamemoded & gamemode-simulate-game's rpath since
    # they use dlopen to load libgamemode. Can't use makeWrapper since
    # it would break the security wrapper in the NixOS module.
    for bin in "$out/bin/gamemoded" "$out/bin/gamemode-simulate-game"; do
      patchelf --set-rpath "$lib/lib:$(patchelf --print-rpath "$bin")" "$bin"
    done

    wrapProgram "$out/bin/gamemodelist" \
      --prefix PATH : ${
        lib.makeBinPath [
          findutils
          gawk
          procps
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Optimise Linux system performance on demand";
    homepage = "https://feralinteractive.github.io/gamemode";
    changelog = "https://github.com/FeralInteractive/gamemode/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kira-bruneau ];
    platforms = lib.platforms.linux;
    mainProgram = "gamemoderun"; # Requires NixOS module to run
  };
})
