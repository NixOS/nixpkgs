{ lib
, stdenv
, fetchFromGitHub
, gcc
, flex
, bison
, autoconf
}:

stdenv.mkDerivation rec {
  pname = "makedepf90";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "outpaddling";
    repo = "makedepf90";
    rev = "1f3ba6915a4289e6b421d873e84bdb86c224a4dc";
    hash = "sha256-OidEbv4S+5vDprX1fhbUWX9o6eFzh+gW3v62xdkhrK4=";
  };

  buildInputs = [ gcc bison flex ];

  nativeBuildInputs = [ autoconf ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ makedepf90

    runHook postInstall
  '';

  meta = {
    description = "Generate make dependencies for Fortran code";
    mainProgram = "makedepf90";
    homepage = "https://github.com/outpaddling/makedepf90";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vasissualiyp ];
  };
}
