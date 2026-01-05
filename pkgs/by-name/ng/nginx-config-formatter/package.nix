{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  version = "1.3.0";
  pname = "nginx-config-formatter";

  src = fetchFromGitHub {
    owner = "slomkowski";
    repo = "nginx-config-formatter";
    rev = "v${version}";
    sha256 = "sha256-0jXm82a4bYpbOJnz+y7+dSg1LZy1Mu28IgBxd24Y5ck=";
  };

  buildInputs = [ python3 ];

  doCheck = true;
  checkPhase = ''
    python3 $src/test_nginxfmt.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 $src/nginxfmt.py $out/bin/nginxfmt
  '';

  meta = with lib; {
    description = "Nginx config file formatter";
    maintainers = with maintainers; [ Baughn ];
    license = licenses.asl20;
    homepage = "https://github.com/slomkowski/nginx-config-formatter";
    mainProgram = "nginxfmt";
  };
}
