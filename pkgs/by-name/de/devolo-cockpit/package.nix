{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  appimageTools,
  dpkg,
  unzip,
  undmg,
  makeBinaryWrapper,
  writeShellScript,
  nixosTests,
}:

let
  pname = "devolo-cockpit";
  sources = import ./sources.nix;
  inherit (sources) version;

  src = fetchurl (if stdenvNoCC.hostPlatform.isDarwin then sources.darwin else sources.linux);

  meta = {
    description = "Display and configure settings of your devolo dLAN/Magic devices";
    homepage = "https://www.devolo.global/support/downloads/download/devolo-cockpit";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ malix ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = pname;
  };

  passthru = {
    updateScript = ./update.sh;
    tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
      nixos = nixosTests.devolo-cockpit;
    };
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [
      undmg
      makeBinaryWrapper
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications $out/bin
      tar -zxf "devolo Cockpit Installation.app/Contents/Resources/dlancockpit_osx.tgz" -C $out/
      makeWrapper "$out/Applications/devolo/devolo Cockpit.app/Contents/MacOS/dLAN Cockpit" "$out/bin/devolo-cockpit"
      runHook postInstall
    '';
  };

  linux =
    let
      arch = if stdenvNoCC.hostPlatform.isx86_64 then "amd64" else "i386";

      unwrapped = stdenvNoCC.mkDerivation {
        pname = "${pname}-unwrapped";
        inherit version src;

        nativeBuildInputs = [
          unzip
          dpkg
        ];

        dontUnpack = true;

        installPhase = ''
          runHook preInstall
          unzip $src
          tail -n +$(( $(grep -a -m1 -n "HERE_BE_DRAG[O]NS" devolo-cockpit-v*.run | cut -d: -f1) + 1 )) devolo-cockpit-v*.run | tar -x
          for deb in *_${arch}.deb; do dpkg -x "$deb" $out; done
          cp -r $out/usr/* $out/
          rm -rf $out/etc $out/usr $out/var
          substituteInPlace $out/opt/devolo/dlancockpit/bin/dlancockpit-run.sh \
            --replace-fail '.appdata/' '$HOME/.appdata/' \
            --replace-fail '/opt/devolo/dlancockpit/bin/dlancockpit' 'setarch i686 /opt/devolo/dlancockpit/bin/dlancockpit'
          substituteInPlace $out/share/applications/devolo-dlan-cockpit.desktop \
            --replace-fail '/opt/devolo/dlancockpit/bin/dlancockpit-run.sh' 'devolo-cockpit'
          runHook postInstall
        '';
      };
      libxml2-compat =
        p:
        p.runCommandCC "libxml2-compat" { } ''
          mkdir -p $out/lib
          $CC -shared -fPIC -o $out/lib/libxml2.so.2 -x c - -Wl,--no-as-needed -L${p.libxml2.out}/lib -lxml2 << 'EOF'
          int xmlLoadExtDtdDefaultValue = 0;
          EOF
        '';
    in
    buildFHSEnv {
      inherit pname version meta;

      multiArch = true;

      nativeBuildInputs = [ makeBinaryWrapper ];

      targetPkgs = pkgs: [
        unwrapped
        pkgs.dpkg
      ];

      profile = ''
        export LD_LIBRARY_PATH=/lib32:/usr/lib32:$LD_LIBRARY_PATH
      '';

      multiPkgs =
        pkgs:
        with pkgs;
        [
          gtk2
          gnome-themes-extra
          libxslt
          libxml2
          (libxml2-compat pkgs)
        ]
        ++ appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

      extraInstallCommands = ''
        ln -s ${unwrapped}/share $out/share
        rm -f $out/bin/devolonetsvc
        makeWrapper $out/bin/devolo-cockpit $out/bin/devolonetsvc \
          --add-flags "--daemon"
      '';

      runScript = writeShellScript "devolo-cockpit-launcher" ''
        if [ "''${1:-}" = "--daemon" ] || [ "''${1:-}" = "devolonetsvc" ]; then
          shift
          exec devolonetsvc "$@"
        else
          exec /opt/devolo/dlancockpit/bin/dlancockpit-run.sh "$@"
        fi
      '';

      passthru = passthru // {
        inherit unwrapped;
      };
    };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
