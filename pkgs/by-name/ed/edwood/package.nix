{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  plan9port,
}:

buildGoModule rec {
  pname = "edwood";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rjkroege";
    repo = "edwood";
    rev = "v${version}";
    hash = "sha256-jKDwNq/iMFqVpPq14kZa+T5fES54f4BAujXUwGlbiTE=";
  };

  vendorHash = "sha256-M7fa46BERNRHbCsAiGqt4GHVVTyrW6iIb6gRc4UuZxA=";

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

  meta = with lib; {
    description = "Go version of Plan9 Acme Editor";
    homepage = "https://github.com/rjkroege/edwood";
    license = with licenses; [
      mit
      bsd3
    ];
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "edwood";
  };
}
