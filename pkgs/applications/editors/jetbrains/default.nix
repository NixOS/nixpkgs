let
  # `ides.json` is handwritten and contains information that doesn't change across updates, like maintainers and other metadata
  # `versions.json` contains everything generated/needed by the update script version numbers, build numbers and tarball hashes
  ideInfo = builtins.fromJSON (builtins.readFile ./bin/ides.json);
  versions = builtins.fromJSON (builtins.readFile ./bin/versions.json);
in

{
  lib,
  stdenv,
  callPackage,
  fetchurl,

  jdk,
  zlib,
  python3,
  lldb,
  dotnet-sdk_8,
  maven,
  openssl,
  expat,
  libxcrypt,
  libxcrypt-legacy,
  fontconfig,
  libxml2,
  runCommand,
  musl,
  R,
  libgcc,
  lttng-ust_2_12,
  xz,
  xorg,
  libGL,

  libICE,
  libSM,
  libX11,

  vmopts ? null,
}:

let
  inherit (stdenv.hostPlatform) system;

  products = versions.${system} or (throw "Unsupported system: ${system}");

  package = if stdenv.hostPlatform.isDarwin then ./bin/darwin.nix else ./bin/linux.nix;
  mkJetBrainsProductCore = callPackage package { inherit vmopts; };
  mkMeta = meta: fromSource: {
    inherit (meta) homepage longDescription;
    description =
      meta.description
      + lib.optionalString meta.isOpenSource (
        if fromSource then " (built from source)" else " (patched binaries from jetbrains)"
      );
    maintainers = map (x: lib.maintainers."${x}") meta.maintainers;
    license = if meta.isOpenSource then lib.licenses.asl20 else lib.licenses.unfree;
    sourceProvenance =
      if fromSource then
        [ lib.sourceTypes.fromSource ]
      else
        (
          if stdenv.hostPlatform.isDarwin then
            [ lib.sourceTypes.binaryNativeCode ]
          else
            [ lib.sourceTypes.binaryBytecode ]
        );
  };

  mkJetBrainsProduct =
    {
      pname,
      fromSource ? false,
      extraWrapperArgs ? [ ],
      extraLdPath ? [ ],
      extraBuildInputs ? [ ],
    }:
    mkJetBrainsProductCore {
      inherit
        pname
        jdk
        extraWrapperArgs
        extraLdPath
        extraBuildInputs
        ;
      src =
        if fromSource then
          communitySources."${pname}"
        else
          fetchurl {
            url = products."${pname}".url;
            sha256 = products."${pname}".sha256;
          };
      version = if fromSource then communitySources."${pname}".version else products."${pname}".version;
      buildNumber =
        if fromSource then communitySources."${pname}".buildNumber else products."${pname}".build_number;
      inherit (ideInfo."${pname}") wmClass product;
      productShort = ideInfo."${pname}".productShort or ideInfo."${pname}".product;
      meta = mkMeta ideInfo."${pname}".meta fromSource;
      libdbm =
        if ideInfo."${pname}".meta.isOpenSource then
          communitySources."${pname}".libdbm
        else
          communitySources.idea-community.libdbm;
      fsnotifier =
        if ideInfo."${pname}".meta.isOpenSource then
          communitySources."${pname}".fsnotifier
        else
          communitySources.idea-community.fsnotifier;
    };

  communitySources = callPackage ./source { };

  buildIdea =
    args:
    mkJetBrainsProduct (
      args
      // {
        extraLdPath = [ zlib ];
        extraWrapperArgs = [
          ''--set M2_HOME "${maven}/maven"''
          ''--set M2 "${maven}/maven/bin"''
        ];
      }
    );

  buildPycharm =
    args:
    (mkJetBrainsProduct args).overrideAttrs (
      finalAttrs: previousAttrs:
      lib.optionalAttrs stdenv.hostPlatform.isLinux {
        buildInputs =
          with python3.pkgs;
          (previousAttrs.buildInputs or [ ])
          ++ [
            python3
            setuptools
          ];
        preInstall = ''
          echo "compiling cython debug speedups"
          if [[ -d plugins/python-ce ]]; then
              ${python3.interpreter} plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace
          else
              ${python3.interpreter} plugins/python/helpers/pydev/setup_cython.py build_ext --inplace
          fi
        '';
        # See https://www.jetbrains.com/help/pycharm/2022.1/cython-speedups.html
      }
    );

in
rec {
  # Sorted alphabetically

  aqua = mkJetBrainsProduct {
    pname = "aqua";
    extraBuildInputs = [
      stdenv.cc.cc
      lldb
    ];
  };

  clion =
    (mkJetBrainsProduct {
      pname = "clion";
      extraBuildInputs =
        lib.optionals (stdenv.hostPlatform.isLinux) [
          fontconfig
          python3
          stdenv.cc.cc
          openssl
          libxcrypt-legacy
          lttng-ust_2_12
          musl
        ]
        ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
          expat
          libxml2
          xz
        ];
    }).overrideAttrs
      (attrs: {
        postInstall =
          (attrs.postInstall or "")
          + lib.optionalString (stdenv.hostPlatform.isLinux) ''
            (
              cd $out/clion

              for dir in plugins/clion-radler/DotFiles/linux-*; do
                rm -rf $dir/dotnet
                ln -s ${dotnet-sdk_8.unwrapped}/share/dotnet $dir/dotnet
              done
            )
          '';

        postFixup =
          (attrs.postFixup or "")
          + lib.optionalString (stdenv.hostPlatform.isLinux) ''
            (
              cd $out/clion

              # I think the included gdb has a couple of patches, so we patch it instead of replacing
              ls -d $PWD/bin/gdb/linux/*/lib/python3.8/lib-dynload/* |
              xargs patchelf \
                --replace-needed libssl.so.10 libssl.so \
                --replace-needed libcrypto.so.10 libcrypto.so

              ls -d $PWD/bin/lldb/linux/*/lib/python3.8/lib-dynload/* |
              xargs patchelf \
                --replace-needed libssl.so.10 libssl.so \
                --replace-needed libcrypto.so.10 libcrypto.so
            )
          '';
      });

  datagrip = mkJetBrainsProduct {
    pname = "datagrip";
    extraBuildInputs = [ stdenv.cc.cc ];
  };

  dataspell =
    let
      libr = runCommand "libR" { } ''
        mkdir -p $out/lib
        ln -s ${R}/lib/R/lib/libR.so $out/lib/libR.so
      '';
    in
    mkJetBrainsProduct {
      pname = "dataspell";
      extraBuildInputs = [
        libgcc
        libr
        stdenv.cc.cc
      ];
    };

  gateway = mkJetBrainsProduct {
    pname = "gateway";
    extraBuildInputs = [ libgcc ];
  };

  goland =
    (mkJetBrainsProduct {
      pname = "goland";
      extraWrapperArgs = [
        # fortify source breaks build since delve compiles with -O0
        ''--prefix CGO_CPPFLAGS " " "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"''
      ];
      extraBuildInputs = [
        libgcc
        stdenv.cc.cc
      ];
    }).overrideAttrs
      (attrs: {
        postFixup =
          (attrs.postFixup or "")
          + lib.optionalString stdenv.hostPlatform.isLinux ''
            interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
            patchelf --set-interpreter $interp $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
            chmod +x $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
          '';
      });

  idea-community-bin = buildIdea {
    pname = "idea-community";
    extraBuildInputs = [ stdenv.cc.cc ];
  };

  idea-community-src = buildIdea {
    pname = "idea-community";
    extraBuildInputs = [ stdenv.cc.cc ];
    fromSource = true;
  };

  idea-community =
    if stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64 then
      idea-community-bin
    else
      idea-community-src;

  idea-ultimate = buildIdea {
    pname = "idea-ultimate";
    extraBuildInputs = [
      stdenv.cc.cc
      lldb
      musl
    ];
  };

  mps = mkJetBrainsProduct { pname = "mps"; };

  phpstorm = mkJetBrainsProduct {
    pname = "phpstorm";
    extraBuildInputs = [
      stdenv.cc.cc
      musl
    ];
  };

  pycharm-community-bin = buildPycharm { pname = "pycharm-community"; };

  pycharm-community-src = buildPycharm {
    pname = "pycharm-community";
    fromSource = true;
  };

  pycharm-community =
    if stdenv.hostPlatform.isDarwin then pycharm-community-bin else pycharm-community-src;

  pycharm-professional = buildPycharm {
    pname = "pycharm-professional";
    extraBuildInputs = [ musl ];
  };

  rider =
    (mkJetBrainsProduct {
      pname = "rider";
      extraBuildInputs =
        [
          fontconfig
          stdenv.cc.cc
          openssl
          libxcrypt
          lttng-ust_2_12
          musl
        ]
        ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
          expat
          libxml2
          xz
        ];
      extraLdPath = lib.optionals (stdenv.hostPlatform.isLinux) [
        # Avalonia dependencies needed for dotMemory
        libICE
        libSM
        libX11
        libGL
      ];
    }).overrideAttrs
      (attrs: {
        postInstall =
          (attrs.postInstall or "")
          + lib.optionalString (stdenv.hostPlatform.isLinux) ''
            (
              cd $out/rider

              ls -d $PWD/plugins/cidr-debugger-plugin/bin/lldb/linux/*/lib/python3.8/lib-dynload/* |
              xargs patchelf \
                --replace-needed libssl.so.10 libssl.so \
                --replace-needed libcrypto.so.10 libcrypto.so \
                --replace-needed libcrypt.so.1 libcrypt.so

              for dir in lib/ReSharperHost/linux-*; do
                rm -rf $dir/dotnet
                ln -s ${dotnet-sdk_8.unwrapped}/share/dotnet $dir/dotnet
              done
            )
          '';
      });

  ruby-mine = mkJetBrainsProduct {
    pname = "ruby-mine";
    extraBuildInputs = [
      stdenv.cc.cc
      musl
    ];
  };

  rust-rover =
    (mkJetBrainsProduct {
      pname = "rust-rover";
      extraBuildInputs =
        lib.optionals (stdenv.hostPlatform.isLinux) [
          python3
          openssl
          libxcrypt-legacy
          fontconfig
          xorg.libX11
          libGL
        ]
        ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
          expat
          libxml2
          xz
        ];
    }).overrideAttrs
      (attrs: {
        postFixup =
          (attrs.postFixup or "")
          + lib.optionalString (stdenv.hostPlatform.isLinux) ''
            (
              cd $out/rust-rover

              # Copied over from clion (gdb seems to have a couple of patches)
              ls -d $PWD/bin/gdb/linux/*/lib/python3.8/lib-dynload/* |
              xargs patchelf \
                --replace-needed libssl.so.10 libssl.so \
                --replace-needed libcrypto.so.10 libcrypto.so

              ls -d $PWD/bin/lldb/linux/*/lib/python3.8/lib-dynload/* |
              xargs patchelf \
                --replace-needed libssl.so.10 libssl.so \
                --replace-needed libcrypto.so.10 libcrypto.so

              chmod +x $PWD/plugins/intellij-rust/bin/linux/*/intellij-rust-native-helper
            )
          '';
      });

  webstorm = mkJetBrainsProduct {
    pname = "webstorm";
    extraBuildInputs = [
      stdenv.cc.cc
      musl
    ];
  };

  writerside = mkJetBrainsProduct {
    pname = "writerside";
    extraBuildInputs = [
      stdenv.cc.cc
      musl
    ];
  };

  plugins = callPackage ./plugins { } // {
    __attrsFailEvaluation = true;
  };

}
