{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.4.0";
  pname = "nginx-config-formatter";

  src = fetchFromGitHub {
    owner = "slomkowski";
    repo = "nginx-config-formatter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HB1knL/q1G2z6RyVCsOyIKpp4O6x68/93ccvox1FKGQ=";
  };

  buildInputs = [ python3 ];

  nativeCheckInputs = [ python3 ];

  strictDeps = true;

  doCheck = true;
  checkPhase = ''
    python3 $src/test_nginxfmt.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 $src/nginxfmt.py $out/bin/nginxfmt
  '';

  doInstallCheck = true;
  # We can't do a version check because there is no version command
  # but we do want to check that python3 is available
  installCheckPhase = ''
    $out/bin/nginxfmt --help
  '';

  meta = {
    description = "Nginx config file formatter";
    maintainers = with lib.maintainers; [ Baughn ];
    license = lib.licenses.asl20;
    homepage = "https://github.com/slomkowski/nginx-config-formatter";
    mainProgram = "nginxfmt";
  };
})
