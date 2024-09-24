{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  mono,
  nodejs_18,
}:
let
  pname = "slskd";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "slskd";
    repo = "slskd";
    rev = version;
    hash = "sha256-qAS8uiXAG0JTOCW/bIVYhv6McUSBihAHFjJu3b5Ttoc=";
  };

  meta = with lib; {
    description = "Modern client-server application for the Soulseek file sharing network";
    homepage = "https://github.com/slskd/slskd";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      ppom
      melvyn2
    ];
    platforms = platforms.linux;
  };

  wwwroot = buildNpmPackage {
    inherit meta version;

    pname = "slskd-web";
    src = "${src}/src/web";
    npmFlags = [ "--legacy-peer-deps" ];
    nodejs = nodejs_18;
    npmDepsHash = "sha256-06qQ1y870TrkXhkHYADjnWVhdyiLWEqdDt3qrJ1BBFo=";
    installPhase = ''
      cp -r build $out
    '';
  };

in
buildDotnetModule {
  inherit
    pname
    version
    src
    meta
    ;

  runtimeDeps = [ mono ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  projectFile = "slskd.sln";

  testProjectFile = "tests/slskd.Tests.Unit/slskd.Tests.Unit.csproj";
  doCheck = true;

  nugetDeps = ./deps.nix;

  postInstall = ''
    rm -r $out/lib/slskd/wwwroot
    ln -s ${wwwroot} $out/lib/slskd/wwwroot
  '';
}
