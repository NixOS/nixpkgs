{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  callPackage,
}:

# Note for maintainers:
#
# These packages are only allowed to be packaged under the the condition that we
# - patch source/creator/config.d to not point to upstream's bug tracker
# - use the "barebones" configuration to remove the mascot and logo from the build
#
# We have received permission by the owner to go ahead with the packaging, as we have met all the criteria
# https://github.com/NixOS/nixpkgs/pull/288841#issuecomment-1950247467

let
  mkGeneric = builderArgs: callPackage ./generic.nix { inherit builderArgs; };
in
{
  inochi-creator = mkGeneric rec {
    pname = "inochi-creator";
    appname = "Inochi Creator";
    version = "0.8.6";

    src = fetchFromGitHub {
      owner = "Inochi2D";
      repo = "inochi-creator";
      rev = "v${version}";
      hash = "sha256-9d3j5ZL6rGOjN1GUpCIfbjby0mNMvOK7BJbHYgwLY2k=";
    };

    dubLock = ./creator-dub-lock.json;

    patches = [
      # Upstream asks that we change the bug tracker URL to not point to the upsteam bug tracker
      (replaceVars ./support-url.patch {
        assignees = "TomaSajt"; # should be a comma separated list of the github usernames of the maintainers
      })
      # Change how duplicate locales differentiate themselves (the store paths were too long)
      ./translations.patch
    ];

    meta = {
      # darwin has slightly different build steps
      broken = stdenv.hostPlatform.isDarwin;
      changelog = "https://github.com/Inochi2D/inochi-creator/releases/tag/${src.rev}";
      description = "An open source editor for the Inochi2D puppet format";
    };
  };

  inochi-session = mkGeneric rec {
    pname = "inochi-session";
    appname = "Inochi Session";
    version = "0.8.7";

    src = fetchFromGitHub {
      owner = "Inochi2D";
      repo = "inochi-session";
      rev = "v${version}";
      hash = "sha256-FcgzTCpD+L50MsPP90kfL6h6DEUtiYkUV1xKww1pQfg=";
    };

    patches = [
      # Dynamically load Lua to get around the linker error on aarch64-linux.
      # https://github.com/Inochi2D/inochi-session/pull/60
      ./session-dynamic-lua.patch
    ];

    dubLock = ./session-dub-lock.json;

    preFixup = ''
      patchelf $out/share/inochi-session/inochi-session --add-needed cimgui.so
    '';

    dontStrip = true; # symbol lookup error: undefined symbol: , version

    meta = {
      # darwin has slightly different build steps
      broken = stdenv.hostPlatform.isDarwin;
      changelog = "https://github.com/Inochi2D/inochi-session/releases/tag/${src.rev}";
      description = "An application that allows streaming with Inochi2D puppets";
    };
  };
}
