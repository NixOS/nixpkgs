{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  runtimeShell,
  runCommand,
  makeWrapper,
  installShellFiles,
  buildGoModule,
  coreutils,
  which,
  gnugrep,
  gnused,
  openresolv,
  systemd,
  iproute2,
  openvpn,
  electron,
  wireguard-tools,
  withWireguard ? stdenv.hostPlatform.isLinux,
}:
let
  version = "1.3.4275.94";
  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-client-electron";
    rev = version;
    sha256 = "sha256-a1arRI4qQy5niKV8JAyusAjheMa/LtEXPZGhngsH+TU=";
  };

  cli = buildGoModule {
    pname = "pritunl-cli";
    inherit version src;

    modRoot = "cli";
    vendorHash = "sha256-xozdrNKBgrrCZ5WYHGWKOuuGrEhx/VzOKLZTGq3scoo=";

    postInstall = ''
      mv $out/bin/cli $out/bin/pritunl-client
    '';
    passthru.updateScript = nix-update-script { };
  };

  service = buildGoModule {
    pname = "pritunl-client-service";
    inherit version src;

    modRoot = "service";
    vendorHash = "sha256-3dgBiCqWj+nwWn9mFARBKIpgjn2aJYvVUrqMIzhToQs=";

    nativeBuildInputs = [ makeWrapper ];

    postPatch =
      ''
        sed -Ei service/connection/scripts.go \
          -e 's|#!\s*(/usr)?/bin/(env )?bash\b|#! ${runtimeShell}|g'
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        sed -Ei service/connection/scripts.go \
          -e 's|(/usr)?/s?bin/busctl\b|busctl|g' \
          -e 's|(/usr)?/s?bin/resolvectl\b|resolvectl|g' \
          -e 's|(/usr)?/s?bin/ip\b|ip|g'
      '';

    postInstall =
      ''
        mv $out/bin/service $out/bin/pritunl-client-service
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        mkdir -p $out/lib/systemd/system/
        cp $src/resources_linux/pritunl-client.service $out/lib/systemd/system/
        substituteInPlace $out/lib/systemd/system/pritunl-client.service \
          --replace-warn "/usr" "$out"
      '';

    postFixup =
      let
        hookScriptsDeps =
          [
            coreutils
            which
            gnused
            gnugrep
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            openresolv
            systemd
            iproute2
          ];
        openvpn-wrapped =
          runCommand "openvpn-wrapped"
            {
              nativeBuildInputs = [ makeWrapper ];
            }
            ''
              mkdir -p $out/bin
              makeWrapper ${openvpn}/bin/openvpn $out/bin/openvpn \
                --prefix PATH : ${lib.makeBinPath hookScriptsDeps} \
                --add-flags "--setenv PATH \$PATH"
            '';
        pritunlDeps =
          [
            openvpn-wrapped
          ]
          ++ lib.optionals withWireguard [
            openresolv
            coreutils
            wireguard-tools
          ];
      in
      lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/pritunl-client-service \
          --prefix PATH : "${lib.makeBinPath pritunlDeps}"
      '';
    passthru.updateScript = nix-update-script { };
  };
in
stdenv.mkDerivation {
  pname = "pritunl-client";
  inherit version src;

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase =
    ''
      runHook preInstall

      mkdir -p $out/bin/
      ln -s ${cli}/bin/pritunl-client $out/bin/
      ln -s ${service}/bin/pritunl-client-service $out/bin/

      mkdir -p $out/lib/
      cp -r client $out/lib/pritunl_client_electron

      makeWrapper ${electron}/bin/electron $out/bin/pritunl-client-electron \
        --add-flags $out/lib/pritunl_client_electron

    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/lib/systemd/system/
      ln -s ${service}/lib/systemd/system/pritunl-client.service $out/lib/systemd/system/

      mkdir -p $out/share/icons/
      cp -r resources_linux/icons $out/share/icons/hicolor

      mkdir -p $out/share/applications/
      cp resources_linux/pritunl-client-electron.desktop $out/share/applications/
      substituteInPlace $out/share/applications/pritunl-client-electron.desktop \
        --replace-fail "/usr/lib/pritunl_client_electron/Pritunl" "$out/bin/pritunl-client-electron"
    ''
    + ''
      # install shell completions for pritunl-client
      installShellCompletion --cmd pritunl-client \
        --bash <($out/bin/pritunl-client completion bash) \
        --fish <($out/bin/pritunl-client completion fish) \
        --zsh <($out/bin/pritunl-client completion zsh)

      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };
  meta = with lib; {
    description = "Pritunl OpenVPN client";
    homepage = "https://client.pritunl.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [
      minizilla
      andrevmatos
    ];
  };
}
