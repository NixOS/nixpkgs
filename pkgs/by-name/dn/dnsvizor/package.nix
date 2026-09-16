{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsStatic,
  ocamlPackages,
  dune_3,
  solo5,
  target ? "hvt",
}:

stdenv.mkDerivation {
  pname = "dnsvizor";
  version = "0-unstable-2026-08-07";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "robur-coop";
    repo = "dnsvizor";
    rev = "b41da80dbe6116cfffb2cdc088229180e677627b";
    hash = "sha256-pB2TifsxNSeFiSA/B/Y+XLWISBBRgR8kSaqMXMGYHNo=";
  };

  nativeBuildInputs =
    with ocamlPackages;
    [
      crunch.bin
      findlib
      mirage
      ocaml
      ocaml-solo5
    ]
    ++ [
      dune_3
    ];

  buildInputs =
    let
      preBuild = ''
        cat > dune-workspace <<EOF
        (lang dune 3.0)
        (context (default (name solo5) (toolchain solo5)))
        EOF
      '';
    in
    with ocamlPackages;
    [
      angstrom
      arp
      charrua
      charrua-server
      cmdliner-stdlib
      (digestif.overrideAttrs (prev: {
        inherit preBuild;

        nativeBuildInputs = prev.nativeBuildInputs ++ [ ocaml-solo5 ];

        doCheck = false;
      }))
      dns
      dns-certify
      dns-client
      dns-client-mirage
      dns-mirage
      dns-resolver
      dns-server
      dns-stub
      dns-tsig
      dnssec
      duration
      ethernet
      http-mirage-client
      logs
      lwt
      metrics
      metrics-lwt
      mirage
      (mirage-bootvar.overrideAttrs (prev: {
        inherit preBuild;

        nativeBuildInputs = prev.nativeBuildInputs ++ [ ocaml-solo5 ];

        buildInputs = [ ocamlPackages.mirage-solo5 ];

        doCheck = false;
      }))
      mirage-crypto-rng-mirage
      mirage-kv-mem
      mirage-logs
      mirage-mtime
      mirage-net-solo5
      mirage-ptime
      mirage-runtime
      mirage-sleep
      mirage-solo5
      multipart_form
      paf
      tcpip
      tyxml
      utcp
      (zarith.overrideAttrs (prev: {
        preConfigure = ''
          export PATH=${ocaml-solo5}/lib/ocaml-solo5/bin:$PATH
        '';

        # use solo5-sysroot layout (see ocaml-solo5 setup hook)
        configureFlags = [
          "-installdir ${placeholder "out"}/lib/ocaml/${ocaml.version}/solo5-sysroot/lib"
        ];

        nativeBuildInputs = prev.nativeBuildInputs ++ [ ocaml-solo5 ];

        propagatedBuildInputs = [
          ((pkgsStatic.gmp.override { cxx = false; }).overrideAttrs {
            # stack protector canary slot at %fs:0x28 does not exist in solo5 unikernel
            hardeningDisable = [ "stackprotector" ];
          })
        ];

        preInstall = "mkdir -p $out/lib/ocaml/${ocaml.version}/solo5-sysroot/lib";
      }))
    ];

  dontAddPrefix = true;
  configureScript = "mirage configure";
  configureFlags = [
    "-f"
    "config.ml"
    "--utcp"
    "-t"
    target
  ];

  buildFlags = [ "build" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 dist/dnsvizor.${target} $out/share/mirageos/dnsvizor.${target}
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ solo5 ];
  installCheckPhase = ''
    runHook preInstallCheck
    solo5-elftool query-abi $out/share/mirageos/dnsvizor.${target} | grep '"target": "${target}"'
    solo5-elftool query-manifest $out/share/mirageos/dnsvizor.${target} | grep '"type": "NET_BASIC"'
    runHook postInstallCheck
  '';

  meta = {
    description = "DNSmasq-like MirageOS unikernel";
    homepage = "https://github.com/robur-coop/dnsvizor";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
    inherit (ocamlPackages.ocaml-solo5.meta) platforms;
    broken =
      !lib.elem target [
        "hvt"
        "spt"
        "virtio"
        "muen" # builds fine but cannot boot without muen
        # "xen" # need mirage-xen 9
        # "unix" # need mirage-net-unix
        # "genode" # need another toolchain?
      ];
  };
}
