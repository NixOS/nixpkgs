{
  lib,
  stdenv,
  fetchFromGitHub,
  deno,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "bewcloud";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "bewcloud";
    repo = "bewcloud";
    rev = "v${version}";
    hash = "sha256-8sIJXV42h3fRr04vbrVi1QjH0EWszzDm6pmmfWGzIak=";
  };

  nativeBuildInputs = [
    makeWrapper
    deno
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/bewcloud}
    cp -r . $out/share/bewcloud

    makeWrapper ${deno}/bin/deno $out/bin/bewcloud \
      --add-flags "run --allow-net --allow-read --allow-write --allow-env $out/share/bewcloud/main.ts"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Self-hosted alternative to Nextcloud built with Fresh";
    homepage = "https://bewcloud.com";
    maintainers = [ maintainers.liberodark ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
