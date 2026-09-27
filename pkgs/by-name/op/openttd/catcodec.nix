{
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "catcodec";
  version = "0-unstable-2024-01-01";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "catcodec";
    rev = "b8eb8f149520060b57433ab9d4b0703f905874a6";
    hash = "sha256-6RJdhn45hq/wRGJ6m2r0aMLTnDxqP/J3Uv0+eH4Ni8E=";
  };

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    printf '1.0.0\t2024-01-01' > .version
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 catcodec $out/bin/
  '';
}
