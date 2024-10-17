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
  stdenv' = if stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
  mkPackage =
    {
      pname,
      version,
      src,
      extraDescription ? "",
    }:

    stdenv'.mkDerivation {
      inherit pname;
      inherit version;
      inherit src;
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

      GIT_HASH = "nix-${version}";
      cmakeFlags = [ "-DBUILD_WITH_QT6=ON" ];
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
      meta = with lib; {
        description = "Chat client for Twitch chat";
        mainProgram = "chatterino";
        longDescription =
          ''
            Chatterino is a chat client for Twitch chat.
            It aims to be an improved/extended version of the Twitch web chat.
            Chatterino 2 is the second installment of the Twitch chat client series "Chatterino".
          ''
          + extraDescription;
        homepage = "https://github.com/${src.owner}/${src.repo}";
        changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/CHANGELOG.md";
        license = licenses.mit;
        platforms = platforms.unix;
        maintainers = with maintainers; [
          rexim
          supa
          hausken
        ];
      };
    };
in
{
  chatterino2 = mkPackage rec {
    pname = "chatterino2";
    version = "2.5.1";
    src = fetchFromGitHub {
      owner = "Chatterino";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-c3Vhzes54xLjKV0Of7D1eFpQvIWJwcUBXvLT2p6VwBE=";
      fetchSubmodules = true;
    };
  };
  chatterino2-unstable = mkPackage rec {
    pname = "chatterino2";
    version = "0-unstable-2024-09-29";
    src = fetchFromGitHub {
      owner = "Chatterino";
      repo = pname;
      rev = "0db477665c5a4b40149aed231c09ce00a075baf7";
      hash = "sha256-1LTfRfxodvyqLSBZsGuFrZaQ5+vYA6LNxuVkLXaTZKI=";
      fetchSubmodules = true;
    };
  };
  chatterino7 = mkPackage rec {
    pname = "chatterino7";
    version = "7.5.1";
    src = fetchFromGitHub {
      owner = "SevenTV";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-T0H+p9hyNd73gETwLilXN0uzcF75TJgx/LzHqnC099M=";
      fetchSubmodules = true;
    };
    extraDescription = ''
      Chatterino7 is a fork of Chatterino 2.
      This fork mainly contains features that aren't accepted into Chatterino 2, most notably 7TV subscriber features.
    '';
  };
  chatterino7-unstable = mkPackage rec {
    pname = "chatterino7";
    version = "0-unstable-2024-09-28";
    src = fetchFromGitHub {
      owner = "SevenTV";
      repo = pname;
      rev = "978fb9820361c2e9ce1b5f1425e0243af1d5517d";
      hash = "sha256-pkY8+UvttYLOJ/9OtJ4q5SY27rutCjR/iJ25+rVGxvk=";
      fetchSubmodules = true;
    };
    extraDescription = ''
      Chatterino7 is a fork of Chatterino 2.
      This fork mainly contains features that aren't accepted into Chatterino 2, most notably 7TV subscriber features.
    '';
  };
}
