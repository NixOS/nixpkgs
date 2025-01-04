{
  lib,
  perlPackages,
  nix,
  dmidecode,
  pciutils,
  usbutils,
  iproute2,
  nettools,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

perlPackages.buildPerlPackage rec {
  pname = "glpi-agent";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "glpi-project";
    repo = "glpi-agent";
    tag = version;
    hash = "sha256-WdQ+/ZnMCRqLZK64oJNoR9dtMPq+CghsA8NUwt3EpjA=";
  };

  postPatch = ''
    patchShebangs bin

    substituteInPlace lib/GLPI/Agent/Tools/Linux.pm \
      --replace-fail "/sbin/ip" $"{iproute2}/sbin/ip"
    substituteInPlace lib/GLPI/Agent/Task/Inventory/Linux/Networks.pm \
      --replace-fail "/sbin/ip" "${iproute2}/sbin/ip"
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = (
    with perlPackages;
    [
      CGI
      DataStructureUtil
      FileCopyRecursive
      HTTPProxy
      HTTPServerSimple
      HTTPServerSimpleAuthen
      IOCapture
      IOSocketSSL
      IPCRun
      JSON
      LWPProtocolHttps
      ModuleInstall
      NetSNMP
      TestCompile
      TestDeep
      TestException
      TestMockModule
      TestMockObject
      TestNoWarnings
      CpanelJSONXS
      XMLLibXML
      NetPing
      ParallelForkManager
      DigestSHA1
      CryptDES
      FileCopyRecursive
      URIEscapeXS
      DateTime
      DataUUID
      URI
      HTTPDaemon
      YAML
      IOCompress
    ]
  );

  propagatedBuildInputs = with perlPackages; [
    FileWhich
    LWP
    NetIP
    TextTemplate
    UNIVERSALrequire
    XMLTreePP
    CompressRawZlib
    HTTPDaemon
    ProcDaemon
    ProcPIDFile
  ];

  # Test fails due to "Argument list too long"
  doCheck = false;

  installPhase = ''
    mkdir -p $out

    cp -r bin $out
    cp -r lib $out
    cp -r share $out

    for cur in $out/bin/*; do
      if [ -x "$cur" ]; then
        sed -e "s|./lib|$out/lib|" -i "$cur"
        wrapProgram "$cur" --prefix PATH : ${
          lib.makeBinPath [
            nix
            dmidecode
            pciutils
            usbutils
            nettools
            iproute2
          ]
        }
      fi
    done
  '';

  outputs = [ "out" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GLPI unified Agent for UNIX, Linux, Windows and MacOSX";
    homepage = "https://glpi-project.org/";
    changelog = "https://github.com/glpi-project/glpi-agent/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "glpi-agent";
  };
}
