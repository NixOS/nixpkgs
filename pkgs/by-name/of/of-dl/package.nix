{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  ffmpeg_7-headless,
}:

buildDotnetModule rec {
  pname = "of-dl";
  version = "1.7.83";

  src = fetchFromGitHub {
    owner = "sim0n00ps";
    repo = "OF-DL";
    rev = "OFDLV1.7.83";
    hash = "sha256-weLa3fCVmEtvLhtSXeGD4nfOlez9iUaeZVMYB+LPNic=";
  };

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg_7-headless ]}"
  ];

  meta = with lib; {
    description = "Console app to download media from Onlyfans";
    homepage = "https://sim0n00ps.github.io/OF-DL/";
    license = with licenses; [ unfree ]; # No license
    mainProgram = "OF DL";
    maintainers = with maintainers; [ csf3o ];
  };
}
