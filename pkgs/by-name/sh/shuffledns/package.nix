{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "shuffledns";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "shuffledns";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-hdlFmUfAKvBaFBIraOyLTuPbwykwIpqX5VzIPRP1lz8=";
  };

  vendorHash = "sha256-dWO/Dut4zwEkJfuBeXvE4Yx85hn0ufCPS9mV09gUrnc=";
=======
    hash = "sha256-wfHGIWdksfe0sNss4pLQ0ODh28u2kMuxAJh5C9Uiap4=";
  };

  vendorHash = "sha256-A4Ssvc6UOvwezzdMa+nPkwyVT8j15+mTAAL+loeBcCo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/shuffledns" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  versionCheckProgramArg = "-version";

  meta = {
    description = "massDNS wrapper to bruteforce and resolve the subdomains with wildcard handling support";
    longDescription = ''
      MassDNS wrapper written in go to enumerate valid subdomains using active bruteforce as well as resolve subdomains with wildcard filtering and easy input-output support.
    '';
    homepage = "https://github.com/projectdiscovery/shuffledns";
    changelog = "https://github.com/projectdiscovery/shuffledns/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.michaelBelsanti ];
    mainProgram = "shuffledns";
  };
})
