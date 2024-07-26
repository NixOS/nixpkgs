{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  writeShellScriptBin,

  cmake,
  gettext,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,

  dbus,
  freetype,
  SDL2,
  zenity,

  builderArgs,
}:

let
  cimgui-src = fetchFromGitHub {
    owner = "Inochi2D";
    repo = "cimgui";
    rev = "49bb5ce65f7d5eeab7861d8ffd5aa2a58ca8f08c";
    hash = "sha256-XcnZbIjwq7vmYBnMAs+cEpJL8HB8wrL098FXGxC+diA=";
    fetchSubmodules = true;
  };

  inherit (builderArgs)
    pname
    appname
    version
    dubLock
    meta
    ;
in
buildDubPackage (
  builderArgs
  // {
    nativeBuildInputs = [
      cmake # used for building `i2d-imgui`
      gettext # used when generating translations
      copyDesktopItems
      makeWrapper

      # A fake git implementation to be used by the `gitver` package
      # It is a dependency of the main packages and the `inochi2d` dub dependency
      # A side effect of this script is that `inochi2d` will have the same version listed as the main package
      (writeShellScriptBin "git" "echo v${version}")
    ];

    buildInputs = [
      dbus
      freetype
      SDL2
    ];

    dontUseCmakeConfigure = true;

    # these deps are not listed inside `dub.sdl`, so they didn't get auto-generated
    # these are used for generating version info when building
    dubLock = lib.recursiveUpdate (lib.importJSON dubLock) {
      dependencies = {
        gitver = {
          version = "1.6.1";
          sha256 = "sha256-NCyFik4FbD7yMLd5zwf/w4cHwhzLhIRSVw1bWo/CZB4=";
        };
        semver = {
          version = "0.3.2";
          sha256 = "sha256-l6c9hniUd5xNsJepq8x30e0JTjmXs4pYUmv4ws+Nrn4=";
        };
      };
    };

    postConfigure = ''
      cimgui_dir=("$DUB_HOME"/packages/i2d-imgui/*/i2d-imgui)

      # `i2d-imgui` isn't able to find SDL2 by default due to it being written in lower case
      # this is only an issue when compiling statically (session)
      substituteInPlace "$cimgui_dir/dub.json" \
          --replace-fail '"sdl2"' '"SDL2"'

      # The `i2d-cimgui` dub dependency fetched inside the auto-generated `*-deps.nix` file
      # which doesn't know that it's actually a git repo, so it doesn't fetch its submodules.
      # Upstream uses a cmake script to fetch the `cimgui` submodule anyway, which we can't do
      # We get around this by manually pre-fetching the submodule and copying it into the right place
      cp -r --no-preserve=all ${cimgui-src}/* "$cimgui_dir/deps/cimgui"

      # Disable the original cmake fetcher script
      substituteInPlace "$cimgui_dir/deps/CMakeLists.txt" \
          --replace-fail "PullSubmodules(" "# PullSubmodules(" \
          --replace-fail  "\''${cimgui_SUBMOD_DIR}" "cimgui"
    '';

    preBuild = ''
      # Generate translations (if possible)
      . gentl.sh

      # Use the fake git to generate version info
      dub build --skip-registry=all --compiler=ldc2 --build=release --config=meta
    '';

    # Use the "barebones" configuration so that we don't include the mascot and icon files in out build
    dubFlags = [ "--config=barebones" ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/${pname}
      cp -r out/* $out/share/${pname}

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        desktopName = appname;
        exec = pname;
        comment = meta.description;
        categories = [ "Utility" ];
      })
    ];

    postFixup = ''
      # Add support for `open file` dialog
      makeWrapper $out/share/${pname}/${pname} $out/bin/${pname} \
          --prefix PATH : ${lib.makeBinPath [ zenity ]}
    '';

    meta = {
      homepage = "https://inochi2d.com/";
      license = lib.licenses.bsd2;
      mainProgram = pname;
      maintainers = with lib.maintainers; [ tomasajt ];
    } // meta;
  }
)
