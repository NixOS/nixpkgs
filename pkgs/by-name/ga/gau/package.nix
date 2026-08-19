{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gau";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "lc";
    repo = "gau";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B2l5joHeFDjYmdb3F1FFDKjIKENZu92O2sMlkf3Sf6Y=";
  };

  vendorHash = "sha256-nhsGhuX5AJMHg+zQUt1G1TwVgMCxnuJ2T3uBrx7bJNs=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Tool to fetch known URLs";
    longDescription = ''
      getallurls (gau) fetches known URLs from various sources for any
      given domain.
    '';
    homepage = "https://github.com/lc/gau";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gau";
  };
})
