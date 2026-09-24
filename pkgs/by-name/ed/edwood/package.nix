{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  plan9port,
}:

buildGoModule (finalAttrs: {
  pname = "edwood";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "rjkroege";
    repo = "edwood";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aPJpp4D5Ej2JLCwx0PiHDd7xrfYtX8bMWUWqJ1l9DqI=";
  };

  vendorHash = "sha256-4UcbGdE2/pzCnBGa6JSX+w4LW7nIGQpA2gq+PSWrwBs=";

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r build/font $out/share

    wrapProgram $out/bin/edwood \
      --prefix PATH : ${lib.makeBinPath [ "${plan9port}/plan9" ]} \
      --set PLAN9 $out/share # envvar is read by edwood to determine the font path prefix
  '';

  doCheck = false; # Tests has lots of hardcoded mess.

  meta = {
    description = "Go version of Plan9 Acme Editor";
    homepage = "https://github.com/rjkroege/edwood";
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = [ ];
    mainProgram = "edwood";
  };
})
