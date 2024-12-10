{
  stdenv,
  lib,
  cmake,
  pkg-config,
  fetchFromGitHub,
  qt6,
  boost,
  openssl,
  libsecret,
  darwin,
}:
let
  stdenv' = if stdenv.hostPlatform.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
  mkPackage =
    {
      pname,
      version,
      src,
      extraMeta,
    }:

    stdenv'.mkDerivation {
      inherit pname version src;
      nativeBuildInputs = [
        cmake
        pkg-config
        qt6.wrapQtAppsHook
      ];
      buildInputs = [
        qt6.qtbase
        qt6.qtsvg
        qt6.qtimageformats
        qt6.qttools
        qt6.qt5compat
        boost
        openssl
        libsecret
      ] ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

      env.GIT_HASH = "nix-${version}";
      cmakeFlags = [ (lib.cmakeBool "BUILD_WITH_QT6" true) ];
      postInstall =
        lib.optionalString stdenv.hostPlatform.isDarwin ''
          mkdir -p "$out/Applications"
          mv bin/chatterino.app "$out/Applications/"
        ''
        + ''
          mkdir -p $out/share/icons/hicolor/256x256/apps
          cp $src/resources/icon.png $out/share/icons/hicolor/256x256/apps/chatterino.png
        '';
      passthru.updateScript = ./update.sh;
      meta = {
        description = "Chat client for Twitch chat";
        mainProgram = "chatterino";
        longDescription = ''
          Chatterino is a chat client for Twitch chat.
          It aims to be an improved/extended version of the Twitch web chat.
          Chatterino 2 is the second installment of the Twitch chat client series "Chatterino".
        '';
        license = lib.licenses.mit;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [
          rexim
          supa
          hausken
        ];
      } // extraMeta;
    };
in
{
  chatterino2 = mkPackage rec {
    pname = "chatterino2";
    version = "2.5.1";
    src = fetchFromGitHub {
      owner = "Chatterino";
      repo = "chatterino2";
      rev = "v${version}";
      hash = "sha256-c3Vhzes54xLjKV0Of7D1eFpQvIWJwcUBXvLT2p6VwBE=";
      fetchSubmodules = true;
    };
    extraMeta = {
      homepage = "https://github.com/Chatterino/chatterino2";
      changelog = "https://github.com/Chatterino/chatterino2/blob/${src.rev}/CHANGELOG.md";
    };
  };
  chatterino2-unstable = mkPackage rec {
    pname = "chatterino2";
    version = "0-unstable-2024-09-29";
    src = fetchFromGitHub {
      owner = "Chatterino";
      repo = "chatterino2";
      rev = "0db477665c5a4b40149aed231c09ce00a075baf7";
      hash = "sha256-1LTfRfxodvyqLSBZsGuFrZaQ5+vYA6LNxuVkLXaTZKI=";
      fetchSubmodules = true;
    };
    extraMeta = {
      homepage = "https://github.com/Chatterino/chatterino2";
      changelog = "https://github.com/Chatterino/chatterino2/blob/${src.rev}/CHANGELOG.md";
    };
  };
  chatterino7 = mkPackage rec {
    pname = "chatterino7";
    version = "7.5.1";
    src = fetchFromGitHub {
      owner = "SevenTV";
      repo = "chatterino7";
      rev = "v${version}";
      hash = "sha256-T0H+p9hyNd73gETwLilXN0uzcF75TJgx/LzHqnC099M=";
      fetchSubmodules = true;
    };
    extraMeta = {
      homepage = "https://github.com/SevenTV/chatterino7";
      changelog = "https://github.com/SevenTV/chatterino7/blob/${src.rev}/CHANGELOG.md";
      longDescription = ''
        Chatterino7 is a fork of Chatterino 2.
        This fork mainly contains features that aren't accepted into Chatterino 2, most notably 7TV subscriber features.
      '';
    };
  };
  chatterino7-unstable = mkPackage rec {
    pname = "chatterino7";
    version = "0-unstable-2024-09-28";
    src = fetchFromGitHub {
      owner = "SevenTV";
      repo = "chatterino7";
      rev = "978fb9820361c2e9ce1b5f1425e0243af1d5517d";
      hash = "sha256-pkY8+UvttYLOJ/9OtJ4q5SY27rutCjR/iJ25+rVGxvk=";
      fetchSubmodules = true;
    };
    extraMeta = {
      homepage = "https://github.com/SevenTV/chatterino7";
      changelog = "https://github.com/SevenTV/chatterino7/blob/${src.rev}/CHANGELOG.md";
      longDescription = ''
        Chatterino7 is a fork of Chatterino 2.
        This fork mainly contains features that aren't accepted into Chatterino 2, most notably 7TV subscriber features.
      '';
    };
  };
}
