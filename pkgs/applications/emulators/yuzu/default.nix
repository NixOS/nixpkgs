{
  callPackage,
  fetchFromGitLab,
  fetchpatch,
  fetchFromGitea,
  fmt_11,
  fetchzip,
  git,
  dos2unix,
  sdl3,
}:

{
  torzu = callPackage ./generic.nix {
    forkName = "torzu";
    version = "unstable-2024-02-26";
    source = fetchFromGitea {
      domain = "git.ynh.ovh";
      owner = "liberodark";
      repo = "torzu";
      rev = "eaa9c9e3a46eb5099193b11d620ddfe96b6aec83";
      hash = "sha256-KxLRXM8Y+sIW5L9oYMSeK95HRb30zGRRSfil9DO+utU=";
      fetchSubmodules = true;
    };
    patches = [
      # Remove coroutines from debugger to fix boost::asio compatibility issues
      ./fix-debugger.patch
      # Add explicit cast for CRC checksum value
      ./fix-udp-protocol.patch
      # Use specific boost::asio includes and update to modern io_context
      ./fix-udp-client.patch
      # Updates suppressed diagnostics
      ./fix-aarch64-linux-build.patch
    ];
    homepage = "http://vub63vv26q6v27xzv2dtcd25xumubshogm67yrpaz2rculqxs7jlfqad.onion/torzu-emu/torzu";
  };

  citron-emu = callPackage ./generic.nix (
    let
      version = "0.6.1";
    in
    {
      forkName = "citron";
      inherit version;
      source = fetchFromGitLab {
        domain = "git.citron-emu.org";
        owner = "citron";
        repo = "emu";
        rev = "v${version}-canary-refresh";
        hash = "sha256-ZQ6k/9e1ZwUXqc5h3dnza27LtpUtQY4eUjeMtX3+in8=";
        # Submodules are fixed in master until a new tag is out apply fix manually
        leaveDotGit = true;
        nativeBuildInputs = [
          git
          dos2unix
        ];
        postFetch = ''
          pushd $out
          # Git won't allow working on submodules otherwise...
          git restore --staged .

          cp .gitmodules{,.bak}

          substituteInPlace .gitmodules \
            --replace-fail git.citron-emu.org/Citron github.com/yuzu-mirror

          git submodule update --init --recursive -j ''${NIX_BUILD_CORES:-1} --progress --depth 1 --checkout --force

          mv .gitmodules{.bak,}

          # Remove .git dirs
          find . -name .git -type f -exec rm -rf {} +
          rm -rf .git/
          popd
        '';
      };
      patches = [
        # Add explicit cast for CRC checksum value
        ./fix-udp-protocol.patch
        # Use specific boost::asio includes and update to modern io_context
        (fetchpatch {
          url = "https://git.citron-emu.org/citron/emu/-/commit/21ca0b31191c4af56a78576c502e8382b4c128b4.patch";
          hash = "sha256-DkCGjeNYjCA7RdB+hBRXuHL8Ckjb+IgWbZ13leQZUF0=";
        })
      ];
      cmakeFlagsPrefix = "CITRON";
      udevFileName = "72-citron-input.rules";
      fmt = fmt_11;
      homepage = "https://git.citron-emu.org/citron/emu/-/releases";
      mainProgram = "citron";
    }
  );

  sudachi = callPackage ./generic.nix (
    let
      version = "1.0.15";
    in
    {
      forkName = "sudachi";
      inherit version;
      source = fetchzip {
        url = "https://github.com/emuplace/sudachi.emuplace.app/releases/download/v${version}/latest.zip";
        hash = "sha256-9qfDtuJWE4KpCY7RFXw/VdYOR0bNe+80afO7/FJ+Cog=";
        stripRoot = false;
        nativeBuildInputs = [
          git
          dos2unix
        ];
        postFetch = ''
          pushd $out
          # Patches will fail to apply because of line endings
          find . -type f -print0 | xargs -0 dos2unix

          # Restore submodules from .gitmodules file
          # https://stackoverflow.com/a/11258810
          git init
          git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
              while read path_key local_path
              do
                  url_key=$(echo $path_key | sed 's/\.path/.url/')
                  url=$(git config -f .gitmodules --get "$url_key")
                  rmdir $local_path
                  git submodule add $url $local_path
              done
          # Fetch nested submodules
          git submodule update --init --recursive

          # Fix submodules versions
          (cd externals/cpp-jwt && git checkout 4a970bc302d671476122cbc6b43cc89fbf4a96ec)

          # Remove .git dirs
          find . -name .git -type f -exec rm -rf {} +
          rm -rf .git/
        '';
      };
      patches = [
        # Add explicit cast for CRC checksum value
        ./fix-udp-protocol.patch
        # Updates suppressed diagnostics
        ./fix-aarch64-linux-build.patch
        # Revert imports to codec.h
        ./fix-libavcodec-import.patch
        # Revert libav function usage
        ./fix-libavcodec-function.patch
        # Fix code mistakes
        # from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=sudachi
        ./fix-sudachi-window.patch
        ./fix-sudachi-guest-memory-namespace.patch
      ];
      cmakeFlagsPrefix = "SUDACHI";
      udevFileName = "72-sudachi-input.rules";
      SDL2 = sdl3;
      homepage = "https://sudachi.emuplace.app/";
      mainProgram = "sudachi";
    }
  );
}
