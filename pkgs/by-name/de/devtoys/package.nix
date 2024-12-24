{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  buildFHSEnv,
  appimageTools,
  writeShellScript,
  mesa,
  libGL,
  fontconfig,
  zlib,
  lttng-ust_2_12,
  icu,
  gtk4,
  libadwaita,
  webkitgtk_6_0,
}:
let
  pname = "devtoys";
  version = "2.0.8.0";

  meta = {
    description = "Swiss Army knife for developers";
    homepage = "https://github.com/DevToys-app/DevToys";
    mainProgram = "devtoys";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ aucub ];
  };

  devtoys-unwrapped = stdenv.mkDerivation {
    inherit pname version meta;

    src =
      let
        selectSystem =
          attrs:
          attrs.${stdenv.hostPlatform.system}
            or (throw "Unsupported host system ${stdenv.hostPlatform.system}");
        arch = selectSystem {
          x86_64-linux = "x64";
          aarch64-linux = "arm";
        };
      in
      fetchurl {
        url = "https://github.com/DevToys-app/DevToys/releases/download/v${version}/devtoys_linux_${arch}.deb";
        hash = selectSystem {
          x86_64-linux = "sha256-j+JKW6JhooX1ZMJzrqwU2utt8OmrjUQLJlAdKHfmCAc=";
          aarch64-linux = "sha256-tBxSS81gzYrEgu3bxfrRP7rrpsElGs1udzDfnC2A0r8=";
        };
      };

    nativeBuildInputs = [
      dpkg
    ];

    dontFixup = true;

    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r opt/devtoys/devtoys $out/lib/devtoys
      cp -r usr/share $out/share
      substituteInPlace $out/share/applications/devtoys.desktop \
        --replace-fail "/usr/bin/DevToys" "devtoys" \
        --replace-fail "/opt/devtoys" "$out/lib"

      runHook postInstall
    '';
  };
in
buildFHSEnv (
  appimageTools.defaultFhsEnvArgs
  // {
    inherit
      pname
      version
      meta
      ;

    targetPkgs =
      pkgs:
      (with pkgs; [
        icu
        gtk4
        webkitgtk_6_0
      ]);

    runScript = writeShellScript "devtoys-wrapper.sh" ''
      exec env FONTCONFIG_PATH=${fontconfig.out}/etc/fonts LD_LIBRARY_PATH=${
        lib.makeLibraryPath [
          zlib
          lttng-ust_2_12
          icu
          gtk4
          libadwaita
          webkitgtk_6_0
          mesa
          libGL
          fontconfig
          (lib.getLib stdenv.cc.cc)
        ]
      }:${devtoys-unwrapped}/lib/devtoys:$LD_LIBRARY_PATH ${devtoys-unwrapped}/lib/devtoys/DevToys.Linux "$@"
    '';

    extraInstallCommands = ''
      ln -s ${devtoys-unwrapped}/share $out/share
    '';
  }
)
