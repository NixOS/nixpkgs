{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, autoPatchelfHook
, fontconfig
}:

buildDotnetModule rec {
  pname = "galaxy-buds-client";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "ThePBone";
    repo = "GalaxyBudsClient";
    rev = version;
    sha256 = "00kqww4niry840grvczrnlz6hd8mqpp1rd2mivc1wqyp6x9p8c7g";
  };

  projectFile = [ "GalaxyBudsClient/GalaxyBudsClient.csproj" ];
  nugetDeps = ./deps.nix;
  dotnetFlags = [ "-p:Runtimeidentifier=linux-x64" ];
  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
  ];

  meta = with lib; {
    description = "Unofficial Galaxy Buds Manager for Windows and Linux";
    homepage = "https://github.com/ThePBone/GalaxyBudsClient";
    license = licenses.gpl3;
    maintainers = [ maintainers.Madouura ];
    platforms = platforms.linux;  # It can work with all, not sure yet how to implement
  };
}
