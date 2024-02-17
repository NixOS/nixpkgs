{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
}:

# Note for maintainers:
#
# This package is only allowed to be packaged under the the condition that we
# - patch source/creator/config.d to not point to upstream's bug tracker
# - use the "barebones" configuration to remove the mascot and logo from the build
#
# We have received permission by the owner to go ahead with the packaging, as we have met all the criteria
# https://github.com/NixOS/nixpkgs/pull/288841#issuecomment-1950247467

let
  mkGeneric = callPackage ./generic.nix { };
in
{
  inochi-creator = mkGeneric rec {
    pname = "inochi-creator";
    appname = "Inochi Creator";
    version = "0.8.4";

    src = fetchFromGitHub {
      owner = "Inochi2D";
      repo = "inochi-creator";
      rev = "v${version}";
      hash = "sha256-wsB9KIZyot2Y+6QpQlIXRzv3cPCdwp2Q/ZfDizAKJc4=";
    };

    # Note: there exists a custom fork of dcv (dcv-i2d) which fixes some issues with the original dcv, and this fork is fetched by the upstream github workflow.
    # However, it seems like it's not actually used anywhere in the repo, so I didn't include it here.
    dubDeps = ./creator-deps.nix;

    patches = [
      # Upstream asks that we change the bug tracker URL to not point to the upsteam bug tracker
      ./support-url.patch
      # Use custom location for translation files, change how duplicate locales differantiate themselves
      ./translations.patch
    ];

    postPatch = ''
      # set custom translation directory
      substituteInPlace source/creator/core/path.d \
          --subst-var-by i18n_dir "$out/share/inochi-creator/i18n"
    '';

    # generate translations
    preBuild = ''
      chmod +x ./gentl.sh
      ./gentl.sh
    '';

    # copy translations
    preInstall = ''
      install -Dm644 out/*.mo -t $out/share/inochi-creator/i18n
    '';

    meta = {
      broken = stdenv.isDarwin; # darwin has slightly different build steps
      changelog = "https://github.com/Inochi2D/inochi-creator/releases/tag/${src.rev}";
      description = "An open source editor for the Inochi2D puppet format";
    };
  };

  inochi-session = mkGeneric rec {
    pname = "inochi-session";
    appname = "Inochi Session";
    version = "0.8.3";

    src = fetchFromGitHub {
      owner = "Inochi2D";
      repo = "inochi-session";
      rev = "v${version}";
      hash = "sha256-yq/uMWEeydZun07/7hgUaAw3IruRqrDuGgbe5NzNYxw=";
    };

    dubDeps = ./session-deps.nix;

    postInstall = ''
      install -Dm755 out/cimgui.so -t $out/lib
    '';

    preFixup = ''
      patchelf $out/bin/inochi-session --add-needed cimgui.so
    '';

    dontStrip = true; # symbol lookup error: undefined symbol: , version

    meta = {
      broken = stdenv.isDarwin || stdenv.isAarch64; # darwin has slightly different build steps, and aarch fails to build (something related to lua)
      changelog = "https://github.com/Inochi2D/inochi-session/releases/tag/${src.rev}";
      description = "An application that allows streaming with Inochi2D puppets";
    };
  };
}
