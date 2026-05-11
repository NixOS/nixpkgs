{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  nixosTests,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "plikd";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "root-gg";
    repo = "plik";
    rev = finalAttrs.version;
    hash = "sha256-WCtfkzlZnyzZDwNDBrW06bUbLYTL2C704Y7aXbiVi5c=";
  };

  # TODO build webapp from source (how to hanndle npm and bower deps?)
  src-webapp = fetchurl {
    url = "https://github.com/root-gg/plik/releases/download/${finalAttrs.version}/plik-${finalAttrs.version}-linux-amd64.tar.gz";
    hash = "sha256-taUFXZJeUHYjjhrVlLgKYPxNn6W5o8uoEVcu+f5flCA=";
  };

  subPackages = [ "server" ];

  vendorHash = null;

  nativeBuildInputs = [
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace server/common/version.go \
      --replace '"0.0.0"' '"${finalAttrs.version}"'
  '';

  postInstall = ''
    # install the webapp
    mkdir -p $out/libexec/plikd/{bin,webapp} $out/bin
    tar xf ${finalAttrs.src-webapp} plik-${finalAttrs.version}-linux-amd64/webapp/dist/
    mv plik-*/webapp/dist $out/libexec/plikd/webapp

    # move and wrap the server binary
    mv $out/bin/server $out/libexec/plikd/bin/plikd
    makeWrapper $out/libexec/plikd/bin/plikd $out/bin/plikd \
      --chdir "$out/libexec/plikd/bin"
  '';

  passthru.tests = {
    inherit (nixosTests) plikd;
  };

  meta = {
    description = "Scalable & friendly temporary file upload system";
    homepage = "https://plik.root.gg/";
    license = lib.licenses.mit;
    mainProgram = "plikd";
    maintainers = [ ];
  };
})
