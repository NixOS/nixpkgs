{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maddy-markdown";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "progsource";
    repo = "maddy";
    rev = "${finalAttrs.version}";
    hash = "sha256-sVUXACT94PSPcohnOyIp7KK8baCBuf6ZNMIyk6Cfdjg=";
  };

  postInstall = ''
    mkdir $out
    mv include $out/include
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "C++ Markdown to HTML header-only parser library";
    homepage = "https://github.com/progsource/maddy";
    license = licenses.mit;
    maintainers = with maintainers; [
      normalcea
      getchoo
    ];
    platforms = platforms.unix;
  };
})
